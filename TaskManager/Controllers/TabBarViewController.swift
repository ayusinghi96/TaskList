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
    var activityIndicator: UIActivityIndicatorView?

    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: Actions
    @IBAction func logout(_ sender: Any) {
        
        logoutButton.isEnabled = false
        
        // Presenting alert controller to confirm the action
        CommonAppFunction.showAlertDailog(view: self, title: "LOGOUT", message: "Do you really want to logout?") { (bool) in
            if bool {
                self.activityIndicator = CommonAppFunction.showActivityIndicator(view: self.view)
                self.activityIndicator?.startAnimating()
                ApiClientAuth.logoutUser(completionHandler: self.handleLogout(bool:error:message:))
            } else {
                self.logoutButton.isEnabled = true
            }
        }
    }

    //MARK: Handlers

    // Handler function on logout confirmation
    func handleLogout(bool: Bool, error: Error?, message: String?) {

        activityIndicator?.stopAnimating()
        
        if bool {
            self.dismiss(animated: true, completion: nil)
        } else {

            guard let message = message else {
                return
            }

            self.logoutButton.isEnabled = true
            CommonAppFunction.showAlertDailog(view: self, title: "Failure", message: message)
        }

    }
}
