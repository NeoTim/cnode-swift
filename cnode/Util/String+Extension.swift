//
//  String+fromNow.swift
//  cnode
//
//  Created by nswbmw on 2018/4/19.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import SwiftDate

let ONE_MINUTE = 60.0
let ONE_HOUR = 60 * ONE_MINUTE
let ONE_DAY = 24 * ONE_HOUR
let ONE_MONTH = 30 * ONE_DAY

extension String {
  func timeAgo() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    let date = dateFormatter.date(from: self)
    if date == nil {
      return "-"
    }
    let passed = abs(date!.timeIntervalSinceNow)
    
    if passed > ONE_MONTH {
      return date!.string(format: .custom("yyyy-MM-dd HH:mm"))
    } else if passed > ONE_DAY {
      return String(Int(passed / ONE_DAY)) + " 天前"
    } else if passed > ONE_HOUR {
      return String(Int(passed / ONE_HOUR)) + " 小时前"
    } else if passed > ONE_MINUTE {
      return String(Int(passed / ONE_MINUTE)) + " 分钟前"
    } else {
      return "刚刚"
    }
  }
  
  func dayDate () -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    let date = dateFormatter.date(from: self)
    return date!.string(format: .custom("yyyy-MM-dd"))
  }
  
  subscript (bounds: CountableClosedRange<Int>) -> String {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return String(self[start...end])
  }
  
  subscript (bounds: CountableRange<Int>) -> String {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return String(self[start..<end])
  }
}
