//
//	TribeNContacts.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import Contacts

class TribeNContacts : NSObject, NSCoding{

	var matched : [TribeNMatched]!
	var unmatched : [TribeNUnmatched]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		matched = [TribeNMatched]()
		if let matchedArray = dictionary["matched"] as? [[String:Any]]{
			for dic in matchedArray{
				let value = TribeNMatched(fromDictionary: dic)
                //checking for already being a tribe member
                var isAlreadyTribeMember = false
                for tribeMember in Global.myTribe.mytribe {
                    if tribeMember.added.id == value.id || tribeMember.addedBy.id == value.id || Global.myProfile.id == value.id {
                        isAlreadyTribeMember = true
                        break
                    }
                }
                //crash safing for nil values during sorting
                if !isAlreadyTribeMember && value.firstName != nil {
                    matched.append(value)
                }
			}
		}
        //sorting by name
        matched = matched.sorted(by: { $0.firstName.lowercased() < $1.firstName.lowercased() })
        
        unmatched = [TribeNUnmatched]()
        if let unmatchedList = dictionary["unmatched"] as? [String] {
            for phone in unmatchedList {
                var dic:[String:Any] = [:]
//                if let name = CNContactFormatter.string(from: Global.localContacts[phone]!, style: .fullName) {
//                    dic["name"] = name
//                    if let pLabel = Global.localContacts[phone]?.phoneNumbers.first?.label , pLabel != "" {//_$!<Mobile>!$_
//                        let pLabel2 = pLabel.characters.split(separator: "<").map(String.init) //[_$!<, Mobile>!$_]
//                        if pLabel2.count > 1 {
//                            let pLabel3 = pLabel2[1].characters.split(separator: ">").map(String.init) //[Mobile, >!$_]
//                            dic["type"] = pLabel3[0] //Mobile
//                        } else {
//                            dic["type"] = pLabel //Mobile
//                        }
//                    }
////                    dic["type"] = Global.localContacts[phone]?.phoneNumbers.first?.label
//                    dic["phone"] = (Global.localContacts[phone]?.phoneNumbers.first?.value.stringValue)!
//                    dic["picture"] = Global.localContacts[phone]?.imageData
                
                    let value = TribeNUnmatched(fromDictionary: dic)
                    unmatched.append(value)
//                }
            }
        }
        //unmatched = unmatched.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if matched != nil{
			var dictionaryElements = [[String:Any]]()
			for matchedElement in matched {
				dictionaryElements.append(matchedElement.toDictionary())
			}
			dictionary["matched"] = dictionaryElements
		}
		if unmatched != nil{
			dictionary["unmatched"] = unmatched
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         matched = aDecoder.decodeObject(forKey :"matched") as? [TribeNMatched]
         unmatched = aDecoder.decodeObject(forKey: "unmatched") as? [TribeNUnmatched]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if matched != nil{
			aCoder.encode(matched, forKey: "matched")
		}
		if unmatched != nil{
			aCoder.encode(unmatched, forKey: "unmatched")
		}

	}

}
