//
//  NoticeViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

class NoticeViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SCNotificationCell.self, forCellReuseIdentifier: SCNotificationCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    public var user: User?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private var notificationArray = [UserOrder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Notice"
        configureTableView()
    }

    private func fetchData() {
        FirebaseDBService.service.retrieveUser { [weak self] user in
            if let user = user {
                if user.userType == UserType.user.rawValue {
                    FirebaseDBService.service.retrieveUserOrders { [weak self] orders in
                        DispatchQueue.main.async {
                            self?.notificationArray = orders
                            self?.user = user
                            self?.tableView.reloadData()
                        }
                    }
                } else {
                    FirebaseDBService.service.retrieveWorkOrders {[weak self] orders in
                        DispatchQueue.main.async {
                            self?.notificationArray = orders
                            self?.user = user
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCNotificationCell.identifier, for: indexPath) as? SCNotificationCell else { return UITableViewCell() }
        
        cell.setData(userOrder: notificationArray[indexPath.row], user: user!)
        cell.order = notificationArray[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.addBottomBorder(with: .brandGem, andWidth: 1)
        
    }
    
}

extension NoticeViewController:SCNotificationCellDelgate {
    
    func syncUserId(id: String, orderId: String) {
        FirebaseDBService.service.retrieveUserById(id: id) { [weak self] user in
            let viewWorkerProfileVc = WorkerProfileViewController()
            viewWorkerProfileVc.user = user
            viewWorkerProfileVc.delegate = self
            viewWorkerProfileVc.orderID = orderId
            self?.present(viewWorkerProfileVc, animated: true, completion: nil)
        }
    }
    
    func checkout(totalCost: String) {
//        let checkoutVC = CheckoutViewController()
//        checkoutVC.totalCost = totalCost
//        self.present(checkoutVC, animated: true, completion: nil)
    }
}

extension NoticeViewController {
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension NoticeViewController:WorkerProfileViewControllerDelegate {
    func didTapAcceptButton(_ orderId: String) {
        FirebaseDBService.service.updateOrderStatus(orderId: orderId, value: ["status": UserOrderType.matched.rawValue])
    }
    
    func didTapRejectedButton(_ orderId: String) {
        FirebaseDBService.service.updateOrderStatus(orderId: orderId, value: ["status": UserOrderType.cancelled.rawValue], isCancellOrder: true)
    }
    
    
}
