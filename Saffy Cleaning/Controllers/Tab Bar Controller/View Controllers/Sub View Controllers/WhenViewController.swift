//
//  WhenViewController.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-11.
//

import UIKit

protocol WhenViewDelegate: AnyObject {
    func addDate(date: String, time: String, duration: Int?)
}

class WhenViewController: UIViewController {
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 10
        datePicker.clipsToBounds = true
        datePicker.minimumDate = Date()
        datePicker.tintColor = .brandGem
        
        return datePicker
    }()
    
    private let durationView = SCInfoView(placeholder: "Choose a duration", text: "Duration")
    private let selectionPopUp = SCSelectionPopUp(isHouseType: false)
    public weak var delegate: WhenViewDelegate?
    private static var selectedDate: Date? = nil
    private static var durationText: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureLayout()
        
        selectionPopUp.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedDate = WhenViewController.selectedDate {
            datePicker.setDate(selectedDate, animated: true)
            datePicker.date = selectedDate
        }
        
        durationView.getTextField().text = WhenViewController.durationText
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        WhenViewController.selectedDate = datePicker.date
        WhenViewController.durationText = checkDurationText()
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func okButtonTapped(_ button: UIBarButtonItem) {
        print(formatDate(date: datePicker.date))
        print(formatTime(date: datePicker.date))
        
        if durationView.getTextField().text == "" {
            self.presentAlert(title: "Empty Field", message: "Please choose a duration.", positiveAction: { action in
                
            }, negativeAction: nil)
        }
        else {
            let date = formatDate(date: datePicker.date)
            let time = formatTime(date: datePicker.date)
            let duration = Int((durationView.getTextField().text!).prefix(1))!
                    
            delegate?.addDate(date: date, time: time, duration: duration)
        }

    }
    
    @objc private func durationViewTapped(_ gesture: UITapGestureRecognizer) {
        selectionPopUp.modalPresentationStyle = .overCurrentContext
        self.present(selectionPopUp, animated: true, completion: nil)
    }
    
    private func configureViewController() {
        
        view.backgroundColor = .lightBrandLake2
        title = "When"
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let okButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(okButtonTapped(_:)))
        okButton.tintColor = .brandDark
        okButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.urbanistRegular(size: 18)!], for: .normal)
        navigationItem.leftBarButtonItem = okButton
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter.string(from: date)
    }
    
    private func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        return formatter.string(from: date)
    }
    
    private func checkDurationText() -> String {
        if self.durationView.getTextField().text == nil || self.durationView.getTextField().text == "" {
            return "0"
        }
        else {
            return self.durationView.getTextField().text!
        }
    }
   

}

extension WhenViewController {
    
    private func configureLayout() {
        view.addSubview(datePicker)
        view.addSubview(durationView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(durationViewTapped(_:)))
        
        durationView.isUserInteractionEnabled = true
        durationView.getTextField().delegate = self
        durationView.getTextField().keyboardType = .numberPad
        durationView.getTextField().isUserInteractionEnabled = false
        durationView.addGestureRecognizer(tap)
                
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            durationView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            durationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            durationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            durationView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}

extension WhenViewController: UITextFieldDelegate {
    
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
        textField.resignFirstResponder()
        return true
    }
    
    
}

extension WhenViewController: SCSelectionPopUpDelegate {
    
    func didSelectRowAt(item: String) {
        self.durationView.getTextField().text = item
    }
    
    
}
