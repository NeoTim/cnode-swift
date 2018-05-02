//
//  TopicCell.swift
//  cnode
//
//  Created by nswbmw on 2018/4/17.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import Kingfisher

class TopicCell: UITableViewCell {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var loginnameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var tabLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  var topic: Topic? {
    didSet {
      avatarImage.kf.setImage(with: URL(string: (topic!.author?.avatar_url!)!), placeholder: nil)
      loginnameLabel.text = topic!.author?.loginname
      if topic!.reply_count! == 0 {
        descriptionLabel.text = topic!.last_reply_at!.timeAgo() + " • " + String(topic!.visit_count!) + " 阅读"
      } else {
        descriptionLabel.text = topic!.last_reply_at!.timeAgo() + " • " + String(topic!.visit_count!) + " 阅读 • " + String(topic!.reply_count!) + " 评论"
      }
      tabLabel.text = Util.getRealTabName(topic: topic!)
      // 置顶或精华用绿底白字
      if topic!.top! || topic!.good! {
        tabLabel.backgroundColor = UIColor(red: 128/255, green: 189/255, blue: 1/255, alpha: 1)
        tabLabel.textColor = .white
      } else {
        tabLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        tabLabel.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
      }
      titleLabel.text = topic!.title
    }
  }
}
