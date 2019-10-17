//
//    TribeNMemberOfTribe.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNMemberOfTribe : NSObject, NSCoding{
    
    var v : Int!
    var id : String!
    var active : Bool!
    var added : TribeNAdded!
    var addedBy : TribeNAddedBy!
    var createdAt : String!
    var status : String!
    var isUpdating : Bool = false
    var updatedAt : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        active = dictionary["active"] as? Bool
        if let addedData = dictionary["added"] as? [String:Any]{
            added = TribeNAdded(fromDictionary: addedData)
        }
        if let addedByData = dictionary["added_by"] as? [String:Any]{
            addedBy = TribeNAddedBy(fromDictionary: addedByData)
        }
        createdAt = dictionary["created_at"] as? String
        status = dictionary["status"] as? String
        if let val = dictionary["isUpdating"] as? Bool {
            isUpdating = val
        }
        updatedAt = dictionary["updated_at"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if active != nil{
            dictionary["active"] = active
        }
        if added != nil{
            dictionary["added"] = added.toDictionary()
        }
        if addedBy != nil{
            dictionary["added_by"] = addedBy.toDictionary()
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if status != nil{
            dictionary["status"] = status
        }
        if isUpdating != nil{
            dictionary["isUpdating"] = isUpdating
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        v = aDecoder.decodeObject(forKey: "__v") as? Int
        id = aDecoder.decodeObject(forKey: "_id") as? String
        active = aDecoder.decodeObject(forKey: "active") as? Bool
        added = aDecoder.decodeObject(forKey: "added") as? TribeNAdded
        addedBy = aDecoder.decodeObject(forKey: "added_by") as? TribeNAddedBy
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        if let val = aDecoder.decodeObject(forKey: "isUpdating") as? Bool {
            isUpdating = val
        }
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if v != nil{
            aCoder.encode(v, forKey: "__v")
        }
        if id != nil{
            aCoder.encode(id, forKey: "_id")
        }
        if active != nil{
            aCoder.encode(active, forKey: "active")
        }
        if added != nil{
            aCoder.encode(added, forKey: "added")
        }
        if addedBy != nil{
            aCoder.encode(addedBy, forKey: "added_by")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if isUpdating != nil{
            aCoder.encode(isUpdating, forKey: "isUpdating")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        
    }
}
