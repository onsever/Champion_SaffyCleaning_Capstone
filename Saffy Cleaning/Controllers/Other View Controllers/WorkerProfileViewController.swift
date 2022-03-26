//
//  WorkerProfileViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-24.
//

import UIKit
import Firebase
import SDWebImage

protocol WorkerProfileViewControllerDelegate: AnyObject {
    func didTapAcceptButton(_ orderId: String)
    func didTapRejectedButton(_ orderId: String)
}

class WorkerProfileViewController: UIViewController {
    
    
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
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private var buttonStackView: SCStackView!
    private let acceptButton = SCMainButton(title: "ACCEPT", backgroundColor: .brandGem, titleColor: .white, cornerRadius: 10, fontSize: nil)
    private let rejectedButton = SCMainButton(title: "REJECTED", backgroundColor: .white, titleColor: .brandError, borderColor: .brandError, cornerRadius: 10, fontSize: nil)
    public weak var delegate: WorkerProfileViewControllerDelegate?
    public var orderID: String?
    
    private var reviewArray = [Review]()
    public var user: User? {
        didSet {
            print("User data is set.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureImageViewAndLabel()
        configureHorizontalStackView()
        configureTableView()
        configureButtonStackView()
        setData()
    }
    
    @objc private func acceptButtonTapped(_ button: UIButton) {
        button.animateWithSpring()
        delegate?.didTapAcceptButton(orderID!)
        print("Accepted")
        self.dismiss(animated: true)
    }
    
    @objc private func rejectedButtonTapped(_ button: UIButton) {
        button.animateWithSpring()
        delegate?.didTapRejectedButton(orderID!)
        print("Rejected")
        self.dismiss(animated: true)
    }
    
    private func setData() {
        FirebaseDBService.service.retrieveUser { user in
            guard let user = user else { return }
            self.profileImageView.sd_setImage(with: user.profileImageUrl)
            FirebaseDBService.service.retrieveUserReviews(type: user.userType) { [weak self] reviews in
                self?.reviewArray = reviews
            }
        }
    }

}

extension WorkerProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension WorkerProfileViewController {
    
    private func configureViewController() {

        view.backgroundColor = .white
        title = "Profile"
    }
    
    private func configureImageViewAndLabel() {
        view.addSubview(profileImageView)
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
        
        hiringView.infoLabel.text = "2"
        hiringView.infoValue.text = "Services"
        
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
    
    private func configureButtonStackView() {
        buttonStackView = SCStackView(arrangedSubviews: [rejectedButton, acceptButton])
        view.addSubview(buttonStackView)
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.axis = .horizontal
        
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped(_:)), for: .touchUpInside)
        rejectedButton.addTarget(self, action: #selector(rejectedButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
}
