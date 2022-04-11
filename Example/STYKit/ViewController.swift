//
//  ViewController.swift
//  STYKit
//
//  Created by 916878440@qq.com on 04/11/2022.
//  Copyright (c) 2022 916878440@qq.com. All rights reserved.
//

import UIKit
import STYKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .randomColor_ty()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        TYAlertManager.share_ty.oneButton_ty(title: "我是标题", description: "我是描述", buttonName: "知道了", closure: nil).show_ty()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

}

