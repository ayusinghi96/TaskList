//
//  RegisterViewController.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var userPasswordMatchField: UITextField!
    @IBOutlet weak var userRegisterButton: UIButton!

    // variables
    var activityIndicator: UIActivityIndicatorView?

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizing button
        userRegisterButton.layer.cornerRadius = 5

        // Setting field delegates
        userNameField.delegate = self
        userEmailField.delegate = self
        userPasswordField.delegate = self
        userPasswordMatchField.delegate = self

    }

    // MARK: Actions

    // On pressing the register button
    @IBAction func registerUser(_ sender: Any) {

        // Safely unwrapping the user entered data
        guard userNameField.text != "" else {
            CommonAppFunction.showAlertDailog(view: self, title: "Error", message: "Enter a username!")
            return
        }
        guard userEmailField.text != "" else {
            CommonAppFunction.showAlertDailog(view: self, title: "Error", message: "Enter a email address!")
            return
        }
        guard userPasswordField.text != "" else {
            CommonAppFunction.showAlertDailog(view: self, title: "Error", message: "Enter a password!")
            return
        }
        guard userPasswordMatchField.text != "" else {
            CommonAppFunction.showAlertDailog(view: self, title: "Error", message: "Enter a password!")
            return
        }

        if isEmailValid(enteredEmail: userEmailField.text!) {
            // if two entered password are same
            if isPasswordMatching(userPasswordField.text!, userPasswordMatchField.text!) {

                // Strating the activity indicator before network call

                activityIndicator = CommonAppFunction.showActivityIndicator(view: view)
                activityIndicator?.startAnimating()
                
                // Disabling the UIElements to stop changes while processing one request
                changeUIElementEnableState(enable: false)

                // Calling the API function registerUser to handel register request
                ApiClientAuth.registerUser(userName: userNameField.text!, email: userEmailField.text!, password: userPasswordField.text!, completionHandler: handleUserRegister(bool:message:error:))

            } else {
                CommonAppFunction.showAlertDailog(view: self, title: "Error", message: "Passwords do not match!")
            }
        } else {
            CommonAppFunction.showAlertDailog(view: self, title: "Error", message: "Enter a correct Email address")
        }
    }


    // MARK: Helpers

    func isEmailValid(enteredEmail: String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }

    // checking if the two passwords are same
    func isPasswordMatching(_ userPassword: String, _ userPasswordMatch: String) -> Bool {

        if userPassword == userPasswordMatch {
            return true
        } else {
            return false
        }
    }

    func changeUIElementEnableState(enable: Bool) {

        userNameField.isEnabled = enable
        userEmailField.isEnabled = enable
        userPasswordMatchField.isEnabled = enable
        userPasswordField.isEnabled = enable
        userRegisterButton.isEnabled = enable
        self.navigationItem.hidesBackButton = !enable
    }

    // MARK: Handlers

    // Register handler function to complete the end process of notifying user
    func handleUserRegister(bool: Bool, message: String, error: Error?) {
        
        activityIndicator?.stopAnimating()
        
        if bool {
            CommonAppFunction.showAlertDailog(view: self, title: "Success", message: message) {
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            
            CommonAppFunction.showAlertDailog(view: self, title: "Failure", message: message)
        }
        self.changeUIElementEnableState(enable: true)
    }
}


// Extension handling the TextField delegate
extension RegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
