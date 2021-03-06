//
//  OrderViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit
import PayPalCheckout
import FirebaseAuth

class OrderViewController: UIViewController {
    
    private var currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var whenView = SCWhenView(title: "When")
    private lazy var whereView = SCWhereView(title: "Where")
    private lazy var otherDetailsView = SCOtherDetailsView(title: "Other details")
    
    // MARK: - WhenView Properties
    private var whenViewHeightAnchor: NSLayoutConstraint!
    private var whenViewDataSetHeightAnchor: NSLayoutConstraint!
    private var isWhenViewDataSet: Bool = false
    
    // MARK: - WhereView Properties
    private var whereViewHeightAnchor: NSLayoutConstraint!
    private var whereViewDataSetHeightAnchor: NSLayoutConstraint!
    private var isWhereViewDataSet: Bool = false
    
    // MARK: - OtherDetails Properties
    private var otherDetailsViewHeightAnchor: NSLayoutConstraint!
    private var otherDetailsDataSetHeightAnchor: NSLayoutConstraint!
    private var isOtherDetailsViewDataSet: Bool = false
    
    private var tipsView = SCTipsView(title: "Tips")
    
    private lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height)
    private var tableHeightConstraint: NSLayoutConstraint!
    private var otherDetailsDataSetCollectionViewEmptyConstraint: NSLayoutConstraint!
    private var isArrayEmpty: Bool = false
    private var resultTotalCost: Double = 0
    
    // MARK: - Order Button Properties
    private var selectedDate: String? = nil
    private var selectedTime: String? = nil
    private var selectedDuration: Int? = nil
    private var selectedAddress: Address? = nil
    private var selectedPetMessage: String? = nil
    private var selectedMessage: String? = nil
    private var selectedItemsArray = [ExtraService]()
    private var selectedTips: Double? = nil
    
    private var selectedFormattedDate: Date? = nil
    private var selectedQuantityText: String? = nil
    private var selectedMessageText: String? = nil
    private var selectedButtonName: String? = nil
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        scrollView.contentSize = contentViewSize
        scrollView.frame = view.bounds
        scrollView.backgroundColor = .white
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        
        return view
    }()
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(SCOrderCell.self, forCellReuseIdentifier: SCOrderCell.identifier)
        tableView.register(SCTotalCostView.self, forHeaderFooterViewReuseIdentifier: SCTotalCostView.identifier)
        tableView.register(SCHeaderView.self, forHeaderFooterViewReuseIdentifier: SCHeaderView.identifier)
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    private let paypalButton = PayPalButton(label: .checkout)
    private let confirmationPopUp = SCConfirmationPopUp()
    private let paymentInformationLabel = SCSubTitleLabel(text: "", isRequired: false, textColor: .brandDark)
    
    private var orderDictionary = [String: Order]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Placing an order"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        configureWhenView()
        configureWhereView()
        configureOtherDetailsView()
        configureTipsView()
        configureTableView()
        configurePaymentLabel()
        configurePayPalButton()
        configurePayPalCheckout()
        
        whenView.delegate = self
        whereView.delegate = self
        otherDetailsView.delegate = self
        confirmationPopUp.delegate = self
        
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isWhenViewDataSet {
            whenViewHeightAnchor.isActive = false
            whenViewDataSetHeightAnchor.isActive = true
        }
        else {
            whenViewHeightAnchor.isActive = true
            whenViewDataSetHeightAnchor.isActive = false
        }
        
        if isWhereViewDataSet {
            whereViewHeightAnchor.isActive = false
            whereViewDataSetHeightAnchor.isActive = true
        }
        else {
            whereViewHeightAnchor.isActive = true
            whereViewDataSetHeightAnchor.isActive = false
        }
        
        if isOtherDetailsViewDataSet {
            
            if isArrayEmpty {
                otherDetailsViewHeightAnchor.isActive = false
                otherDetailsDataSetHeightAnchor.isActive = false
                otherDetailsDataSetCollectionViewEmptyConstraint.isActive = true
            } else {
                otherDetailsViewHeightAnchor.isActive = false
                otherDetailsDataSetHeightAnchor.isActive = true
                otherDetailsDataSetCollectionViewEmptyConstraint.isActive = false
            }
            
        }
        else {
            otherDetailsViewHeightAnchor.isActive = true
            otherDetailsDataSetHeightAnchor.isActive = false
        }
        
        otherDetailsView.updateCollectionView()
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let heightTotal: CGFloat = (whenView.frame.size.height) + (whereView.frame.size.height) + (otherDetailsView.frame.size.height) + (tipsView.frame.size.height) + (tableView.frame.size.height) + (paypalButton.frame.size.height) + (paymentInformationLabel.frame.size.height) + 200
        
        self.contentViewSize = CGSize(width: view.frame.size.width, height: heightTotal)
        self.scrollView.contentSize = contentViewSize
        self.contentView.frame.size = contentViewSize
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.tableView.layer.removeAllAnimations()
        tableHeightConstraint.constant = self.tableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        
    }
    
    @objc private func doneButtonTapped(_ button: UIBarButtonItem) {
        guard let text = tipsView.amountTextField.text else { return }
        
        orderDictionary["tips"] = Order(name: "Tips", cost: Double(text) ?? 0)
        selectedTips = Double(text) ?? 0
        
        self.tableView.reloadData()
        
        tipsView.amountTextField.resignFirstResponder()
    }

}

