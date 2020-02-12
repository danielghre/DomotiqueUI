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

    @IBOutlet weak var userProfilImageView: UIImageView!
    @IBOutlet weak var userNameTextView: UITextView!
    @IBOutlet weak var streetNameTF: MaterialTextField!
    @IBOutlet weak var cityNameTF: MaterialTextField!
    @IBOutlet weak var postCodeTF: MaterialTextField!
    @IBOutlet weak var countryNameTF: MaterialTextField!
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in [streetNameTF, cityNameTF, postCodeTF, countryNameTF] {
            textField!.delegate = self
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        userProfilImageView.layer.cornerRadius = userProfilImageView.frame.height / 2
        userNameTextView.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        streetNameTF.text = user?.address.street
        cityNameTF.text = user?.address.city
        if let strPostCode = user?.address.postalCode  {
           postCodeTF.text = String(strPostCode)
        }
        else {
           postCodeTF.text = "";
        }
        countryNameTF.text = String(user?.address.country ?? "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height - 80
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
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
