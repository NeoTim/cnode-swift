//
//  TopicDetailContentCell.swift
//  cnode
//
//  Created by nswbmw on 2018/4/19.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import MarkdownView

class TopicDetailContentCell: UITableViewCell {
  @IBOutlet weak var topicContentView: MarkdownView!
  
  var content: String? {
    didSet {
      topicContentView.load(markdown: content!, enableImage: true)
      topicContentView.isScrollEnabled = false
    }
  }
}
