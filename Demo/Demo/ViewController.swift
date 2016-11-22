//
//  ViewController.swift
//  Demo
//
//  Created by DaveTech on 2016/11/22.
//  Copyright © 2016年 DaveTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circularProgressView: CircularProgress!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startClick(_ sender: UIButton) {
        circularProgressView.start()
    }
    @IBAction func StopClick(_ sender: UIButton) {
        circularProgressView.stop()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