extension OrderViewController: WhenViewDelegate, SCWhenViewDelegate {
    
    func addDate(date: String, time: String, duration: Int?, selectedDate: Date?) {
        self.navigationController?.popViewController(animated: true)
        
        self.isWhenViewDataSet = self.whenView.setData(date: date, time: time, duration: duration ?? 0)
        
        orderDictionary["basic_cleaning"] = Order(name: "Basic cleaning hours (\(duration ?? 0) hours)", cost: Double((duration ?? 0) * 30))
        self.selectedDate = date
        selectedTime = time
        selectedDuration = duration ?? 0
        self.selectedFormattedDate = selectedDate
        self.tableView.reloadData()
        
    }
    
    func didTapEditButtonWhenView(_ button: UIButton) {
        
        let whenVC = WhenViewController()
        
        if let date = selectedFormattedDate, let duration = selectedDuration {
            whenVC.setData(date: date, duration: "\(duration) hours")
        }
        
        navigationController?.pushViewController(whenVC, animated: true)
        whenVC.delegate = self
                
    }
    
    
}

extension OrderViewController: WhereViewDelegate, SCWhereViewDelegate {
    
    func didTapEditButtonWhereView(_ button: UIButton) {
        
        let whereVC = WhereViewController()
        self.navigationController?.pushViewController(whereVC, animated: true)
        whereVC.delegate = self
    }
    
    
    func addAddress(address: Address) {
        self.navigationController?.popViewController(animated: true)
        
        self.isWhereViewDataSet = self.whereView.setData(address: address.street, contactPerson: address.contactPerson, contactNumber: address.contactNumber, type: address.type, sizes: address.sizes)
        
        orderDictionary["travel_expense"] = Order(name: "Travelling expenses", cost: 3)
        orderDictionary["sizes"] = Order(name: "Sizes add up", cost: 10)
        
        selectedAddress = address
        
        self.tableView.reloadData()
    }
    
}

extension OrderViewController: SCOtherDetailsViewDelegate, OtherDetailsViewDelegate {
    
    func fetchOtherDetailsData(buttonName: String, quantityText: String, messageText: String) {
        self.selectedButtonName = buttonName
        self.selectedQuantityText = quantityText
        self.selectedMessageText = messageText
    }
    
    
    func addOtherDetails(pet: String, message: String, selectedItems: [Int : ExtraService]) {
        self.navigationController?.popViewController(animated: true)
        
        self.isOtherDetailsViewDataSet = self.otherDetailsView.setData(pet: pet, message: message, selectedItems: selectedItems)
        
        if selectedItems.count == 0 {
            isArrayEmpty = true
        } else {
            isArrayEmpty = false
        }
          
        orderDictionary.removeValue(forKey: "extra_\(1)")
        orderDictionary.removeValue(forKey: "extra_\(2)")
        orderDictionary.removeValue(forKey: "extra_\(3)")
        orderDictionary.removeValue(forKey: "extra_\(4)")
        orderDictionary.removeValue(forKey: "extra_\(5)")
        orderDictionary.removeValue(forKey: "extra_\(6)")
        
        if !(pet.prefix(2) == "No") {
            orderDictionary["pets"] = Order(name: "Pets add up", cost: 10)
        }
        else {
            orderDictionary.removeValue(forKey: "pets")
        }
        
        for item in 0..<selectedItems.count {
            orderDictionary["extra_\(item + 1)"] = Order(name: "Extra services \(item + 1)", cost: 15)
        }
        
        selectedItemsArray.removeAll()
        
        for (_, value) in selectedItems {
            selectedItemsArray.append(value)
        }
                
        selectedPetMessage = pet
        selectedMessage = message
                
        self.tableView.reloadData()
        
    }
    
    
    
