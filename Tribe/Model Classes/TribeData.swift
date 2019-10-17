//
//	TribeData.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeData : NSObject, NSCoding{

	var isSilhouette : Bool!
	var url : String!
	var id : String!
	var name : String!
	var photoCount : Int!
	var picture : TribePicture!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		isSilhouette = dictionary["is_silhouette"] as? Bool
		url = dictionary["url"] as? String
		id = dictionary["id"] as? String
		name = dictionary["name"] as? String
		photoCount = dictionary["photo_count"] as? Int
		if let pictureData = dictionary["picture"] as? [String:Any]{
			picture = TribePicture(fromDictionary: pictureData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if isSilhouette != nil{
			dictionary["is_silhouette"] = isSilhouette
		}
		if url != nil{
			dictionary["url"] = url
		}
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		if photoCount != nil{
			dictionary["photo_count"] = photoCount
		}
		if picture != nil{
			dictionary["picture"] = picture.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         isSilhouette = aDecoder.decodeObject(forKey: "is_silhouette") as? Bool
         url = aDecoder.decodeObject(forKey: "url") as? String
         id = aDecoder.decodeObject(forKey: "id") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         photoCount = aDecoder.decodeObject(forKey: "photo_count") as? Int
         picture = aDecoder.decodeObject(forKey: "picture") as? TribePicture

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if isSilhouette != nil{
			aCoder.encode(isSilhouette, forKey: "is_silhouette")
		}
		if url != nil{
			aCoder.encode(url, forKey: "url")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if photoCount != nil{
			aCoder.encode(photoCount, forKey: "photo_count")
		}
		if picture != nil{
			aCoder.encode(picture, forKey: "picture")
		}

	}

}
