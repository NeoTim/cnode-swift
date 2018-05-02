//
//  LoginViewController.swift
//  cnode
//
//  Created by nswbmw on 2018/5/2.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import SwiftQRScanner

class LoginViewController: UIViewController {
  @IBOutlet weak var accessTokenTextField: UITextField!
  @IBAction func loginTap(_ sender: Any) {
    doLogin(accessToken: accessTokenTextField.text ?? "")
  }
  @IBAction func agreementTap(_ sender: Any) {
    let agreementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "agreementViewController")
    self.navigationController?.pushViewController(agreementViewController, animated: true)
  }
  @IBAction func scanTap(_ sender: Any) {
    let scanner = QRCodeScannerController()
    scanner.delegate = self
    self.present(scanner, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
      Toaster.showToast(str: "登录成功")
    })
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
