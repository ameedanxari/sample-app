//
//  Global.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import Contacts
import CoreLocation

struct Global {
    
    static var isHudShowing = false
    static var likesDisLikesIndex = 0
    static var tribesPhonenumber = [String]()
    static var user: TribeUser!
    static var otherUser = [TribeUser]()
    static var valueArray = [String]()
    static var request = [TribeUser]()
    static var matches = [TribeUser]()
    static var otherUserMatches = [TribeUser]()
    static var imageIndex = 0
    static var RingOfFireindex = 0
    static var frinedIndex = 0
    static var checkDater = false
    static var lastMesage:[[String:String]] = []
    static var arrimg = [String]()
    static var arrImgTemp = [UIImage]()
    static var testHashMap: [String:[TribeUser]] = [:]
    static var key = [String]()
    
    static var messageRequestFromVC = ""
    static var fbToken = ""
    static var fbID = ""
    static var deviceToken = ""
    static var firebaseToken = ""
    static var myProfile: TribeNUser!
    static var currentProfile: TribeNUser!
    static var profileCache: [String:TribeNUser] = [:]
    static var localContacts:[String:CNContact] = [:]
    static var localContactsArray: [CNContact] = []
    static var serverContacts:TribeNContacts!
    static var myTribe:TribeNTribeData = TribeNTribeData(fromDictionary: [:])
    static var matchables:[TribeNMatchable] = []
    static var currentMatchable = 0
    static var matchMade: TribeNUser!
    static var tribeMatches:[TribeNTribeMember] = []
    static var currentTribeMatch:TribeNTribeMember!
    static var tribeSwipeList:[TribeNMatchable] = []
    static var blockList:[String] = []
    static var currentTribeMemberId = ""
    static var currentTribeMatchable = 0
    static var invitedContacts = [String]()
    static var contactsArray = [String]()
    
    static var currentProfileImageIndex = 0
    
    static let locationManager:CLLocationManager = CLLocationManager()
    
    static var lastMessage = [users]()
    
    static var facebookAlbum = TribeFacebookAlbumResponse(fromDictionary: [:])
    static var albumPictures = AlbumsPicturesResponse(fromDictionary: [:])
    
    static var deletedUserIds = [String]()
    
    static var newChat = false
    static var newTribeNotification = false
    static var newRingOfFireNotification = false
    static var newMatch = false
}
