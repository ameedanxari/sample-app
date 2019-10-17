//
//	TribeNSetting.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNSetting : NSObject, NSCoding{

	var dater : Bool!
	var daterSetting : TribeNDaterSetting!
	var publicProfile : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		dater = dictionary["dater"] as? Bool
		if let daterSettingData = dictionary["dater_setting"] as? [String:Any]{
			daterSetting = TribeNDaterSetting(fromDictionary: daterSettingData)
        } else {
            daterSetting = TribeNDaterSetting(fromDictionary: [:])
        }
		publicProfile = dictionary["public_profile"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if dater != nil{
			dictionary["dater"] = dater
		}
		if daterSetting != nil{
			dictionary["dater_setting"] = daterSetting.toDictionary()
		}
		if publicProfile != nil{
			dictionary["public_profile"] = publicProfile
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         dater = aDecoder.decodeObject(forKey: "dater") as? Bool
         daterSetting = aDecoder.decodeObject(forKey: "dater_setting") as? TribeNDaterSetting
         publicProfile = aDecoder.decodeObject(forKey: "public_profile") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if dater != nil{
			aCoder.encode(dater, forKey: "dater")
		}
		if daterSetting != nil{
			aCoder.encode(daterSetting, forKey: "dater_setting")
		}
		if publicProfile != nil{
			aCoder.encode(publicProfile, forKey: "public_profile")
		}

	}

}
