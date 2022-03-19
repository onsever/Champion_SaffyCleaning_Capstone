//
//  HomeViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isScrollEnabled = true
        mapView.showsCompass = false
        
        return mapView
    }()
    
    private let orderButton = SCCircleButton(image: UIImage(systemName: "plus")!, cornerRadius: 20)
    private let addressButton = SCCircleButton(image: UIImage(systemName: "list.dash")!, cornerRadius: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        configureMapView()
        configureButtons()
    }
    
    @objc private func orderButtonDidTap(_ button: UIButton) {
        print("Order button tapped.")
        
        let orderVC = OrderViewController()
        
        navigationController?.pushViewController(orderVC, animated: true)
    }
    
    @objc private func addressButtonDidTap(_ button: UIButton) {
        print("Address button tapped.")
        
        let addressVC = SCAddressVC(height: 380)
        
        if let sheet = addressVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = false
            sheet.delegate = self
            addressVC.delegate = self
        }
        
        self.present(addressVC, animated: true, completion: nil)
    }
    
}

extension HomeViewController: SCAddressVCDelegate {
    
    func didSelectItem(_ address: Address) {
        print(address.sizes)
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let addressLocation = MKPointAnnotation()
        addressLocation.title = "Testing"
        addressLocation.coordinate = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        mapView.addAnnotation(addressLocation)
    }
    
    
}

extension HomeViewController: UISheetPresentationControllerDelegate {
    
    // Note: Inherited from UIAdaptivePresentationControllerDelegate
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("Dismissed")
        
        guard let vc = presentationController.presentedViewController as? SCAddressVC else { return }
        
        guard let address = vc.getCurrentAddress() else { return }
        guard let allAddresses = vc.getAllAddresses() else { return }
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let addressLocation = MKPointAnnotation()
        addressLocation.title = "Testing"
        addressLocation.coordinate = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        mapView.addAnnotation(addressLocation)
        
        print(address.contactPerson)
        print(allAddresses)
    }
    
}

extension HomeViewController {
    
    private func configureMapView() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureButtons() {
        mapView.addSubview(orderButton)
        mapView.addSubview(addressButton)
        
        orderButton.addTarget(self, action: #selector(orderButtonDidTap(_:)), for: .touchUpInside)
        addressButton.addTarget(self, action: #selector(addressButtonDidTap(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            orderButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20),
            orderButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            orderButton.heightAnchor.constraint(equalToConstant: 40),
            orderButton.widthAnchor.constraint(equalToConstant: 40),
            addressButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20),
            addressButton.trailingAnchor.constraint(equalTo: orderButton.leadingAnchor, constant: -10),
            addressButton.widthAnchor.constraint(equalToConstant: 40),
            addressButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
