//
//  SettingViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/18.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftQRScanner

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
      // 未登录->扫码
      if userDic == nil {
        // 隐私协议声明
        let alertController = UIAlertController(title: "隐私协议声明",
                                                message: "您是否同意“关于”中的《隐私协议》？",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "不同意", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "同意", style: .default, handler: {
          action in
          // 同意后才可以扫码
          let scanner = QRCodeScannerController()
          scanner.delegate = self
          self.present(scanner, animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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

extension MenuViewController: QRScannerCodeDelegate {
  // 扫码成功
  func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
    APIRequest.checkAccessToken(accessToken: result, callback: { (err: String?, userDic: [String: String]?) in
      if err != nil {
        Toaster.showToast(str: err!)
        return
      }
      Util.setUserInfo(userDic: userDic!)
      // 重绘，显示头像和名字
      self.tableView.reloadData()
      Toaster.showToast(str: "登录成功")
      // 设置 navigationBar 左上角和右上角按钮状态
      self.delegateTopicListsViewController?.setUnreadBadge()
      self.delegateTopicListsViewController?.setCreateTopicBtn()
    })
  }
  
  // 扫码失败
  func qrScannerDidFail(_ controller: UIViewController, error: String) {
    Toaster.showToast(str: error)
  }
  
  // 取消扫码
  func qrScannerDidCancel(_ controller: UIViewController) {
     Toaster.showToast(str: "已取消扫码登录")
  }
}
