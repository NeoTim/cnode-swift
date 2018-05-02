//
//  CommentCreateViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/25.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import Eureka

class CommentCreateViewController: FormViewController {
  var topicId: String = ""
  var comment: Comment?
  var delegateTopicViewController: TopicViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let cancelBtn = UIBarButtonItem(title: "取消",
                                    style: UIBarButtonItemStyle.plain,
                                    target: self,
                                    action: #selector(TopicCreateViewController.cancelCreate))
    navigationItem.leftBarButtonItem = cancelBtn
    
    let createBtn = UIBarButtonItem(title: "评论",
                                    style: UIBarButtonItemStyle.plain,
                                    target: self,
                                    action: #selector(TopicCreateViewController.tapCreate))
    navigationItem.rightBarButtonItem = createBtn
    
    form +++ Section("引用评论") { section in
      if comment == nil {
        section.hidden = true
      }
    }
      <<< TextAreaRow(){ row in
        if comment == nil {
          return
        }
        row.value = comment!.author!.loginname! + ": " + comment!.content! + " "
        row.textAreaHeight = .dynamic(initialTextViewHeight: 0)
        row.disabled = true
      }
    +++ Section("评论内容")
      <<< TextAreaRow("content"){ row in
        if comment != nil {
          row.value = "@" + comment!.author!.loginname! + " "
        }
        row.textAreaHeight = .dynamic(initialTextViewHeight: 300)
        row.add(rule: RuleRequired())
      }
  }
  
  // 取消发布
  @objc func cancelCreate () {
    self.dismiss(animated: true, completion: nil)
  }
  
  // 点击发布
  @objc func tapCreate () {
    guard let content = form.rowBy(tag: "content")?.baseValue else {
      Toaster.showToast(str: "请填写内容")
      return
    }
    var newContent = content as! String
    let isTailOn = Util.getTailState()
    if isTailOn {
      newContent += """
      
      via [CNode](https://github.com/nswbmw/cnode-swift)
      """
    }
    
    APIRequest.createComment(topic_id: topicId, reply_id: comment?.id, content: newContent, callback: { (err: String?, topic_id: String?) in
      if err != nil {
        Toaster.showToast(str: err!)
        return
      }
      self.dismiss(animated: true, completion: nil)
      Toaster.showToast(str: "评论成功")
      self.delegateTopicViewController?.loadTopic()
    })
  }
}
