//
//  WhereViewController.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-11.
//

import UIKit
import MapKit

protocol WhereViewDelegate: AnyObject {
    func addAddress(address: String, contactPerson: String, contactNumber: String, type: String, sizes: String)
}

class WhereViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
            let mapView = MKMapView()
            mapView.translatesAutoresizingMaskIntoConstraints = false
            mapView.isScrollEnabled = true
            
            return mapView
    }()
    
    public weak var delegate: WhereViewDelegate?
    private static var indexPath: IndexPath? = nil
    private let addressVC = SCAddressVC(height: nil)
    private var selectedAddress: Address? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureMapView()
        configureAddressVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = WhereViewController.indexPath {
            print(indexPath)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @objc private func okButtonTapped(_ button: UIBarButtonItem) {
        
        if let selectedAddress = selectedAddress {
            delegate?.addAddress(address: selectedAddress.address, contactPerson: selectedAddress.contactPerson, contactNumber: selectedAddress.contactNumber, type: selectedAddress.type, sizes: selectedAddress.sizes)
        }
         
    }

}

extension WhereViewController: SCAddressVCDelegate {
    
    func didSelectItem(_ address: Address) {
        print(address.address)
        selectedAddress = address
    }
    
    
}

extension WhereViewController {
    
    private func configureViewController() {
        
        view.backgroundColor = .lightBrandLake2
        title = "Where"
        
        let okButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(okButtonTapped(_:)))
        okButton.tintColor = .brandDark
        okButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.urbanistRegular(size: 18)!], for: .normal)
        navigationItem.leftBarButtonItem = okButton
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
        ])
    }
    
    private func configureAddressVC() {
        view.addSubview(addressVC.view)
        addressVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(addressVC)
        addressVC.didMove(toParent: self)
        addressVC.delegate = self
        
        NSLayoutConstraint.activate([
            addressVC.view.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            addressVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addressVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addressVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
}
