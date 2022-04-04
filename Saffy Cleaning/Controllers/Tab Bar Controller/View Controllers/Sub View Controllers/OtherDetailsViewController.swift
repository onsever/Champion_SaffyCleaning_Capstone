//
//  OtherDetailsViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit

protocol OtherDetailsViewDelegate: AnyObject {
    func addOtherDetails(pet: String, message: String, selectedItems: [Int : ExtraService])
    func fetchOtherDetailsData(buttonName: String, quantityText: String, messageText: String)
}

class OtherDetailsViewController: UIViewController {
    
    private let petView = SCVerticalOrderInfoView(backgroundColor: .lightBrandLake2, height: 20)
    private var horizontalStackView: SCStackView!
    private let yesButton = SCRadioButtonView(title: "Yes")
    private let noButton = SCRadioButtonView(title: "No")
    private let quantityTextField = SCTextField(placeholder: "Describe quantity and type of pet in the place.")
    private let messageLabel = SCMainLabel(fontSize: 16, textColor: .brandDark)
    private let messageTextField = SCTextField(placeholder: "Leave a message to the cleaner...")
    private let extraServiceLabel = SCMainLabel(fontSize: 16, textColor: .brandDark)
    private lazy var serviceCollectionView: UICollectionView = {
        let layout = UIHelper.createThreeColumnFlowLayout(in: self.view)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SCExtraServiceCell.self, forCellWithReuseIdentifier: SCExtraServiceCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        layout.scrollDirection = .horizontal
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    public weak var delegate: OtherDetailsViewDelegate?
    private var serviceArray = [ExtraService]()
    private var selectedArray = [ExtraService]()
    private var selectedDictionary = [Int : ExtraService]()
    private static var selectedIndexes = [Int : IndexPath]()
    private var buttonName: String? {
        didSet {
            if let buttonName = buttonName {
                if buttonName == "Yes" {
                    self.yesButton.radioButton.isSelected = true
                }
                else {
                    self.noButton.radioButton.isSelected = true
                }
            }
        }
    }
    private var quantityText: String? {
        didSet {
            if let quantityText = quantityText {
                self.quantityTextField.text = quantityText
            }
        }
    }
    private var messageText: String? {
        didSet {
            if let messageText = messageText {
                self.messageTextField.text = messageText
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configurePetView()
        configureHorizontalStackView()
        configureQuantityTextField()
        configureServiceLabel()
        configureCollectionView()
        configureMessageLabel()
        configureMessageTextField()
        setData()
        
        if self.buttonName == nil {
            noButton.radioButton.isSelected = true
            self.buttonName = "No"
            quantityTextField.isUserInteractionEnabled = false
        }
        
        yesButton.delegate = self
        noButton.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OtherDetailsViewController.selectedIndexes.count != 0 {
            for (_, value) in OtherDetailsViewController.selectedIndexes {
                self.serviceCollectionView.delegate?.collectionView?(self.serviceCollectionView, didSelectItemAt: value)
            }
            
        }
        
        
    }
    
    @objc private func okButtonTapped(_ button: UIBarButtonItem) {
        
        if (quantityTextField.text == "" && self.buttonName == "Yes") || messageTextField.text == "" {
            
            self.presentAlert(title: "Empty Fields", message: "Please fill all the fields.", positiveAction: { action in
                
            }, negativeAction: nil)
            
        }
        else {
            let pet = quantityTextField.text!
            let message = messageTextField.text!
            
            delegate?.addOtherDetails(
                pet: self.buttonName == "Yes" ? "\(self.buttonName!)\n\(pet)" : "\(self.buttonName!)",
                message: message,
                selectedItems: selectedDictionary)
            
            delegate?.fetchOtherDetailsData(buttonName: self.buttonName ?? "No", quantityText: pet, messageText: message)
        }
        
    }
    
    public func setOtherDetailsData(buttonName: String, quantityText: String, messageText: String) {
        self.buttonName = buttonName
        self.quantityText = quantityText
        self.messageText = messageText
    }
    
    private func setData() {
        
        serviceArray.append(ExtraService(image: UIImage(named: "sc_garage")!, name: "Garage\nCleaning"))
        serviceArray.append(ExtraService(image: UIImage(named: "sc_carpet")!, name: "Carpet\nCleaning"))
        serviceArray.append(ExtraService(image: UIImage(named: "sc_laundry")!, name: "Laundry\nCleaning"))
        serviceArray.append(ExtraService(image: UIImage(named: "sc_oven")!, name: "Oven\nCleaning"))
        serviceArray.append(ExtraService(image: UIImage(named: "sc_toilet")!, name: "Toilet\nCleaning"))
        serviceArray.append(ExtraService(image: UIImage(named: "sc_utensil")!, name: "Utensil\nCleaning"))
        
    }
    

}

extension OtherDetailsViewController: SCRadioButtonViewDelegate {
    
    func didTapRadioButton(_ button: UIButton) {
        
        if yesButton.radioButton.isSelected {
            noButton.radioButton.isSelected = false
        }
        
        if noButton.radioButton.isSelected {
            yesButton.radioButton.isSelected = false
        }
        
        switch button {
        case yesButton.radioButton:
            self.buttonName = "Yes"
            yesButton.radioButton.isSelected = true
            noButton.radioButton.isSelected = false
            quantityTextField.isUserInteractionEnabled = true
        case noButton.radioButton:
            self.buttonName = "No"
            noButton.radioButton.isSelected = true
            yesButton.radioButton.isSelected = false
            quantityTextField.isUserInteractionEnabled = false
            quantityTextField.text = nil
        default:
            break
        }
    }
    
    
}

extension OtherDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCExtraServiceCell.identifier, for: indexPath) as? SCExtraServiceCell else { return UICollectionViewCell() }
        
        cell.setData(image: serviceArray[indexPath.row].image, name: serviceArray[indexPath.row].name)
        cell.setImageOpacity(opacity: 0.5)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! SCExtraServiceCell
        
        cell.setImageOpacity(opacity: 1)
        
        selectedDictionary[indexPath.row] = serviceArray[indexPath.row]
        OtherDetailsViewController.selectedIndexes[indexPath.row] = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! SCExtraServiceCell
        
        cell.setImageOpacity(opacity: 0.5)
        
        selectedDictionary.removeValue(forKey: indexPath.row)
        OtherDetailsViewController.selectedIndexes.removeValue(forKey: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension OtherDetailsViewController {
    
    private func configureViewController() {
        
        view.backgroundColor = .lightBrandLake2
        title = "Other details"
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let okButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(okButtonTapped(_:)))
        okButton.tintColor = .brandDark
        okButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.urbanistRegular(size: 18)!], for: .normal)
        navigationItem.leftBarButtonItem = okButton
    }
    
