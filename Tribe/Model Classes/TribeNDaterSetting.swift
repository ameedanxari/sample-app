//
//    TribeNDaterSetting.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNDaterSetting : NSObject, NSCoding{
    
    var ageRange : TribeNAgeRange!
    var distanceRange : Double!
    var interested : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let ageRangeData = dictionary["age_range"] as? [String:Any]{
            ageRange = TribeNAgeRange(fromDictionary: ageRangeData)
        } else {
            ageRange = TribeNAgeRange(fromDictionary: [:])
        }
        distanceRange = dictionary["distance_range"] as? Double
        interested = dictionary["interested"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if ageRange != nil{
            dictionary["age_range"] = ageRange.toDictionary()
        }
        if distanceRange != nil{
            dictionary["distance_range"] = distanceRange
        }
        if interested != nil{
            dictionary["interested"] = interested
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        ageRange = aDecoder.decodeObject(forKey: "age_range") as? TribeNAgeRange
        distanceRange = aDecoder.decodeObject(forKey: "distance_range") as? Double
        interested = aDecoder.decodeObject(forKey: "interested") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if ageRange != nil{
            aCoder.encode(ageRange, forKey: "age_range")
        }
        if distanceRange != nil{
            aCoder.encode(distanceRange, forKey: "distance_range")
        }
        if interested != nil{
            aCoder.encode(interested, forKey: "interested")
        }
        
    }
    
}
