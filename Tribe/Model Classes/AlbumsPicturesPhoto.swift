//
//	AlbumsPicturesPhoto.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class AlbumsPicturesPhoto : NSObject, NSCoding{

	var data : [AlbumsPicturesData]!
	var paging : AlbumsPicturesPaging!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		data = [AlbumsPicturesData]()
		if let dataArray = dictionary["data"] as? [[String:Any]]{
			for dic in dataArray{
				let value = AlbumsPicturesData(fromDictionary: dic)
				data.append(value)
			}
		}
		if let pagingData = dictionary["paging"] as? [String:Any]{
			paging = AlbumsPicturesPaging(fromDictionary: pagingData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if data != nil{
			var dictionaryElements = [[String:Any]]()
			for dataElement in data {
				dictionaryElements.append(dataElement.toDictionary())
			}
			dictionary["data"] = dictionaryElements
		}
		if paging != nil{
			dictionary["paging"] = paging.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObject(forKey :"data") as? [AlbumsPicturesData]
         paging = aDecoder.decodeObject(forKey: "paging") as? AlbumsPicturesPaging

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if paging != nil{
			aCoder.encode(paging, forKey: "paging")
		}

	}

}
