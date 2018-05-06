//
//  LoginViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/5/2.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import SwiftQRScanner
import Eureka
import SVProgressHUD

class LoginViewController: FormViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 扫码
    // app store 审核
    APIRequest.isChecking(callback: { checking in
      print("isCehcking: " + String(checking))
      if checking == false {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "scan"),
                                                                 landscapeImagePhone: nil,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(self.scanTap))
      }
    })

    // 表单
    form +++ Section()
      <<< TextRow("username"){ row in
        row.title = "用户名"
        row.placeholder = "username"
        row.add(rule: RuleRequired())
      }
      <<< PasswordRow("password"){ row in
        row.title = "密码"
        row.placeholder = "password"
        row.add(rule: RuleRequired())
      }
    +++ Section()
      <<< ButtonRow() {
          $0.title = "登录"
        }
        .onCellSelection { cell, row in
          guard let username = self.form.rowBy(tag: "username")?.baseValue else {
            Toaster.showToast(str: "请填写用户名")
            return
          }
          guard let password = self.form.rowBy(tag: "password")?.baseValue else {
            Toaster.showToast(str: "请填写密码")
            return
          }
          SVProgressHUD.show()
          APIRequest.login(username: username as! String, password: password as! String, callback: { (err: String?, accessToken: String?) in
            if err != nil {
              Toaster.showToast(str: err!)
              SVProgressHUD.dismiss()
              return
            }
            self.doLogin(accessToken: accessToken!)
          })
        }
    +++ Section()
      <<< ButtonRow() {
          $0.title = "阅读《隐私协议》"
        }
        .onCellSelection { cell, row in
          let agreementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "agreementViewController")
          self.navigationController?.pushViewController(agreementViewController, animated: true)
        }
  }
  
  func doLogin (accessToken: String) {
    APIRequest.checkAccessToken(accessToken: accessToken, callback: { (err: String?, userDic: [String: String]?) in
      if err != nil {
        Toaster.showToast(str: err!)
        return
      }
      Util.setUserInfo(userDic: userDic!)
      let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootViewController")
      self.present(rootViewController, animated: true, completion: nil)
      SVProgressHUD.dismiss()
      Toaster.showToast(str: "登录成功")
    })
  }

  @objc func scanTap() {
    let scanner = QRCodeScannerController()
    scanner.delegate = self
    self.present(scanner, animated: true, completion: nil)
  }

}

extension LoginViewController: QRScannerCodeDelegate {
  // 扫码成功
  func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
    doLogin(accessToken: result)
  }
  
  // 扫码失败
  func qrScannerDidFail(_ controller: UIViewController, error: String) {
    Toaster.showToast(str: error)
  }
  
  // 取消扫码
  func qrScannerDidCancel(_ controller: UIViewController) {
    Toaster.showToast(str: "已取消扫码登录")
  }
}
