//
//  SettingsViewController.swift
//  Memoize
//
//  Created by Grantley on 6/5/19.
//  Copyright © 2019 grantcallant. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getText()
       
    }
    
    func getText()
    {
        let todoEndpoint: String = "http://192.168.1.103:8000/api/test"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to make string")
                        return
                }
                
                print("The todo is: " + todo.description)
                
                
            } catch {
                print("error trying to convert data to JSON \(error)")
                return
            }
        }
        task.resume()
    }
}
