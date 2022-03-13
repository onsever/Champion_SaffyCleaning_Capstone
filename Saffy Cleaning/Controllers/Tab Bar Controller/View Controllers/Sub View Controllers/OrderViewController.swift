//
//  OrderViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

class OrderViewController: UIViewController {
    
    private lazy var whenView = SCWhenView(title: "When")
    private lazy var whereView = SCWhereView(title: "Where")
    private lazy var otherDetailsView = SCOtherDetailsView(title: "Other details")
    
    // MARK: - WhenView Properties
    private var whenViewHeightAnchor: NSLayoutConstraint!
    private var whenViewDataSetHeightAnchor: NSLayoutConstraint!
    private var isWhenViewDataSet: Bool = false
    
    // MARK: - WhereView Properties
    private var whereViewHeightAnchor: NSLayoutConstraint!
    private var whereViewDataSetHeightAnchor: NSLayoutConstraint!
    private var isWhereViewDataSet: Bool = false
    
    // MARK: - OtherDetails Properties
    private var otherDetailsViewHeightAnchor: NSLayoutConstraint!
    private var otherDetailsDataSetHeightAnchor: NSLayoutConstraint!
    private var isOtherDetailsViewDataSet: Bool = false
    
    private lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 600)
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Placing an order"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        configureWhenView()
        configureWhereView()
        configureOtherDetailsView()
        
        whenView.delegate = self
        whereView.delegate = self
        otherDetailsView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isWhenViewDataSet {
            whenViewHeightAnchor.isActive = false
            whenViewDataSetHeightAnchor.isActive = true
        }
        else {
            whenViewHeightAnchor.isActive = true
            whenViewDataSetHeightAnchor.isActive = false
        }
        
        if isWhereViewDataSet {
            whereViewHeightAnchor.isActive = false
            whereViewDataSetHeightAnchor.isActive = true
        }
        else {
            whereViewHeightAnchor.isActive = true
            whereViewDataSetHeightAnchor.isActive = false
        }
        
        if isOtherDetailsViewDataSet {
            otherDetailsViewHeightAnchor.isActive = false
            otherDetailsDataSetHeightAnchor.isActive = true
        }
        else {
            otherDetailsViewHeightAnchor.isActive = true
            otherDetailsDataSetHeightAnchor.isActive = false
        }
        
        otherDetailsView.updateCollectionView()
        
    }

}

extension OrderViewController: WhenViewDelegate, SCWhenViewDelegate {
    
    func addDate(date: String, time: String, duration: String?) {
        self.navigationController?.popViewController(animated: true)
        
        self.isWhenViewDataSet = self.whenView.setData(date: date, time: time, duration: duration ?? "0")
        
    }
    
    func didTapEditButtonWhenView(_ button: UIButton) {
        print("Edit button clicked")
        
        let whenVC = WhenViewController()
        navigationController?.pushViewController(whenVC, animated: true)
        whenVC.delegate = self
                
    }
    
    
}

extension OrderViewController: WhereViewDelegate, SCWhereViewDelegate {
    
    func didTapEditButtonWhereView(_ button: UIButton) {
        
        let whereVC = WhereViewController()
        self.navigationController?.pushViewController(whereVC, animated: true)
        whereVC.delegate = self
    }
    
    
    func addAddress(address: String, contactPerson: String, contactNumber: String, type: String, sizes: String) {
        self.navigationController?.popViewController(animated: true)
        
        self.isWhereViewDataSet = self.whereView.setData(address: address, contactPerson: contactPerson, contactNumber: contactNumber, type: type, sizes: sizes)
    }
    
}

extension OrderViewController: SCOtherDetailsViewDelegate, OtherDetailsViewDelegate {
    
    func addOtherDetails(pet: String, message: String, tips: String, selectedItems: [ExtraService]) {
        self.navigationController?.popViewController(animated: true)
        
        self.isOtherDetailsViewDataSet = self.otherDetailsView.setData(pet: pet, message: message, tips: tips, selectedItems: selectedItems)
        
    }
    
    
    
    func didTapEditButtonOtherView(_ button: UIButton) {
        
        let otherDetailsVC = OtherDetailsViewController()
        self.navigationController?.pushViewController(otherDetailsVC, animated: true)
        otherDetailsVC.delegate = self
        
    }
    
    
}

extension OrderViewController {
    
    private func configureWhenView() {
        contentView.addSubview(whenView)
        
        NSLayoutConstraint.activate([
            whenView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            whenView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            whenView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        whenViewHeightAnchor = whenView.heightAnchor.constraint(equalToConstant: 50)
        whenViewDataSetHeightAnchor = whenView.heightAnchor.constraint(equalToConstant: 160)
        whenViewHeightAnchor.isActive = true
        whenViewDataSetHeightAnchor.isActive = false
        
    }
    
    private func configureWhereView() {
        contentView.addSubview(whereView)
        
        NSLayoutConstraint.activate([
            whereView.topAnchor.constraint(equalTo: whenView.bottomAnchor, constant: 20),
            whereView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            whereView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        whereViewHeightAnchor = whereView.heightAnchor.constraint(equalToConstant: 50)
        whereViewDataSetHeightAnchor = whereView.heightAnchor.constraint(equalToConstant: 260)
        whereViewHeightAnchor.isActive = true
        whereViewDataSetHeightAnchor.isActive = false
    }
    
    private func configureOtherDetailsView() {
        contentView.addSubview(otherDetailsView)
        
        NSLayoutConstraint.activate([
            otherDetailsView.topAnchor.constraint(equalTo: whereView.bottomAnchor, constant: 20),
            otherDetailsView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            otherDetailsView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        otherDetailsViewHeightAnchor = otherDetailsView.heightAnchor.constraint(equalToConstant: 50)
        otherDetailsDataSetHeightAnchor = otherDetailsView.heightAnchor.constraint(equalToConstant: 480)
        otherDetailsViewHeightAnchor.isActive = true
        otherDetailsDataSetHeightAnchor.isActive = false
    }
    
}


