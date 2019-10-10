//
//  TabBarViewController.swift
//  TaskManager
//
//  Created by Ayush on 09/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    //MARK: Properties
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    @IBAction func logout(_ sender: Any) {
        logoutButton.isEnabled = false
        
        
        // Presenting alert controller to confirm the action
        let alertDailog = UIAlertController(title: "LOGOUT", message: "Do you really want to logout?", preferredStyle: .alert)
        
        alertDailog.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in

            ApiClientAuth.logoutUser(completionHandler: self.handleLogout(bool:error:message:))

        }))
        alertDailog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            self.logoutButton.isEnabled = true
        }))
        
        self.present(alertDailog, animated: true, completion: nil)
    }
    
    //MARK: Handlers
    
    // Handler function on logout confirmation
    func handleLogout(bool: Bool, error: Error?, message: String?){
        
        DispatchQueue.main.async {
            if bool{
                self.dismiss(animated: true, completion: nil)
            }else{
                
                guard let message = message else{
                    return
                }
                
                self.logoutButton.isEnabled = true
                let alertController = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
