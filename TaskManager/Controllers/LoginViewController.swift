//
//  LoginViewController.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var userLoginButton: UIButton!
    @IBOutlet weak var userRegisterButton: UIButton!

    // Variables
    var activityIndicator: UIActivityIndicatorView?

    // MARK: Overrides

    // Checking if user is already logged-in
    override func loadView() {
        super.loadView()

        if UserDefaults.standard.string(forKey: "authToken") != "" {
            ApiClientAuth.RequestToken = UserDefaults.standard.string(forKey: "authToken")!
            self.performSegue(withIdentifier: "LoginUserSegue", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizing buttons on the UI
        userLoginButton.layer.cornerRadius = 5
        userRegisterButton.layer.cornerRadius = 5

        // Setting textfield delegates
        userNameField.delegate = self
        userPasswordField.delegate = self
    }

    // MARK: Actions

    // Login button pressed
    @IBAction func login(_ sender: Any) {

        // Safely extracting the credentials
        guard userNameField.text != "" else {

            CommonAppFunction.showAlertDailog(view: self, title: "Error", message: "Enter your username!")
            return
        }
        guard userPasswordField.text != "" else {

            CommonAppFunction.showAlertDailog(view: self, title: "Error", message: "Enter your password!")
            return
        }

        // Starting the activity indicator before network call
        activityIndicator = CommonAppFunction.showActivityIndicator(view: view)
        activityIndicator?.startAnimating()

        // Diabling UIElements
        changeUIElementEnableState(enable: false)

        // Making API call to authenticate User
        ApiClientAuth.loginUser(userName: userNameField.text!, password: userPasswordField.text!, completionHandler: handleUserLogin(bool:error:message:))
    }

    // MARK: Helpers

    // Changing state of the UIElements on login button pressed
    func changeUIElementEnableState(enable: Bool) {

        userNameField.isEnabled = enable
        userPasswordField.isEnabled = enable
        userLoginButton.isEnabled = enable
        userRegisterButton.isEnabled = enable
    }

    // MARK: Handlers

    // Login handler function
    func handleUserLogin(bool: Bool, error: Error?, message: String?) {

        // Stoping the activity indicator before network call
        activityIndicator?.stopAnimating()

        if bool {

            // Logging user in
            self.performSegue(withIdentifier: "LoginUserSegue", sender: self)
        } else {

            guard let message = message else {
                return
            }

            // Notifying user of errors
            CommonAppFunction.showAlertDailog(view: self, title: "Failure", message: message)
        }

        // Enabling UIElements
        changeUIElementEnableState(enable: true)
    }
}


// Extension handling the TextField delegate
extension LoginViewController: UITextFieldDelegate {

    // Resigning first responder on pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
