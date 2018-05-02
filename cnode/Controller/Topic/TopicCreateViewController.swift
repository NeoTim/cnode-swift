//
//  TopicCreateViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/25.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import Eureka

class TopicCreateViewController: FormViewController {
  var tab: String = "dev"
  var topic: Topic?
  var delegateTopicViewController: TopicViewController?
  var delegateTopicListsViewController: TopicListsViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let cancelBtn = UIBarButtonItem(title: "取消",
                                    style: UIBarButtonItemStyle.plain,
                                    target: self,
                                    action: #selector(TopicCreateViewController.cancelCreate))
    navigationItem.leftBarButtonItem = cancelBtn
    
    let createBtn = UIBarButtonItem(title: "发布",
                                    style: UIBarButtonItemStyle.plain,
                                    target: self,
                                    action: #selector(TopicCreateViewController.tapCreate))
    navigationItem.rightBarButtonItem = createBtn
    
    form +++ Section("板块")
      <<< PickerInputRow<String>("tab"){
        $0.options = ["测试", "分享", "问答", "招聘"]
        $0.value = topic != nil
          ? Tab(tab: topic!.tab!).rawValue // 编辑帖子则用 topic.tab
          : (["dev", "share", "ask", "job"].contains(tab) ? Tab(tab: tab).rawValue : "测试") // 在某个 tab 下创建话题用这个 tab
        $0.add(rule: RuleRequired())
      }
    +++ Section("描述")
      <<< TextRow("title"){ row in
        row.placeholder = "标题"
        if topic != nil {
          row.value = topic!.title!
        }
        row.add(rule: RuleRequired())
      }
      <<< TextAreaRow("content"){ row in
        row.placeholder = "内容"
        if topic != nil {
          row.value = topic!.content!
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
    let tab = Tab.getTabByName(name: form.rowBy(tag: "tab")?.baseValue as! String)
    guard let title = form.rowBy(tag: "title")?.baseValue else {
      Toaster.showToast(str: "请填写标题")
      return
    }
    guard let content = form.rowBy(tag: "content")?.baseValue else {
      Toaster.showToast(str: "请填写内容")
      return
    }

    if topic == nil {
      // 创建
      APIRequest.createTopic(title: title as! String, tab: tab, content: content as! String, callback: { (err: String?, topicId: String?) in
        if err != nil {
          Toaster.showToast(str: err!)
          return
        }
        self.dismiss(animated: true, completion: nil)
        Toaster.showToast(str: "发布成功")
        let topicViewController = TopicViewController()
        topicViewController.topicId = topicId!
        self.delegateTopicListsViewController?.navigationController?.pushViewController(topicViewController, animated: true)
      })
    } else {
      // 修改
      APIRequest.updateTopic(topic_id: topic!.id!, title: title as! String, tab: tab, content: content as! String, callback: { (err: String?, topicId: String?) in
        if err != nil {
          Toaster.showToast(str: err!)
          return
        }
        self.dismiss(animated: true, completion: nil)
        Toaster.showToast(str: "修改成功")
        self.delegateTopicViewController?.loadTopic()
      })
    }
  }
}
