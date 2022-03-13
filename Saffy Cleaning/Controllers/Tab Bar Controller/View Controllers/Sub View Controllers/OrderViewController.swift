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
    
    private lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 600)
    
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
        
        return tableView
    }()
    
    private let paypalButton = SCMainButton(title: "Pay with PayPal", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: 18)
    
    private var orderArray = [Order]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Placing an order"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        configureWhenView()
        configureWhereView()
        configureOtherDetailsView()
        configureTableView()
        configurePayPalButton()
        
        whenView.delegate = self
        whereView.delegate = self
        otherDetailsView.delegate = self
        
        setData()
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
            otherDetailsViewHeightAnchor.isActive = false
            otherDetailsDataSetHeightAnchor.isActive = true
        }
        else {
            otherDetailsViewHeightAnchor.isActive = true
            otherDetailsDataSetHeightAnchor.isActive = false
        }
        
        otherDetailsView.updateCollectionView()
        
    }
    
    @objc private func paypalButtonTapped(_ button: UIButton) {
        print("Paypal button tapped")
    }
    
    private func setData() {
        orderArray.append(Order(name: "Basic cleaning hours (2 hrs)", cost: 30))
    }

}

extension OrderViewController: WhenViewDelegate, SCWhenViewDelegate {
    
    func addDate(date: String, time: String, duration: String?) {
        self.navigationController?.popViewController(animated: true)
        
        self.isWhenViewDataSet = self.whenView.setData(date: date, time: time, duration: duration ?? "0")
        
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
        
        orderArray.append(Order(name: "Travelling expenses", cost: 3))
        orderArray.append(Order(name: "Sizes add up", cost: 10))
        
        self.tableView.reloadData()
    }
    
}

extension OrderViewController: SCOtherDetailsViewDelegate, OtherDetailsViewDelegate {
    
    func addOtherDetails(pet: String, message: String, tips: String, selectedItems: [ExtraService]) {
        self.navigationController?.popViewController(animated: true)
        
        self.isOtherDetailsViewDataSet = self.otherDetailsView.setData(pet: pet, message: message, tips: tips, selectedItems: selectedItems)
        
        for item in 0..<selectedItems.count {
            orderArray.append(Order(name: "Extra services \(item + 1)", cost: 15))
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
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCOrderCell.identifier, for: indexPath) as? SCOrderCell else { return UITableViewCell() }
        
        cell.setData(title: orderArray[indexPath.row].name, value: orderArray[indexPath.row].cost)
        
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
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SCTotalCostView.identifier) as? SCTotalCostView else { return UIView() }
        
        var totalCost: Double = 0
        
        for item in orderArray {
            totalCost += item.cost
        }
        
        view.setData(cost: totalCost)
        
        return view
        
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
        otherDetailsDataSetHeightAnchor = otherDetailsView.heightAnchor.constraint(equalToConstant: 480)
        otherDetailsViewHeightAnchor.isActive = true
        otherDetailsDataSetHeightAnchor.isActive = false
    }
    
    private func configureTableView() {
        contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addTopBorder(with: .brandGem, andWidth: 1)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: otherDetailsView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 360)
        ])
    }
    
    private func configurePayPalButton() {
        contentView.addSubview(paypalButton)
        paypalButton.addTarget(self, action: #selector(paypalButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            paypalButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            paypalButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            paypalButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            paypalButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

class Order {
    var name: String
    var cost: Double
    
    init(name: String, cost: Double) {
        self.name = name
        self.cost = cost
    }
}
