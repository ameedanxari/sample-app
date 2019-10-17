//
//    TribeNUnmatched.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNUnmatched : NSObject, NSCoding{
    
    var phone : String!
    var picture : Data!
    var name : String!
    var isInvited : Bool = false
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        phone = dictionary["phone"] as? String
        picture = dictionary["picture"] as? Data
        name = dictionary["name"] as? String
        if let val = dictionary["type"] as? String {
            name = name + " - " + val
        }
        if let val = dictionary["isInvited"] as? Bool {
            isInvited = val
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if phone != nil{
            dictionary["phone"] = phone
        }
        if name != nil{
            dictionary["name"] = name
        }
        if picture != nil{
            dictionary["picture"] = picture
        }
        if isInvited != nil{
            dictionary["isInvited"] = isInvited
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        picture = aDecoder.decodeObject(forKey: "picture") as? Data
        if let val = aDecoder.decodeObject(forKey: "isInvited") as? Bool {
            isInvited = val
        }
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if phone != nil{
            aCoder.encode(phone, forKey: "phone")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if picture != nil{
            aCoder.encode(picture, forKey: "picture")
        }
        if isInvited != nil{
            aCoder.encode(isInvited, forKey: "isInvited")
        }
    }
}
