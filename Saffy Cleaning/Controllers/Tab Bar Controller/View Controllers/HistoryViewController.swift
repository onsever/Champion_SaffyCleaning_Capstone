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

class HistoryViewController: UITableViewController {

    private var historyArray = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "History"
        view.backgroundColor = .white
        
        self.tableView.register(SCHistoryCardCell.self, forCellReuseIdentifier: SCHistoryCardCell.identifier)
        setData()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCHistoryCardCell.identifier, for: indexPath) as? SCHistoryCardCell else { return UITableViewCell() }
        
        cell.setData(addressTitle: historyArray[indexPath.row].address, date: historyArray[indexPath.row].date, status: historyArray[indexPath.row].status)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

}

extension HistoryViewController {
    
    private func setData() {
        historyArray.append(History(address: "6th Ave N. Fountain Heights", date: "28-Dec-2021", status: .proceeding))
        historyArray.append(History(address: "6th Ave N. Fountain Heights", date: "28-Dec-2021", status: .completed))
        historyArray.append(History(address: "6th Ave N. Fountain Heights", date: "28-Dec-2021", status: .cancelled))
    }
    
}
