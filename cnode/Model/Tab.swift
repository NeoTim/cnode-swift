//
//  Tab.swift
//  cnode
//
//  Created by nswbmw on 2018/4/17.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

enum Tab: String {
  case all = "全部"
  case good = "精华"
  case share = "分享"
  case ask = "问答"
  case job = "招聘"
  case dev = "测试"
  
  init(tab: String?) {
    if tab == nil {
      self = .share
      return
    }
    switch tab! {
    case "ask": self = .ask
    case "share": self = .share
    case "good": self = .good
    case "job": self = .job
    case "dev": self = .dev
    default: self = .all
    }
  }
  static let allTabsEn = ["all", "good", "share", "ask", "job", "dev"]
  static let allTabs = ["全部", "精华", "分享", "问答", "招聘", "测试"]
  static func getTabByName(name: String?) -> String {
    if name == nil {
      return ""
    }
    switch name! {
    case "全部": return "all"
    case "精华": return "good"
    case "分享": return "share"
    case "问答": return "ask"
    case "招聘": return "job"
    case "测试": return "dev"
    default: return "all"
    }
  }
}
