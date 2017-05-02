//
//  TestViewController.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 04. 26..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    var selectTestView: TestView!
    var newTestView: TestView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        
        self.view.contentMode = .redraw
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        initViews()
    }
    
    private func initViews() {
        
        if selectTestView != nil && newTestView != nil {
            
            selectTestView.removeFromSuperview()
            newTestView.removeFromSuperview()
        }
        
        selectTestView = TestView(frame: CGRect(
            x: 0,
            y: self.view.frame.height / 5 + (self.navigationController?.navigationBar.frame.height)!,
            width: self.view.frame.width,
            height: self.view.frame.height / 5)
        )
        
        selectTestView.imageView.image = #imageLiteral(resourceName: "select")
        selectTestView.label.text = "Beteg kiválasztása"
        selectTestView.label.textColor = self.view.tintColor
        
        newTestView = TestView(frame: CGRect(
            x: 0,
            y: self.view.frame.height / 5 * 3 + (self.navigationController?.navigationBar.frame.height)!,
            width: self.view.frame.width,
            height: self.view.frame.height / 5)
        )
        
        newTestView.imageView.image = #imageLiteral(resourceName: "add")
        newTestView.label.text = "Beteg felvétele"
        newTestView.label.textColor = self.view.tintColor
        
        self.view.addSubview(selectTestView)
        self.view.addSubview(newTestView)
    }

}
