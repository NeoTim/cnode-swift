//
//  MessageCell.swift
//  cnode
//
//  Created by nswbmw on 2018/4/21.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyMarkdown

class MessageCell: UITableViewCell {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var loginnameLabel: UILabel!
  @IBOutlet weak var timeAgoLabel: UILabel!
  @IBOutlet weak var commentDescriptionLabel: UILabel!
  @IBOutlet weak var commentContentTextView: UITextView!
  
  var message: Message? {
    didSet {
      avatarImage.kf.setImage(with: URL(string: (message!.author?.avatar_url!)!), placeholder: nil)
      loginnameLabel.text = message!.author?.loginname
      timeAgoLabel.text = message!.create_at!.timeAgo()
      commentDescriptionLabel.text = "在《" + message!.topic!.title! + "》中" + (message!.type == "at" ? " at " : "回复") + "了你："
      // 早期的消息message.reply={}
      if message!.reply?.content == nil {
        commentContentTextView.isHidden = true
      } else {
        let md = SwiftyMarkdown(string: message!.reply!.content!.trimmingCharacters(in: .whitespacesAndNewlines))
        md.body.fontSize = 15
        commentContentTextView.attributedText = md.attributedString()
      }
    }
  }
}
