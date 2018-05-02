//
//  APIRequest.swift
//  cnode
//
//  Created by nswbmw on 2018/4/17.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

class APIRequest {
  static let API_URL = "https://cnodejs.org/api/v1"
  
  // MARK: - 主题
  // 主题首页
  static func getTopics(page: Int? = 1,
                        tab: String? = "all",
                        limit: Int? = 20,
                        callback: @escaping (_ err: String?, _ topics: [Topic]?) -> Void) {
    let parameters: Parameters = ["page": page!, "tab": tab!, "limit": limit!, "mdrender": "false"]
    Alamofire.request(API_URL + "/topics", parameters: parameters).responseObject { (response: DataResponse<TopicsResponse>) in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let result = response.result.value
      callback(result?.error_msg, result?.data)
    }
  }
  
  // 主题详情
  static func getTopic(id: String,
                       callback: @escaping (_ err: String?, _ topic: Topic?) -> Void) {
    let accessToken = Util.getAccessToken()
    let parameters: Parameters = ["accesstoken": accessToken ?? "", "mdrender": "false"]
    Alamofire.request(API_URL + "/topic/" + id, parameters: parameters).responseObject { (response: DataResponse<TopicResponse>) in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let result = response.result.value
      callback(result?.error_msg, result?.data)
    }
  }
  
