//
//  OperationNavigationViewController.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 05. 18..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit

//DEPRICATED
//class OperationNavigationViewController: UINavigationController {
//
//    @IBOutlet var customNavigationBar: UINavigationBar!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        customNavigationBar.delegate = self
//    }
//}
//
//extension OperationNavigationViewController : UINavigationBarDelegate {
//    
//    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
//        
//        for viewController in self.viewControllers {
//            
//            if viewController is OperationViewController {
//                
//                if let operationTabBarController = self.visibleViewController as? OperationTabBarController {
//                    
//                    if let operationTableViewController = operationTabBarController.selectedViewController as? OperationTableViewController {
//                        
//                        //operationTableViewController.cancelOperation()
//                        return false
//                    }
//                }
//            }
//        }
//        
//        popViewController(animated: true)
//        
//        return true
//    }
//}
