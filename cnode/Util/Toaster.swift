//
//  Toaster.swift
//  cnode
//
//  Created by nswbmw on 2018/4/19.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import Toaster

class Toaster {
  static func showToast(str: String) {
    Toast.makeText(str, duration: 3).show()
  }
}
