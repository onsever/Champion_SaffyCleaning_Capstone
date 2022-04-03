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
    

    private var orders : [UserOrder]?
    private var selectedOrder : UserOrder?
    
    private var currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"

    }
    
    private func renderIcon () {

        
        let bView = UIView()
        bView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let imageView = UIImageView(image: UIImage(named: currentUser.userType == UserType.user.rawValue ? "owner" : "bucket")?.withRenderingMode(.alwaysTemplate))
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        bView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .brandGem
        
        let barItem = UIBarButtonItem(customView: bView)

        navigationItem.leftBarButtonItem = barItem
    }
    
    @objc private func leftBar () {
        print("pressing")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureMapView()
        self.mapView.delegate = self
        self.renderView()

    }
    
    private func showCurrentLocation () {
        handleMapZoom(lat: 43.7261496, lng: -79.473145, isAddress: false)
    }
    

    
    private func renderView() {
        FirebaseDBService.service.retrieveUser { [weak self] user in
            guard let self = self else { return }
            if let currentUser = user {
                if currentUser.userType == UserType.user.rawValue {
                    DispatchQueue.main.async {
                        self.configureButtons()
                        self.renderIcon()
                    }
                    
                }
                else {
                    FirebaseDBService.service.retrievePendingOrders{ [weak self] result in
                        DispatchQueue.main.async {
                            self?.removeButtons()
                            self?.orders = result
                            self?.addAnnotation(orders: result)
                            self?.renderIcon()
                        }
                        
                    }
                    
                }
            }
        }
        self.showCurrentLocation()
        
    }
    private func handleMapZoom(lat: Double, lng: Double, isAddress: Bool) {
        // set coordinates (lat lon)
        let coords = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        // set span (radius of points)
        let span = MKCoordinateSpan(latitudeDelta: isAddress ? 0.01 : 0.8, longitudeDelta: isAddress ? 0.08 : 0.8)
        // set region
        let region = MKCoordinateRegion(center: coords, span: span)
        // set the view
        mapView.setRegion(region, animated: true)
    }
    
    
    @objc private func orderButtonDidTap(_ button: UIButton) {
        print("Order button tapped.")
        
        let orderVC = OrderViewController(currentUser: currentUser)
        
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    @objc private func addressButtonDidTap(_ button: UIButton) {
        print("Address button tapped.")
        
        let addressVC = SCAddressVC(height: 380)
        
        if let sheet = addressVC.sheetPresentationController {
            sheet.detents = [.large()]
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
            if currentUser.userType == UserType.worker.rawValue {
                addressLocation.title = "Price: $\(order.totalCost)"
            }
//            addressLocation.title = "Testing"
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
            let nearbyOrderVC = NearbyOrderViewController(userOrder: userOrder!, currentUser: currentUser)
            nearbyOrderVC.delegate = self
            if let sheet = nearbyOrderVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            }
            guard let userOrder = userOrder else { return }
            self.handleMapZoom(lat: userOrder.address.latitude, lng: userOrder.address.longitude, isAddress: true)
            mapView.deselectAnnotation(view.annotation, animated: false)
            self.present(nearbyOrderVC, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: NearbyOrderViewControllerDelegate {
    
    func didDismissNearbyOrder() {
        self.showCurrentLocation()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension HomeViewController: ProfileViewProtocol {
    func changeUserType() {
        self.renderView()
    }
}

extension HomeViewController: SCAddressVCDelegate {
    
    func didSelectItem(_ address: Address) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
//        self.mapView.layoutMargins = UIEdgeInsets(top: 15, left: 25, bottom: 45, right: 25)
        
        let addressLocation = MKPointAnnotation()
//        addressLocation.title = "Testing"
        addressLocation.coordinate = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        mapView.addAnnotation(addressLocation)
//        mapView.layoutMargins = UIEdgeInsets(top: 15, left: 25, bottom: 45, right: 25)
        mapView.showAnnotations(mapView.annotations, animated: true)
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
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
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
    
    private func removeButtons() {
//        mapView.willRemoveSubview(orderButton)
//        mapView.willRemoveSubview(addressButton)
        orderButton.removeFromSuperview()
        addressButton.removeFromSuperview()
    }
    
}
