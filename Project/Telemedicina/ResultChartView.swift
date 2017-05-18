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
    
    //private var titleLabel: UILabel!
    
    private var titleHeight: CGFloat!
    
    private var bottomHeight: CGFloat!
    
    private var chartHeight: CGFloat!
    
    var xPositions = [(xPos: CGFloat, resultDate: String)]() {
        
        didSet {
            
            addXAxisLabels()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        titleHeight = self.frame.height / 9 * 2
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            
            chartHeight = self.frame.height / 9 * 6
            bottomHeight = self.frame.height / 9
            
        } else {
            
            chartHeight = self.frame.height / 9 * 5
            bottomHeight = self.frame.height / 9 * 2
        }
        
        addTitleinformations()
        
        chartLineView = ChartLineView(frame: CGRect(
            x: 0,
            y: titleHeight,
            width: self.frame.width,
            height: chartHeight)
        )
        
        chartLineView.backgroundColor = UIColor.clear
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        self.addSubview(chartLineView)
        
        GradientLayerGenerator.SetDefaultGradientColorTo(view: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTitleinformations() {
        
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
        
        let labelWidth = self.frame.width / 2
        
        createTitleLabel(withHeight: titleHeight / 2)
        createSexTypeLabel(toPoint: CGPoint(x: labelWidth, y: 0))
        createAgeLabel(toPoint: CGPoint(x: labelWidth, y: self.subviews[0].frame.maxY))
        createAvarageLabel(withTextAlignment: NSTextAlignment.left, toPoint: CGPoint(x: 5, y: self.subviews[0].frame.maxY), withHeight: titleHeight / 2)
    }
    
    private func drawLandscapeMode() {
        
        createTitleLabel(withHeight: titleHeight)
        createAvarageLabel(withTextAlignment: NSTextAlignment.right, toPoint: CGPoint(x: self.frame.width / 2, y: 0), withHeight: titleHeight)
    }
    
    private func createTitleLabel(withHeight height: CGFloat) {
        
        let titleLabel = UILabel(frame: CGRect(
            x: 5,
            y: 0,
            width: self.frame.width / 2 - 10,
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
            width: self.frame.width / 2 - 10,
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
        
        for currentXPos in xPositions {
            
            let label = UILabel(frame: CGRect(
                x: currentXPos.xPos - labelWidth / 2,
                y: chartLineView.frame.maxY + 2,
                width: labelWidth,
                height: bottomHeight - 4)
            )
            
            label.adjustsFontSizeToFitWidth = true
            label.transform = CGAffineTransform(rotationAngle:  -1 * (CGFloat.pi / 4))
            label.textColor = UIColor.white
            label.text = currentXPos.resultDate
            
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
        
        UIColor.white.set()
        addSeparatorLines().stroke()
    }

    
    
    
    
}
