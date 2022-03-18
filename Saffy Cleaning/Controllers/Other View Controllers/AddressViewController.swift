//
//  AddressViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit
import MapKit
import FirebaseDatabase

protocol AddressVCDelegate: AnyObject {
    func didTapAddButton(_ address: Address)
}

protocol AddressVCDataSource: AnyObject {
    func didTapSave(_ address: Address)
}

class AddressViewController: UIViewController {
    
    private lazy var ref = Database.database().reference()
    
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
    
    private let infoLabel = SCSubTitleLabel(text: "Detail address will be shown in the matched order.", isRequired: true, textColor: .brandDark)
    
    private let roomView = SCInfoView(placeholder: "e.g. Room A", text: "Room")
    private let flatView = SCInfoView(placeholder: "e.g. Flat 2", text: "Flat")
    private let streetView = SCInfoView(placeholder: "e.g. Some example", text: "Street")
    private let buildingView = SCInfoView(placeholder: "e.g. Some example", text: "Building")
    private let districtView = SCInfoView(placeholder: "e.g. Some example", text: "District")
    private let houseTypeView = SCInfoView(placeholder: "For cleaner suggestioning...", text: "House type")
    private let houseSizeView = SCInfoView(placeholder: "e.g. Some example", text: "House size")
    private let contactPersonView = SCInfoView(placeholder: "Who should worker contact", text: "Contact person")
    private let contactNumberView = SCInfoView(placeholder: "For cleaner suggestioning...", text: "Contact number")
    private lazy var addButton = SCMainButton(title: isEditingMode ? "Save" : "Add", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    private let selectionPopUp = SCSelectionPopUp(isHouseType: true)
    
    private var horizontalStackView: SCStackView!
    private var verticalStackView: SCStackView!
    
    public weak var delegate: AddressVCDelegate?
    public weak var dataSource: AddressVCDataSource?
    private var isEditingMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = isEditingMode ? "Edit the address" : "Add new address"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(didTapOk(_:)))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        
        view.layer.borderColor = UIColor.brandGem.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        configureInfoLabel()
        configureHorizontalStackView()
        configureVerticalStackView()
        configureAddButton()
        
        selectionPopUp.delegate = self
    }
    
    @objc private func didTapOk(_ button: UIBarButtonItem) {
        
    }
    
    @objc private func userDidTapAdd(_ button: UIButton) {
        
        let room = roomView.getTextField().text!
        let flat = flatView.getTextField().text!
        let street = streetView.getTextField().text!
        let building = buildingView.getTextField().text!
        let district = districtView.getTextField().text!
        let contactPerson = contactPersonView.getTextField().text!
        let contactNumber = contactNumberView.getTextField().text!
        let houseType = houseTypeView.getTextField().text!
        let houseSize = houseSizeView.getTextField().text!
        
        let newAddress = Address(name: "", room: room, flat: flat, street: street, building: building, district: district, contactPerson: contactPerson, contactNumber: contactNumber, type: houseType, sizes: String(format: "%d", Int(houseSize)!), longitude: 30, latitude: 30)
        let NSDict = try! DictionaryEncoder.encode(newAddress)
        FirebaseDBService.service.saveAddress(value: NSDict as NSDictionary)
        
        if isEditingMode {
            dataSource?.didTapSave(newAddress)
        } else {
            delegate?.didTapAddButton(newAddress)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapHouseType(_ gesture: UITapGestureRecognizer) {
        
        selectionPopUp.modalPresentationStyle = .overCurrentContext
        self.present(selectionPopUp, animated: true, completion: nil)
        
    }
    
    public func setData(_ address: Address?) {
        
        if let address = address {
            streetView.getTextField().text = address.street
            contactPersonView.getTextField().text = address.contactPerson
            contactNumberView.getTextField().text = address.contactNumber
            houseTypeView.getTextField().text = address.type
            roomView.getTextField().text = address.room
            flatView.getTextField().text = address.flat
            buildingView.getTextField().text = address.building
            districtView.getTextField().text = address.district
            houseSizeView.getTextField().text = address.sizes
        }
        
    }
    
    public func setEditingMode(isEditing: Bool) {
        self.isEditingMode = isEditing
    }
    
}

extension AddressViewController: SCSelectionPopUpDelegate {
    
    func didSelectRowAt(item: String) {
        houseTypeView.getTextField().text = item
    }
    
}

extension AddressViewController {
    
    private func configureInfoLabel() {
        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            infoLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureHorizontalStackView() {
        horizontalStackView = SCStackView(arrangedSubviews: [roomView, flatView])
        contentView.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .fillEqually
                
        NSLayoutConstraint.activate([
            roomView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            flatView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureVerticalStackView() {
        verticalStackView = SCStackView(arrangedSubviews: [streetView, buildingView, districtView, houseTypeView, houseSizeView, contactPersonView, contactNumberView])
        contentView.addSubview(verticalStackView)
        verticalStackView.spacing = 10
        verticalStackView.distribution = .fillEqually
        
        houseTypeView.getTextField().isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHouseType(_:)))
        houseTypeView.addGestureRecognizer(tap)
        
        for view in verticalStackView.arrangedSubviews {
            view.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 0),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            verticalStackView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private func configureAddButton() {
        contentView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(userDidTapAdd(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
