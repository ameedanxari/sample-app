//
//	TribeNTribeData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TribeNTribeData : NSObject, NSCoding{

	var memberOfTribe : [TribeNMemberOfTribe]!
	var mytribe : [TribeNMemberOfTribe]!
	var pendingMyTribe : [TribeNPendingMyTribe]!
	var requestedForTribe : [TribeNMemberOfTribe]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		memberOfTribe = [TribeNMemberOfTribe]()
		if let memberOfTribeArray = dictionary["MemberOfTribe"] as? [[String:Any]]{
			for dic in memberOfTribeArray{
				let value = TribeNMemberOfTribe(fromDictionary: dic)
                //check block list
                if let user_id = value.addedBy?.id, !Global.blockList.contains(user_id) {
                    memberOfTribe.append(value)
                }
			}
        }
		mytribe = [TribeNMemberOfTribe]()
		if let mytribeArray = dictionary["Mytribe"] as? [[String:Any]]{
			for dic in mytribeArray{
				let value = TribeNMemberOfTribe(fromDictionary: dic)
                //check block list
                if let user_id = value.added?.id, !Global.blockList.contains(user_id) {
                    mytribe.append(value)
                }
			}
		}
		pendingMyTribe = [TribeNPendingMyTribe]()
		if let pendingMyTribeArray = dictionary["pendingMyTribe"] as? [[String:Any]]{
			for dic in pendingMyTribeArray{
				let value = TribeNPendingMyTribe(fromDictionary: dic)
                //check block list
                if let user_id = value.added?.id, !Global.blockList.contains(user_id) {
                    pendingMyTribe.append(value)
                }
			}
		}
		requestedForTribe = [TribeNMemberOfTribe]()
		if let requestedForTribeArray = dictionary["requestedForTribe"] as? [[String:Any]]{
			for dic in requestedForTribeArray{
				let value = TribeNMemberOfTribe(fromDictionary: dic)
                //check block list
                if let user_id = value.addedBy?.id, !Global.blockList.contains(user_id) {
                    requestedForTribe.append(value)
                }
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if memberOfTribe != nil{
			var dictionaryElements = [[String:Any]]()
			for memberOfTribeElement in memberOfTribe {
				dictionaryElements.append(memberOfTribeElement.toDictionary())
			}
			dictionary["MemberOfTribe"] = dictionaryElements
		}
		if mytribe != nil{
			var dictionaryElements = [[String:Any]]()
			for mytribeElement in mytribe {
				dictionaryElements.append(mytribeElement.toDictionary())
			}
			dictionary["Mytribe"] = dictionaryElements
		}
		if pendingMyTribe != nil{
			var dictionaryElements = [[String:Any]]()
			for pendingMyTribeElement in pendingMyTribe {
				dictionaryElements.append(pendingMyTribeElement.toDictionary())
			}
			dictionary["pendingMyTribe"] = dictionaryElements
		}
		if requestedForTribe != nil{
			var dictionaryElements = [[String:Any]]()
			for requestedForTribeElement in requestedForTribe {
				dictionaryElements.append(requestedForTribeElement.toDictionary())
			}
			dictionary["requestedForTribe"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         memberOfTribe = aDecoder.decodeObject(forKey :"MemberOfTribe") as? [TribeNMemberOfTribe]
         mytribe = aDecoder.decodeObject(forKey :"Mytribe") as? [TribeNMemberOfTribe]
         pendingMyTribe = aDecoder.decodeObject(forKey :"pendingMyTribe") as? [TribeNPendingMyTribe]
         requestedForTribe = aDecoder.decodeObject(forKey :"requestedForTribe") as? [TribeNMemberOfTribe]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if memberOfTribe != nil{
			aCoder.encode(memberOfTribe, forKey: "MemberOfTribe")
		}
		if mytribe != nil{
			aCoder.encode(mytribe, forKey: "Mytribe")
		}
		if pendingMyTribe != nil{
			aCoder.encode(pendingMyTribe, forKey: "pendingMyTribe")
		}
		if requestedForTribe != nil{
			aCoder.encode(requestedForTribe, forKey: "requestedForTribe")
		}

	}

}
