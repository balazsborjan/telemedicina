//
//  ResultChartViewController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 21..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit

class ResultChartViewController: UIViewController {

    var chartView: ResultChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawChartView(chartViewHeightScale: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        drawChartView(chartViewHeightScale: nil)
    }
    
    private func drawChartView(chartViewHeightScale: CGFloat?) {
        
        chartView?.removeFromSuperview()
        
        if patient != nil {
            
            let navBarBottomPos = (self.navigationController?.navigationBar.frame.maxY)!
            let tabBarTopPos = (self.tabBarController?.tabBar.frame.minY)!
            
            chartView = ResultChartView(frame: CGRect(
                x: self.view.frame.origin.x + 10,
                y: navBarBottomPos + 10,
                width: self.view.frame.width - 20,
                height: (tabBarTopPos - navBarBottomPos - 20) / (chartViewHeightScale ?? CGFloat(1)))
            )
            
            if patient!.results != nil {
                
                let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
                
                chartView.setResultSet(resultSet: patient!.results!.sortedArray(using: [sortDescriptor]) as! [Result])
            }
        }
        
        self.view.addSubview(chartView)
    }
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func chartViewColor0() -> UIColor {
        
        return UIColor(red: 248, green: 91, blue: 72)
    }
    
    class func chartViewColor1() -> UIColor {
        
        return UIColor(red: 244, green: 76, blue: 60)
    }
    
    class func chartViewColor2() -> UIColor {
        
        return UIColor(red: 242, green: 35, blue: 36)
    }
}
