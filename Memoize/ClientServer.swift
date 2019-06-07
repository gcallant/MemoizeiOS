//
// Created by Grantley on 2019-05-31.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation

class ClientServerController
{
   func callServer()
   {
   
   }
   
   private static func getServerAddress() -> String
   {
      let infoPlist = Bundle.main.infoDictionary
      let address   = infoPlist!["ServerAddress"] as! String
      return address
   }
}