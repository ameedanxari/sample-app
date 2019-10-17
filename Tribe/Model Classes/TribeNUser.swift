//
//    TribeNUser.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNUser : NSObject, NSCoding{
    
    var v : Int!
    var id : String!
    var aboutMe : String!
    var age : String!
    var authToken : String!
    var createdAt : String!
    var deviceToken : String!
    var deviceType : String!
    var email : String!
    var fbId : String!
    var fbToken : String!
    var firebaseToken : String!
    var firstName : String!
    var gender : String!
    var intersted : [String]!
    var lastName : String!
    var matches : [TribeNMatch]!
    var phone : String!
    var profession : String!
    var ethnicity : String!
    var location : String!
    var religion : String!
    var education : String!
    var picUrl : [String]!
    var settings : TribeNSetting!
    var geo : [Double]!
    var height : Int!
    var updatedAt : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        aboutMe = dictionary["about_me"] as? String
        age = dictionary["age"] as? String
        authToken = dictionary["auth_token"] as? String
        createdAt = dictionary["created_at"] as? String
        deviceToken = dictionary["device_token"] as? String
        deviceType = dictionary["device_type"] as? String
        email = dictionary["email"] as? String
        fbId = dictionary["fb_id"] as? String
        fbToken = dictionary["fb_token"] as? String
        firebaseToken = dictionary["firebase_token"] as? String
        firstName = dictionary["first_name"] as? String
        gender = dictionary["gender"] as? String
        intersted = dictionary["intersted"] as? [String]
        lastName = dictionary["last_name"] as? String
        //matches = dictionary["matches"] as? [TribeNMatch]
        matches = [TribeNMatch]()
        if let matchesArray = dictionary["matches"] as? [[String:Any]]{
            for dic in matchesArray{
                let value = TribeNMatch(fromDictionary: dic)
                matches.append(value)
            }
        }
        phone = dictionary["phone"] as? String
        profession = dictionary["profession"] as? String
        ethnicity = dictionary["ethnicity"] as? String
        location = dictionary["location"] as? String
        religion = dictionary["religion"] as? String
        education = dictionary["education"] as? String
        geo = dictionary["geo"] as? [Double]
        picUrl = dictionary["pic_url"] as? [String]
        height = dictionary["height"] as? Int
        if let settingsData = dictionary["settings"] as? [String:Any]{
            settings = TribeNSetting(fromDictionary: settingsData)
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
        if aboutMe != nil{
            dictionary["about_me"] = aboutMe
        }
        if age != nil{
            dictionary["age"] = age
        }
        if authToken != nil{
            dictionary["auth_token"] = authToken
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deviceToken != nil{
            dictionary["device_token"] = deviceToken
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if email != nil{
            dictionary["email"] = email
        }
        if fbId != nil{
            dictionary["fb_id"] = fbId
        }
        if fbToken != nil{
            dictionary["fb_token"] = fbToken
        }
        if firebaseToken != nil{
            dictionary["firebase_token"] = firebaseToken
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if intersted != nil{
            dictionary["intersted"] = intersted
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
//        if matches != nil{
//            dictionary["matches"] = matches
//        }
        if matches != nil{
            var dictionaryElements = [[String:Any]]()
            for matchElement in matches {
                dictionaryElements.append(matchElement.toDictionary())
            }
            dictionary["matches"] = dictionaryElements
        }
        if phone != nil{
            dictionary["phone"] = phone
        }
        if profession != nil{
            dictionary["profession"] = profession
        }
        if ethnicity != nil{
            dictionary["ethnicity"] = ethnicity
        }
        if location != nil{
            dictionary["location"] = location
        }
        if religion != nil{
            dictionary["religion"] = religion
        }
        if education != nil{
            dictionary["education"] = education
        }
        if picUrl != nil{
            dictionary["pic_url"] = picUrl
        }
        if height != nil{
            dictionary["height"] = height
        }
        if geo != nil{
            dictionary["geo"] = geo
        }
        if settings != nil{
            dictionary["settings"] = settings.toDictionary()
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
    func toDictionaryForUpdate() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if aboutMe != nil{
            dictionary["about_me"] = aboutMe
        }
        if age != nil{
            dictionary["age"] = age
        }
        if authToken != nil{
            dictionary["auth_token"] = authToken
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deviceToken != nil{
            dictionary["device_token"] = deviceToken
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if email != nil{
            dictionary["email"] = email
        }
        if fbId != nil{
            dictionary["fb_id"] = fbId
        }
        if fbToken != nil{
            dictionary["fb_token"] = fbToken
        }
        if firebaseToken != nil{
            dictionary["firebase_token"] = firebaseToken
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if intersted != nil{
            dictionary["intersted"] = intersted
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        //        if matches != nil{
        //            dictionary["matches"] = matches
        //        }
//        if matches != nil{
//            var dictionaryElements = [[String:Any]]()
//            for matchElement in matches {
//                dictionaryElements.append(matchElement.toDictionary())
//            }
//            dictionary["matches"] = dictionaryElements
//        }
        if phone != nil{
            dictionary["phone"] = phone
        }
        if profession != nil{
            dictionary["profession"] = profession
        }
        if ethnicity != nil{
            dictionary["ethnicity"] = ethnicity
        }
        if location != nil{
            dictionary["location"] = location
        }
        if religion != nil{
            dictionary["religion"] = religion
        }
        if education != nil{
            dictionary["education"] = education
        }
        if picUrl != nil{
            dictionary["pic_url"] = picUrl
        }
        if height != nil{
            dictionary["height"] = height
        }
        if geo != nil{
            dictionary["geo"] = geo
        }
        if settings != nil{
            dictionary["settings"] = settings.toDictionary()
        }
//        if updatedAt != nil{
//            dictionary["updated_at"] = updatedAt
//        }
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
        aboutMe = aDecoder.decodeObject(forKey: "about_me") as? String
        age = aDecoder.decodeObject(forKey: "age") as? String
        authToken = aDecoder.decodeObject(forKey: "auth_token") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
        deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        fbId = aDecoder.decodeObject(forKey: "fb_id") as? String
        fbToken = aDecoder.decodeObject(forKey: "fb_token") as? String
        firebaseToken = aDecoder.decodeObject(forKey: "firebase_token") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        intersted = aDecoder.decodeObject(forKey: "intersted") as? [String]
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        matches = aDecoder.decodeObject(forKey: "matches") as? [TribeNMatch]
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        profession = aDecoder.decodeObject(forKey: "profession") as? String
        ethnicity = aDecoder.decodeObject(forKey: "ethnicity") as? String
        location = aDecoder.decodeObject(forKey: "location") as? String
        religion = aDecoder.decodeObject(forKey: "religion") as? String
        education = aDecoder.decodeObject(forKey: "education") as? String
        picUrl = aDecoder.decodeObject(forKey: "pic_url") as? [String]
        height = aDecoder.decodeObject(forKey: "height") as? Int
        geo = aDecoder.decodeObject(forKey: "geo") as? [Double]
        settings = aDecoder.decodeObject(forKey: "settings") as? TribeNSetting
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        
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
        if aboutMe != nil{
            aCoder.encode(aboutMe, forKey: "about_me")
        }
        if age != nil{
            aCoder.encode(age, forKey: "age")
        }
        if authToken != nil{
            aCoder.encode(authToken, forKey: "auth_token")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if deviceToken != nil{
            aCoder.encode(deviceToken, forKey: "device_token")
        }
        if deviceType != nil{
            aCoder.encode(deviceType, forKey: "device_type")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if fbId != nil{
            aCoder.encode(fbId, forKey: "fb_id")
        }
        if fbToken != nil{
            aCoder.encode(fbToken, forKey: "fb_token")
        }
        if firebaseToken != nil{
            aCoder.encode(firebaseToken, forKey: "firebase_token")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if intersted != nil{
            aCoder.encode(intersted, forKey: "intersted")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if matches != nil{
            aCoder.encode(matches, forKey: "matches")
        }
        if phone != nil{
            aCoder.encode(phone, forKey: "phone")
        }
        if profession != nil{
            aCoder.encode(profession, forKey: "profession")
        }
        if ethnicity != nil{
            aCoder.encode(ethnicity, forKey: "ethnicity")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if religion != nil{
            aCoder.encode(religion, forKey: "religion")
        }
        if education != nil{
            aCoder.encode(education, forKey: "education")
        }
        if picUrl != nil{
            aCoder.encode(picUrl, forKey: "pic_url")
        }
        if settings != nil{
            aCoder.encode(settings, forKey: "settings")
        }
        if height != nil{
            aCoder.encode(height, forKey: "height")
        }
        if geo != nil{
            aCoder.encode(geo, forKey: "geo")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        
    }
}
