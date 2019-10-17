//
//	TribeNTribeMemberDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNTribeMemberDetail : NSObject, NSCoding{

	var v : Int!
	var id : String!
	var aboutMe : String!
	var age : String!
	var createdAt : String!
	var deviceToken : String!
	var deviceType : String!
	var education : String!
	var email : String!
	var ethnicity : String!
	var fbId : String!
	var fbToken : String!
	var firstName : String!
	var gender : String!
	var geo : [Float]!
	var height : Int!
	var intersted : [AnyObject]!
	var lastName : String!
	var location : String!
	var matches : [TribeNMatch]!
	var phone : String!
	var picUrl : [String]!
	var religion : String!
	var settings : TribeNSetting!
	var updatedAt : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		aboutMe = dictionary["about_me"] as? String
		age = dictionary["age"] as? String
		createdAt = dictionary["created_at"] as? String
		deviceToken = dictionary["device_token"] as? String
		deviceType = dictionary["device_type"] as? String
		education = dictionary["education"] as? String
		email = dictionary["email"] as? String
		ethnicity = dictionary["ethnicity"] as? String
		fbId = dictionary["fb_id"] as? String
		fbToken = dictionary["fb_token"] as? String
		firstName = dictionary["first_name"] as? String
		gender = dictionary["gender"] as? String
		geo = dictionary["geo"] as? [Float]
		height = dictionary["height"] as? Int
		intersted = dictionary["intersted"] as? [AnyObject]
		lastName = dictionary["last_name"] as? String
		location = dictionary["location"] as? String
		matches = [TribeNMatch]()
		if let matchesArray = dictionary["matches"] as? [[String:Any]]{
			for dic in matchesArray{
				let value = TribeNMatch(fromDictionary: dic)
                //#BYPASSED: checking if the match is still valid
                if Int(Date().timeIntervalSince(Date.getDateFromString(string: value.matchedDate))) < Constants.MATCH_QUEUE_TIMER {
                    //checking for blocked users
                    if !Global.blockList.contains(value.id) {
                        matches.append(value)
                    }
                }
			}
		}
		phone = dictionary["phone"] as? String
		picUrl = dictionary["pic_url"] as? [String]
		religion = dictionary["religion"] as? String
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
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if deviceToken != nil{
			dictionary["device_token"] = deviceToken
		}
		if deviceType != nil{
			dictionary["device_type"] = deviceType
		}
		if education != nil{
			dictionary["education"] = education
		}
		if email != nil{
			dictionary["email"] = email
		}
		if ethnicity != nil{
			dictionary["ethnicity"] = ethnicity
		}
		if fbId != nil{
			dictionary["fb_id"] = fbId
		}
		if fbToken != nil{
			dictionary["fb_token"] = fbToken
		}
		if firstName != nil{
			dictionary["first_name"] = firstName
		}
		if gender != nil{
			dictionary["gender"] = gender
		}
		if geo != nil{
			dictionary["geo"] = geo
		}
		if height != nil{
			dictionary["height"] = height
		}
		if intersted != nil{
			dictionary["intersted"] = intersted
		}
		if lastName != nil{
			dictionary["last_name"] = lastName
		}
		if location != nil{
			dictionary["location"] = location
		}
		if matches != nil{
			var dictionaryElements = [[String:Any]]()
			for matchesElement in matches {
				dictionaryElements.append(matchesElement.toDictionary())
			}
			dictionary["matches"] = dictionaryElements
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if picUrl != nil{
			dictionary["pic_url"] = picUrl
		}
		if religion != nil{
			dictionary["religion"] = religion
		}
		if settings != nil{
			dictionary["settings"] = settings.toDictionary()
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
         aboutMe = aDecoder.decodeObject(forKey: "about_me") as? String
         age = aDecoder.decodeObject(forKey: "age") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
         deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
         education = aDecoder.decodeObject(forKey: "education") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         ethnicity = aDecoder.decodeObject(forKey: "ethnicity") as? String
         fbId = aDecoder.decodeObject(forKey: "fb_id") as? String
         fbToken = aDecoder.decodeObject(forKey: "fb_token") as? String
         firstName = aDecoder.decodeObject(forKey: "first_name") as? String
         gender = aDecoder.decodeObject(forKey: "gender") as? String
         geo = aDecoder.decodeObject(forKey: "geo") as? [Float]
         height = aDecoder.decodeObject(forKey: "height") as? Int
         intersted = aDecoder.decodeObject(forKey: "intersted") as? [AnyObject]
         lastName = aDecoder.decodeObject(forKey: "last_name") as? String
         location = aDecoder.decodeObject(forKey: "location") as? String
         matches = aDecoder.decodeObject(forKey :"matches") as? [TribeNMatch]
         phone = aDecoder.decodeObject(forKey: "phone") as? String
         picUrl = aDecoder.decodeObject(forKey: "pic_url") as? [String]
         religion = aDecoder.decodeObject(forKey: "religion") as? String
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
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if deviceToken != nil{
			aCoder.encode(deviceToken, forKey: "device_token")
		}
		if deviceType != nil{
			aCoder.encode(deviceType, forKey: "device_type")
		}
		if education != nil{
			aCoder.encode(education, forKey: "education")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if ethnicity != nil{
			aCoder.encode(ethnicity, forKey: "ethnicity")
		}
		if fbId != nil{
			aCoder.encode(fbId, forKey: "fb_id")
		}
		if fbToken != nil{
			aCoder.encode(fbToken, forKey: "fb_token")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if gender != nil{
			aCoder.encode(gender, forKey: "gender")
		}
		if geo != nil{
			aCoder.encode(geo, forKey: "geo")
		}
		if height != nil{
			aCoder.encode(height, forKey: "height")
		}
		if intersted != nil{
			aCoder.encode(intersted, forKey: "intersted")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if matches != nil{
			aCoder.encode(matches, forKey: "matches")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if picUrl != nil{
			aCoder.encode(picUrl, forKey: "pic_url")
		}
		if religion != nil{
			aCoder.encode(religion, forKey: "religion")
		}
		if settings != nil{
			aCoder.encode(settings, forKey: "settings")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}
