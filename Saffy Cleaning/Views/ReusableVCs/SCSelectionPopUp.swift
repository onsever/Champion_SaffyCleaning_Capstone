//
//  SCSelectionPopUp.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-08.
//

import UIKit

protocol SCSelectionPopUpDelegate: AnyObject {
    func didSelectRowAt(item: String)
}

class SCSelectionPopUp: UIViewController {
    
    private let containerView = UIView()
    private let seperatorView = UIView()
    private var tableView: UITableView!
    private lazy var selectionLabel = SCSubTitleLabel(text: isHouseType! ? "Select a House type" : "Duration", isRequired: false, textColor: .white)
    private let identifier = "SelectionCell"
    private let houseTypes = ["Apartment", "Mansion", "Container House", "Cottage", "Villa"]
    private let durations = ["2 hours", "3 hours", "4 hours", "5 hours", "6 hours"]
    private let dismissCrossMark: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        return button
    }()
    public weak var delegate: SCSelectionPopUpDelegate?
    private var isHouseType: Bool? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init(isHouseType: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isHouseType = isHouseType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.cornerRadius = 20
        configureContainerView()
        configureDismissButton()
        configureTitleLabel()
        configureSeperatorView()
        configureTableView()
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .brandGem
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 330)
        ])
    }
    
    private func configureDismissButton() {
        containerView.addSubview(dismissCrossMark)
        
        NSLayoutConstraint.activate([
            dismissCrossMark.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            dismissCrossMark.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            dismissCrossMark.widthAnchor.constraint(equalToConstant: 20),
            dismissCrossMark.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(selectionLabel)
        selectionLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            selectionLabel.topAnchor.constraint(equalTo: dismissCrossMark.bottomAnchor, constant: 5),
            selectionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            selectionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            selectionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureSeperatorView() {
        containerView.addSubview(seperatorView)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.layer.borderWidth = 1.0
        seperatorView.layer.borderColor = UIColor.white.cgColor
        
        NSLayoutConstraint.activate([
            seperatorView.topAnchor.constraint(equalTo: selectionLabel.bottomAnchor, constant: 7),
            seperatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            seperatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            seperatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .brandGem
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }

}

extension SCSelectionPopUp: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isHouseType! {
            return houseTypes.count
        }
        
        return durations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if isHouseType! {
            cell.textLabel?.text = houseTypes[indexPath.row]
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .brandGem
            cell.textLabel?.textAlignment = .center
        }
        else {
            cell.textLabel?.text = durations[indexPath.row]
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .brandGem
            cell.textLabel?.textAlignment = .center
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isHouseType! {
            delegate?.didSelectRowAt(item: houseTypes[indexPath.row])
        }
        else {
            delegate?.didSelectRowAt(item: durations[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
