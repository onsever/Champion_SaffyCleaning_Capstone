//
//  SignUpViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "sc_brand_logo")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var logoTitleLabel = SCTitleLabel(fontSize: 32, textColor: .brandDark)
    private lazy var logoSubTitleLabel = SCSubTitleLabel(text: "Keep your place clean\nSafe and effective", isRequired: false, textColor: .brandDark)
    private lazy var usernameTextField = SCTextField(placeholder: "Login Name")
    private lazy var fullNameTextField = SCTextField(placeholder: "Full Name")
    private lazy var passwordTextField = SCTextField(placeholder: "Password")
    private lazy var emailTextField = SCTextField(placeholder: "e.g name@emailprovider.com")
    private lazy var contactNumberTextField = SCTextField(placeholder: "e.g. 617-680-12-09")
    private var textFieldStackView: SCStackView!
    private let signUpButton = SCMainButton(title: "Sign Up", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    private lazy var alreadyUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedText = NSMutableAttributedString(string: "Do you have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistSemibold(size: 14)!])
        attributedText.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandGem, NSAttributedString.Key.font: UIFont.urbanistBold(size: 14)!]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureLogoImageView()
        configureLogoTitleLabel()
        configureLogoSubTitleLabel()
        configureTextFieldStackView()
        configureAlreadyUserLabel()
        configureSignUpButton()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Selectors
    @objc private func signUpButtonDidTapped(_ button: UIButton) {
        button.animateWithSpring()
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            FirebaseAuthService.service.createUser(email: email, password: password) {
                [weak self] (success) in
                guard let `self` = self else {return}
                var message: String = ""
                if (success) {
                    message = "User was successfully created"
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainTabBarController())
                    
                }else {
                    message = "There was an error"
                }
                self.presentAlert(title: "Sign Up", message: message) { action in
                    print("Positive action is tapped on.")
                } negativeAction: { action in
                    print("Negative action is tapped on.")
                }
            }
        }


    }
    
    @objc private func haveAnAccountDidTapped(_ gesture: UITapGestureRecognizer) {
        print("Have an account label tapped on.")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text!.count == 0 {
            textField.rightView = nil
            textField.layer.borderColor = UIColor.brandGem.cgColor
            textField.tintColor = .brandGem
            return
        }
        
        textField.rightViewMode = .always
        
        if textField.text!.count > 5 {
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            let image = UIImage(systemName: "checkmark")
            imageView.image = image
            let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageContainerView.addSubview(imageView)
            textField.rightView = imageContainerView
            
            textField.layer.borderColor = UIColor.brandGem.cgColor
            
            textField.tintColor = .brandGem
        }
        else {
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            let image = UIImage(systemName: "xmark")
            imageView.image = image
            let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageContainerView.addSubview(imageView)
            textField.rightView = imageContainerView
            
            textField.layer.borderColor = UIColor.brandError.cgColor
            
            textField.tintColor = .brandError
        }
    }


}

// MARK: - UIConfiguration Methods
extension SignUpViewController {
    
    private func configureViewController() {
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configureLogoTitleLabel() {
        view.addSubview(logoTitleLabel)
        logoTitleLabel.text = "Saffy Cleaning"
        logoTitleLabel.setCharacterSpacing(characterSpacing: 2)
        
        NSLayoutConstraint.activate([
            logoTitleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 5),
            logoTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoTitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureLogoSubTitleLabel() {
        view.addSubview(logoSubTitleLabel)
        logoSubTitleLabel.numberOfLines = 2
        logoSubTitleLabel.setCharacterSpacing(characterSpacing: 2)
        logoSubTitleLabel.font = .urbanistRegular(size: 25)
        logoSubTitleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            logoSubTitleLabel.topAnchor.constraint(equalTo: logoTitleLabel.bottomAnchor, constant: 15),
            logoSubTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoSubTitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureTextFieldStackView() {
        textFieldStackView = SCStackView(arrangedSubviews: [usernameTextField, fullNameTextField, emailTextField, contactNumberTextField, passwordTextField])
        view.addSubview(textFieldStackView)
        
        passwordTextField.isSecureTextEntry = true
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        contactNumberTextField.delegate = self
        
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            usernameTextField.widthAnchor.constraint(equalTo: textFieldStackView.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: textFieldStackView.widthAnchor),
            emailTextField.widthAnchor.constraint(equalTo: textFieldStackView.widthAnchor),
            contactNumberTextField.widthAnchor.constraint(equalTo: textFieldStackView.widthAnchor),
            fullNameTextField.widthAnchor.constraint(equalTo: textFieldStackView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: logoSubTitleLabel.bottomAnchor, constant: 60),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
    }
    
    private func configureSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: alreadyUserLabel.topAnchor, constant: -20),
            signUpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureAlreadyUserLabel() {
        view.addSubview(alreadyUserLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(haveAnAccountDidTapped(_:)))
        alreadyUserLabel.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            alreadyUserLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            alreadyUserLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            alreadyUserLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            alreadyUserLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count == 0 {
            textField.rightView = nil
            textField.layer.borderColor = UIColor.brandGem.cgColor
        } else {
            textField.layer.borderColor = UIColor.brandGem.cgColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
}
