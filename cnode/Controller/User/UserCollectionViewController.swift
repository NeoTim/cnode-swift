//
//  UserCollectionViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/21.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserCollectionViewController: UITableViewController {
  var loginname: String = ""
  var topics: [Topic] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //去除尾部多余的空行
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    // 注册单元格
    let topicCellNib = UINib(nibName: "TopicCell", bundle: Bundle.main)
    tableView.register(topicCellNib, forCellReuseIdentifier: "TopicCell")
    
    // 获取收藏主题
    SVProgressHUD.show()
    APIRequest.getCollectTopics(loginname: loginname, callback: { (err: String?, topics: [Topic]?) in
      if err != nil {
        Toaster.showToast(str: err!)
        SVProgressHUD.dismiss()
        return
      }
      self.topics = topics!
      self.tableView.reloadData()
      
      SVProgressHUD.dismiss()
    })
  }
  
  // cell 数
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return topics.count
  }
  
  // 每个 cell 显示
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell") as! TopicCell
    cell.topic = topics[indexPath.row]
    return cell
  }
  
  // cell 点击
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let topic = topics[indexPath.row]
    let topicViewController = storyboard?.instantiateViewController(withIdentifier: "TopicViewController") as? TopicViewController
    topicViewController?.topicId = topic.id!
    navigationController?.pushViewController(topicViewController!, animated: true)
  }
  
  // 左滑『取消收藏』
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let removeCollect = UITableViewRowAction(style: .normal, title: "取消收藏") {
      action, index in
      let topic_id = self.topics[index.row].id!
      self.topics.remove(at: index.row)
      self.tableView.deleteRows(at: [index], with: UITableViewRowAnimation.automatic)
      APIRequest.deCollectTopic(topic_id: topic_id, callback: { (err: String?) in
        if err != nil {
          Toaster.showToast(str: "取消收藏失败")
          return
        }
        Toaster.showToast(str: "取消收藏成功")
      })
    }
    removeCollect.backgroundColor = .orange
    return [removeCollect]
  }
}
