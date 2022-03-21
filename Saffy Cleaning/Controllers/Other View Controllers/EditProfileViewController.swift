//
//  EditProfileViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-21.
//

import UIKit
import Firebase
import SDWebImage

class EditProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    private let profileImageView = SCProfileImageView(cornerRadius: 60)
    private var verticalStackView: SCStackView!
    private let loginNameView = SCInfoView(placeholder: "Full Name", text: "Full Name")
    private let numberView = SCInfoView(placeholder: "Number", text: "Contact Number")
    private let emailView = SCInfoView(placeholder: "Email", text: "Email")
    private let saveButton = SCMainButton(title: "Save", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 15, fontSize: nil)
    public var user: User?
    private var userImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureImageView()
        configureStackView()
        configureSaveButton()
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapImageView(_ gesture: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func didTapSaveButton(_ button: UIButton) {
        
        guard let loginName = loginNameView.getTextField().text, let contactNumber = numberView.getTextField().text, let email = emailView.getTextField().text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("users")
        
        let values = ["fullName": loginName, "contactNumber": contactNumber, "email": email]
        
        let user = Auth.auth().currentUser
        user?.updateEmail(to: email, completion: { error in
            if let error = error {
                print("Error updating email : \(error.localizedDescription)")
                return
            }
        })
        
        ref.child(uid).updateChildValues(values)
        
        guard let userImage = userImage else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        FirebaseDBService.service.saveImage(image: userImage) { imageUrl in
                        
            guard let imageUrl = imageUrl else {
                return
            }
            
            DispatchQueue.main.async {
                self.profileImageView.sd_setImage(with: imageUrl, completed: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    

}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        self.userImage = image
        self.profileImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileViewController {
    
    private func configureImageView() {
        view.addSubview(profileImageView)
        
        profileImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        profileImageView.addGestureRecognizer(tap)
        
        if let profileImage = user?.profileImageUrl {
            self.profileImageView.sd_setImage(with: profileImage, completed: nil)
        }
        else {
            profileImageView.image = UIImage(systemName: "person.circle")!
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    private func configureStackView() {
        verticalStackView = SCStackView(arrangedSubviews: [loginNameView, numberView, emailView])
        view.addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        
        verticalStackView.arrangedSubviews.forEach {
            $0.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        loginNameView.getTextField().text = user?.fullName
        numberView.getTextField().text = user?.contactNumber
        emailView.getTextField().text = user?.email
    }
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(didTapSaveButton(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
