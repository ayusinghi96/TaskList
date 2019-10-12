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
    var userName: String?
    var userEmail: String?
    var userPassword: String?
    var userPasswordMatch: String?
    
    var task: URLSessionDataTask?
    
    static let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating Activity Indicator
        RegisterViewController.myActivityIndicator.hidesWhenStopped = true
        RegisterViewController.myActivityIndicator.center = view.center
        view.addSubview(RegisterViewController.myActivityIndicator)

        // Customizing button
        userRegisterButton.layer.cornerRadius = 5
        
        // Setting field delegates
        userNameField.delegate = self
        userEmailField.delegate = self
        userPasswordField.delegate = self
        userPasswordMatchField.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
        guard let task = task else{
            return
        }
        task.cancel()
    }
    
    // MARK: Actions
    
    // On pressing the register button
    @IBAction func registerUser(_ sender: Any) {
        
        // Safely unwrapping the user entered data
        guard userNameField.text != "" else{
            self.showAlertDailog(title: "Error", message: "Enter a username!")
            return
        }
        guard userEmailField.text != "" else{
            print(userNameField.text!)
            self.showAlertDailog(title: "Error", message: "Enter an email addreess!")
            return
        }
        guard userPasswordField.text != "" else{
            self.showAlertDailog(title: "Error", message: "Enter the password!")
            return
        }
        guard userPasswordMatchField.text != "" else{
            self.showAlertDailog(title: "Error", message: "Enter your password!")
            return
        }
        
        if isEmailValid(enteredEmail: userEmailField.text!){
            // if two entered password are same
            if isPasswordMatching(userPasswordField.text!, userPasswordMatchField.text!) {
                
                // Strating the activity indicator before network call
                RegisterViewController.myActivityIndicator.startAnimating()
                
                // Disabling the UIElements to stop changes while processing one request
                changeState(bool: false)
                
                // Calling the API function registerUser to handel register request
                task = ApiClientAuth.registerUser(userName: userNameField.text!.lowercased(), email: userEmailField.text!, password: userPasswordField.text!, completionHandler: handelUserRegister(bool:error:message:))
            
            }else{
                showAlertDailog(title: "Error", message: "Passwords do not match!")
            }
        }else{
            showAlertDailog(title: "Error", message: "Enter a correct Email address")
        }
    }
    
    
    // MARK: Helpers
    
    func isEmailValid(enteredEmail: String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    // Creating an alert dailog to display appropriate alerts
    func showAlertDailog(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if title == "Success"{
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
            }))
        }else{
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // checking if the two passwords are same
    func isPasswordMatching(_ userPassword: String, _ userPasswordMatch: String) -> Bool{
        
        if userPassword == userPasswordMatch{
            return true
        }else{
            return false
        }
    }
    
    func changeState(bool: Bool){
        
        userNameField.isEnabled = bool
        userEmailField.isEnabled = bool
        userPasswordMatchField.isEnabled = bool
        userPasswordField.isEnabled = bool
        userRegisterButton.isEnabled = bool
        
    }
    
    // MARK: Handlers
    
    // Register handler function to complete the end process of notifying user
    func handelUserRegister(bool: Bool, error: Error?, message: String){
        var title = "Success"
        if !bool{
            title = "Failure"
        }
        
        DispatchQueue.main.async {
            RegisterViewController.myActivityIndicator.stopAnimating()
            self.showAlertDailog(title: title, message: message)
            self.changeState(bool: true)
        }
    }
}


// Extension handling the TextField delegate
extension RegisterViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
