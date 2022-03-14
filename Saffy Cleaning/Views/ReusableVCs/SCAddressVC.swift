//
//  SCAddressVC.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

protocol SCAddressVCDelegate: AnyObject {
    func didSelectItem(_ address: Address)
}

class SCAddressVC: UIViewController {
    
    private let containerView = UIView()
    private let emptyView = UIView()
    private let addressCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SCAddressCell.self, forCellWithReuseIdentifier: SCAddressCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        layout.scrollDirection = .horizontal
        
        return collectionView

    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = SCAddressVC.addressArray.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = .brandGem
        pageControl.pageIndicatorTintColor = .brandLake
        
        return pageControl
    }()
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .brandDark
        
        return imageView
    }()
    
    private let infoLabel = SCInfoLabel(alignment: .center, fontSize: 14, text: "Add a new address")
    
    private static var addressArray = [Address]()
    private static var currentIndex: Int = 0
    public weak var delegate: SCAddressVCDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init(height: CGFloat?) {
        super.init(nibName: nil, bundle: nil)
        
        if let height = height {
            containerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        else {
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContainerView()
        
        //addressArray.append(Address(address: "550 Arthur Avenue,\n Freeport, IL 61032", contactPerson: "Onurcan Sever", contactNumber: "815-837-3463", type: "Apartment", sizes: "2,467"))
        //addressArray.append(Address(address: "North York", contactPerson: "Mark Cheung", contactNumber: "815-837-3463", type: "Condo", sizes: "1,467"))
        
        checkArrayCount()
    }
    
    @objc private func addNewAddress(_ gesture: UITapGestureRecognizer) {
        print("Add a new address tapped.")
        
        let vc = AddNewAddressViewController()
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = false
        }
        
        vc.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
}



extension SCAddressVC: AddNewAddressDelegate {
    
    func didTapAddButton(_ address: Address) {
        SCAddressVC.addressArray.append(address)
        self.addressCollectionView.reloadData()
        checkArrayCount()
        print(address.address)
    }
    
    
}
    
extension SCAddressVC {
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 20),
        ])
    }
    
    private func checkArrayCount() {
        
        if SCAddressVC.addressArray.count == 0 || SCAddressVC.addressArray.isEmpty {
            configureEmptyView()
        }
        else {
            configureCollectionView()
            configurePageControl()
        }
        
    }
    
    private func configureCollectionView() {
        addressCollectionView.delegate = self
        addressCollectionView.dataSource = self
        addressCollectionView.clipsToBounds = true
        addressCollectionView.layer.cornerRadius = 20
        addressCollectionView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        containerView.addSubview(addressCollectionView)
        
        NSLayoutConstraint.activate([
            addressCollectionView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 5),
            addressCollectionView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            addressCollectionView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addressCollectionView.heightAnchor.constraint(equalToConstant: 240),
        ])
    }
    
    private func configurePageControl() {
        containerView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: addressCollectionView.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            pageControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureEmptyView() {
        containerView.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.backgroundColor = .white
        emptyView.layer.cornerRadius = 20
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addNewAddress(_:)))
        emptyView.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 5),
            emptyView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emptyView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            emptyView.heightAnchor.constraint(equalToConstant: 240),
        ])
        
        emptyView.addSubview(plusImageView)
        
        NSLayoutConstraint.activate([
            plusImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -18),
            plusImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            plusImageView.heightAnchor.constraint(equalToConstant: 40),
            plusImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        emptyView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: plusImageView.bottomAnchor, constant: 10),
            infoLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}

extension SCAddressVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SCAddressVC.addressArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCAddressCell.identifier, for: indexPath) as? SCAddressCell else { return UICollectionViewCell() }
        
        let username = SCAddressVC.addressArray[indexPath.row].contactPerson
        let phoneNumber = SCAddressVC.addressArray[indexPath.row].contactNumber
        let address = SCAddressVC.addressArray[indexPath.row].address
        let houseType = SCAddressVC.addressArray[indexPath.row].type
        let houseSize = SCAddressVC.addressArray[indexPath.row].sizes
        
        // Image upload is limited to 3 - 4
        cell.setData(username: username, phoneNumber: phoneNumber, imageArray: [UIImage(systemName: "person.fill")!, UIImage(named: "carpet")!, UIImage(systemName: "person")!, UIImage(named: "carpet")!], address: address, houseType: houseType, houseSize: houseSize)
        
        
        
       cell.delegate = self
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: addressCollectionView.bounds.size.width, height: addressCollectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        pageControl.currentPage = indexPath.row
        SCAddressVC.currentIndex = indexPath.row
        delegate?.didSelectItem(SCAddressVC.addressArray[indexPath.row])
        
    }
    
}

extension SCAddressVC: SCAddressCellDelegate {
    
    func didTapEditButton(_ button: UIButton) {
        print("Edit button tapped.")
        
        let vc = EditAddressViewController()
        vc.setData(SCAddressVC.addressArray[SCAddressVC.currentIndex])
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func didTapDeleteButton(_ button: UIButton) {
        print("Delete button tapped.")
        SCAddressVC.addressArray.remove(at: SCAddressVC.currentIndex)
        checkArrayCount()
    }
    
    func didTapButton(_ username: String) {
        
    }
    
    
}

extension SCAddressVC: EditAddressDelegate {
    
    func didTapSave(_ address: Address) {
        SCAddressVC.addressArray[SCAddressVC.currentIndex] = address
        self.addressCollectionView.reloadData()
        checkArrayCount()
    }
    
    
}