    func didTapEditButtonOtherView(_ button: UIButton) {
        
        let otherDetailsVC = OtherDetailsViewController()
        
        if let button = self.selectedButtonName, let quantity = selectedQuantityText, let message = selectedMessageText {
            otherDetailsVC.setOtherDetailsData(buttonName: button, quantityText: quantity, messageText: message)
        }
        
        self.navigationController?.pushViewController(otherDetailsVC, animated: true)
        otherDetailsVC.delegate = self
        
    }
    
    
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCOrderCell.identifier, for: indexPath) as? SCOrderCell else { return UITableViewCell() }
        
        let key = Array(orderDictionary).sorted(by: {$0.key < $1.key})[indexPath.row].key
        let value = orderDictionary[key]
        
        cell.setData(title: value!.name, value: value!.cost)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SCHeaderView.identifier) as? SCHeaderView else { return UIView() }
        
        view.setData(title: "Service charge")
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SCTotalCostView.identifier) as? SCTotalCostView else { return UIView() }
        
        var totalCost: Double = 0
        
        for item in orderDictionary.values {
            totalCost += item.cost
        }
        
        resultTotalCost = totalCost
        
        view.setData(cost: totalCost)
        
        configurePaymentLabel()
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
    
}

extension OrderViewController: SCConfirmationPopUpDelegate {
    
