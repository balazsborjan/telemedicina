//
//  ResultChartView.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 21..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit

class ResultChartView: UIView {
    
    private var chartLineView: ChartLineView!
    
    private var titleHeight: CGFloat!
    
    private var bottomHeight: CGFloat!
    
    private var chartHeight: CGFloat!
    
    var xPositions = [(xPos: CGFloat, resultDate: Date)]() {
        
        didSet {
            
            addXAxisLabels()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        
        GradientLayerGenerator.SetDefaultGradientColorTo(view: self)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        let scale = UIApplication.shared.statusBarFrame.height * 2
        
        titleHeight = scale
        chartHeight = self.bounds.height - (2 * scale)
        bottomHeight = scale
        
//        print("scale: \(scale)")
//        print("titleHeight: \(titleHeight)")
//        print("chartHeight: \(chartHeight)")
//        print("bottomHeight: \(bottomHeight)")
//        
//        print("self.bounds.height: \(self.bounds.height)")
//        print("self.frame.height: \(self.frame.height)")
//        print("self.frame.minY: \(self.frame.minY)")
//        print("self.frame.maxY: \(self.frame.maxY)")
        
        addTitleInformations()
        
        chartLineView = ChartLineView(frame: CGRect(
            x: 0,
            y: titleHeight,
            width: self.bounds.width,
            height: chartHeight)
        )
        
//        print("chartLineView.bounds.height: \(chartLineView.bounds.height)")
//        print("chartLineView.frame.height: \(chartLineView.frame.height)")
//        
//        print("chartLineView.minY: \(chartLineView.frame.minY)")
//        print("chartLineView.maxY: \(chartLineView.frame.maxY)")
        
        chartLineView.backgroundColor = UIColor.clear
        
        self.addSubview(chartLineView)
    }
    
    private func addTitleInformations() {
        
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            
            drawPortraitMode()
            
        case .faceUp, .faceDown:
            
            (self.frame.width < self.frame.height) ? drawPortraitMode() : drawLandscapeMode()
            
        default:
            
            drawLandscapeMode()
        }
    }
    
    private func drawPortraitMode() {
        
        let labelWidth = self.bounds.midX
        
        createTitleLabel(withHeight: titleHeight)
        //createSexTypeLabel(toPoint: CGPoint(x: labelWidth, y: 5))
        //createAgeLabel(toPoint: CGPoint(x: labelWidth, y: self.subviews[0].frame.maxY))
        createAvarageLabel(withTextAlignment: NSTextAlignment.right, toPoint: CGPoint(x: labelWidth, y: 5), withHeight: titleHeight)
    }
    
    private func drawLandscapeMode() {
        
        let labelWidth = self.frame.midX
        
        createTitleLabel(withHeight: titleHeight)
        createAvarageLabel(withTextAlignment: NSTextAlignment.right, toPoint: CGPoint(x: labelWidth, y: 0), withHeight: titleHeight)
    }
    
    private func createTitleLabel(withHeight height: CGFloat) {
        
        let titleLabel = UILabel(frame: CGRect(
            x: 5,
            y: 5,
            width: self.bounds.midX - 10,
            height: height)
        )
        
        titleLabel.text = patient?.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.white
        
        self.addSubview(titleLabel)
    }
    
    private func createAvarageLabel(withTextAlignment textAlignment: NSTextAlignment, toPoint point: CGPoint, withHeight height: CGFloat) {
        
        let avaragePoint = calculateAvarage()
        
        let avarageLabel = UILabel(frame: CGRect(
            x: point.x,
            y: point.y,
            width: self.bounds.midX - 10,
            height: height)
        )
        
        avarageLabel.text = "Átlag: \(avaragePoint)"
        avarageLabel.font = avarageLabel.font.withSize(16)
        avarageLabel.textAlignment = textAlignment
        avarageLabel.textColor = UIColor.white
        
        self.addSubview(avarageLabel)
    }
    
