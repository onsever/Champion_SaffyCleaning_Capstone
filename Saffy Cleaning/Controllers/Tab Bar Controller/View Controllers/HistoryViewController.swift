//
//  HistoryViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

enum Status: String {
    case completed = "Completed"
    case proceeding = "Proceeding"
    case cancelled = "Cancelled"
}

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var historyArray = [History]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(SCHistoryCardCell.self, forCellReuseIdentifier: SCHistoryCardCell.identifier)
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "History"
        view.backgroundColor = .white
        
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseDBService.service.retrieveOrderHistory() { histories in
            guard histories.isEmpty == false else { return }
            DispatchQueue.main.async {
                self.historyArray = histories
                self.tableView.reloadData()
            }
            
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCHistoryCardCell.identifier, for: indexPath) as? SCHistoryCardCell else { return UITableViewCell() }
        
        cell.setData(addressTitle: historyArray[indexPath.row].address, date: historyArray[indexPath.row].date, status: historyArray[indexPath.row].status.capitalized)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

}

extension HistoryViewController {
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