    func didTapConfirmationButton(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension OrderViewController {
    
    private func configureWhenView() {
        contentView.addSubview(whenView)
        
        NSLayoutConstraint.activate([
            whenView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            whenView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            whenView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        whenViewHeightAnchor = whenView.heightAnchor.constraint(equalToConstant: 50)
        whenViewDataSetHeightAnchor = whenView.heightAnchor.constraint(equalToConstant: 160)
        whenViewHeightAnchor.isActive = true
        whenViewDataSetHeightAnchor.isActive = false
        
    }
    
    private func configureWhereView() {
        contentView.addSubview(whereView)
        
        NSLayoutConstraint.activate([
            whereView.topAnchor.constraint(equalTo: whenView.bottomAnchor, constant: 20),
            whereView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            whereView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        whereViewHeightAnchor = whereView.heightAnchor.constraint(equalToConstant: 50)
        whereViewDataSetHeightAnchor = whereView.heightAnchor.constraint(equalToConstant: 260)
        whereViewHeightAnchor.isActive = true
        whereViewDataSetHeightAnchor.isActive = false
    }
    
    private func configureOtherDetailsView() {
        contentView.addSubview(otherDetailsView)
        
        NSLayoutConstraint.activate([
            otherDetailsView.topAnchor.constraint(equalTo: whereView.bottomAnchor, constant: 20),
            otherDetailsView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            otherDetailsView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        otherDetailsViewHeightAnchor = otherDetailsView.heightAnchor.constraint(equalToConstant: 50)
        otherDetailsDataSetHeightAnchor = otherDetailsView.heightAnchor.constraint(equalToConstant: 400)
        otherDetailsDataSetCollectionViewEmptyConstraint = otherDetailsView.heightAnchor.constraint(equalToConstant: 220)
        otherDetailsViewHeightAnchor.isActive = true
        otherDetailsDataSetHeightAnchor.isActive = false
        otherDetailsDataSetCollectionViewEmptyConstraint.isActive = false
    }
    
    private func configureTipsView() {
        contentView.addSubview(tipsView)
        
        let numberToolBar: UIToolbar = UIToolbar()
        numberToolBar.barStyle = UIBarStyle.default
        numberToolBar.items = [
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped(_:)))
        ]
        
        numberToolBar.sizeToFit()
        tipsView.amountTextField.inputAccessoryView = numberToolBar
        
        NSLayoutConstraint.activate([
            tipsView.topAnchor.constraint(equalTo: otherDetailsView.bottomAnchor, constant: 20),
            tipsView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tipsView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tipsView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureTableView() {
        contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addTopBorder(with: .brandGem, andWidth: 1)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tipsView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 360)
        tableHeightConstraint.isActive = true
    }
    
    private func configurePaymentLabel() {
        contentView.addSubview(paymentInformationLabel)
        paymentInformationLabel.font = UIFont.urbanistRegular(size: 16)!
        let attributedText = NSMutableAttributedString(string: "Your PayPal account will be temporarily authorized for ")
        attributedText.append(NSAttributedString(string: "$\(String(format: "%.2f", resultTotalCost))", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandGem, NSAttributedString.Key.font: UIFont.urbanistBold(size: 16)!]))
        attributedText.append(NSAttributedString(string: ". Once the order is "))
        attributedText.append(NSAttributedString(string: "completed", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: UIColor.systemGreen]))
        attributedText.append(NSAttributedString(string: ", it will automatically transfer the fund to the worker, and if order is "))
        attributedText.append(NSAttributedString(string: "cancelled", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandError, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: UIColor.brandError]))
        attributedText.append(NSAttributedString(string: ", the fund will send to your PayPal account."))
        paymentInformationLabel.attributedText = attributedText
        
        NSLayoutConstraint.activate([
            paymentInformationLabel.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 10),
            paymentInformationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            paymentInformationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
    }
    
    private func configurePayPalButton() {
        contentView.addSubview(paypalButton)
        paypalButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paypalButton.topAnchor.constraint(equalTo: paymentInformationLabel.bottomAnchor, constant: 10),
            paypalButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            paypalButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            paypalButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        paypalButton.setTitleColor(UIColor.brandDark, for: .normal)
        paypalButton.layer.shadowColor = UIColor.gray.cgColor
        paypalButton.layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
        paypalButton.layer.shadowRadius = 10
        paypalButton.layer.masksToBounds = false
        paypalButton.layer.shadowOpacity = 0.5
    }
    
    private func configurePayPalCheckout() {
        // acc: sb-f7pwi15477250@personal.example.com
        // pw: s!L3:4$A
        Checkout.setCreateOrderCallback { [weak self] createOrderAction in
            
            guard let self = self else { return }
            
            let amount = PurchaseUnit.Amount(currencyCode: .cad, value: String(format:"%.2f" ,self.resultTotalCost))
            let purchaseUnit = PurchaseUnit(amount: amount)
            let order = OrderRequest(intent: .capture, purchaseUnits: [purchaseUnit])

            createOrderAction.create(order: order)
        }

        Checkout.setOnApproveCallback { [weak self] approval in
            approval.actions.capture { [weak self] (response, error) in
                
                guard let self = self else { return }
                
                if error != nil {
                    self.presentAlert(title: "Error!", message: "There is an error with the payment. Please try again!", positiveAction: { action in
                        
                    }, negativeAction: nil)
                    
                    return
                }
                
                // get order id from paypal response
                self.confirmationPopUp.setOrderNumber(orderNumber: String(describing: response!.data.id))
                self.present(self.confirmationPopUp, animated: true, completion: nil)
                
                // consider add validation in every field
                guard let selectedDate = self.selectedDate, let selectedTime = self.selectedTime, let selectedDuration = self.selectedDuration, let selectedAddress = self.selectedAddress
                else {
                    return
                }
                
                let userOrder = UserOrder(date: selectedDate,
                                          time: selectedTime,
                                          duration: selectedDuration,
                                          address: selectedAddress,
                                          pet: self.selectedPetMessage ?? "",
                                          message: self.selectedMessage ?? "",
                                          selectedItems: self.selectedItemsArray.map {$0.name},
                                          tips: 0,
                                          totalCost: self.resultTotalCost,
                                          userId: self.currentUser.uid,
                                          id: UUID().uuidString,
                                          userName: self.currentUser.fullName,
                                          workerName: "",
                                          workerImageURL: "",
                                          userImageURL: self.currentUser.profileImageUrl?.absoluteString ?? "",
                                          createdAt: Date().toString(),
                                          updatedAt: Date().toString()
                                        )
                
                if let selectedTips = self.selectedTips {
                    userOrder.tips = selectedTips
                }

                let orderDict = try! DictionaryEncoder.encode(userOrder)
                FirebaseDBService.service.createNewOrder(value: orderDict as NSDictionary, id: userOrder.id)
                
            }
        }
        
        Checkout.setOnCancelCallback {
            print("Order Cancel")
        }
        
        Checkout.setOnErrorCallback {err in
            print(err.error)
        }
    }
}
