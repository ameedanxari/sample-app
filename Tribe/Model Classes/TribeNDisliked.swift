//
//    TribeNDisliked.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNDisliked : NSObject, NSCoding{
    
    var id : String!
    var dislikedBy : String!
    var dislikedDate : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        dislikedBy = dictionary["disliked_by"] as? String
        dislikedDate = dictionary["disliked_date"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
        if dislikedBy != nil{
            dictionary["disliked_by"] = dislikedBy
        }
        if dislikedDate != nil{
            dictionary["disliked_date"] = dislikedDate
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "_id") as? String
        dislikedBy = aDecoder.decodeObject(forKey: "disliked_by") as? String
        dislikedDate = aDecoder.decodeObject(forKey: "disliked_date") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "_id")
        }
        if dislikedBy != nil{
            aCoder.encode(dislikedBy, forKey: "disliked_by")
        }
        if dislikedDate != nil{
            aCoder.encode(dislikedDate, forKey: "disliked_date")
        }
        
    }
    
}
