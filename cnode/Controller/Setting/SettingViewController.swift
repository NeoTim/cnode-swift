//
//  SettingViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/4/26.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import SideMenu
import SafariServices

class SettingViewController: UITableViewController {
  @IBAction func turnTail(_ sender: UISwitch) {
    Util.setTailState(isOn: sender.isOn)
  }
  @IBOutlet weak var tailSwitch: UISwitch!
  @IBOutlet weak var versionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tailSwitch.isOn = Util.getTailState()
    versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      // app store
      if indexPath.row == 1 {
        UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1376632178")!, options: [:], completionHandler: nil)
      }
      // star&issue
      if indexPath.row == 2 {
        guard let url = URL(string: "https://github.com/nswbmw/cnode-swift") else { return }
        let webViewController = SFSafariViewController(url: url)
        present(webViewController, animated: true, completion: nil)
      }
    }
  }
}
