//
//  ChatListController.swift
//  Saffy Cleaning
//
//  Created by Mark Chan on 30/3/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

enum Completion: String {
    case proceeding = "Proceeding"
    case completed = "Completed"
}

class Chat {
    var userImage: URL
    var userName: String
    var message: String
    var date: String
    var completion: Completion
    var id: String
    
    init(userImage: URL, userName: String, message: String, date: String, completion: Completion, id: String) {
        self.userImage = userImage
        self.userName = userName
        self.message = message
        self.date = date
        self.completion = completion
        self.id = id
    }
}
class ChatListViewController : UIViewController {
    private let toolbarLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private var chatArray: [Chat] = []
    
    private let channelCellIdentifier = "channelCell"
    private var currentChannelAlertController: UIAlertController?
    
    private let database = Firestore.firestore()
    
    private var channelReference: CollectionReference {
        return database.collection("channels")
    }
    
    private var channelListener: ListenerRegistration?
    
    private var currentUser: User
    
    deinit {
        channelListener?.remove()
    }
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setData() {
   
        FirebaseDBService.service.retrieveMatchedOrders(type: currentUser.userType) { [weak self] orders in
            var _chatArray: [Chat] = []
            orders.forEach { order in
                let isWorker = self?.currentUser.userType == UserType.worker.rawValue ? true : false
                let userName = isWorker ? order.userName : order.workerName
                let icon = isWorker ? URL(string: order.userImageURL) : URL(string: order.workerImageURL)
                _chatArray.append(Chat(userImage: icon!,
                                       userName: userName,
                                       message: "", date: "",
                                       completion: order.status == UserOrderType.matched.rawValue ? .proceeding: .completed,
                                       id: order.id))
            }

            DispatchQueue.main.async {
                self?.chatArray = _chatArray
                self?.tableView.reloadData()
            }
        }
    }
    
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
    

    
//    // MARK: Add new channel -> after the booking is matched
//    @objc private func addButtonPressed() {
//        let alertController = UIAlertController(title: "Create a new Channel", message: nil, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alertController.addTextField { field in
//            field.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
//            field.enablesReturnKeyAutomatically = true
//            field.autocapitalizationType = .words
//            field.clearButtonMode = .whileEditing
//            field.placeholder = "Channel name"
//            field.returnKeyType = .done
//            field.tintColor = .primary
//        }
//
//        let createAction = UIAlertAction(
//            title: "Create",
//            style: .default) { _ in
//                self.createChannel()
//            }
//        createAction.isEnabled = false
//        alertController.addAction(createAction)
//        alertController.preferredAction = createAction
//
//        present(alertController, animated: true) {
//            alertController.textFields?.first?.becomeFirstResponder()
//        }
//        currentChannelAlertController = alertController
//    }
    
    @objc private func textFieldDidChange(_ field: UITextField) {
        guard let alertController = currentChannelAlertController else {
            return
        }
        alertController.preferredAction?.isEnabled = field.hasText
    }
    
    // MARK: - Helpers
    private func createChannel() {
        guard
            let alertController = currentChannelAlertController,
            let channelName = alertController.textFields?.first?.text
        else {
            return
        }
        
        let channel = Channel(name: channelName)
        channelReference.addDocument(data: channel.representation) { error in
            if let error = error {
                print("Error saving channel: \(error.localizedDescription)")
            }
        }
    }
    
}

// MARK: - TableViewDelegate
extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCChatCell.identifier, for: indexPath) as? SCChatCell else { return UITableViewCell() }
        
        cell.setData(userImage: chatArray[indexPath.row].userImage,
                     userName: chatArray[indexPath.row].userName,
                     chatMessage: chatArray[indexPath.row].message,
                     completionLabel: chatArray[indexPath.row].completion,
                     dateLabel: chatArray[indexPath.row].date)
        
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
        let id = chatArray[indexPath.row].id
        let isAble = chatArray[indexPath.row].completion == .proceeding
        let viewController = ChatViewController(user: currentUser, orderId: id, isAble: isAble)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
