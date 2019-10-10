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
    
    // variables
    var userName: String?
    var userPassword: String?

    static let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    // MARK: Overrides

    override func loadView() {
        super.loadView()
        if UserDefaults.standard.string(forKey: "authToken") != ""{
            ApiClientAuth.requestToken = UserDefaults.standard.string(forKey: "authToken")!
            self.performSegue(withIdentifier: "LoginUserSegue", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating Activity Indicator
        LoginViewController.myActivityIndicator.hidesWhenStopped = true
        LoginViewController.myActivityIndicator.center = view.center
        // Adding it as a subview to the current view
        view.addSubview(LoginViewController.myActivityIndicator)

        // Customizing buttons on the UI
        userLoginButton.layer.cornerRadius = 5
        userRegisterButton.layer.cornerRadius = 5
        
        // Setting textfield delegates
        userNameField.delegate = self
        userPasswordField.delegate = self
        
        // updating the state of the button
        checkButtonEnabled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // updating the button state
        checkButtonEnabled()
    }

    // MARK: Actions
    
    // On pressing the login button
    @IBAction func loginUser(_ sender: Any) {
        
        // Safely extracting the credentials
        guard let userName = userNameField.text else{
            return
        }
        guard let userPassword = userPasswordField.text else{
            return
        }
        
        // Strating the activity indicator before network call
        LoginViewController.myActivityIndicator.startAnimating()
        
        // Calling the API function login to handel login request
        ApiClientAuth.loginUser(userName: userName, password: userPassword, completionHandler: handelUserLogin(bool:error:message:))
        //self.performSegue(withIdentifier: "LoginUserSegue", sender: self)
    }
    
    
    // MARK: Helpers
    
    // Creating an alert dailog display appropriate alerts
    func showAlertDailog(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Updating the button state depending on various conditions
    func checkButtonEnabled(){
        
        userName = userNameField.text
        userPassword = userPasswordField.text
        
        userLoginButton.isEnabled = !(userName!.isEmpty || userPassword!.isEmpty)
        let alpha = CommonAppFunction.updateButtonState(userLoginButton.isEnabled)
        userLoginButton.alpha = CGFloat(alpha)
        
    }
    
    // MARK: Handlers
    
    // Login handler function to complete the end process of notifying user
    func handelUserLogin(bool: Bool, error: Error?, message: String?){
        
        DispatchQueue.main.async {
            LoginViewController.myActivityIndicator.stopAnimating()
            if bool{
                ApiClientAuth.requestToken = UserDefaults.standard.string(forKey: "authToken")!
                self.performSegue(withIdentifier: "LoginUserSegue", sender: self)
            }else{
                guard let message = message else{
                    return
                }
                self.showAlertDailog(title: "Failure", message: message)
            }
        }
    }
}


// Extension handling the TextField delegate
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userLoginButton.isEnabled = false
        let alpha = CommonAppFunction.updateButtonState(userLoginButton.isEnabled)
        userLoginButton.alpha = CGFloat(alpha)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkButtonEnabled()
        return true
    }
}
