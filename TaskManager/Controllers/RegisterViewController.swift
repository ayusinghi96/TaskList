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
        
        // Updating the button state
        checkButtonEnabled()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //checkButtonEnabled()
    }
    
    
    // MARK: Actions
    
    // On pressing the register button
    @IBAction func registerUser(_ sender: Any) {
        
        // Safely unwrapping the user entered data
        guard let userName = userNameField.text else{
            return
        }
        guard let userEmail = userEmailField.text else{
            return
        }
        guard let userPassword = userPasswordField.text else{
            return
        }
        guard let userPasswordMatch = userPasswordMatchField.text else{
            return
        }
        
        // if two entered password are same
        if isPasswordMatching(userPassword, userPasswordMatch){
            
            // Strating the activity indicator before network call
            RegisterViewController.myActivityIndicator.startAnimating()
            // Calling the API function registerUser to handel register request
            ApiClientAuth.registerUser(userName: userName, email: userEmail, password: userPassword, completionHandler: handelUserRegister(bool:error:message:))
        }else{
            showAlertDailog(title: "Error", message: "Passwords donot match!")
        }
        
    }
    
    
    // MARK: Helpers
    
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
    
    // Updating the button state depending on various conditions
    func checkButtonEnabled(){
       
        userName = userNameField.text
        userEmail = userEmailField.text
        userPassword = userPasswordField.text
        userPasswordMatch = userPasswordMatchField.text
        
        userRegisterButton.isEnabled = !(userName!.isEmpty || userEmail!.isEmpty || userPassword!.isEmpty || userPasswordMatch!.isEmpty)
        let alpha = CommonAppFunction.updateButtonState(userRegisterButton.isEnabled)
        userRegisterButton.alpha = CGFloat(alpha)
        
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
        }
    }
}


// Extension handling the TextField delegate
extension RegisterViewController: UITextFieldDelegate{
   
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userRegisterButton.isEnabled = false
        let alpha = CommonAppFunction.updateButtonState(userRegisterButton.isEnabled)
        userRegisterButton.alpha = CGFloat(alpha)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkButtonEnabled()
        return true
    }
}
