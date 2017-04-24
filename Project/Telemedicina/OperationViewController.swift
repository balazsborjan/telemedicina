//
//  OperationViewController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 13..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit

class OperationViewController: UIViewController {

    var navigateBackToMainController = false
    
    var mainVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if navigateBackToMainController {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            mainVC = storyBoard.instantiateViewController(withIdentifier: "mainVC")
            
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "Kezdőoldal", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = newBackButton
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        
        if mainVC != nil {
            
            self.navigationController?.pushViewController(mainVC!, animated: true)
        }
    }
    
}
