//
//  Message.swift
//  cnode
//
//  Created by nswbmw on 2018/4/17.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import Foundation
import ObjectMapper

class MessagesResponse: Mappable {
  var success: Bool?
  var error_msg: String?
  var has_read_messages: [Message]?
  var hasnot_read_messages: [Message]?
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    success <- map["success"]
    error_msg <- map["error_msg"]
    has_read_messages <- map["data.has_read_messages"]
    hasnot_read_messages <- map["data.hasnot_read_messages"]
  }
}

class Message: Mappable {
  var id: String?
  var type: String?
  var has_read: Bool?
  var author: Author?
  var topic: Topic?
  var reply: Comment?
  var create_at: String?
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    type <- map["type"]
    has_read <- map["has_read"]
    author <- map["author"]
    topic <- map["topic"]
    reply <- map["reply"]
    create_at <- map["create_at"]
  }
}
