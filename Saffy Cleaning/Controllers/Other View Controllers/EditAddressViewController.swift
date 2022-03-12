//
//  EditAddressViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit
import MapKit

protocol EditAddressDelegate: AnyObject {
    func didTapSave(_ address: Address)
}

class EditAddressViewController: UIViewController {
    
    private lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 600)
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isScrollEnabled = true
        
        return mapView
    }()
        
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
    private let contactPersonView = SCInfoView(placeholder: "Who should worker contact", text: "Contact person")
    private let contactNumberView = SCInfoView(placeholder: "For cleaner suggestioning...", text: "Contact number")
    private let saveButton = SCMainButton(title: "Save", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    
    private var horizontalStackView: SCStackView!
    private var verticalStackView: SCStackView!
    private let selectionPopUp = SCSelectionPopUp()
    
    public weak var delegate: EditAddressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add new address"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(didTapOk(_:)))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        configureMapView()
        configureInfoLabel()
        configureHorizontalStackView()
        configureVerticalStackView()
        configureAddButton()
        
        selectionPopUp.delegate = self
    }
    
    @objc private func didTapOk(_ button: UIBarButtonItem) {
        
    }
    
    @objc private func userDidTapSave(_ button: UIButton) {
        
        let address = streetView.getTextField().text!
        let contactPerson = contactPersonView.getTextField().text!
        let contactNumber = contactNumberView.getTextField().text!
        let houseType = houseTypeView.getTextField().text!
        
        let newAddress = Address(address: address, contactPerson: contactPerson, contactNumber: contactNumber, type: houseType, sizes: "2.164")
        
        delegate?.didTapSave(newAddress)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapHouseType(_ gesture: UITapGestureRecognizer) {
        
        selectionPopUp.modalPresentationStyle = .overCurrentContext
        self.present(selectionPopUp, animated: true, completion: nil)
        
    }
    
    public func setData(_ address: Address?) {
        
        if let address = address {
            streetView.getTextField().text = address.address
            contactPersonView.getTextField().text = address.contactPerson
            contactNumberView.getTextField().text = address.contactNumber
            houseTypeView.getTextField().text = address.type
        }
        
    }
    
}

extension EditAddressViewController: SCSelectionPopUpDelegate {
    
    func didSelectRowAt(item: String) {
        houseTypeView.getTextField().text = item
    }
    
}

extension EditAddressViewController {
    
    
    private func configureMapView() {
        contentView.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
    }
    
    private func configureInfoLabel() {
        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
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
        verticalStackView = SCStackView(arrangedSubviews: [streetView, buildingView, districtView, houseTypeView, contactPersonView, contactNumberView])
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
            verticalStackView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            verticalStackView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private func configureAddButton() {
        contentView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(userDidTapSave(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
