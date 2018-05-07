//
//  TopicViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/19.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import MarkdownView
import SVProgressHUD
import SafariServices

// 首先显示头部（标题+作者+板块信息），然后异步加载内容+评论列表，然后 reloadData
class TopicViewController: UITableViewController {
  var topicId = ""
  var topic: Topic?
  var headerCell: TopicCell?
  var contentCell: TopicDetailContentCell?
  var user = Util.getUserInfo()
  
  var contentCellHeight: CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //去除尾部多余的空行
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    // 右上角“更多”按钮(登录用户才会显示)
    if user != nil {
      let showTopicActionSheetBtn = UIBarButtonItem(image: UIImage(named: "more"),
                                               style: UIBarButtonItemStyle.plain,
                                               target: self,
                                               action: #selector(TopicViewController.showTopicActionSheet))
      navigationItem.rightBarButtonItem = showTopicActionSheetBtn
    }
    
    // headerCell
    headerCell = Bundle.main.loadNibNamed("TopicCell", owner: nil, options: nil)?[0] as! TopicCell
    // contentCell
    contentCell = Bundle.main.loadNibNamed("TopicDetailContentCell", owner: nil, options: nil)?[0] as! TopicDetailContentCell
    // commentCell
    let commentCellNib = UINib(nibName: "TopicDetailCommentCell", bundle: Bundle.main)
    tableView.register(commentCellNib, forCellReuseIdentifier: "TopicDetailCommentCell")
    
    // 获取帖子详情
    loadTopic()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    SVProgressHUD.dismiss()
  }
  
  // MARK: - tableView
  // 单元格数量
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return topic != nil ? topic!.replies!.count + 2 : 0
  }
  
  // 每个 cell 显示
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      return headerCell!
    } else if indexPath.row == 1 {
      return contentCell!
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TopicDetailCommentCell") as! TopicDetailCommentCell
      // 前 2 个 cell 不算
      let level = indexPath.row - 2
      let comment = topic?.replies?[level]
      
      cell.authorName = topic?.author?.loginname
      cell.level = level + 1
      cell.comment = comment
      return cell
    }
  }

  // cell 高度
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 1 {
      return contentCellHeight
    }
    return super.tableView(tableView, heightForRowAt: indexPath)
  }
  
  // cell 点击
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row < 2 {
      return
    }
    // 未登录不让操作
    if user == nil {
      return
    }
    let comment = topic?.replies?[indexPath.row - 2]
    showCommentActionSheet(comment: comment!)
  }
  
  // MARK: - action sheet
  // showCommentActionSheet
  func showCommentActionSheet (comment: Comment) {
    let alertController = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
    // ipad
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
    alertController.popoverPresentationController?.permittedArrowDirections = []
    
    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    let authorAction = UIAlertAction(title: "查看作者(@" + comment.author!.loginname! + ")", style: .default, handler: { action in
      self.performSegue(withIdentifier: "showAuthor", sender: comment.author!.loginname!)
    })
    alertController.addAction(authorAction)
    
    let replyAction = UIAlertAction(title: "回复(@" + comment.author!.loginname! + ")", style: .default, handler: { action in
      self.performSegue(withIdentifier: "createReplyComment", sender: comment)
    })
    alertController.addAction(replyAction)
    
    let likeAction = UIAlertAction(title: comment.is_uped! ? "取消赞" : "赞", style: .default, handler: { action in
      APIRequest.upComment(reply_id: comment.id!, callback: { (err: String?, action: String?) in
        if err != nil {
          Toaster.showToast(str: err!)
          return
        }
        Toaster.showToast(str: action! == "down" ? "已取消点赞" : "已点赞")
      })
    })
    alertController.addAction(likeAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  // showTopicActionSheet
  @objc func showTopicActionSheet () {
    let alertController = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
    // ipad
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
    alertController.popoverPresentationController?.permittedArrowDirections = []
    
    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    // 只有自己的帖子才显示“编辑”，非作者显示“查看作者”
    if user!["loginname"] == topic?.author?.loginname {
      let editAction = UIAlertAction(title: "编辑", style: .default, handler: { action in
        self.performSegue(withIdentifier: "editTopic", sender: self.topic)
      })
      alertController.addAction(editAction)
    } else {
      let loginname = topic!.author!.loginname!
      let authorAction = UIAlertAction(title: "查看作者(@" + loginname + ")", style: .default, handler: { action in
        self.performSegue(withIdentifier: "showAuthor", sender: loginname)
      })
      alertController.addAction(authorAction)
    }
    
    let collectAction = UIAlertAction(title: "收藏", style: .default, handler: { action in
      APIRequest.collectTopic(topic_id: self.topicId, callback: { (err: String?) in
        if err != nil {
          Toaster.showToast(str: err!)
          return
        }
        Toaster.showToast(str: "收藏成功")
      })
    })
    alertController.addAction(collectAction)
    
    let commentAction = UIAlertAction(title: "评论", style: .default, handler: { action in
      self.performSegue(withIdentifier: "createComment", sender: nil)
    })
    alertController.addAction(commentAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 编辑帖子
    if segue.identifier == "editTopic" {
      let nav = segue.destination as! UINavigationController
      let destViewController = nav.topViewController as! TopicCreateViewController
      destViewController.topic = sender as? Topic
      destViewController.delegateTopicViewController = self
    }
    
    // 创建评论
    if segue.identifier == "createComment" {
      let nav = segue.destination as! UINavigationController
      let destViewController = nav.topViewController as! CommentCreateViewController
      destViewController.topicId = topicId
      destViewController.delegateTopicViewController = self
    }
    
    // 回复评论
    if segue.identifier == "createReplyComment" {
      let nav = segue.destination as! UINavigationController
      let destViewController = nav.topViewController as! CommentCreateViewController
      destViewController.topicId = topicId
      destViewController.comment = sender as! Comment
      destViewController.delegateTopicViewController = self
    }
    
    // 显示作者
    if segue.identifier == "showAuthor" {
      let destViewController = segue.destination as! UserViewController
      destViewController.loginname = sender as! String
    }
  }
  
  // 加载帖子详情
  func loadTopic () {
    SVProgressHUD.show()
    APIRequest.getTopic(id: topicId, callback: { (err: String?, topic: Topic?) in
      if err != nil {
        Toaster.showToast(str: err!)
        SVProgressHUD.dismiss()
        return
      }
      self.topic = topic
      self.headerCell!.topic = topic
      // 替换 //，否则不能正常显示
      let content = topic!.content?.replacingOccurrences(of: "//dn-cnode.qbox.me", with: "http://dn-cnode.qbox.me")
      self.contentCell!.content = content
      // 为了调用 tableView.reloadData()，把 onRendered 监听器放到这
      self.contentCell!.topicContentView.onRendered = { [weak self] height in
        // 由于 topicContentView 添加了上下约束各 10px，所以这里 height 要加 20，否则会显示不全。。
        self?.contentCellHeight = height + 20
        self?.tableView.reloadData()
        SVProgressHUD.dismiss()
      }
      // 点击链接
      self.contentCell!.topicContentView.onTouchLink = { [weak self] request in
        guard let url = request.url else { return false }
        if url.scheme == "http" || url.scheme == "https" {
          let webViewController = SFSafariViewController(url: url)
          self?.present(webViewController, animated: true, completion: nil)
        }
        return false
      }
    })
  }
}
