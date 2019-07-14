//
// Created by Grantley on 2019-05-31.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import OAuthSwift

typealias ServiceResponse = (NSDictionary?, Error?) -> Void

class ClientServerController
{
   private var serverAddress: String
   private var token: Token
   
   init()
   {
      let infoPlist = Bundle.main.infoDictionary
      let address   = infoPlist!["ServerAddress"] as! String
      serverAddress = address
      print("Got server address as \(address)")
      token = Token(serverAddress)
   }
   
   func uploadUserToServer(_ user: User, _ onCompletion: ServiceResponse) -> Void
   {
      self.sendUser(token.OAUTH, token.getToken(), user)
   }
   
   func requestLogin(_ user: User?)
   {
      let server = serverAddress + "api/user/login"
      let userID = ["id": user!.userID]
   }
   
   
   private func sendUser(_ oauthswift: OAuth2Swift, _ token: String, _ user: User) -> Void
   {
      let server:  String = serverAddress + "api/user"
      let newUser: [String: Any]
                          = ["name": user.name!, "email": user.email!, "phone": user.phone!, "public_key": user.userKey.convertPublicKeyForExport()!]
      let _ = oauthswift.client.post(
              server, parameters: newUser,
              headers: ["Accept": "application/json", "Authorization": "Bearer \(token)", "Content-Type": "application/json; charset=utf-8"],
              success: {response in
                 let jsonDict = try? response.jsonObject() as! [String: AnyObject]
                 print(jsonDict)
                 let userID = jsonDict?["id"] as! Int
                 user.userID = userID
                 print("UserID is \(userID)")
              },
              failure: {error in print("Error in creating user \(error)")}
      )
   }
}