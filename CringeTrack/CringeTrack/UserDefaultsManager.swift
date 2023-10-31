//
//  UserDefaultsManager.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 31/10/2023.
//

import Foundation
//this is a class where settings are stored in user defaults
class UserDefaultsManager {
    private static let standard = UserDefaults.standard
    private static let birthdayKey = "BIRTHDAY_STATUS_KEY"
    
    static func saveBirthdayStatus(showOnHomeScreen isBirthdayShow: Bool) {
        standard.setValue(isBirthdayShow, forKey: birthdayKey)
    }
    
    static func readBirthdayState() -> Bool {
        if let birthdayState =  standard.value(forKey: birthdayKey) as? Bool {
            return birthdayState
        } else {
            //returns false if there is nothing
            return false
        }
        
    }
}
