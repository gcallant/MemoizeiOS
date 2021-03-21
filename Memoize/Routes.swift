//
//  Routes.swift
//  Memoize
//
//  Created by Grant on 10/15/18.
//  Copyright © 2018 grantcallant. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Routes
{
   static func viewControllerRoutes(window: UIWindow)
   {
      if(AppDelegate.CLEAR_USER)
      {
         UserDefaults.standard.removeObject(forKey: "firstRun")
         User.clearUser()
      }
      if(User.loadUser() != nil)
      {
         showLoginView(window: window)
      }
      else
      {
         Routes.showWelcomeView(window: window)
      }
   }
   
   static func showWelcomeView(window: UIWindow)
   {
      let mainStoryboard:        UIStoryboard          = UIStoryboard(name: "Main", bundle: nil)
      let welcomeViewController: WelcomeViewController = mainStoryboard.instantiateViewController(
              withIdentifier: "WelcomeView") as! WelcomeViewController
      
      window.rootViewController = welcomeViewController
      window.makeKeyAndVisible()
   }
   
   static func showHomeView(window: UIWindow)
   {
      let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let homeViewController           = mainStoryboard.instantiateViewController(
              withIdentifier: "HomeBarController") as! UITabBarController
      window.rootViewController = homeViewController
      window.makeKeyAndVisible()
   }
   
   static func showLoggedInView(window: UIWindow)
   {
      let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let loggedInView           = mainStoryboard.instantiateViewController(
              withIdentifier: "LoggedInView")
      window.rootViewController = loggedInView
      window.makeKeyAndVisible()
   }
   
   class func showLoginView(window: UIWindow)
   {
      let mainStoryboard:      UIStoryboard     = UIStoryboard(name: "Main", bundle: nil)
      let loginViewController: UIViewController = mainStoryboard.instantiateViewController(
              withIdentifier: "LoginView")
      
      window.rootViewController = loginViewController
      window.makeKeyAndVisible()
   }
}
