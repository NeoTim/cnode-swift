//
//  UserViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/20.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import SVProgressHUD
import PPBadgeViewSwift

class UserViewController: UITableViewController {
  var loginname: String = ""
  var recent_topics: [Topic] = []
  var recent_replies: [Topic] = []

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var loginnameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //去除尾部多余的空行
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    // 设置 title
    navigationItem.title = loginname
    
    // 加载用户信息
    loadUser()
    
    // 设置“我的消息”badge
    tryToSetMessageBadge()
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else if section == 1 {
      return 3
    } else {
      return 2
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 80
    }
    if indexPath.section == 2 {
      // 不是自己，则隐藏“我的消息”
      if !isSelf(loginname: loginname) {
        return 0
      }
    }
    return -1
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 登出
    if indexPath.section == 2 && indexPath.row == 1 {
      Util.clearUserInfo()
      tableView.reloadData()
      Toaster.showToast(str: "登出成功")
    }
  }
  
  // segue 跳转传参
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserCollections" {
      let destViewController = segue.destination as! UserCollectionViewController
      destViewController.loginname = loginname
    }
    if segue.identifier == "showUserCreatedTopics" {
      let destViewController = segue.destination as! UserCreatedTopicsViewController
      destViewController.topics = recent_topics
    }
    if segue.identifier == "showUserRepliedTopics" {
      let destViewController = segue.destination as! UserRepliedTopicsViewController
      destViewController.topics = recent_replies
    }
  }
  
  func isSelf (loginname: String) -> Bool {
    let userInfo = Util.getUserInfo()
    return loginname == userInfo?["loginname"]
  }
  
  func loadUser () {
    // SVProgressHUD
    SVProgressHUD.show()
    APIRequest.getUser(loginname: loginname, callback: { (err: String?, author: Author?) in
      if err != nil {
        Toaster.showToast(str: "获取用户信息失败")
        SVProgressHUD.dismiss()
        return
      }
      
      self.avatarImage.kf.setImage(with: URL(string: author!.avatar_url!), placeholder: nil)
      self.loginnameLabel.text = self.loginname
      self.descriptionLabel.text = "创建于 " + author!.create_at!.dayDate() + " • 积分 " + String(author!.score!)
      
      self.recent_topics = author!.recent_topics!
      self.recent_replies = author!.recent_replies!
      
      SVProgressHUD.dismiss()
    })
  }
  
  // 设置“我的消息”badge
  func tryToSetMessageBadge () {
    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2))
    let user = Util.getUserInfo()
    if user == nil {
      cell?.pp.hiddenBadge()
      return
    }
    APIRequest.getUnreadCount(callback: { (err: String?, count: Int?) in
      if err != nil {
        Toaster.showToast(str: err!)
        return
      }
      
      if count! == 0 {
        cell?.pp.hiddenBadge()
      } else {
        cell?.pp.addBadge(number: count!)
        cell?.pp.setBadgeHeight(points: 16)
        cell?.pp.moveBadge(x: -40, y: 22)
      }
    })
  }
}
