
//
//  Created by LM Mac on 3/7/18.
//  Copyright © 2018 Hassan. All rights reserved.

import Foundation


class TribeUser : NSObject, NSCoding{
    
    var name : String!
    var email : String!
    var phoneNumber : String!
    var age : String!
    var picUrl : String!
    var gender : String!
    var dater : String!
    var request = [String]()
    var mactches = [String]()
    var sendRequest = [String]()
    var otherFriendMatches = [String]()
    var likes = [String]()
    var disLikes = [String]()
    var isUpdating = false
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        name = dictionary["name"] as? String
        if let emailData = dictionary["email"] as? String{
            email = emailData
        }
        else
        {
            email = ""
        }
        
        if let phoneNumberData = dictionary["phoneNumber"] as? String{
            phoneNumber = phoneNumberData
        }
        else
        {
            phoneNumber = ""
        }
        
        if let ageData = dictionary["age"] as? String{
            age = ageData
        }
        else
        {
            age = ""
        }
        
        if let picUrlData = dictionary["picUrl"] as? String{
            picUrl = picUrlData
        }
        else
        {
            picUrl = ""
        }
        
        if let genderData = dictionary["gender"] as? String{
            gender = genderData
        }
        else
        {
            gender = ""
        }
        dater = dictionary["dater"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
 
        if name != nil{
            dictionary["name"] = name
        }
        if email != nil{
            dictionary["email"] = email
        }
        if phoneNumber != nil{
            dictionary["phoneNumber"] = phoneNumber
        }
        
        if age != nil{
            dictionary["age"] = age
        }
        if picUrl != nil{
            dictionary["picUrl"] = picUrl
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if dater != nil{
            dictionary["dater"] = dater
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as? String
        email = aDecoder.decodeObject(forKey :"email") as? String
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        picUrl = aDecoder.decodeObject(forKey: "picUrl") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        age = aDecoder.decodeObject(forKey: "age") as? String
        dater = aDecoder.decodeObject(forKey: "dater") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if phoneNumber != nil{
            aCoder.encode(phoneNumber, forKey: "phoneNumber")
        }
        if picUrl != nil{
            aCoder.encode(picUrl, forKey: "picUrl")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if age != nil{
            aCoder.encode(age, forKey: "age")
        }
        if dater != nil{
            aCoder.encode(dater, forKey: "dater")
        }
        
    }
    
}

