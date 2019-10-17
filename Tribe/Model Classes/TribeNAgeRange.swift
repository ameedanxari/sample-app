//
//	TribeNAgeRange.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNAgeRange : NSObject, NSCoding{

	var max : Int!
	var min : Int!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		max = dictionary["max"] as? Int
		min = dictionary["min"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if max != nil{
			dictionary["max"] = max
		}
		if min != nil{
			dictionary["min"] = min
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         max = aDecoder.decodeObject(forKey: "max") as? Int
         min = aDecoder.decodeObject(forKey: "min") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if max != nil{
			aCoder.encode(max, forKey: "max")
		}
		if min != nil{
			aCoder.encode(min, forKey: "min")
		}

	}

}
