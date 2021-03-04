//
//  AppDelegate.swift
//  Memoize
//
//  Created by Grant on 2/28/18.
//  Copyright © 2018 grantcallant. All rights reserved.
//

import UIKit
//import PushNotifications
import Branch


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
   //Constants
   
   public static let CLEAR_USER = false
   public static let TEST       = true
//   let pushNotifications = PushNotifications.shared
   
   var window: UIWindow?
   
   
   func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
   {
      // if you are using the TEST key
//  Branch.setUseTestBranchKey(true)
  // listener for Branch Deep Link data
//  Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
    // do stuff with deep link data (nav to page, display content, etc)
//    print(params as? [String: AnyObject] ?? {})
  //}
      self.window = UIWindow(frame: UIScreen.main.bounds)
      Routes.viewControllerRoutes(window: self.window!)
      return true
   }
   
   func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
   {
//      guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//            let url = userActivity.webpageURL,
//            let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
//      else
//      {
//         print("Incorrect URL Base type")
//         return false
//      }
//
//      for path in components.path
//      {
//         print(path)
//      }
      
    // handler for Universal Links
//  Branch.getInstance().continue(userActivity)
      return true
   }
   
   func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
   {
    //Pusher
//    self.pushNotifications.registerDeviceToken(deviceToken)
   }
   
   func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
   {
    // handler for Push Notifications
//  Branch.getInstance().handlePushNotification(userInfo)
    //Pusher
//      self.pushNotifications.handleNotification(userInfo: userInfo)
   }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//  Branch.getInstance().application(app, open: url, options: options)
  return true
}
   
   func showHome()
   {
      self.window = UIWindow(frame: UIScreen.main.bounds)
      Routes.showHomeView(window: window!)
   }
   
   
   func applicationWillResignActive(_ application: UIApplication)
   {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
      UserDefaults.standard.set(false, forKey: "authenticated")
   }
   
   
   func applicationDidEnterBackground(_ application: UIApplication)
   {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      UserDefaults.standard.set(false, forKey: "authenticated")
   }
   
   
   func applicationWillEnterForeground(_ application: UIApplication)
   {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
      self.window = UIWindow(frame: UIScreen.main.bounds)
      Routes.viewControllerRoutes(window: self.window!)
   }
   
   
   func applicationDidBecomeActive(_ application: UIApplication)
   {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }
   
   
   func applicationWillTerminate(_ application: UIApplication)
   {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   }
   
}
