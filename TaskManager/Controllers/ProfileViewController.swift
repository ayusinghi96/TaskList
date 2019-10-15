//
//  ProfileViewController.swift
//  TaskManager
//
//  Created by Ayush on 25/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var taskHandledLabel: UILabel!


    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        ApiClientProfile.getUserProfile { (bool, error, message, user, tasks) in

            if bool {
                guard let user = user else {
                    self.userNameLabel.text = "Current User"
                    self.userEmailLabel.text = "User's current email"
                    return
                }

                self.userNameLabel.text = user.username
                self.userEmailLabel.text = user.email
                self.taskHandledLabel.text = String(tasks)
            }
        }
    }

    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
