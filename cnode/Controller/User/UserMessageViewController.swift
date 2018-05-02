//
//  UserMessageViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/21.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserMessageViewController: UITableViewController {
  var has_read_messages: [Message] = []
  var hasnot_read_messages: [Message] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //去除尾部多余的空行
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    // 注册单元格
    let messageCellNib = UINib(nibName: "MessageCell", bundle: Bundle.main)
    tableView.register(messageCellNib, forCellReuseIdentifier: "MessageCell")
    
    // 获取用户消息
    SVProgressHUD.show()
    APIRequest.getMessages(callback: { (err: String?, messages: MessagesResponse?) in
      if err != nil {
        Toaster.showToast(str: err!)
        SVProgressHUD.dismiss()
        return
      }
      self.has_read_messages = messages!.has_read_messages!
      self.hasnot_read_messages = messages!.hasnot_read_messages!
      self.tableView.reloadData()
      
      SVProgressHUD.dismiss()
      // 标记所有已读
      APIRequest.markAll(callback: { (err: String?) in Void.self})
    })
  }
  
  // section 数
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  // section 标题
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "  未读" : "  已读"
  }
  
  
  // 每个 section 内 cell 数
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? hasnot_read_messages.count : has_read_messages.count
  }
  
  // 每个 cell 显示
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
    if (indexPath.section == 0) {
      let message = hasnot_read_messages[indexPath.row]
      cell.message = message
    } else {
      let message = has_read_messages[indexPath.row]
      cell.message = message
    }
    
    return cell
  }
  
  // cell 点击
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let topicId = indexPath.section == 0
      ? hasnot_read_messages[indexPath.row].topic!.id!
      : has_read_messages[indexPath.row].topic!.id!
    
    performSegue(withIdentifier: "showTopic", sender: topicId)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTopic" {
      let destViewController = segue.destination as! TopicViewController
      destViewController.topicId = sender as! String
    }
  }
}
