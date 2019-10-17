//
//	TribeNAdded.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNAdded : NSObject, NSCoding{

	var v : Int!
	var id : String!
	var aboutMe : String!
	var age : String!
	var createdAt : String!
	var deviceToken : String!
	var deviceType : String!
	var email : String!
	var fbId : String!
	var fbToken : String!
	var firstName : String!
	var gender : String!
	var height : Int!
	var intersted : [String]!
	var lastName : String!
	var lat : String!
	var lng : String!
	var matches : [AnyObject]!
	var phone : String!
	var picUrl : [String]!
	var settings : TribeNSetting!
	var tribe : [TribeNTribe]!
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
		email = dictionary["email"] as? String
		fbId = dictionary["fb_id"] as? String
		fbToken = dictionary["fb_token"] as? String
		firstName = dictionary["first_name"] as? String
		gender = dictionary["gender"] as? String
		height = dictionary["height"] as? Int
		intersted = dictionary["intersted"] as? [String]
		lastName = dictionary["last_name"] as? String
		lat = dictionary["lat"] as? String
		lng = dictionary["lng"] as? String
		matches = dictionary["matches"] as? [AnyObject]
		phone = dictionary["phone"] as? String
		picUrl = dictionary["pic_url"] as? [String]
		if let settingsData = dictionary["settings"] as? [String:Any]{
			settings = TribeNSetting(fromDictionary: settingsData)
		}
		tribe = [TribeNTribe]()
		if let tribeArray = dictionary["tribe"] as? [[String:Any]]{
			for dic in tribeArray{
				let value = TribeNTribe(fromDictionary: dic)
				tribe.append(value)
			}
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
		if email != nil{
			dictionary["email"] = email
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
		if height != nil{
			dictionary["height"] = height
		}
		if intersted != nil{
			dictionary["intersted"] = intersted
		}
		if lastName != nil{
			dictionary["last_name"] = lastName
		}
		if lat != nil{
			dictionary["lat"] = lat
		}
		if lng != nil{
			dictionary["lng"] = lng
		}
		if matches != nil{
			dictionary["matches"] = matches
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if picUrl != nil{
			dictionary["pic_url"] = picUrl
		}
		if settings != nil{
			dictionary["settings"] = settings.toDictionary()
		}
		if tribe != nil{
			var dictionaryElements = [[String:Any]]()
			for tribeElement in tribe {
				dictionaryElements.append(tribeElement.toDictionary())
			}
			dictionary["tribe"] = dictionaryElements
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
         email = aDecoder.decodeObject(forKey: "email") as? String
         fbId = aDecoder.decodeObject(forKey: "fb_id") as? String
         fbToken = aDecoder.decodeObject(forKey: "fb_token") as? String
         firstName = aDecoder.decodeObject(forKey: "first_name") as? String
         gender = aDecoder.decodeObject(forKey: "gender") as? String
         height = aDecoder.decodeObject(forKey: "height") as? Int
         intersted = aDecoder.decodeObject(forKey: "intersted") as? [String]
         lastName = aDecoder.decodeObject(forKey: "last_name") as? String
         lat = aDecoder.decodeObject(forKey: "lat") as? String
         lng = aDecoder.decodeObject(forKey: "lng") as? String
         matches = aDecoder.decodeObject(forKey: "matches") as? [AnyObject]
         phone = aDecoder.decodeObject(forKey: "phone") as? String
         picUrl = aDecoder.decodeObject(forKey: "pic_url") as? [String]
         settings = aDecoder.decodeObject(forKey: "settings") as? TribeNSetting
         tribe = aDecoder.decodeObject(forKey :"tribe") as? [TribeNTribe]
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
		if email != nil{
			aCoder.encode(email, forKey: "email")
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
		if height != nil{
			aCoder.encode(height, forKey: "height")
		}
		if intersted != nil{
			aCoder.encode(intersted, forKey: "intersted")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
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
		if settings != nil{
			aCoder.encode(settings, forKey: "settings")
		}
		if tribe != nil{
			aCoder.encode(tribe, forKey: "tribe")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}