    private func createSexTypeLabel(toPoint point: CGPoint) {
    
        var sexType: String!
        
        if patient!.sexType == 0 {
            
            sexType = "Nő"
        
        } else {
            
            sexType = "Férfi"
        }
        
        let sexTypeLabel = UILabel(frame: CGRect(
            x: point.x,
            y: point.y,
            width: self.frame.width / 2 - 10,
            height: titleHeight / 2)
        )
        
        sexTypeLabel.text = "Nem: \(sexType!)"
        sexTypeLabel.font = sexTypeLabel.font.withSize(16)
        sexTypeLabel.textAlignment = .right
        sexTypeLabel.textColor = UIColor.white
        
        self.addSubview(sexTypeLabel)
    }
    
    private func createAgeLabel(toPoint point: CGPoint) {
        
        let age = Date.getPatientAge()
        
        let ageLabel = UILabel(frame: CGRect(
            x: point.x,
            y: point.y,
            width: self.frame.width / 2 - 10,
            height: titleHeight / 2)
        )
        
        ageLabel.text = "Életkor: \(age)"
        ageLabel.font = ageLabel.font.withSize(16)
        ageLabel.textAlignment = .right
        ageLabel.textColor = UIColor.white
        
        self.addSubview(ageLabel)
    }
    
    private func calculateAvarage() -> Int {
        
        var avg = Int32(0)
        
        if let results = (patient!.results?.allObjects as? [Result]) {
        
            for r in results {
                
                avg = avg + r.point
            }
            
            if avg == 0 {
                
                return 0
                
            } else {
                
                return Int(avg) / results.count
            }
        }
        
        return 0
    }
    
    func setResultSet(resultSet: [Result]) {
        
        chartLineView.resultSet = resultSet
    }
    
    private func addXAxisLabels() {
        
        let maxLabelWidth = CGFloat(40)
        var labelWidth: CGFloat!
        
        if xPositions.count > 1 {
            
            labelWidth = (xPositions[1].xPos - xPositions[0].xPos) / 2
            
            if labelWidth > maxLabelWidth {
                
                labelWidth = maxLabelWidth
            }
        
        } else {
            
            labelWidth = maxLabelWidth
        }
        
        var actualMonth: String?
        
        if xPositions.count > 0 {
            
            actualMonth = xPositions[0].resultDate.getMonth()
        }
        
        for i in 0..<xPositions.count {
            
            let label: UILabel!
            
            if i == 0 {
                
                label = UILabel(frame: CGRect(
                    x: xPositions[i].xPos - labelWidth,
                    y: chartLineView.frame.maxY + 2,
                    width: labelWidth * 1.5,
                    height: bottomHeight - 4)
                )
                
            } else {
                
                label = UILabel(frame: CGRect(
                    x: xPositions[i].xPos - labelWidth / 2,
                    y: chartLineView.frame.maxY + 2,
                    width: labelWidth,
                    height: bottomHeight - 4)
                )
            }
            
            let currentMonth = xPositions[i].resultDate.getMonth()
            
            if actualMonth == nil {
                
                actualMonth = currentMonth
            }
            
            if i == 0 || currentMonth != actualMonth! {
            
                label.text = xPositions[i].resultDate.getMonthAndDay()
                
            } else {
                
                label.text = xPositions[i].resultDate.getDay()
            }
            
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.textColor = UIColor.white
            
            
            self.addSubview(label)
        }
    }
    
    private func addSeparatorLines() -> UIBezierPath {
        
        let separator = UIBezierPath()
        
        separator.lineWidth = 2
        
        separator.move(to: CGPoint(x: 5, y: titleHeight))
        separator.addLine(to: CGPoint(x: self.frame.width - 10, y: titleHeight))
        
        separator.move(to: CGPoint(x: 5, y: titleHeight + chartHeight))
        separator.addLine(to: CGPoint(x: self.frame.width - 10, y: titleHeight + chartHeight))
        
        return separator
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.white.set()
        //addSeparatorLines().stroke()
    }

    
    
    
    
}
