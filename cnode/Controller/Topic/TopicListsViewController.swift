//
//  TopicListsViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/17.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import SideMenu
import MJRefresh
import PPBadgeViewSwift

class TopicListsViewController: UITableViewController {
  var tab = "all"
  var pages: [String: Int] = [:]
  var topics: [String: [Topic]] = [:]
  var user: [String: String]?

  let header = MJRefreshNormalHeader()
  let footer = MJRefreshAutoNormalFooter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 注册单元格
    let topicCellNib = UINib(nibName: "TopicCell", bundle: Bundle.main)
    tableView.register(topicCellNib, forCellReuseIdentifier: "TopicCell")
    
    // 设置侧边栏菜单
    setupSideMenu()
    
    // 设置 title
    navigationItem.title = Tab(tab: tab).rawValue
    
    // 下拉刷新
    header.setRefreshingTarget(self, refreshingAction: #selector(pullToRefresh))
    tableView.mj_header = header
    
    // 上拉加载
    footer.setRefreshingTarget(self, refreshingAction: #selector(loadMore))
    tableView.mj_footer = footer
    
    pullToRefresh()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // 左上角“未读消息数”
    setUnreadBadge()
    
    // 右上角“新建帖子”
    setCreateTopicBtn()
  }

  // section 数
  override func numberOfSections(in tableView: UITableView) -> Int {
    return topics[tab]?.count ?? 0
  }

  // 每个 section 内 cell 数
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  // 每个 cell 显示
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell") as! TopicCell
    let topic = topics[tab]![indexPath.section]
    
    cell.topic = topic
    return cell
  }
  
  // 左滑『举报』
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let report = UITableViewRowAction(style: .normal, title: "举报") {
      action, index in
      // for: app store 审核
      Toaster.showToast(str: "举报成功")
    }
    report.backgroundColor = .red
    return [report]
  }
  
  // MARK: - section
  // section 间隔
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }
  
  // section footer 高度
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 8
  }
  
  // cell 点击
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let topic = topics[tab]![indexPath.section]
    performSegue(withIdentifier: "showTopic", sender: topic)
  }
  
  // MARK: - SideMenu
  // 设置侧边栏菜单
  func setupSideMenu() {
    // 隐藏 status bar
    SideMenuManager.default.menuFadeStatusBar = false
    SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
    // 添加右滑手势
    SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
    SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
  }
  
  // MARK: - pullToRefresh & loadMore
  // 下拉刷新
  @objc func pullToRefresh () {
    APIRequest.getTopics(tab: tab, callback: { (err: String?, topics: [Topic]?) in
      if err != nil {
        Toaster.showToast(str: err!)
        return
      }
      self.pages[self.tab] = 1
      self.topics[self.tab] = topics
      self.tableView.reloadData()
      
      self.tableView.mj_header.endRefreshing()
    })
  }
  
  // 上拉加载
  @objc func loadMore () {
    APIRequest.getTopics(page: pages[tab]! + 1, tab: tab, callback: { (err: String?, topics: [Topic]?) in
      if err != nil {
        Toaster.showToast(str: err!)
        return
      }
      self.pages[self.tab]! += 1
      self.topics[self.tab] = self.topics[self.tab]! + topics!
      self.tableView.reloadData()
      
      self.tableView.mj_footer.endRefreshing()
      if topics?.count == 0 {
        self.footer.endRefreshingWithNoMoreData()
      }
    })
  }
  
  // segue 跳转传参
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTopic" {
      let destViewController = segue.destination as! TopicViewController
      let topic = sender as! Topic
      destViewController.topicId = topic.id!
    }
    if segue.identifier == "createTopic" {
      let nav = segue.destination as! UINavigationController
      let destViewController = nav.topViewController as! TopicCreateViewController
      destViewController.tab = sender as! String
      destViewController.delegateTopicListsViewController = self
    }
  }
  
  // 左上角设置“未读数“
  func setUnreadBadge () {
    user = Util.getUserInfo()
    
    if user == nil {
      self.navigationItem.leftBarButtonItem?.pp.hiddenBadge()
      return
    }
    APIRequest.getUnreadCount(callback: { (err: String?, count: Int?) in
      if err != nil {
        Toaster.showToast(str: err!)
        return
      }
      if count! == 0 {
        self.navigationItem.leftBarButtonItem?.pp.hiddenBadge()
      } else {
        self.navigationItem.leftBarButtonItem?.pp.addBadge(number: count!)
        self.navigationItem.leftBarButtonItem?.pp.setBadgeHeight(points: 16)
        self.navigationItem.leftBarButtonItem?.pp.moveBadge(x: -5, y: 7)
      }
    })
  }
  
  // 右上角“新建帖子”
  func setCreateTopicBtn () {
    user = Util.getUserInfo()
    
    if user == nil {
      navigationItem.rightBarButtonItem = nil
      return
    }
    let createTopicBtn = UIBarButtonItem(image: UIImage(named: "send"),
                                         style: UIBarButtonItemStyle.plain,
                                        target: self,
                                        action: #selector(TopicListsViewController.createTopic))
    navigationItem.rightBarButtonItem = createTopicBtn
  }
  
  // 创建帖子
  @objc func createTopic () {
    performSegue(withIdentifier: "createTopic", sender: tab)
  }
}

// 扫码登录后，刷新 navigationBar 状态
extension TopicListsViewController: UISideMenuNavigationControllerDelegate {
  func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
    let menuViewController = menu.topViewController as! MenuViewController
    menuViewController.delegateTopicListsViewController = self
  }
}
