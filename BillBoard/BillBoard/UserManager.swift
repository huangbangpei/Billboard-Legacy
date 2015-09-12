//
//  UserManager.swift
//  BillBoard
//
//  Created by Kedan Li on 15/9/11.
//  Copyright (c) 2015年 Takefive Interactive. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var UserInfo: UserManager = UserManager()

class UserManager: NSObject {
    
    let userDefault = NSUserDefaults.standardUserDefaults()

    var userName = ""
    
    lazy var isLogin: (() -> (Bool)) = {
        if self.userDefault.objectForKey("userID") != nil && count(self.userDefault.objectForKey("userID") as! String) > 0 {
            return true
        }else{
            return false
        }
    }
    
    func jsonResponse (response: NSHTTPURLResponse?, JSON: AnyObject?, error: NSError?, completion:(error: String, result: [String: AnyObject]?) -> ()){
        if error == nil{
            //succ
            if JSON != nil{
                let result = SwiftyJSON.JSON(JSON!)
                completion(error: SwiftyJSON.JSON(JSON!)["error"].string!, result: SwiftyJSON.JSON(JSON!).dictionaryObject)
            }
            
        }else{
            //error
            if JSON != nil && SwiftyJSON.JSON(JSON!)["error"] != nil{
                completion(error: SwiftyJSON.JSON(JSON!)["error"].string!, result: nil)
            }else{
                completion(error: error!.description, result: nil)
            }
        }
    }
    
    func facebookLogin(token: String, completion:(error: String, result: [String: AnyObject]?) -> ()){
        Alamofire.request(.POST, NSURL(string: ServerAddress + ServerVersion + "auth/login")!, parameters: ["fbToken": token]).responseJSON { (_, response, JSON, error) in
            self.jsonResponse(response, JSON: JSON, error: error, completion: completion)
        }
    }
    
    func login(userID: String){
        userDefault.setObject(userID, forKey: "userID")
        userDefault.synchronize()
    }
    
    func logout(){
        userDefault.setObject("", forKey: "userID")
        userDefault.synchronize()
    }
    

}
