//
//  ChatViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

enum Completion: String {
    case proceeding = "Proceeding"
    case completed = "Completed"
}

class Chat {
    var userImage: UIImage
    var userName: String
    var message: String
    var date: String
    var completion: Completion
    
    init(userImage: UIImage, userName: String, message: String, date: String, completion: Completion) {
        self.userImage = userImage
        self.userName = userName
        self.message = message
        self.date = date
        self.completion = completion
    }
}

class ChatViewController: UIViewController {
    
    private var chatArray = [Chat]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SCChatCell.self, forCellReuseIdentifier: SCChatCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Chat"
        configureTableView()
        setData()
    }
    
    private func setData() {
        chatArray.append(Chat(userImage: UIImage(named: "carpet")!, userName: "Sella", message: "Hello mark, I am sella and I just take the job.", date: "Yesterday", completion: .completed))
        chatArray.append(Chat(userImage: UIImage(named: "carpet")!, userName: "Sella", message: "Hello mark, I am sella and I just take the job. I want you to beware of me!", date: "Yesterday", completion: .proceeding))
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCChatCell.identifier, for: indexPath) as? SCChatCell else { return UITableViewCell() }
        
        cell.setData(userImage: chatArray[indexPath.row].userImage, userName: chatArray[indexPath.row].userName, chatMessage: chatArray[indexPath.row].message, completionLabel: chatArray[indexPath.row].completion, dateLabel: chatArray[indexPath.row].date)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.addBottomBorder(with: .brandLake, andWidth: 1)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index of \(indexPath.row) is selected!")
    }
    
}

extension ChatViewController {
    
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
