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
    
    var tableView: UITableView?
    
    let newOperationButton = UIButton()
    
    let showAllDataButton = UIButton()
    
    var resultInfoData: Array<(String, String)>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let minResult = Array(patient!.results!).map { ($0 as! Result).point }.min()
        
        let maxResult = patient!.results!.map { ($0 as! Result).point }.max()
        
        let avgResult =  patient!.results!.map { ($0 as! Result).point }.average
        
        resultInfoData = [
            ("Legalacsonyabb pont", String(describing: minResult ?? 0)),
            ("Legmagasabb pont", String(describing: maxResult ?? 0)),
            ("Átlag", String(avgResult))
        ]
        
        newOperationButton.setTitle("Új vizsgálat indítása", for: .normal)
        newOperationButton.setTitleColor(self.view.tintColor, for: .normal)
        showAllDataButton.setTitle("Összes adat megtekintése", for: .normal)
        showAllDataButton.setTitleColor(self.view.tintColor, for: .normal)
        
        newOperationButton.addTarget(self, action: #selector(newOperationButtonClick(sender:)), for: .touchUpInside)
        showAllDataButton.addTarget(self, action: #selector(showAllDataButtonClick(sender:)), for: .touchUpInside)
        
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addSubviews()
    }
    
    @objc private func showAllDataButtonClick(sender: UIButton) {
        
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc private func newOperationButtonClick(sender: UIButton) {
        
        print("new operation")
    }
    
    private func addSubviews() {
        
        drawChartViewByOrientation()
        initTableViewByOrientation()
    }
    
    private func initTableViewByOrientation() {
        
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            
            addTableView()
            
        case .faceUp, .faceDown:
            
            (self.view.frame.width < self.view.frame.height) ? addTableView() : tableView?.removeFromSuperview()
            
        default:
            
            tableView?.removeFromSuperview()
        }
    }
    
    private func addTableView() {
        
        self.view.addSubview(tableView ?? initTableView())
        
    }
    
    private func initTableView() -> UITableView {
        
        let navBarBottomPos = (self.navigationController?.navigationBar.frame.maxY)!
        let tabBarTopPos = (self.tabBarController?.tabBar.frame.minY)!
        
        tableView = UITableView(frame: CGRect(
            x: 0,
            y: (tabBarTopPos + navBarBottomPos) / 2,
            width: self.view.frame.width,
            height: (tabBarTopPos - navBarBottomPos) / 2 - 20)
        )
        
        tableView?.isScrollEnabled = false
        tableView?.allowsSelection = false
        
        tableView?.rowHeight = (tableView?.frame.height)! / 7
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        setInfoTableViewHeaderSeparator()
        
        return tableView!
    }
    
    private func setInfoTableViewHeaderSeparator() {
        
        if tableView != nil {
            
            let px = 1 / UIScreen.main.scale
            let frame =  CGRect(x: 0, y: 0, width: self.tableView!.frame.width, height: px)
            let line = UIView(frame: frame)
            self.tableView!.tableHeaderView = line
            line.backgroundColor = self.tableView!.separatorColor
        }
    }
    
    private func drawChartViewByOrientation() {
        
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            
            drawChartView(chartViewHeightScale: CGFloat(2))
            
        case .faceUp, .faceDown:
            
            (self.view.frame.width < self.view.frame.height) ? drawChartView(chartViewHeightScale: CGFloat(2)) : drawChartView(chartViewHeightScale: nil)
            
        default:
            
            drawChartView(chartViewHeightScale: nil)
        }
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
                //height: self.view.frame.height / 3)
            )
            
            if patient!.results != nil {
                
                let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
                
                chartView.setResultSet(resultSet: (patient!.results!.sortedArray(using: [sortDescriptor]) as! [Result]))
                
                //let slice : Array<Result> = Array((patient!.results!.sortedArray(using: [sortDescriptor]) as! [Result])[0...6])
                //chartView.setResultSet(resultSet: slice as! [Result])
            }
        }
        
        self.view.addSubview(chartView)
    }
}

extension ResultChartViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row < 3 {
            
            cell = UITableViewCell(style: .value1, reuseIdentifier: "chartInfoTableViewCell")
            
            if resultInfoData != nil {
                
                cell.textLabel?.text = resultInfoData![indexPath.row].0
                cell.detailTextLabel?.text = resultInfoData![indexPath.row].1
            }
            
        } else {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "chartInfoTableViewCell")
            
            switch indexPath.row {
            case 4:
                newOperationButton.frame = cell.contentView.frame
                newOperationButton.bounds = cell.contentView.bounds
                cell.contentView.addSubview(newOperationButton)
            case 6:
                showAllDataButton.frame = cell.contentView.frame
                cell.contentView.addSubview(showAllDataButton)
            default:
                break
            }
        }
        
        if indexPath.row > 1 {
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
}

extension Array where Element == Int32 {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(count)
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
