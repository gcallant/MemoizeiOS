//
//  LoggedInView.swift
//  Memoize
//
//  Created by Grantley on 3/14/21.
//  Copyright © 2021 grantcallant. All rights reserved.
//

import SwiftUI

class LoggedInView: UIViewController
{
   
   
   @IBOutlet weak var UserLabel:    UILabel!
   @IBOutlet weak var LogoutButton: UIButton!
   
   override func viewDidAppear(_ animated: Bool)
   {
      LogoutButton.backgroundColor = .systemRed
      LogoutButton.layer.cornerRadius = 5
      LogoutButton.layer.borderWidth = 1
      LogoutButton.layer.borderColor = UIColor.white.cgColor
      
      getUserDetails()
   }
   
   private func getUserDetails()
   {
      let user = User.loadUser()!
      let name = user.name!
      //UserLabel.numberOfLines = 0
      UserLabel.text = "Hi \(name)!\n\nYou are successfully logged in"
      //UserLabel.sizeToFit()
      //UserLabel.layoutIfNeeded()
   }
   
   @IBAction func handleLogoutButton(_ sender: UIButton)
   {
      logout({[self]
      (success, error) in
         if (success != nil)
         {
            showAlert(title: "Success!",
                      message: """
                               You've been successfully logged out, you will be redirected to the login screen
                               Please ensure you close your browser window or tab to complete the logout process.
                               """,
                      view: goToHomeView(sender: self))
         }
         else
         {
            showAlert(title: "Error!", message: """
                                                Could not log you out. If you already logged out in your browser, you've been successfully logged out, and will need to login again on this next app load.
                                                If you believe this is an error, please try again
                                                """, view: ())
         }
      })
   }
   
   private func logout(_ onCompletion: @escaping ServiceResponse)
   {
      let server = ClientServerController()
      server.logout({(success, error) in
         if (success != nil)
         {
            onCompletion(success, nil)
         }
         else
         {
            onCompletion(nil, error)
         }
      })
   }
   
   private func showAlert(title: String, message: String, view: ())
   {
      let alertWindow = UIWindow(frame: UIScreen.main.bounds)
      alertWindow.rootViewController = UIViewController()
   
      let alertController = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
      alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: {_ in
         alertWindow.isHidden = true
         view
      }))
   
      alertWindow.windowLevel = UIWindowLevelAlert + 1;
      alertWindow.makeKeyAndVisible()
      alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
   }
   
   @IBAction private func goToHomeView(sender: AnyObject?)
   {
      let app = UIApplication.shared.delegate as! AppDelegate
      app.showHome()
   }
}
