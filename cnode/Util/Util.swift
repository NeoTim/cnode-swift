//
//  Util.swift
//  cnode
//
//  Created by nswbmw on 2018/4/20.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import Foundation

class Util {
  // MARK: - Tab
  static func getRealTabName (topic: Topic) -> String {
    let tab  = topic.top!
      ? "置顶"
      : (topic.good! ? "精华" : Tab(tab: topic.tab ?? "dev").rawValue)
    return tab
  }
  
  // MARK: - userInfo
  static func getAccessToken () -> String? {
    let accessToken = UserDefaults.standard.object(forKey: "user") as? [String: String]
    return accessToken?["accessToken"]
  }
  
  static func getUserInfo () -> [String: String]? {
    let accessToken = UserDefaults.standard.object(forKey: "user") as? [String: String]
    return accessToken
  }
  
  static func setUserInfo (userDic: [String: String]) {
    UserDefaults.standard.setValue(userDic, forKey: "user")
    UserDefaults.standard.synchronize()
  }
  
  static func clearUserInfo () {
    UserDefaults.standard.setValue(nil, forKey: "user")
    UserDefaults.standard.synchronize()
  }
  
  // MARK: - setting
  static func getTailState () -> Bool {
    let isOn = UserDefaults.standard.object(forKey: "tail") as? Bool
    // 默认 On
    if isOn == nil {
      return true
    }
    return isOn!
  }
  
  static func setTailState (isOn: Bool) {
    UserDefaults.standard.setValue(isOn, forKey: "tail")
    UserDefaults.standard.synchronize()
  }
}

