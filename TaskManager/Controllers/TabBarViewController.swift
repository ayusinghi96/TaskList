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

    // Variables
    var activityIndicator: UIActivityIndicatorView?

    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: Actions

    // Logout User
    @IBAction func logout(_ sender: Any) {

        // Disabling logoutButton to restrict multiple requests
        logoutButton.isEnabled = false

        // Presenting alert controller to confirm the action
        CommonAppFunction.showAlertDailog(view: self, title: "LOGOUT", message: "Do you really want to logout?") { (bool) in

            if bool {

                // Presenting activityIndicator
                self.activityIndicator = CommonAppFunction.showActivityIndicator(view: self.view)
                self.activityIndicator?.startAnimating()

                // Making API call to logout
                ApiClientAuth.logoutUser(completionHandler: self.handleLogout(bool:error:message:))
            } else {

                // Enabling logoutButton if some error happens
                self.logoutButton.isEnabled = true
            }
        }
    }

    //MARK: Handlers

    // Handling API response
    func handleLogout(bool: Bool, error: Error?, message: String?) {

        // Stopping activity indicator
        activityIndicator?.stopAnimating()

        // If successfull response is obtained
        if bool {

            // Removing all the cached data
            APIClientCalls.Cache.removeAllObjects()

            // Dismissing the view and going back to login view controller
            self.dismiss(animated: true, completion: nil)
        } else {

            // Safely extracting the message obtained
            guard let message = message else {
                return
            }

            // Enabling the logout button
            self.logoutButton.isEnabled = true

            // Notifying user of the errors
            CommonAppFunction.showAlertDailog(view: self, title: "Failure", message: message)
        }
    }
}
