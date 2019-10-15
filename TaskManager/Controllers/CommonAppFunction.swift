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

    // Creating an alert dailog to display appropriate alerts
    class func showAlertDailog(view: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        view.present(alertController, animated: true, completion: nil)
    }
    
    class func showActivityIndicator(view: UIView) -> UIActivityIndicatorView {
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.center = view.center
        view.addSubview(myActivityIndicator)
        return myActivityIndicator
    }
    
    class func showAlertDailog(view: UIViewController, title: String, message: String, completionHandler: @escaping (Bool) -> ()){
        
        let alertDailog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertDailog.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alertDailog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            completionHandler(false)
        }))
        
        view.present(alertDailog, animated: true, completion: nil)
    }
    
    class func showAlertDailog(view: UIViewController, title: String, message: String, completionHandler: @escaping () -> ()){
        let alertDailog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertDailog.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        view.present(alertDailog, animated: true, completion: nil)
    }
}
