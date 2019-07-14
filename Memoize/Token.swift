//
// Created by Grantley on 2019-07-13.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import OAuthSwift

class Token
{
   private var tokenString: String = ""
   private let account = "MemoizeToken"
   let OAUTH:       OAuth2Swift
   
   init(_ serverAddress: String)
   {
      let tokenUrl = serverAddress + "oauth/token"
      OAUTH = OAuth2Swift(
              consumerKey: "5",
              consumerSecret: "szQXFeiJUeh6De4ThttEnNsWGFjCV5c3Ed0P9Scx",
              authorizeUrl: "",
              accessTokenUrl: tokenUrl,
              responseType: "token"
      )
      print("Got token address as \(tokenUrl)")
      tokenString = getToken()
      guard !tokenString.isEmpty else
      {
         print("No token found, fetching a new one")
         fetchToken(serverAddress)
         return
      }
   }
   
   /**
   Facade using the Passcode wrapper to load the token from the keychain, if it is available
   Returns an empty string if a token with the account tag is not found,
   */
   public func getToken() -> String
   {
      guard !tokenString.isEmpty else
      {
         return Passcode.loadPasscode(account)
      }
      return tokenString
   }
   
   private func fetchToken(_ serverAddress: String)
   {
      print("Attempting to get app token")
   
      OAUTH.authorize(deviceToken: "Memoize", grantType: "client_credentials",
                                        success: {credential, response, parameters in
                                           print("Got credentials ")
                                           self.tokenString = credential.oauthToken
                                           self.saveToken()
                                        },
                                        failure: {error in print("error in getting token \(error)")})
   }
   
   /**
   Facade using the Passcode wrapper to save the token into the keychain
   */
   private func saveToken()
   {
      print("Saving token")
      Passcode.savePasscode(tokenString, account)
   }
}
