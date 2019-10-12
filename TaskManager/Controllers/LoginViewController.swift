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
    var task: URLSessionDataTask?
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
        task?.cancel()
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
        
    }

    // MARK: Actions
    
    // On pressing the login button
    @IBAction func loginUser(_ sender: Any) {
        
        // Safely extracting the credentials
        guard userNameField.text != "" else{
            self.showAlertDailog(title: "Error", message: "Enter your username!")
            return
        }
        guard userPasswordField.text != "" else{
            print(userNameField.text!)
            self.showAlertDailog(title: "Error", message: "Enter your password!")
            return
        }
        
        // Strating the activity indicator before network call
        LoginViewController.myActivityIndicator.startAnimating()
        changeState(bool: false)
        
        // Calling the API function login to handel login request
        task = ApiClientAuth.loginUser(userName: userNameField.text!.lowercased(), password: userPasswordField.text!, completionHandler: handelUserLogin(bool:error:message:))
        
    }
    
    
    // MARK: Helpers
    
    // Change state of the UIElements on login button pressed
    func changeState(bool: Bool){
        userNameField.isEnabled = bool
        userPasswordField.isEnabled = bool
        userLoginButton.isEnabled = bool
    }
    
    // Creating an alert dailog display appropriate alerts
    func showAlertDailog(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
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
            self.changeState(bool: true)
        }
    }
}


// Extension handling the TextField delegate
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