    private func configurePetView() {
        view.addSubview(petView)
        
        petView.infoLabel.text = "Pets"
        petView.infoValue.text = "Is/are there pets in the place?"
        
        NSLayoutConstraint.activate([
            petView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            petView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            petView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            petView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func configureHorizontalStackView() {
        horizontalStackView = SCStackView(arrangedSubviews: [yesButton, noButton])
        view.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .fillEqually
                
        NSLayoutConstraint.activate([
            yesButton.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            noButton.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: petView.bottomAnchor, constant: 30),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureQuantityTextField() {
        view.addSubview(quantityTextField)
        
        NSLayoutConstraint.activate([
            quantityTextField.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 10),
            quantityTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            quantityTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            quantityTextField.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func configureServiceLabel() {
        view.addSubview(extraServiceLabel)
        
        extraServiceLabel.text = "Extra services"
        extraServiceLabel.font = .urbanistBold(size: 16)
        
        NSLayoutConstraint.activate([
            extraServiceLabel.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 15),
            extraServiceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            extraServiceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            extraServiceLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureCollectionView() {
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
        serviceCollectionView.clipsToBounds = false
        serviceCollectionView.backgroundColor = .lightBrandLake2
        view.addSubview(serviceCollectionView)
        
        NSLayoutConstraint.activate([
            serviceCollectionView.topAnchor.constraint(equalTo: extraServiceLabel.bottomAnchor, constant: 15),
            serviceCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            serviceCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            serviceCollectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func configureMessageLabel() {
        view.addSubview(messageLabel)
        messageLabel.text = "Message to cleaner"
        messageLabel.font = .urbanistBold(size: 16)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: serviceCollectionView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureMessageTextField() {
        view.addSubview(messageTextField)
        
        NSLayoutConstraint.activate([
            messageTextField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            messageTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            messageTextField.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    
    
}

/*
 private func configureTipsView() {
     view.addSubview(tipsView)
     
     let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
     let image = UIImage(systemName: "dollarsign.circle.fill")
     imageView.image = image
     imageView.tintColor = .brandDark
     let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
     imageContainerView.addSubview(imageView)
     tipsView.getTextField().rightViewMode = .always
     tipsView.getTextField().rightView = imageContainerView
     tipsView.getTextField().keyboardType = .numberPad
     
     tipsView.mainLabel.font = .urbanistBold(size: 16)
     
     NSLayoutConstraint.activate([
         tipsView.topAnchor.constraint(equalTo: serviceCollectionView.bottomAnchor, constant: 15),
         tipsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
         tipsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
         tipsView.heightAnchor.constraint(equalToConstant: 70)
     ])
 }
 */
