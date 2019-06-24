//
//  SettingsViewController.swift
//  Memoize
//
//  Created by Grantley on 6/5/19.
//  Copyright © 2019 grantcallant. All rights reserved.
//

import UIKit
import OAuthSwift

class SettingsViewController: UIViewController
{
   
   
   
   @IBOutlet weak var settingsText: UITextField!
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      authorize()
      
   }
   
   
   
   func getText()
   {
      let server: String = "http://192.168.1.103:8000/api/user"
      guard let serverURL = URL(string: server)
      else
      {
         print("Error: cannot create URL")
         return
      }
      var serverUrlRequest = URLRequest(url: serverURL)
      serverUrlRequest.httpMethod = "POST"
      serverUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      let newUser:  [String: Any]
              = ["name": "Jim", "email": "jim@jim.com", "phone": "2345678901", "public_key": "sdflkj234asdfuasldkfjsdf"]
      let jsonUser: Data
      do
      {
         jsonUser = try JSONSerialization.data(withJSONObject: newUser, options: [])
         print(jsonUser)
         serverUrlRequest.httpBody = jsonUser
      }
      catch
      {
         print("Error: cannot create JSON from user")
         return
      }
      
      let session = URLSession.shared
      
      let task = session.dataTask(with: serverUrlRequest)
      {
         (data, response, error) in
         guard error == nil
         else
         {
            print("error calling POST on /user")
            print(error!)
            return
         }
         guard let responseData = data
         else
         {
            print("Error: did not receive data")
            return
         }
         
         // parse the result as JSON, since that's what the API provides
         do
         {
            guard let receivedUser = try JSONSerialization.jsonObject(with: responseData,
                                                                      options: .allowFragments) as? [String: Any]
            else
            {
               print("Could not get JSON from responseData as dictionary")
               return
            }
            print("The user is: " + receivedUser.description)
            
         }
         catch
         {
            print("error parsing response from POST on \(error)")
            return
         }
      }
      task.resume()
   }
}
