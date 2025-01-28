//
//  UserDefaultsManager.swift
//  TodaySpace
//
//  Created by 김상규 on 1/28/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum UserDefaultsManager {
    
    private enum Key: String {
        case accessToken
        case refreshToken
        case userID
    }
    
    @UserDefault(key: Key.accessToken.rawValue, defaultValue: "")
    static var accessToken
    
    @UserDefault(key: Key.refreshToken.rawValue, defaultValue: "")
    static var refreshToken
    
    @UserDefault(key: Key.userID.rawValue, defaultValue: "")
    static var userID
    
    
    static func refresh(_ accessToken: String, _ refreshToken: String) {
        UserDefaultsManager.accessToken = accessToken
        UserDefaultsManager.refreshToken = refreshToken
    }
    
    static func logIn(_ accessToken: String, _ refreshToken: String, _ id: String) {
        UserDefaultsManager.accessToken = accessToken
        UserDefaultsManager.refreshToken = refreshToken
        UserDefaultsManager.userID = id
    }
    
    static func removeAll() {
        UserDefaultsManager.accessToken = ""
        UserDefaultsManager.refreshToken = ""
        UserDefaultsManager.userID = ""
    }
}
