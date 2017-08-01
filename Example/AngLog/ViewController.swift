//
//  ViewController.swift
//  AngLog
//
//  Created by skyphinehas@hanmail.net on 08/01/2017.
//  Copyright (c) 2017 skyphinehas@hanmail.net. All rights reserved.
//

import UIKit
import AngLog

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Log.d("view")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

