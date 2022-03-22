//
//  NearbyOrderViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-22.
//

import UIKit

protocol NearbyOrderViewControllerDelegate: AnyObject {
    func didDismissNearbyOrder()
}

class NearbyOrderViewController: UIViewController {
    
    private lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 250)
        
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
    
    private let nearbyOrderLabel = SCMainLabel(fontSize: 20, textColor: .brandDark)
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SCHousePhotoCell.self, forCellWithReuseIdentifier: SCHousePhotoCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = false
        layout.scrollDirection = .horizontal
        
        return collectionView
    }()
    
    private lazy var informationTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(SCNearbyOrderCell.self, forCellReuseIdentifier: SCNearbyOrderCell.identifier)
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private let messageToCleanerView = SCVerticalOrderInfoView(backgroundColor: .white, height: 40)
    
    private lazy var rewardsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(SCOrderCell.self, forCellReuseIdentifier: SCOrderCell.identifier)
        tableView.register(SCTotalCostView.self, forHeaderFooterViewReuseIdentifier: SCTotalCostView.identifier)
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private let takeJobButton = SCMainButton(title: "Take Job", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    
    private var infoTableHeightConstraint: NSLayoutConstraint!
    private var rewardsTableHeightConstraint: NSLayoutConstraint!
    
    private var infoDictionary = [String: String]()
    private var rewardsDictionary = [String: Order]()
    private var imageArray = [UIImage]()
    private var userOrder: UserOrder
    
    public weak var delegate: NearbyOrderViewControllerDelegate?
    
    init(userOrder: UserOrder) {
        self.userOrder = userOrder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.layer.borderColor = UIColor.brandGem.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        imageArray.append(UIImage(named: "carpet")!)
        imageArray.append(UIImage(named: "carpet")!)
        imageArray.append(UIImage(named: "carpet")!)
        imageArray.append(UIImage(named: "carpet")!)
        
        view.backgroundColor = .white
        configureNearbyOrderLabel()
        configureCollectionView()
        configureInfoTableView()
        configureMessageView()
        configureRewardsTableView()
        configureTakeJobButton()
        
        informationTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        rewardsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        setUserOrder()
        
    }
    
    @objc private func takeJobButtonTapped(_ button: UIButton) {
        button.animateWithSpring()
        
        let takeJobVC = SCTakeJobPopUp()
        takeJobVC.delegate = self
        self.present(takeJobVC, animated: true, completion: nil)
    }
    
    private func setUserOrder() {
        
        infoDictionary["Date"] = userOrder.date
        infoDictionary["Time"] = userOrder.time
        infoDictionary["Duration "] = "\(userOrder.duration) hours"
        infoDictionary["Address"] = userOrder.address.street
        infoDictionary["Type"] = userOrder.address.type
        infoDictionary["Sizes"] = "\(userOrder.address.sizes) square feet"
        infoDictionary["Pets"] = userOrder.pet
        infoDictionary["Extra services"] = "\(userOrder.selectedItems.count) services"
        messageToCleanerView.infoValue.text = userOrder.message
        
        rewardsDictionary["basic_cleaning"] = Order(name: "Basic cleaning", cost: 30)
        rewardsDictionary["travelling_expenses"] = Order(name: "Travelling expenses", cost: 3)
        rewardsDictionary["sizes"] = Order(name: "Sizes add up", cost: 10)
        
        for index in 0..<userOrder.selectedItems.count {
            rewardsDictionary["extra_\(index + 1)"] = Order(name: "Extra services \(index + 1)", cost: 10)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.informationTableView.layer.removeAllAnimations()
        infoTableHeightConstraint.constant = self.informationTableView.contentSize.height
        self.rewardsTableView.layer.removeAllAnimations()
        rewardsTableHeightConstraint.constant = self.rewardsTableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        
    }
    

}

extension NearbyOrderViewController: SCTakeJobPopUpDelegate {
    
    func didTapConfirmationTakeJob(_ button: UIButton) {
        print("Confirmation button tapped!")
        delegate?.didDismissNearbyOrder()
    }
    
}

extension NearbyOrderViewController {
    
    private func configureNearbyOrderLabel() {
        contentView.addSubview(nearbyOrderLabel)
        nearbyOrderLabel.font = .urbanistBold(size: 20)
        nearbyOrderLabel.text = "Nearby Order"
        nearbyOrderLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            nearbyOrderLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            nearbyOrderLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nearbyOrderLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nearbyOrderLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureCollectionView() {
        contentView.addSubview(imageCollectionView)
        
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: nearbyOrderLabel.bottomAnchor, constant: 15),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureInfoTableView() {
        contentView.addSubview(informationTableView)
        
        NSLayoutConstraint.activate([
            informationTableView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 10),
            informationTableView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            informationTableView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        infoTableHeightConstraint = informationTableView.heightAnchor.constraint(equalToConstant: 360)
        infoTableHeightConstraint.isActive = true
    }
    
    private func configureMessageView() {
        contentView.addSubview(messageToCleanerView)
        
        messageToCleanerView.infoLabel.text = "Message to cleaner"
        
        NSLayoutConstraint.activate([
            messageToCleanerView.topAnchor.constraint(equalTo: informationTableView.bottomAnchor, constant: 10),
            messageToCleanerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageToCleanerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            messageToCleanerView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureRewardsTableView() {
        contentView.addSubview(rewardsTableView)
        
        NSLayoutConstraint.activate([
            rewardsTableView.topAnchor.constraint(equalTo: messageToCleanerView.bottomAnchor, constant: 10),
            rewardsTableView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            rewardsTableView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        rewardsTableHeightConstraint = rewardsTableView.heightAnchor.constraint(equalToConstant: 360)
        rewardsTableHeightConstraint.isActive = true
    }
    
    private func configureTakeJobButton() {
        contentView.addSubview(takeJobButton)
        takeJobButton.addTarget(self, action: #selector(takeJobButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            takeJobButton.topAnchor.constraint(equalTo: rewardsTableView.bottomAnchor, constant: 10),
            takeJobButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            takeJobButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            takeJobButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}

extension NearbyOrderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCHousePhotoCell.identifier, for: indexPath) as? SCHousePhotoCell else { return UICollectionViewCell() }
        
        cell.setData(image: imageArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth: CGFloat = 75.0
        let numberOfCells = floor(collectionView.frame.size.width / cellWidth)
        let edgeInsets = (collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
                
        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
        
    }
}

extension NearbyOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == informationTableView {
            return infoDictionary.count
        }
        
        if tableView == rewardsTableView {
            return rewardsDictionary.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == informationTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SCNearbyOrderCell.identifier, for: indexPath) as? SCNearbyOrderCell else { return UITableViewCell() }
            
            let key = Array(infoDictionary).sorted(by: {$0.key < $1.key})[indexPath.row].key
            let value = infoDictionary[key]
            
            cell.setData(title: key, value: value!)
            
            return cell
        }
        
        if tableView == rewardsTableView {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SCOrderCell.identifier, for: indexPath) as? SCOrderCell else { return UITableViewCell() }
            
            let key = Array(rewardsDictionary).sorted(by: {$0.key < $1.key})[indexPath.row].key
            let value = rewardsDictionary[key]
            
            cell.setData(title: value!.name, value: value!.cost)
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == rewardsTableView {
            return "Job Details"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if tableView == rewardsTableView {
            guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.textColor = .brandDark
            header.textLabel?.font = UIFont.urbanistBold(size: 16)!
            header.textLabel?.frame = header.bounds
            header.isUserInteractionEnabled = false
        }
        
        
    }
    
}
