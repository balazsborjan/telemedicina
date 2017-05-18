//
//  ResultsTabBarController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 20..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit

class ResultsTabBarController: UITabBarController {

    var backBarButtonChangeNeeded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor(red: 251, green: 15, blue: 68)
        self.tabBar.backgroundColor = UIColor.white
        
        if backBarButtonChangeNeeded {
            
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "Adatlap", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = newBackButton
        }
    }
    
    @objc private func back() {

        for viewController in (self.navigationController?.viewControllers)! {
            
            if viewController is OperationViewController {
                
                self.navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }
}
