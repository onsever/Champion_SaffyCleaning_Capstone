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
    
    // MARK: - WhenView Properties
    private var whenViewHeightAnchor: NSLayoutConstraint!
    private var whenViewDataSetHeightAnchor: NSLayoutConstraint!
    private var isWhenViewDataSet: Bool = false
    
    // MARK: - WhereView Properties
    private var whereViewHeightAnchor: NSLayoutConstraint!
    private var whereViewDataSetHeightAnchor: NSLayoutConstraint!
    private var isWhereViewDataSet: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Placing an order"
        view.backgroundColor = .white
        
        configureWhenView()
        configureWhereView()
        
        whenView.delegate = self
        whereView.delegate = self
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

extension OrderViewController {
    
    private func configureWhenView() {
        view.addSubview(whenView)
        
        NSLayoutConstraint.activate([
            whenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            whenView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            whenView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        whenViewHeightAnchor = whenView.heightAnchor.constraint(equalToConstant: 50)
        whenViewDataSetHeightAnchor = whenView.heightAnchor.constraint(equalToConstant: 160)
        whenViewHeightAnchor.isActive = true
        whenViewDataSetHeightAnchor.isActive = false
        
    }
    
    private func configureWhereView() {
        view.addSubview(whereView)
        
        NSLayoutConstraint.activate([
            whereView.topAnchor.constraint(equalTo: whenView.bottomAnchor, constant: 20),
            whereView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            whereView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        whereViewHeightAnchor = whereView.heightAnchor.constraint(equalToConstant: 50)
        whereViewDataSetHeightAnchor = whereView.heightAnchor.constraint(equalToConstant: 260)
        whereViewHeightAnchor.isActive = true
        whereViewDataSetHeightAnchor.isActive = false
    }
    
}


