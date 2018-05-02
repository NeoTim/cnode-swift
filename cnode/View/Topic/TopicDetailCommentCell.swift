//
//  TopicDetailCommnetCell.swift
//  cnode
//
//  Created by nswbmw on 2018/4/19.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyMarkdown

class TopicDetailCommentCell: UITableViewCell {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var loginnameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var commentTextView: UITextView!
  
  var authorName: String?
  var level: Int? = 0
  var comment: Comment? {
    didSet {
      avatarImage.kf.setImage(with: URL(string: (comment!.author?.avatar_url!)!), placeholder: nil)
      let commentAuthorName = comment!.author?.loginname
      loginnameLabel.text = commentAuthorName == authorName ? commentAuthorName! + "(作者)" : commentAuthorName
      if comment?.ups?.count != nil && comment!.ups!.count > 0 {
        descriptionLabel.text = "#" + String(level!) + " • " + comment!.create_at!.timeAgo() + " • ♥ " + String(comment!.ups!.count)
      } else {
        descriptionLabel.text = "#" + String(level!) + " • " + comment!.create_at!.timeAgo()
      }
      // trim
      let md = SwiftyMarkdown(string: comment!.content!.trimmingCharacters(in: .whitespacesAndNewlines))
      md.body.fontSize = 15
      commentTextView.attributedText = md.attributedString()
    }
  }
}
