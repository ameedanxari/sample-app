//
//	AlbumsPicturesPaging.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class AlbumsPicturesPaging : NSObject, NSCoding{

	var cursors : AlbumsPicturesCursor!
	var next : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let cursorsData = dictionary["cursors"] as? [String:Any]{
			cursors = AlbumsPicturesCursor(fromDictionary: cursorsData)
		}
		next = dictionary["next"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if cursors != nil{
			dictionary["cursors"] = cursors.toDictionary()
		}
		if next != nil{
			dictionary["next"] = next
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cursors = aDecoder.decodeObject(forKey: "cursors") as? AlbumsPicturesCursor
         next = aDecoder.decodeObject(forKey: "next") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cursors != nil{
			aCoder.encode(cursors, forKey: "cursors")
		}
		if next != nil{
			aCoder.encode(next, forKey: "next")
		}

	}

}
