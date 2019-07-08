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
   
   init()
   {
      let infoPlist = Bundle.main.infoDictionary
      let address   = infoPlist!["ServerAddress"] as! String
      serverAddress = address
      print("Got server address as \(address)")
   }
   
   func authorize(_ user: User, _ onCompletion: ServiceResponse) -> Void
   {
      let tokenUrl = serverAddress + "oauth/token"
      print("Got token address as \(tokenUrl)")
      let oauthswift = OAuth2Swift(
              consumerKey: "5",
              consumerSecret: "szQXFeiJUeh6De4ThttEnNsWGFjCV5c3Ed0P9Scx",
              authorizeUrl: "",
              accessTokenUrl: tokenUrl,
              responseType: "token"
      )
      
      print("Attempting to get app token")
      
      let handle = oauthswift.authorize(deviceToken: "Memoize", grantType: "client_credentials",
                                        success: {credential, response, parameters in
                                           print("Got credentials ")
                                           self.sendUser(oauthswift, credential.oauthToken, user)
                                        },
                                        failure: {error in print("error in getting token \(error)")})
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
                 let jsonDict = try? response.jsonObject()
                 print(jsonDict as Any)
              },
              failure: {error in print("Error in creating user \(error)")}
      )
   }
}