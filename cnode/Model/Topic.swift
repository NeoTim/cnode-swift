//
//  Topic.swift
//  cnode
//
//  Created by nswbmw on 2018/4/17.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import Foundation
import ObjectMapper

class TopicsResponse: Mappable {
  var success: Bool?
  var data: [Topic]?
  var error_msg: String?
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    success <- map["success"]
    data <- map["data"]
    error_msg <- map["error_msg"]
  }
}

class TopicResponse: Mappable {
  var success: Bool?
  var data: Topic?
  var error_msg: String?

  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    success <- map["success"]
    data <- map["data"]
    error_msg <- map["error_msg"]
  }
}

class Topic: Mappable {
  var id: String?
  var author_id: String?
  var tab: String?
  var content: String?
  var title: String?
  var last_reply_at: String?
  var good: Bool?
  var top: Bool?
  var reply_count: Int?
  var visit_count: Int?
  var create_at: String?
  var author: Author?
  var replies: [Comment]?
  var is_collect: Bool?
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    author_id <- map["author_id"]
    tab <- map["tab"]
    content <- map["content"]
    title <- map["title"]
    last_reply_at <- map["last_reply_at"]
    good <- map["good"]
    top <- map["top"]
    reply_count <- map["reply_count"]
    visit_count <- map["visit_count"]
    create_at <- map["create_at"]
    author <- map["author"]
    replies <- map["replies"]
    is_collect <- map["is_collect"]
  }
}
