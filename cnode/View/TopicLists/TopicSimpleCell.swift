//
//  TopicSimple.swift
//  cnode
//
//  Created by nswbmw on 2018/4/24.
//  Copyright © 2018年 nswbmw. All rights reserved.
//


import UIKit
import Kingfisher

class TopicSimpleCell: UITableViewCell {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var loginnameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  var topic: Topic? {
    didSet {
      avatarImage.kf.setImage(with: URL(string: (topic!.author?.avatar_url!)!), placeholder: nil)
      loginnameLabel.text = topic!.author?.loginname
      descriptionLabel.text = "最后更新 " + topic!.last_reply_at!.timeAgo()
      titleLabel.text = topic!.title
    }
  }
}
