//
//  ProfileViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    private let profileImageView = SCProfileImageView(cornerRadius: 60)
    private let usernameLabel = SCMainLabel(fontSize: 18, textColor: .brandDark)
    private var horizontalStackView: SCStackView!
    private let hiringView = SCVerticalOrderInfoView(backgroundColor: .white, height: 30, isCentered: true)
    private let averageScoreView = SCVerticalOrderInfoView(backgroundColor: .white, height: 30, isCentered: true)
    private let yearView = SCVerticalOrderInfoView(backgroundColor: .white, height: 30, isCentered: true)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SCReviewCell.self, forCellReuseIdentifier: SCReviewCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private var reviewArray = [Review]()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureImageViewAndLabel()
        configureHorizontalStackView()
        configureTableView()
        setData()
        
        // GET THE USER DATA FROM FIREBASE TO DISPLAY
    }
    
    
    @objc private func refreshButtonTapped(_ button: UIBarButtonItem) {
        
    }
    
    @objc private func editButtonTapped(_ button: UIBarButtonItem) {
        
    }
    
    @objc private func signOutButtonTapped(_ button: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(UINavigationController(rootViewController: LoginViewController()))
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func setData() {
        reviewArray.append(Review(date: "17-Nov-21", info: "Effective and polite kasjddsakjdashkldahsljkdhjaskdajhksldasljkhdasjhdjsahkldashjkdsajhkldasljkhdasjhkdasjhlkdasljasdkadsljksaddhjaskdhsajldsahjlkdsahjldasljh"))
        reviewArray.append(Review(date: "17-Nov-21", info: "Effective and polite"))
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCReviewCell.identifier, for: indexPath) as? SCReviewCell else { return UITableViewCell() }
        
        cell.setData(userImage: UIImage(named: "carpet"), ratingCount: 4, userReview: reviewArray[indexPath.row].info, currentDate: reviewArray[indexPath.row].date)
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .brandDark
        header.textLabel?.font = UIFont.urbanistRegular(size: 18)!
        header.textLabel?.frame = header.bounds
        
    }
        
}

extension ProfileViewController {
    
    private func configureViewController() {
        
        view.backgroundColor = .white
        title = "Profile"
        
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "gobackward"), style: .plain, target: self, action: #selector(refreshButtonTapped(_:)))
        
        let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .done, target: self, action: #selector(editButtonTapped(_:)))
        
        let signOutButton = UIBarButtonItem(image: UIImage(systemName: "power.circle"), style: .done, target: self, action: #selector(signOutButtonTapped(_:)))
        
        navigationItem.rightBarButtonItems = [editButton, refreshButton]
        navigationItem.leftBarButtonItem = signOutButton
        
    }
    
    private func configureImageViewAndLabel() {
        view.addSubview(profileImageView)
        profileImageView.image = UIImage(named: "carpet")!
        usernameLabel.text = "Onurcan Sever"
        view.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureHorizontalStackView() {
        horizontalStackView = SCStackView(arrangedSubviews: [hiringView, averageScoreView, yearView])
        view.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.addTopBorder(with: .brandGem, andWidth: 1)
        horizontalStackView.addBottomBorder(with: .brandGem, andWidth: 1)
        
        hiringView.infoLabel.text = "2"
        hiringView.infoValue.text = "Hiring"
        
        averageScoreView.infoLabel.text = "4"
        averageScoreView.infoValue.text = "Average"
        
        yearView.infoLabel.text = "1"
        yearView.infoValue.text = "Year"
        
        NSLayoutConstraint.activate([
            hiringView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            hiringView.widthAnchor.constraint(equalToConstant: 60),
            averageScoreView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            averageScoreView.widthAnchor.constraint(equalToConstant: 80),
            yearView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            yearView.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

class Review {
    var date: String
    var info: String
    
    init(date: String, info: String) {
        self.date = date
        self.info = info
    }
}
