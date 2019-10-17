//
//    TribeNLiked.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNLiked : NSObject, NSCoding{
    
    var id : String!
    var likedBy : String!
    var likedDate : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        likedBy = dictionary["liked_by"] as? String
        likedDate = dictionary["liked_date"] as? String
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
        if likedBy != nil{
            dictionary["liked_by"] = likedBy
        }
        if likedDate != nil{
            dictionary["liked_date"] = likedDate
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
        likedBy = aDecoder.decodeObject(forKey: "liked_by") as? String
        likedDate = aDecoder.decodeObject(forKey: "liked_date") as? String
        
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
        if likedBy != nil{
            aCoder.encode(likedBy, forKey: "liked_by")
        }
        if likedDate != nil{
            aCoder.encode(likedDate, forKey: "liked_date")
        }
        
    }
    
}
