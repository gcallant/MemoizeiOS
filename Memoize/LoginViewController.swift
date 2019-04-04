//
//  LoginViewController.swift
//  Memoize
//
//  Created by Grant on 3/12/19.
//  Copyright © 2019 grantcallant. All rights reserved.
//  Credit: Biometric login tutorial by Jgonfer
//  @see: https://jgonfer.com/blog/touch-id-authentication-tutorial-for-swift-3/
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate
{
   @IBOutlet weak var passwordText: UITextField!
   @IBOutlet weak var loginButton:  UIButton!
   
   private let context         = LAContext()
   private let loginController = LoginController()
   
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      // registerLoginNotification()
      passwordText.delegate = self
      updateLoginButtonState()
   }


   
   override func viewWillAppear(_ animated: Bool)
   {
      super.viewWillAppear(animated)
      loginBiometric()
   }
   
   
   private func loginBiometric()
   {
      var policy: LAPolicy
   
      let useBiometrics = {() -> Bool in return UserDefaults.standard.object(forKey: "Biometrics") as! Bool == true}
   
      if #available(iOS 9.0, *), useBiometrics()
      {
         policy = .deviceOwnerAuthenticationWithBiometrics
      }
      else
      {
         //Biometrics not available or user opted-out
         return
      }
      
      var error: NSError?
      
      guard context.canEvaluatePolicy(policy, error: &error)
      else
      {
         print(error?.localizedDescription)
         return
      }
   
      //On Success, loads homeView, on failure, returns
      processBiometricLogin(policy: policy)
   }
   
   private func processBiometricLogin(policy: LAPolicy)
   {
      context.evaluatePolicy(policy, localizedReason: "Login is Required", reply:
      {
         (success, error) in
         DispatchQueue.main.async
         {
            guard success
            else
            {
               guard let error = error
               else
               {
                  self.showUnexpectedError()
                  return
               }
               switch(error)
               {
                  case LAError.authenticationFailed:
                     print("Could not authenticate")
                  default:
                     print("TouchID or FaceID might be broken.")
                     break
               }
               return
            }
            self.goToHomeView(sender: self)
         }
      })
   }
   
   private func performStandardLogin()
   {
      loginController.login(passwordText.text)
   }
   
   //MARK: Action
   
   @IBAction private func goToHomeView(sender: AnyObject?)
   {
      performSegue(withIdentifier: "LoginToHomeSegue", sender: sender)
   }
   
   private func showUnexpectedError()
   {
      print("An error was not able to be processed")
   }
   
   @IBAction func onTap(_ sender: UITapGestureRecognizer)
   {
      passwordText.resignFirstResponder()
   }
   
   
   @IBAction func buttonLogin(_ sender: UIButton)
   {
      self.performStandardLogin()
   }
   
   //MARK: UITextFieldDelegate
   
   func textFieldDidBeginEditing(_ textField: UITextField)
   {
      //Disable the Save button while editing.
      updateLoginButtonState()
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool
   {
      //Hides the Keyboard
      passwordText.resignFirstResponder()
      self.performStandardLogin()
      return true
   }
   
   func textFieldDidEndEditing(_ textField: UITextField)
   {
      passwordText.resignFirstResponder()
      updateLoginButtonState()
   }
   
   //MARK: Private Methods
   private func updateLoginButtonState()
   {
      let text = passwordText.text ?? ""
      loginButton.isEnabled = text.count >= 6
      
      if loginButton.isEnabled
      {
         loginButton.backgroundColor = .green
         
      }
      else
      {
         loginButton.backgroundColor = .gray
         
      }
   }
}
