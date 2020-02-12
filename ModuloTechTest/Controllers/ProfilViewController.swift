//
//  ProfilViewController.swift
//  ModuloTechTest
//
//  Created by Daniel Ghrenassia on 12/02/2020.
//  Copyright © 2020 Daniel Ghrenassia. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController, UITextFieldDelegate {
    
    var user: User?
    let datePicker = UIDatePicker()

    @IBOutlet weak var userProfilImageView: UIImageView!
    @IBOutlet weak var userNameTextView: UITextView!
    @IBOutlet weak var streetNameTF: MaterialTextField!
    @IBOutlet weak var cityNameTF: MaterialTextField!
    @IBOutlet weak var postCodeTF: MaterialTextField!
    @IBOutlet weak var countryNameTF: MaterialTextField!
    @IBOutlet weak var birthdateTF: MaterialTextField!
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDatePicker()
        
        for textField in [streetNameTF, cityNameTF, postCodeTF, countryNameTF] {
            textField!.delegate = self
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setUserInfos()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func setUserInfos() {
        userProfilImageView.layer.cornerRadius = userProfilImageView.frame.height / 2
        userNameTextView.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        streetNameTF.text = user?.address.street
        cityNameTF.text = user?.address.city
        let date = Date(timeIntervalSince1970: Double(user!.birthDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        let strDate = dateFormatter.string(from: date)
        birthdateTF.text = strDate
        if let strPostCode = user?.address.postalCode  {
           postCodeTF.text = String(strPostCode)
        }
        else {
           postCodeTF.text = "";
        }
        countryNameTF.text = String(user?.address.country ?? "")
    }
    
    func showDatePicker() {

        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_US")
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 35))
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))

        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        birthdateTF.inputAccessoryView = toolBar
        birthdateTF.inputView = datePicker
        
    }
    
    @objc func doneDatePicker(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        birthdateTF.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if view.frame.origin.y == 0 {
//                Don't move the UI too up if it's a tall iPhone
                if keyboardSize.height > 300 {
                    view.frame.origin.y -= keyboardSize.height - 100
                } else {
                    view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Update..")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

}
