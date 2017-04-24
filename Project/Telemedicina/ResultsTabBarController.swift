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
            let newBackButton = UIBarButtonItem(title: "Új vizsgálat", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = newBackButton
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if let operationVC = storyBoard.instantiateViewController(withIdentifier: "operationVC") as? OperationViewController {
            
            operationVC.navigateBackToMainController = true
            self.navigationController?.pushViewController(operationVC, animated: true)
        }
    }

}
