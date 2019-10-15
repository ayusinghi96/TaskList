//
//  DaysPopUpViewController.swift
//  TaskManager
//
//  Created by Ayush on 11/10/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class DaysPopUpViewController: UIViewController {

    @IBOutlet weak var daysTextField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var enterDaysLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!

    var days = 30
    var onSave: ((_ days: Int) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.layer.cornerRadius = 5
        applyButton.layer.cornerRadius = 5
        popUpView.layer.cornerRadius = 10

        daysTextField.delegate = self

        daysTextField.text = String(days)

    }

    @IBAction func apply(_ sender: Any) {

        guard let days = daysTextField.text else {
            return
        }

        onSave?(Int(days)!)
        textFieldDidEndEditing(daysTextField)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        textFieldDidEndEditing(daysTextField)
        dismiss(animated: true, completion: nil)
    }
}

extension DaysPopUpViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        return
    }

}
