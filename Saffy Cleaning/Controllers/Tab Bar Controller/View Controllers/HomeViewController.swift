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
    
    public var user: User?
    private var orders : [UserOrder]?
    private var selectedOrder : UserOrder?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseDBService.service.retrieveUser { [weak self] user in
            
            guard let self = self else { return }
            
            if let user = user {
                self.user = user
                if user.userType == UserType.user.rawValue {
                    DispatchQueue.main.async {
                        self.configureMapView()
                        self.configureButtons()
                    }
                    
                }
                else {
                    FirebaseDBService.service.retrievePendingOrders(completion: {[weak self] result in
                        DispatchQueue.main.async {
                            self?.configureMapView()
                            self?.orders = result
                            self?.addAnnotation(orders: result)
                            self?.mapView.delegate = self
                        }
                        
                    })
                    
                }
            }
        }
    }
    
    
    @objc private func orderButtonDidTap(_ button: UIButton) {
        print("Order button tapped.")
        
        let orderVC = OrderViewController()
        
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    @objc private func addressButtonDidTap(_ button: UIButton) {
        print("Address button tapped.")
        
        let addressVC = SCAddressVC(height: 380)
        
        if let sheet = addressVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = false
            //sheet.delegate = self
            addressVC.delegate = self
        }
        
        self.present(addressVC, animated: true, completion: nil)
    }
    
    private func addAnnotation(orders: [UserOrder]) {
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        for order in orders {
            let addressLocation = MKPointAnnotation()
            addressLocation.title = "Testing"
            addressLocation.coordinate = CLLocationCoordinate2D(latitude: order.address.latitude, longitude: order.address.longitude)
            mapView.addAnnotation(addressLocation)
        }
    }
    
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let long = view.annotation?.coordinate.longitude ?? 0
        let lat = view.annotation?.coordinate.latitude ?? 0
        if orders != nil {
            let userOrder = orders?.first(where: {$0.address.latitude == lat && $0.address.longitude == long})
            let nearbyOrderVC = NearbyOrderViewController(userOrder: userOrder!)
            nearbyOrderVC.delegate = self
            if let sheet = nearbyOrderVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
            self.present(nearbyOrderVC, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: NearbyOrderViewControllerDelegate {
    
    func didDismissNearbyOrder() {
        // TODO: send workerId and
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension HomeViewController: SCAddressVCDelegate {
    
    func didSelectItem(_ address: Address) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let addressLocation = MKPointAnnotation()
        addressLocation.title = "Testing"
        addressLocation.coordinate = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        mapView.addAnnotation(addressLocation)
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
