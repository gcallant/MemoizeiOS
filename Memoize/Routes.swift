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
      if(UserDefaults.standard.string(forKey: "firstRun") == nil)
      {
         Routes.showWelcomeView(window: window)
      }
      else if(User.loadUser() != nil)
      {
         showLoginView(window: window)
      }
   }
   
   static func showWelcomeView(window: UIWindow)
   {
      UserDefaults.standard.set(false, forKey: "firstRun")
      UserDefaults.standard.synchronize()
      let mainStoryboard:        UIStoryboard          = UIStoryboard(name: "Main", bundle: nil)
      let welcomeViewController: WelcomeViewController = mainStoryboard.instantiateViewController(
              withIdentifier: "WelcomeView") as! WelcomeViewController
      
      window.rootViewController = welcomeViewController
      window.makeKeyAndVisible()
   }
   
   static func showHomeView(window: UIWindow)
   {
      let user = User.loadUser()
      
      if(user != nil)
      {
         let mainStoryboard:     UIStoryboard       = UIStoryboard(name: "Main", bundle: nil)
         let homeViewController: HomeViewController = mainStoryboard.instantiateViewController(
                 withIdentifier: "HomeView") as! HomeViewController
         window.rootViewController = homeViewController
      }
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
