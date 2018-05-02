//
//  SettingViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/18.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import Kingfisher

class MenuViewController: UITableViewController {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var loginnameLabel: UILabel!
  var delegateTopicListsViewController: TopicListsViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    //去除尾部多余的空行
    tableView.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // 设置左滑菜单头像+名字
    trySetUserInfo()
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else if section == 1 {
      return 6
    } else {
      return 1
    }
  }

  // cell 点击
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 用户
    if indexPath.section == 0 {
      let userDic = Util.getUserInfo()
      // 未登录
      if userDic == nil {
        performSegue(withIdentifier: "showLogin", sender: nil)
      } else {
        // 已登录->个人页
        performSegue(withIdentifier: "showUser", sender: userDic!["loginname"])
      }
    } else if indexPath.section == 1 {
      // 板块
      let tabNameEn = Tab.allTabsEn[indexPath.row]
      performSegue(withIdentifier: "changeTopic", sender: tabNameEn)
    } else if indexPath.section == 2 {
      // 其他
      performSegue(withIdentifier: "showSetting", sender: nil)
    }
  }
  
  // segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUser" {
      let destViewController = segue.destination as! UserViewController
      destViewController.loginname = sender as! String
    }
    if segue.identifier == "changeTopic" {
      let destViewController = segue.destination as! TopicListsViewController
      destViewController.tab = sender as! String
    }
  }

  func trySetUserInfo () {
    let userDic = Util.getUserInfo()
    if userDic == nil {
      avatarImage.image = UIImage(named: "user")
      avatarImage.clipsToBounds = false
      loginnameLabel.text = "登录"
      return
    }
    avatarImage.kf.setImage(with: URL(string: userDic!["avatar_url"] as! String!))
    avatarImage.layer.cornerRadius = 40
    avatarImage.clipsToBounds = true
    loginnameLabel.text = userDic!["loginname"] as! String
  }
}
