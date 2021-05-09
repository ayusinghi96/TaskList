//
//  DaysPopUpViewController.swift
//  TaskManager
//
//  Created by Ayush on 11/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class DaysPopUpViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var daysTextField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var enterDaysLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!


    // Variables
    var onApplyFilter: ((_ days: Int) -> ())?

    // MARK: Overrired
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizing UIElements
        cancelButton.layer.cornerRadius = 5
        applyButton.layer.cornerRadius = 5
        popUpView.layer.cornerRadius = 10

        // Setting-up delegates
        daysTextField.delegate = self

        // Setting default number of days
        let days = 30
        daysTextField.text = String(days)

    }

    // MARK: Actions
    // Applying filters
    @IBAction func apply(_ sender: Any) {

        // Safely extracting days from the daysTextField
        guard let days = daysTextField.text else {
            return
        }

        // Passing in the days to the parentVC
        onApplyFilter?(Int(days)!)

        // Resigning first responder for the textField
        textFieldDidEndEditing(daysTextField)

        // Dismissing the current view controller
        dismiss(animated: true, completion: nil)
    }


    // Cancelling the filter popUp
    @IBAction func cancel(_ sender: Any) {

        // Resinging the first responder
        textFieldDidEndEditing(daysTextField)

        // Dismissing the current view controller
        dismiss(animated: true, completion: nil)
    }
}

// Extension handling the textField Delegate
extension DaysPopUpViewController: UITextFieldDelegate {

    // Resigning first responder for textFields
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        return
    }

}