  // 新建主题
  static func createTopic(title: String,
                          tab: String,
                          content: String,
                          callback: @escaping (_ err: String?, _ topicId: String?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录", nil)
      return
    }
    let parameters: Parameters = ["accesstoken": accessToken!, "title": title, "tab": tab, "content": content ]
    Alamofire.request(API_URL + "/topics",
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.httpBody).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let json = JSON(response.result.value!)
      callback(json["error_msg"].string, json["topic_id"].string)
    }
  }
  
  // 编辑主题
  static func updateTopic(topic_id: String,
                          title: String,
                          tab: String,
                          content: String,
                          callback: @escaping (_ err: String?, _ topicId: String?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录", nil)
      return
    }
    let parameters: Parameters = ["accesstoken": accessToken!, "topic_id": topic_id, "title": title, "tab": tab, "content": content ]
    Alamofire.request(API_URL + "/topics/update",
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.httpBody).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let json = JSON(response.result.value!)
      callback(json["error_msg"].string, json["topic_id"].string)
    }
  }
  
  // MARK: - 主题收藏
  // 收藏主题
  static func collectTopic(topic_id: String,
                           callback: @escaping (_ err: String?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录")
      return
    }
    let parameters: Parameters = ["accesstoken": accessToken!, "topic_id": topic_id ]
    Alamofire.request(API_URL + "/topic_collect/collect",
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.httpBody).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题")
        return
      }
      let json = JSON(response.result.value!)
      callback(json["error_msg"].string)
    }
  }
  
  // 取消收藏主题
  static func deCollectTopic(topic_id: String,
                             callback: @escaping (_ err: String?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录")
      return
    }
    let parameters: Parameters = ["accesstoken": accessToken!, "topic_id": topic_id ]
    Alamofire.request(API_URL + "/topic_collect/de_collect",
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.httpBody).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题")
        return
      }
      let json = JSON(response.result.value!)
      callback(json["error_msg"].string)
    }
  }
  
  // 获取用户收藏的主题
  static func getCollectTopics(loginname: String,
                               callback: @escaping (_ err: String?, _ topics: [Topic]?) -> Void) {
    Alamofire.request(API_URL + "/topic_collect/" + loginname).responseObject { (response: DataResponse<TopicsResponse>) in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let result = response.result.value
      callback(result?.error_msg, result?.data)
    }
  }
  
  // MARK: - 评论
  // 新建/回复评论
  static func createComment(topic_id: String,
                            reply_id: String?,
                            content: String,
                            callback: @escaping (_ err: String?, _ topic_id: String?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录", nil)
      return
    }
    var parameters: Parameters
    if reply_id == nil {
      parameters = ["accesstoken": accessToken!, "content": content ]
    } else {
      parameters = ["accesstoken": accessToken!, "reply_id": reply_id!, "content": content ]
    }
    Alamofire.request(API_URL + "/topic/" + topic_id + "/replies",
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.httpBody).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let json = JSON(response.result.value!)
      callback(json["error_msg"].string, topic_id)
    }
  }
  
  // 点赞评论
  static func upComment(reply_id: String,
                        callback: @escaping (_ err: String?, _ action: String?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录", nil)
      return
    }
    let parameters: Parameters = ["accesstoken": accessToken! ]
    Alamofire.request(API_URL + "/reply/" + reply_id + "/ups",
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.httpBody).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let json = JSON(response.result.value!)
      callback(json["error_msg"].string, json["action"].string)
    }
  }
  
  // MARK: - 用户
  // 用户详情
  static func getUser(loginname: String,
                      callback: @escaping (_ err: String?, _ author: Author?) -> Void) {
    Alamofire.request(API_URL + "/user/" + loginname).responseObject { (response: DataResponse<AuthorResponse>) in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let result = response.result.value
      callback(result?.error_msg, result?.data)
    }
  }
  
  // 验证 accessToken 的正确性
  static func checkAccessToken(accessToken: String?,
                               callback: @escaping (_ err: String?, _ userDic: [String: String]?) -> Void) {
    let _accessToken = accessToken ?? Util.getAccessToken()
    if _accessToken == nil {
      callback("请登录", nil)
      return
    }
    let parameters: Parameters = ["accesstoken": _accessToken! ]
    Alamofire.request(API_URL + "/accesstoken",
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.httpBody).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let json = JSON(response.result.value!)
      if !json["success"].bool! {
        callback("扫码登录失败", nil)
        return
      }
      var _userDic: [String: String] = [:]
      _userDic["accessToken"] = accessToken
      _userDic["id"] = json["id"].string
      _userDic["loginname"] = json["loginname"].string
      var avatar_url = json["avatar_url"].string
      if avatar_url!.hasPrefix("//") {
        avatar_url = "http:" + avatar_url!
      }
      _userDic["avatar_url"] = avatar_url
      callback(json["error_msg"].string, _userDic)
    }
  }
  
  // MARK: - 消息通知
  // 获取未读消息数
  static func getUnreadCount(callback: @escaping (_ err: String?, _ count: Int?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录", nil)
      return
    }
    let parameters: Parameters = ["accesstoken": accessToken! ]
    Alamofire.request(API_URL + "/message/count", parameters: parameters).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let json = JSON(response.result.value!)
      callback(json["error_msg"].string, json["data"].int)
    }
  }
  
  // 获取已读和未读消息
  static func getMessages(callback: @escaping (_ err: String?, _ messages: MessagesResponse?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录", nil)
      return
    }
    let parameters: Parameters = ["accesstoken": accessToken!, "mdrender": "false" ]
    Alamofire.request(API_URL + "/messages", parameters: parameters).responseObject { (response: DataResponse<MessagesResponse>) in
      if response.result.isFailure {
        callback("网络连接出问题", nil)
        return
      }
      let result = response.result.value
      callback(result?.error_msg, result)
    }
  }
  
  // 全部标记为已读
  static func markAll(callback: @escaping (_ err: String?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录")
      return
    }
    let parameters: Parameters = ["accesstoken": accessToken! ]
    Alamofire.request(API_URL + "/message/mark_all",
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.httpBody).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题")
        return
      }
      let json = JSON(response.result.value!)
      callback(json["error_msg"].string)
    }
  }
  
  // 标记单个消息为已读
  static func markOne(msg_id: String,
                      callback: @escaping (_ err: String?) -> Void) {
    let accessToken = Util.getAccessToken()
    if accessToken == nil {
      callback("请登录")
      return
    }
    let parameters: Parameters = ["accesstoken": accessToken! ]
    Alamofire.request(API_URL + "/message/mark_one/" + msg_id,
                      method: .post,
                      parameters: parameters,
                      encoding: URLEncoding.httpBody).responseJSON { response in
      if response.result.isFailure {
        callback("网络连接出问题")
        return
      }
      let json = JSON(response.result.value!)
      callback(json["error_msg"].string)
    }
  }
}
