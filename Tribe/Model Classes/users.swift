//
//  lastMessage.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import Foundation
class users : NSObject {
    

    private var messageTo = ""
    private var time: Double!
    private var status = ""
    private var name = ""
    private var picUrl = ""
    private var userID = ""
    private var isMatch:String!

    
    init(msg:String, tim:Double, st: String, na: String, pic: String,id: String, matchType: String!)
    {
        
        messageTo = msg
        time = tim
        status = st
        name = na
        picUrl = pic
        userID = id
        isMatch = matchType
    }
    var msg: String
    {
        return messageTo;
    }
    var tim: Double
    {
        return time;
    }
    var st: String
    {
        return status;
    }
    var na: String
    {
        return name;
    }
    var pic: String
    {
        return picUrl;
    }
    var ID: String
    {
        return userID;
    }
    
    var type: String!
    {
        return isMatch;
    }
}
