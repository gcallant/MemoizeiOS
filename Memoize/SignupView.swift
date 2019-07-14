//
// Created by Grant on 7/31/18.
// Copyright (c) 2018 grantcallant. All rights reserved.
//

import Foundation
import Eureka

class SignupView: FormViewController
{
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      showRegistrationForm()
   }
   
   private func showRegistrationForm()
   {
      var dictionary: [String: Any?] = [:]
      form +++ Section("Register")
               <<< TextRow()
               {
                  row in
                  row.tag = "Name"
                  row.title = "Name"
                  row.add(rule: RuleRequired())
                  row.add(rule: RuleRegExp(regExpr: "[a-zA-Z ]+"))
                  row.add(rule: RuleMaxLength(maxLength: 255))
                  row.placeholder = "What should we call you?"
                  row.validationOptions = .validatesOnBlur
               }
                       .cellUpdate
                       {
                          cell, row in
                          if !row.isValid
                          {
                             cell.titleLabel?.textColor = .red
                          }
                       }
               <<< PhoneRow()
               {
                  row in
                  row.tag = "Phone"
                  row.title = "Phone"
                  row.add(rule: RuleRequired())
                  row.add(rule: RuleMinLength(minLength: 10))
                  row.add(rule: RuleMaxLength(maxLength: 10))
                  row.validationOptions = .validatesOnBlur
                  row.placeholder = "Enter your phone #"
               }
                       .cellUpdate
                       {
                          cell, row in
                          if !row.isValid
                          {
                             cell.titleLabel?.textColor = .red
                          }
                       }
               <<< EmailRow()
               {
                  row in
                  row.tag = "Email"
                  row.title = "Email"
                  row.add(rule: RuleRequired())
                  row.add(rule: RuleEmail())
                  row.validationOptions = .validatesOnBlur
                  row.placeholder = "Enter your email"
               }
                       .cellUpdate
                       {
                          cell, row in
                          if !row.isValid
                          {
                             cell.titleLabel?.textColor = .red
                          }
                       }
      +++ Section("Passcode to secure app")
          <<< PhoneRow()
          {
             row in
             row.tag = "Passcode"
             row.title = "Passcode"
             row.add(rule: RuleRequired())
             row.add(rule: RuleMinLength(minLength: 6))
             row.validationOptions = .validatesOnBlur
             row.placeholder = "Enter 6 or more characters"
          }
                  .cellUpdate
                  {
                     cell, row in
                     if !row.isValid
                     {
                        cell.titleLabel?.textColor = .red
                     }
                  }
          <<< SwitchRow()
          {
             row in
             row.title = "FaceID/TouchID Disabled"
             row.tag = "Biometrics"
          }
                  .onChange
                  {
                     row in
                     row.title = (row.value ?? false) ? "FaceID/TouchID Enabled" : "FaceID/TouchID Disabled"
                     row.updateCell()
                  }
          <<< ButtonRow()
          {(row: ButtonRow) -> Void in
             row.title = "SUBMIT"
          }
                  .onCellSelection
                  {[weak self] (cell, row) in
                     if row.section?.form?.validate().count == 0
                     {
                        dictionary = self!.form.values()
                        self!.performFirstTimeSetup(dictionary)
                        self!.segue(sender: ButtonRow.self)
                     }
                  }
   }
   
   private func performFirstTimeSetup(_ dictionary: [String: Any?])
   {
      let user = User.userFactory(dictionary)!
      let server = ClientServerController()
      
         server.uploadUserToServer(user)
         {
            (success, error) in
            if error != nil
            {
               showFailedAuthorizeAlert()
            }
            else
            {
               user.saveUser()
            }
         }
   }
   
   private func showFailedAuthorizeAlert()
   {
      let alert = UIAlertController(title: "There was a problem!", message: "Error communicating with server, please try again.",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Retry", style: .default))
      self.present(alert, animated: true)
   }
   
   @IBAction func segue(sender: AnyObject)
   {
      performSegue(withIdentifier: "SignupToHomeSegue", sender: sender)
   }
}
