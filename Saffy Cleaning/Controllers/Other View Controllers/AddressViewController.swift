//
//  AddressViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit
import MapKit
import FirebaseDatabase
import Photos
import PhotosUI

protocol AddressVCDelegate: AnyObject {
    func didTapAddButton(_ address: Address)
}

protocol AddressVCDataSource: AnyObject {
    func didTapSave(_ address: Address)
}

class AddressViewController: UIViewController {
    
    private lazy var ref = Database.database().reference()
    
    private lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 300)
        
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
    private let streetView = SCInfoView(placeholder: "e.g. Bloor Street", text: "Street")
    private let postalCodeView = SCInfoView(placeholder: "e.g. M2S0K2", text: "Postal Code")
    private let buildingView = SCInfoView(placeholder: "e.g. Black Condos", text: "Building")
    private let districtView = SCInfoView(placeholder: "e.g. Some example", text: "District")
    private let houseTypeView = SCInfoView(placeholder: "For cleaner suggestioning...", text: "House type")
    private let houseSizeView = SCInfoView(placeholder: "e.g. 2464", text: "House size")
    private let contactPersonView = SCInfoView(placeholder: "Who should worker contact", text: "Contact person")
    private let contactNumberView = SCInfoView(placeholder: "For cleaner suggestioning...", text: "Contact number")
    private lazy var addButton = SCMainButton(title: isEditingMode ? "Save" : "Add", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    private let addPhotosLabel = SCMainLabel(fontSize: 16, textColor: .brandDark)
    private let selectionPopUp = SCSelectionPopUp(isHouseType: true)
    
    private var horizontalStackView: SCStackView!
    private var verticalStackView: SCStackView!
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SCHousePhotoCell.self, forCellWithReuseIdentifier: SCHousePhotoCell.identifier)
        collectionView.register(SCEmptyPhotoCell.self, forCellWithReuseIdentifier: SCEmptyPhotoCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.scrollDirection = .horizontal
        
        return collectionView
    }()
    
    public weak var delegate: AddressVCDelegate?
    public weak var dataSource: AddressVCDataSource?
    private var isEditingMode: Bool = false
    private var imageArray = [UIImage]()
    
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
        configureAddPhotosLabel()
        configureImageCollectionView()
        configureAddButton()
        selectionPopUp.delegate = self
    }
    
    @objc private func didTapOk(_ button: UIBarButtonItem) {
        
    }
    
    @objc private func userDidTapAdd(_ button: UIButton) {
        
        let room = roomView.getTextField().text!
        let flat = flatView.getTextField().text!
        
        guard let street = streetView.getTextField().validateTextField() else { return }
        guard let postalCode = postalCodeView.getTextField().validateTextField() else { return }
        
        let building = buildingView.getTextField().text!
        let district = districtView.getTextField().text!
        
        guard let houseType = houseTypeView.getTextField().validateTextField() else { return }
        guard let houseSize = houseSizeView.getTextField().validateTextField() else { return }
        guard let contactPerson = contactPersonView.getTextField().validateTextField() else { return }
        guard let contactNumber = contactNumberView.getTextField().validateTextField() else { return }

        LocationSearchService.service.searchLocation(text: postalCode, completion: { [weak self] (location) in
            guard let self = self else { return }
            if let location = location {

                let newAddress = Address(name: "", room: room, flat: flat, street: street, postalCode: postalCode, building: building, district: district, contactPerson: contactPerson, contactNumber: contactNumber, type: houseType, sizes: String(format: "%d", Int(houseSize)!), longitude: location.longitude, latitude: location.latitude, images: [], createdAt: String(format: "%.6f", Date() as CVarArg))

                let NSDict = try! DictionaryEncoder.encode(newAddress)

                let child = FirebaseDBService.service.saveAddress(value: NSDict as NSDictionary)
                
                FBStorageService.service.saveImages(images: self.imageArray, imageRef: Constants.addressImages) { imgArr in
                    child.updateChildValues(["images": imgArr])
                }
                
                if self.isEditingMode == true {
                    self.dataSource?.didTapSave(newAddress)
                }
                else {
                    self.delegate?.didTapAddButton(newAddress)
                }
            }
            
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapHouseType(_ gesture: UITapGestureRecognizer) {
        
        selectionPopUp.modalPresentationStyle = .overCurrentContext
        self.present(selectionPopUp, animated: true, completion: nil)
        
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        let searchRequest = MKLocalSearch.Request()
        let isPostalCodeValid = validZipCode(postalCode: postalCodeView.getTextField().text ?? "")
        searchRequest.naturalLanguageQuery = postalCodeView.getTextField().text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { [weak self] response,error in
            guard let response = response else {
                   print(error?.localizedDescription ?? "This should be impossible")
                   return
               }
            if ((response.mapItems.first?.placemark.postalCode) != nil) == isPostalCodeValid
            {
                print("VALID POSTALCODE")
            }
            
            else if ((response.mapItems.first?.placemark.postalCode) != nil) != isPostalCodeValid {
                
                print("Invalid Postalcode")
                
            }
            
            
        
//        let isPostalCodeValid = validZipCode(postalCode: postalCodeView.getTextField().text ?? "")
//
//                    if isPostalCodeValid == false {
//                        print("Invalid postalcode")
//                       // simpleAlert(title: "Error!", msg: "Please enter a valid CA postal code")
//
//                    } else
//                        if isPostalCodeValid == true {
//                            print("Valid Postalcode")
//                       //the postalCaode is correct formatting
//                    }
    }
    }
    
    func validZipCode(postalCode:String)->Bool{
            let postalcodeRegex = "^[a-zA-Z][0-9][a-zA-Z][- ]*[0-9][a-zA-Z][0-9]$"
            let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
            let bool = pinPredicate.evaluate(with: postalCode) as Bool
            return bool
        }
    
    public func setData(_ address: Address?) {
        
        if let address = address {
            streetView.getTextField().text = address.street
            postalCodeView.getTextField().text = address.postalCode
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

extension AddressViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cells: UICollectionViewCell?
        
        if indexPath.row < imageArray.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCHousePhotoCell.identifier, for: indexPath) as? SCHousePhotoCell else { return UICollectionViewCell() }
            
            cell.setData(image: imageArray[indexPath.row])
            
            cells = cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCEmptyPhotoCell.identifier, for: indexPath) as? SCEmptyPhotoCell else { return UICollectionViewCell() }
            
            cell.delegate = self
            cells = cell
        }
        
        return cells!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
    
}

extension AddressViewController: SCEmptyPhotoCellDelegate {
    
    func addPhotoCellTapped(_ gesture: UITapGestureRecognizer) {
        
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 4
        config.filter = .any(of: [.images, .livePhotos])
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

extension AddressViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        self.imageArray.removeAll()
        let group = DispatchGroup()
        
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                
                defer {
                    group.leave()
                }
                
                guard let self = self else { return }
                guard let image = reading as? UIImage, error == nil else { return }
                
                self.imageArray.append(image)
            }
        }
        
        group.notify(queue: .main) {
            print(self.imageArray.count)
            self.imageCollectionView.reloadData()
        }
        
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
        
        horizontalStackView.arrangedSubviews.forEach {
            ($0 as! SCInfoView).getTextField().delegate = self
        }
                
        NSLayoutConstraint.activate([
            roomView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            flatView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 85)
        ])
    }
    
    private func configureVerticalStackView() {
        verticalStackView = SCStackView(arrangedSubviews: [streetView, postalCodeView, buildingView, districtView, houseTypeView, houseSizeView, contactPersonView, contactNumberView])
        contentView.addSubview(verticalStackView)
        verticalStackView.spacing = 14
        verticalStackView.distribution = .fillEqually
        
        houseTypeView.getTextField().isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHouseType(_:)))
        houseTypeView.addGestureRecognizer(tap)
        
        verticalStackView.arrangedSubviews.forEach {
            $0.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor).isActive = true
            ($0 as! SCInfoView).getTextField().delegate = self
            
        }
      postalCodeView.getTextField().addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        contactNumberView.getTextField().keyboardType = .phonePad
        
        houseSizeView.getTextField().keyboardType = .numberPad
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 0),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            verticalStackView.heightAnchor.constraint(equalToConstant: 650)
        ])
    }
    
    private func configureAddPhotosLabel() {
        contentView.addSubview(addPhotosLabel)
        addPhotosLabel.text = "Add Photos"
        
        NSLayoutConstraint.activate([
            addPhotosLabel.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 20),
            addPhotosLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            addPhotosLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addPhotosLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func configureImageCollectionView() {
        contentView.addSubview(imageCollectionView)
        
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: addPhotosLabel.bottomAnchor, constant: 20),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureAddButton() {
        contentView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(userDidTapAdd(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

extension AddressViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case roomView.getTextField():
            flatView.getTextField().becomeFirstResponder()
        case flatView.getTextField():
            streetView.getTextField().becomeFirstResponder()
        case streetView.getTextField():
            postalCodeView.getTextField().becomeFirstResponder()
        case postalCodeView.getTextField():
            buildingView.getTextField().becomeFirstResponder()
        case buildingView.getTextField():
            districtView.getTextField().becomeFirstResponder()
        case districtView.getTextField():
            houseSizeView.getTextField().becomeFirstResponder()
        case houseSizeView.getTextField():
            contactPersonView.getTextField().becomeFirstResponder()
        case contactPersonView.getTextField():
            contactNumberView.getTextField().becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            break
        }
                
        return true
    }
    
}
