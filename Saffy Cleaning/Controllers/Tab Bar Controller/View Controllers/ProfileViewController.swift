//
//  ProfileViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit
import Firebase
import SDWebImage

protocol ProfileViewProtocol {
    func changeUserType()
}


class ProfileViewController: UIViewController {
    
    private let profileImageView = SCProfileImageView(cornerRadius: 60)
    private let usernameLabel = SCMainLabel(fontSize: 18, textColor: .brandDark)
    private var horizontalStackView: SCStackView!
    private let hiringView = SCVerticalOrderInfoView(backgroundColor: .white, height: 30, isCentered: true)
    private let averageScoreView = SCVerticalOrderInfoView(backgroundColor: .white, height: 30, isCentered: true)
    private let yearView = SCVerticalOrderInfoView(backgroundColor: .white, height: 30, isCentered: true)
    
    var delegate: ProfileViewProtocol? = nil
    private var numbOfHire = 0;
    private var average = 0;
    private var yearsOfJoining = 0;

    private var switchUserVC: SCSwitchUserPopUp? = nil
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SCReviewCell.self, forCellReuseIdentifier: SCReviewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private var reviewArray = [Review]()
    
    public var user: User? {
        didSet {
            print("User data is set.")
            switchUserVC = SCSwitchUserPopUp(user: user!)
            switchUserVC?.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureImageViewAndLabel()
        configureHorizontalStackView()
        configureTableView()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseDBService.service.retrieveUser { [weak self] user in
            
            guard let self = self else { return }
            
            if let user = user {
                self.user = user
            
                DispatchQueue.main.async {
                    self.usernameLabel.text = user.fullName
                    
                    if let profileImage = user.profileImageUrl {
                        self.profileImageView.sd_setImage(with: profileImage, completed: nil)
                    }
                    else {
                        self.profileImageView.image = UIImage(systemName: "person.circle")!
                    }
                }
            }
        }
    }
    
    @objc private func changeButtonTapped(_ button: UIBarButtonItem) {
        
        if user != nil {
            self.present(switchUserVC!, animated: true, completion: nil)
        }
        
    }
    
    @objc private func editButtonTapped(_ button: UIBarButtonItem) {
        let vc = EditProfileViewController(user: self.user!)
        navigationController?.pushViewController(vc, animated: true)
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
    
    private func updateContent () {
        if(!reviewArray.isEmpty) {
        hiringView.infoLabel.text = String(reviewArray.count)
            for item in reviewArray {
                average += item.ratingCount
            }
            average = average / reviewArray.count
        }
        averageScoreView.infoLabel.text = String(average)
    }
    
    private func setData() {
        FirebaseDBService.service.retrieveUser { user in
            guard let user = user else { return }
            FirebaseDBService.service.retrieveReviews(type: user.userType) { [weak self] reviews in
                self?.reviewArray = reviews
                self?.numbOfHire = reviews.count

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.updateContent()
                }
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCReviewCell.identifier, for: indexPath) as? SCReviewCell else { return UITableViewCell() }
        
        cell.setData(userImage: reviewArray[indexPath.row].reviewerImageUrl, ratingCount: reviewArray[indexPath.row].ratingCount, userReview: reviewArray[indexPath.row].info, currentDate: reviewArray[indexPath.row].date)
        
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

extension ProfileViewController :SCSwitchUserPopUpDelegate {
    func dismissPopUp() {
        self.delegate?.changeUserType()
    }
}

extension ProfileViewController {
    
    private func configureViewController() {
        
        view.backgroundColor = .white
        title = "Profile"
        
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "gobackward"), style: .plain, target: self, action: #selector(changeButtonTapped(_:)))
        
        let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .done, target: self, action: #selector(editButtonTapped(_:)))
        
        let signOutButton = UIBarButtonItem(image: UIImage(systemName: "power.circle"), style: .done, target: self, action: #selector(signOutButtonTapped(_:)))
        
        navigationItem.rightBarButtonItems = [editButton, refreshButton]
        navigationItem.leftBarButtonItem = signOutButton
        
    }
    
    private func configureImageViewAndLabel() {
        view.addSubview(profileImageView)
        
        /*
        if let profileImage = user?.profileImageUrl {
            if let data = try? Data(contentsOf: profileImage) {
                profileImageView.image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal)
            }
        }
        else {
            profileImageView.image = UIImage(named: "carpet")!
        }
        */
        usernameLabel.text = user?.fullName
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
        
        hiringView.infoLabel.text = "0"
        hiringView.infoValue.text = "Hiring"
        
        averageScoreView.infoLabel.text = "0"
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
