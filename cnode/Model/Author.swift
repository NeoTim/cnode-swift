//
//  Author.swift
//  cnode
//
//  Created by nswbmw on 2018/4/17.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import Foundation
import ObjectMapper

class AuthorResponse: Mappable {
  var success: Bool?
  var data: Author?
  var error_msg: String?
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    success <- map["success"]
    data <- map["data"]
    error_msg <- map["error_msg"]
  }
}

class Author: Mappable {
  var id: String?
  var loginname: String?
  var avatar_url: String? {
    didSet {
      if avatar_url!.hasPrefix("//") {
        avatar_url = "http:" + avatar_url!
      }
    }
  }
  var githubUsername: String?
  var create_at: String?
  var score: Int?
  var recent_topics: [Topic]?
  var recent_replies: [Topic]?
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    loginname <- map["loginname"]
    avatar_url <- map["avatar_url"]
    githubUsername <- map["githubUsername"]
    create_at <- map["create_at"]
    score <- map["score"]
    recent_topics <- map["recent_topics"]
    recent_replies <- map["recent_replies"]
  }
}
