//
//	AlbumsPicturesData.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class AlbumsPicturesData : NSObject, NSCoding{

	var id : String!
	var images : [AlbumsPicturesImage]!
	var picture : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["id"] as? String
		images = [AlbumsPicturesImage]()
		if let imagesArray = dictionary["images"] as? [[String:Any]]{
			for dic in imagesArray{
				let value = AlbumsPicturesImage(fromDictionary: dic)
				images.append(value)
			}
		}
		picture = dictionary["picture"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["id"] = id
		}
		if images != nil{
			var dictionaryElements = [[String:Any]]()
			for imagesElement in images {
				dictionaryElements.append(imagesElement.toDictionary())
			}
			dictionary["images"] = dictionaryElements
		}
		if picture != nil{
			dictionary["picture"] = picture
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? String
         images = aDecoder.decodeObject(forKey :"images") as? [AlbumsPicturesImage]
         picture = aDecoder.decodeObject(forKey: "picture") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if images != nil{
			aCoder.encode(images, forKey: "images")
		}
		if picture != nil{
			aCoder.encode(picture, forKey: "picture")
		}

	}

}
