//
//  OrderViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

class OrderViewController: UIViewController {
    
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
    
    private lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 600)
    private var tableHeightConstraint: NSLayoutConstraint!
    private var otherDetailsDataSetCollectionViewEmptyConstraint: NSLayoutConstraint!
    private var isArrayEmpty: Bool = false
    private var resultTotalCost: Double = 0
    
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
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    private let paypalButton = SCMainButton(title: "Pay with PayPal", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: 18)
    private let confirmationPopUp = SCConfirmationPopUp()
    
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
        configurePayPalButton()
        
        whenView.delegate = self
        whereView.delegate = self
        otherDetailsView.delegate = self
        tipsView.amountTextField.delegate = self
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
        
        print("Constant: \(otherDetailsDataSetHeightAnchor.constant)")
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.tableView.layer.removeAllAnimations()
        tableHeightConstraint.constant = self.tableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        
    }
    
    @objc private func paypalButtonTapped(_ button: UIButton) {
        print("Paypal button tapped and result cost is \(resultTotalCost)")
        confirmationPopUp.setOrderNumber(orderNumber: "456-878-996")
        self.present(confirmationPopUp, animated: true, completion: nil)
        for (key, value) in orderDictionary {
            print("\(key) : \(value)")
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    @objc private func doneButtonTapped(_ button: UIBarButtonItem) {
        guard let text = tipsView.amountTextField.text else { return }
        
        orderDictionary["tips"] = Order(name: "Tips", cost: Double(text) ?? 0)
        
        self.tableView.reloadData()
        
        tipsView.amountTextField.resignFirstResponder()
    }

}

extension OrderViewController: WhenViewDelegate, SCWhenViewDelegate {
    
    func addDate(date: String, time: String, duration: Int?) {
        self.navigationController?.popViewController(animated: true)
        
        self.isWhenViewDataSet = self.whenView.setData(date: date, time: time, duration: duration ?? 0)
        
        orderDictionary["basic_cleaning"] = Order(name: "Basic cleaning hours (\(duration ?? 0) hours)", cost: Double((duration ?? 0) * 30))
        self.tableView.reloadData()
        
    }
    
    func didTapEditButtonWhenView(_ button: UIButton) {
        print("Edit button clicked")
        
        let whenVC = WhenViewController()
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
    
    
    func addAddress(address: String, contactPerson: String, contactNumber: String, type: String, sizes: String) {
        self.navigationController?.popViewController(animated: true)
        
        self.isWhereViewDataSet = self.whereView.setData(address: address, contactPerson: contactPerson, contactNumber: contactNumber, type: type, sizes: sizes)
        
        orderDictionary["travel_expense"] = Order(name: "Travelling expenses", cost: 3)
        orderDictionary["sizes"] = Order(name: "Sizes add up", cost: 10)
        
        self.tableView.reloadData()
    }
    
}

extension OrderViewController: SCOtherDetailsViewDelegate, OtherDetailsViewDelegate {
    
    func addOtherDetails(pet: String, message: String, selectedItems: [ExtraService]) {
        self.navigationController?.popViewController(animated: true)
        
        self.isOtherDetailsViewDataSet = self.otherDetailsView.setData(pet: pet, message: message, selectedItems: selectedItems)
        
        if selectedItems.count == 0 {
            isArrayEmpty = true
        } else {
            isArrayEmpty = false
        }
  
        print("Selected items count: \(selectedItems.count)")
        
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
            print("Before adding: \(orderDictionary.values)")
            orderDictionary["extra_\(item + 1)"] = Order(name: "Extra services \(item + 1)", cost: 15)
            print("After adding: \(orderDictionary.values)")
            print("Selected items: \(selectedItems)")
        }
                
        self.tableView.reloadData()
        
    }
    
    
    
    func didTapEditButtonOtherView(_ button: UIButton) {
        
        let otherDetailsVC = OtherDetailsViewController()
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Service charge"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .brandDark
        header.textLabel?.font = UIFont.urbanistBold(size: 18)!
        header.textLabel?.frame = header.bounds
        header.isUserInteractionEnabled = false
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SCTotalCostView.identifier) as? SCTotalCostView else { return UIView() }
        
        var totalCost: Double = 0
        
        for item in orderDictionary.values {
            totalCost += item.cost
        }
        
        resultTotalCost = totalCost
        
        view.setData(cost: totalCost)
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
    
}

extension OrderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text else { return false }
        
        orderDictionary["tips"] = Order(name: "Tips", cost: Double(text)!)
        
        self.tableView.reloadData()
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

extension OrderViewController: SCConfirmationPopUpDelegate {
    
    func didTapConfirmationButton(_ button: UIButton) {
        print("Order confirmation button pressed.")
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
        tipsView.amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
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
    
    private func configurePayPalButton() {
        contentView.addSubview(paypalButton)
        paypalButton.addTarget(self, action: #selector(paypalButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            paypalButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            paypalButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            paypalButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            paypalButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
