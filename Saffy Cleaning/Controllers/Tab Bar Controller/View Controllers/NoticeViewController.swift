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
    
    private var notificationArray = [UserOrder]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Notice"
        configureTableView()
        testDummyData()
    }
    
    private func testDummyData() {
        
        let userOrder1 = UserOrder(
            date: "30-03-2022",
            time: "14:04 PM",
            duration: 4,
            address:
                Address(
                    name: "",
                    room: "Room A",
                    flat: "Flat B",
                    street: "Sherbourne Street",
                    postalCode: "M4X31A",
                    building: "Empire Building",
                    district: "",
                    contactPerson: "Hector Vu",
                    contactNumber: "561-334-11-22",
                    type: "Apartment", sizes: "1255",
                    longitude: -80.74135461822152,
                    latitude: 43.48108050634096,
                    images: ["carpet"],
                    createdAt: "22-03-2022"),
            pet: "No",
            message: "Please beware of",
            selectedItems: ["Carpet\nCleaning", "Garage Cleaning"],
            tips: nil,
            totalCost: 104)
        
        let userOrder2 = UserOrder(
            date: "30-03-2022",
            time: "14:04 PM",
            duration: 4,
            address:
                Address(
                    name: "",
                    room: "Room A",
                    flat: "Flat B",
                    street: "Sherbourne Street",
                    postalCode: "M4X31A",
                    building: "Empire Building",
                    district: "",
                    contactPerson: "Hector Vu",
                    contactNumber: "561-334-11-22",
                    type: "Apartment", sizes: "1255",
                    longitude: -80.74135461822152,
                    latitude: 43.48108050634096,
                    images: ["carpet"],
                    createdAt: "22-03-2022"),
            pet: "No",
            message: "Please beware of",
            selectedItems: ["Carpet\nCleaning", "Garage Cleaning"],
            tips: nil,
            totalCost: 104)
        
        userOrder2.status = "matched"
        
        let userOrder3 = UserOrder(
            date: "30-03-2022",
            time: "14:04 PM",
            duration: 4,
            address:
                Address(
                    name: "",
                    room: "Room A",
                    flat: "Flat B",
                    street: "Sherbourne Street",
                    postalCode: "M4X31A",
                    building: "Empire Building",
                    district: "",
                    contactPerson: "Hector Vu",
                    contactNumber: "561-334-11-22",
                    type: "Apartment", sizes: "1255",
                    longitude: -80.74135461822152,
                    latitude: 43.48108050634096,
                    images: ["carpet"],
                    createdAt: "22-03-2022"),
            pet: "No",
            message: "Please beware of",
            selectedItems: ["Carpet\nCleaning", "Garage Cleaning"],
            tips: nil,
            totalCost: 104)
        
        userOrder3.status = "completed"
        
        notificationArray.append(userOrder1)
        notificationArray.append(userOrder2)
        notificationArray.append(userOrder3)
        
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
        
        cell.setData(userOrder: notificationArray[indexPath.row])
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

extension NoticeViewController: SCNotificationCellDelegate {
    
    func userTappedOnView() {
        print("User will see workers profile.")
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
