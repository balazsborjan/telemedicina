//
//  AddNewPatientViewController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 13..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit
import CoreData

class AddNewPatientViewController: UIViewController {
    
    var patientPOJO = PatientPOJO()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var sexTypeSelector: UISegmentedControl!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var tajTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    let pickerViewComponents = ["Nő", "Férfi"]
    
    var selectedSexType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tappedGR = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        self.view.addGestureRecognizer(tappedGR)
        
        nameTextField.delegate = self
        tajTextField.delegate = self
        
        let minimumYear = -89
        let maximumYear = -16
        
        var dateComponents = DateComponents()
        
        dateComponents.year = minimumYear
        
        let minimumDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        
        dateComponents.year = maximumYear
        
        let maximumDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
    }
    
    @objc private func tappedView(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let operationVC = segue.destination as? OperationViewController {
            
            operationVC.navigateBackToMainController = true
        }
    }
    
    func isSavePatientEnabled() -> Bool {
        
//        if PatientValidator.isValid(name: nameTextField.text) && PatientValidator.isValid(TAJ: tajTextField.text) {
//            return true
//        }
        
        if sexTypeSelector.selectedSegmentIndex > -1
            && patientPOJO.name != nil
            && patientPOJO.name.characters.count > 0
            && patientPOJO.TAJ != nil
            && patientPOJO.TAJ.characters.count >= 9 {
            
            if patientPOJO.birthDate == nil {
                
                patientPOJO.birthDate = datePicker.date
            }
            
            return true
        }
        
        return false
    }
    
    @IBAction func birthDateChanged(_ sender: UIDatePicker) {
        
        patientPOJO.birthDate = sender.date
    }

    @IBAction func selectedSexTypeChanged(_ sender: UISegmentedControl) {
        
        self.view.endEditing(true)
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.patientPOJO.sexType = SexType.No
        case 1:
            self.patientPOJO.sexType = SexType.Ferfi
        default:
            break
        }
        
        if isSavePatientEnabled() {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func savePatient(_ sender: UIButton) {
        
        self.view.endEditing(true)
        showSaveAlert()
    }
    
    private func showSaveAlert() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let name = "Név: \(patientPOJO.name!)\n"
        let sex = "Nem: \(patientPOJO.sexType == SexType.No ? "Nő" : "Férfi") \n"
        let birthDate = "Születési dátum: \(dateFormatter.string(from: patientPOJO.birthDate!)) \n"
        let taj = "TAJ szám: \(patientPOJO.TAJ!)"
        
        let savePatientAlert = UIAlertController(
            title: "Beteg rögzítése",
            message: "Adatak: \n" + name + sex + birthDate + taj, preferredStyle: .alert)
        
        savePatientAlert.addAction(UIAlertAction(title: "Mégsem", style: .cancel, handler: { (action: UIAlertAction) in
            //Do nothing
        }))
        
        savePatientAlert.addAction(UIAlertAction(title: "Rögzít", style: .default, handler: { (action: UIAlertAction) in
            
            patient = Patient(context: managedObjectContext!)
            
            patient!.name = self.patientPOJO.name
            patient!.birthDate = self.patientPOJO.birthDate! as NSDate
            patient!.sexType = Int32(self.patientPOJO.sexType.hashValue)
            patient!.taj = self.patientPOJO.TAJ
            
            try! managedObjectContext?.save()
            
            let segue = UIStoryboardSegue.init(identifier: "operationVCSegue", source: self, destination: (self.storyboard?.instantiateViewController(withIdentifier: "operationVC"))!)
            
            self.performSegue(withIdentifier: segue.identifier!, sender: self)
        }))
        
        self.present(savePatientAlert, animated: true, completion: nil)
    }
}

extension AddNewPatientViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.nameTextField {
            
            self.patientPOJO.name = textField.text
            
        } else if textField == self.tajTextField {
            
            self.patientPOJO.TAJ = textField.text
        }
        
        if self.isSavePatientEnabled() {
            
            self.saveButton.isEnabled = true
        }
        
        self.view.endEditing(true)
        return false
    }
}

// MARK: Keyboard notification handling

extension AddNewPatientViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let keyboardRectTopY = self.view.frame.height - keyboardSize.height
            
            var selectedTextField: UITextField!
            
            if nameTextField.isEditing {
                
                selectedTextField = nameTextField
                
            } else if tajTextField.isEditing {
                
                selectedTextField = tajTextField
            }
            
            let textFieldBottomY = selectedTextField.frame.maxY + saveButton.frame.height + (navigationController?.navigationBar.frame.height)!
            
            if textFieldBottomY > keyboardRectTopY {
                
                self.view.frame.origin.y -= (textFieldBottomY - keyboardRectTopY)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            
            self.view.frame.origin.y = 0
        }
    }
}










