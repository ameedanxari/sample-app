//
//    TribeNMatch.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNMatch : NSObject, NSCoding{
    
    var id : String!
    var disliked : [TribeNDisliked]!
    var liked : [TribeNLiked]!
    var iLiked:Bool!
    var matchedDate : String!
    var matcher : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        disliked = [TribeNDisliked]()
        if let dislikedArray = dictionary["disliked"] as? [[String:Any]]{
            for dic in dislikedArray{
                let value = TribeNDisliked(fromDictionary: dic)
                
                //checking for my action
                if value.dislikedBy == Global.myProfile?.id {
                    iLiked = false
                }
                    
                disliked.append(value)
            }
        }
        liked = [TribeNLiked]()
        if let likedArray = dictionary["liked"] as? [[String:Any]]{
            for dic in likedArray{
                let value = TribeNLiked(fromDictionary: dic)
                
                //checking for my action
                if value.likedBy == Global.myProfile?.id {
                    iLiked = true
                }
                
                
                liked.append(value)
            }
        }
        matchedDate = dictionary["matched_date"] as? String
        matcher = dictionary["matcher"] as? String
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
        if disliked != nil{
            var dictionaryElements = [[String:Any]]()
            for dislikedElement in disliked {
                dictionaryElements.append(dislikedElement.toDictionary())
            }
            dictionary["disliked"] = dictionaryElements
        }
        if liked != nil{
            var dictionaryElements = [[String:Any]]()
            for likedElement in liked {
                dictionaryElements.append(likedElement.toDictionary())
            }
            dictionary["liked"] = dictionaryElements
        }
        if matchedDate != nil{
            dictionary["matched_date"] = matchedDate
        }
        if matcher != nil{
            dictionary["matcher"] = matcher
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
        disliked = aDecoder.decodeObject(forKey :"disliked") as? [TribeNDisliked]
        liked = aDecoder.decodeObject(forKey :"liked") as? [TribeNLiked]
        matchedDate = aDecoder.decodeObject(forKey: "matched_date") as? String
        matcher = aDecoder.decodeObject(forKey: "matcher") as? String
        
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
        if disliked != nil{
            aCoder.encode(disliked, forKey: "disliked")
        }
        if liked != nil{
            aCoder.encode(liked, forKey: "liked")
        }
        if matchedDate != nil{
            aCoder.encode(matchedDate, forKey: "matched_date")
        }
        if matcher != nil{
            aCoder.encode(matcher, forKey: "matcher")
        }
        
    }
    
}
