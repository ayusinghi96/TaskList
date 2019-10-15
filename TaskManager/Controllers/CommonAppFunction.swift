//
//  CommonAppFunction.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import Foundation
import UIKit

// class to house commonly used functions
class CommonAppFunction {

    class func updateButtonState(_ button: Bool) -> Float {
        if button {
            return 1
        } else {
            return 0.5
        }
    }

    // Creating an alert dailog to display appropriate alerts
    class func showAlertDailog(view: UIViewController, title: String, message: String, completionHandler: @escaping () -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if title == "Success" {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                completionHandler()
            }))
        } else {
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
        }
        view.present(alertController, animated: true, completion: nil)
    }
}
