//
//	TribeCursor.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeCursor : NSObject, NSCoding{

	var after : String!
	var before : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		after = dictionary["after"] as? String
		before = dictionary["before"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if after != nil{
			dictionary["after"] = after
		}
		if before != nil{
			dictionary["before"] = before
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         after = aDecoder.decodeObject(forKey: "after") as? String
         before = aDecoder.decodeObject(forKey: "before") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if after != nil{
			aCoder.encode(after, forKey: "after")
		}
		if before != nil{
			aCoder.encode(before, forKey: "before")
		}

	}

}
