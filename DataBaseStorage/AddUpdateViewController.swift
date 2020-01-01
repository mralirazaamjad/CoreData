//
//  AddUpdateViewController.swift
//  DataBaseStorage
//
//  Created by Ali Raza Amjad on 01/01/2020.
//  Copyright © 2020 Ali Raza. All rights reserved.
//

import UIKit
import CoreData

class AddUpdateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var lblMissingName: UILabel!
    @IBOutlet weak var lblMissingAddress: UILabel!
    @IBOutlet weak var btnAddUpdate: UIButton!
    
    var _objProfile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if _objProfile != nil {
            tfName.text = _objProfile?.name
            tfAddress.text = _objProfile?.address
            btnAddUpdate.setTitle("UPDATE", for: .normal)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func validateFields() -> Bool{
        var isValid = true
        if !tfName.text!.validateRequiredField() {
            isValid = false
            lblMissingName.text = "* missing"
        }
        if !tfAddress.text!.validateRequiredField() {
            isValid = false
            lblMissingAddress.text = "* missing"
        }
        
        return isValid
    }
    
    @IBAction func actionAddUpdate(_ sender: UIButton) {
        if validateFields() {
            if _objProfile == nil {
                let obj = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: DatabaseHelper.managedObjectContext) as! Profile
                obj.name = tfName.text!.textTrim()
                obj.address = tfAddress.text!.textTrim()
            }else {
                let predicate = NSPredicate(format: "name == %@ AND address == %@", _objProfile!.name!, _objProfile!.address!)
                let arrayDbProfile = DatabaseHelper.fetchAllRecords("Profile", filter: predicate, sortDiscripter: [], fetchLimit: 0) as! [Profile]
                if !arrayDbProfile.isEmpty {
                    let obj = arrayDbProfile.first
                    obj?.name = tfName.text!
                    obj?.address = tfAddress.text!
                }
            }
            
            if DatabaseHelper.save() {
                self.showAlert("Data has been saved successfully.")
            }
        }
    }
    
    private func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfName {
            lblMissingName.text = ""
        }
        
        if textField == tfAddress {
            lblMissingAddress.text = ""
        }
        
        return true
    }
    
    
    
}

extension String {
    func textTrim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func validateRequiredField() -> Bool {
        var isValid = true
        let strText = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (strText == "") {
            
            isValid = false
        }
        return isValid
    }
}
