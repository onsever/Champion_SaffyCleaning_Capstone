//
//  ViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

class LoginViewController: UIViewController {
    
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
    private lazy var passwordTextField = SCTextField(placeholder: "Password")
    private var textFieldStackView: SCStackView!
    private lazy var forgetPasswordLabel = SCCompletionLabel(title: "Forget Password", titleColor: .brandDark, fontSize: 13)
    private let loginButton = SCMainButton(title: "Log in", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    private let signUpButton = SCMainButton(title: "Sign Up", backgroundColor: .white, titleColor: .brandGem, borderColor: .brandGem, cornerRadius: 10, fontSize: nil)
    private var buttonStackView: SCStackView!
    private let googleSignInView = SCSignInView(image: UIImage(named: "sc_google_logo"), title: "Continue with Google")
    private let facebookSignInView = SCSignInView(image: UIImage(named: "sc_facebook_logo"), title: "Continue with Facebook")
    private var signInStackView: SCStackView!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureLogoImageView()
        configureLogoTitleLabel()
        configureLogoSubTitleLabel()
        configureTextFieldStackView()
        configureForgetPasswordLabel()
        configureButtonStackView()
        configureSignInStackView()
    }
    
    // MARK: - Selectors
    @objc private func loginButtonDidTapped(_ button: UIButton) {
        button.animateWithSpring()
        
        self.presentAlert(title: "Incorrect Credentials", message: "Please check your email and / or your password again.") { action in
            print("Positive action is tapped on.")
        } negativeAction: { action in
            print("Negative action is tapped on.")
        }

    }
    
    @objc private func signUpButtonDidTapped(_ button: UIButton) {
        button.animateWithSpring()
    }
    
    @objc private func continueWithGoogleDidTapped(_ gesture: UITapGestureRecognizer) {
        googleSignInView.animateWithSpring()
    }
    
    @objc private func continueWithFacebookDidTapped(_ gesture: UITapGestureRecognizer) {
        facebookSignInView.animateWithSpring()
    }
    
    @objc private func forgetPasswordDidTapped(_ gesture: UITapGestureRecognizer) {
        print("Forget password label tapped on.")
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
extension LoginViewController {
    
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
        textFieldStackView = SCStackView(arrangedSubviews: [usernameTextField, passwordTextField])
        view.addSubview(textFieldStackView)
        
        passwordTextField.isSecureTextEntry = true
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            usernameTextField.widthAnchor.constraint(equalTo: textFieldStackView.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: textFieldStackView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: logoSubTitleLabel.bottomAnchor, constant: 30),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
    }
    
    private func configureForgetPasswordLabel() {
        view.addSubview(forgetPasswordLabel)
        forgetPasswordLabel.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(forgetPasswordDidTapped(_:)))
        
        forgetPasswordLabel.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            forgetPasswordLabel.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 5),
            forgetPasswordLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            forgetPasswordLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureButtonStackView() {
        buttonStackView = SCStackView(arrangedSubviews: [loginButton, signUpButton])
        view.addSubview(buttonStackView)
        
        loginButton.addTarget(self, action: #selector(loginButtonDidTapped(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor),
            signUpButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: forgetPasswordLabel.bottomAnchor, constant: 25),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 160),
        ])
    }
    
    private func configureSignInStackView() {
        signInStackView = SCStackView(arrangedSubviews: [googleSignInView, facebookSignInView])
        view.addSubview(signInStackView)
        signInStackView.spacing = 20
        
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(continueWithGoogleDidTapped(_:)))
        let facebookTap = UITapGestureRecognizer(target: self, action: #selector(continueWithFacebookDidTapped(_:)))
        
        googleSignInView.addGestureRecognizer(googleTap)
        facebookSignInView.addGestureRecognizer(facebookTap)
                
        NSLayoutConstraint.activate([
            facebookSignInView.widthAnchor.constraint(equalTo: signInStackView.widthAnchor),
            facebookSignInView.heightAnchor.constraint(equalToConstant: 50),
            googleSignInView.widthAnchor.constraint(equalTo: signInStackView.widthAnchor),
            googleSignInView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            signInStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 30),
            signInStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            signInStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
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
