//
//  Comment.swift
//  cnode
//
//  Created by nswbmw on 2018/4/17.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Mappable {
  var id: String?
  var author: Author?
  var content: String?
  var ups: [String]?
  var create_at: String?
  var reply_id: String?
  var is_uped: Bool?
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    author <- map["author"]
    content <- map["content"]
    ups <- map["ups"]
    create_at <- map["create_at"]
    reply_id <- map["reply_id"]
    is_uped <- map["is_uped"]
  }
}
