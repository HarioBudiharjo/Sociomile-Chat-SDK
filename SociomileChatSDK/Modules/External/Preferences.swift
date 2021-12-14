//
//  Preferences.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 26/10/21.
//

import Foundation

struct Preferences {
    
    static let pref = UserDefaults.standard
    
    public static func commit(){
        pref.synchronize()
    }
    
    public static func remove(key:String) {
        pref.removeObject(forKey: key)
    }
    
    public static func saveString(key:String,value:String) {
        pref.set(value, forKey: key)
        commit()
    }
    
    public static func getString(key:String) -> String{
        if let string = pref.string(forKey: key) {
            return string
        }else{
            return ""
        }
    }
    
    public static func saveBool(key:String,value:Bool){
        pref.set(value, forKey: key)
        commit()
    }
    
    public static func getBool(key:String) -> Bool {
        if pref.bool(forKey: key) {
            return pref.bool(forKey: key)
        }else {
            return false
        }
    }
}
