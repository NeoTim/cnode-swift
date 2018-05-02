//
//  UserCreatedTopicsViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/21.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserCreatedTopicsViewController: UITableViewController {
  var topics: [Topic] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //去除尾部多余的空行
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    // 注册单元格
    let topicCellNib = UINib(nibName: "TopicSimpleCell", bundle: Bundle.main)
    tableView.register(topicCellNib, forCellReuseIdentifier: "TopicSimpleCell")
  }
  
  // cell 数
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return topics.count
  }
  
  // 每个 cell 显示
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TopicSimpleCell") as! TopicSimpleCell
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
}
