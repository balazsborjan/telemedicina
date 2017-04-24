//
//  OperationTableViewController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 20..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit
import CoreData

extension UIApplication {
    
    var statusBarView: UIView? {
        
        return value(forKey: "statusBar") as? UIView
    }
}

class OperationTableViewController: UITableViewController {

    var points: Int = 0
    
    var fetchedWords = Dictionary<String, Array<String>>()
    
    var isSelectionEnabled = true
    
    var adjustForTabbarInsets: UIEdgeInsets!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInsets()
        
        let finishOperationBarButtonItem = UIBarButtonItem(title: "Kész", style: .plain, target: self, action: #selector(finishOperation))
        
        self.tabBarController?.navigationItem.setRightBarButton(finishOperationBarButtonItem, animated: true)
        
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        self.tabBarController?.title = self.tabBarItem.title
        
        self.tableView.contentMode = .redraw
        
        self.fetchedWords = ((self.tabBarController as? OperationTabBarController)?.fetchedWords)!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setInsets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setInsets() {
        
        adjustForTabbarInsets = UIEdgeInsetsMake((self.navigationController?.navigationBar.frame.maxY)!, 0, 0, 0);
        
        self.tableView.contentInset = adjustForTabbarInsets;
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
    }
    
    @objc private func finishOperation() {
        
        let finishOperationAlert = UIAlertController(
            title: "Vizsgálat befejezése",
            message: "Biztosan befejezi az aktuális vizsgálatot?", preferredStyle: .alert)
        
        finishOperationAlert.addAction(UIAlertAction(title: "Mégsem", style: .cancel, handler: { (action: UIAlertAction) in
            //Do nothing
        }))
        
        finishOperationAlert.addAction(UIAlertAction(title: "Befejezés", style: .default, handler: { (action: UIAlertAction) in
            
            self.isSelectionEnabled = false
            
            if let tabBarC = self.tabBarController as? OperationTabBarController {
             
                tabBarC.addPoints(self.points)
                
                if tabBarC.currentTabBarItemIndex == (tabBarC.tabBar.items?.count)! - 1 {
                    
                    tabBarC.calculateResult()
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    if let resultVC = storyBoard.instantiateViewController(withIdentifier: "resultVC") as? ResultsTabBarController {
                        
                        resultVC.backBarButtonChangeNeeded = true
                        
                        self.navigationController?.pushViewController(resultVC, animated: true)
                    }
                    
                } else {
                    
                    tabBarC.currentTabBarItemIndex = tabBarC.currentTabBarItemIndex + 1
                    
                    tabBarC.tabBar.items?[tabBarC.currentTabBarItemIndex].isEnabled = true
                    tabBarC.selectedIndex = tabBarC.currentTabBarItemIndex
                }
            }
        }))
        
        self.present(finishOperationAlert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedWords.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return Array(fetchedWords.keys)[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "operationTVC", for: indexPath)

        if let operationTVC = cell as? OperationTableViewCell {
            
            let currentWord = Array(fetchedWords.values)[indexPath.section][indexPath.row]
            
            operationTVC.wordLabel.text = currentWord
            
            if operationTVC.isSelected {
                
                let backgroundView = UIView(frame: (operationTVC.frame))
                
                operationTVC.selectedBackgroundView = backgroundView
                operationTVC.selectedBackgroundView?.backgroundColor = UIColor.green
            }
            
            return operationTVC
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSelectionEnabled {
            
            let cell = tableView.cellForRow(at: indexPath)
            
            let backgroundView = UIView(frame: (cell?.frame)!)
            
            cell?.selectedBackgroundView = backgroundView
            cell?.selectedBackgroundView?.backgroundColor = UIColor.green
            
            self.points = self.points + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if isSelectionEnabled {
            
            let cell = tableView.cellForRow(at: indexPath)
            
            let backgroundView = UIView(frame: (cell?.frame)!)
            
            cell?.selectedBackgroundView = backgroundView
            cell?.selectedBackgroundView?.backgroundColor = UIColor.white
            
            self.points = self.points - 1
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if isSelectionEnabled {
            
            return indexPath
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if isSelectionEnabled {
            
            return indexPath
        }
        
        return nil
    }

}
