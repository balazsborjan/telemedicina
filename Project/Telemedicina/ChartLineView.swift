//
//  ChartLineView.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 22..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit

class ChartLineView: UIView {

    var resultSet = [Result]() { didSet { setNeedsDisplay() } }
    
    private var lineColor: UIColor = UIColor.white { didSet { setNeedsDisplay() } }
    
    private var separatorLine = UIBezierPath()
    
    private let maximumXAxisScale = CGFloat(10)
    
    private let maximumYValue = CGFloat(80)
    
    private var ySubLines = UIBezierPath()
    
    private var xPositions = [(xPos: CGFloat, resultDate: Date)]()
    
    
    private func pathForChartLine() -> UIBezierPath {
        
        let chartLine = UIBezierPath()
        
        chartLine.lineWidth = 5.0
        
        var currentXPos: CGFloat!
        
        var currentYPos: CGFloat!
        
        let maximumWithRange = self.frame.width / maximumXAxisScale
        
        let heightRange = self.frame.height / CGFloat(maximumYValue)
        
        var widthRange = self.frame.width / 8.0 //CGFloat(resultSet.count + 1)
        
        if widthRange < maximumWithRange {
            
            widthRange = maximumWithRange
        }
        
        xPositions.removeAll()
        
        var i = 0
        
        for currentResult in resultSet.reversed() {
            
            //let currentResult = resultSet[i]
            
            currentXPos = self.frame.maxX - (widthRange * CGFloat(i + 1)) - 10
            currentYPos = self.bounds.maxY - (heightRange * CGFloat(currentResult.point)) - 5
            
            //drawLineChart(chartLine: chartLine, currentXPos: currentXPos, currentYPos: currentYPos, currentIndex: i)
            drawBarChart(chartLine: chartLine, currentXPos: currentXPos, currentYPos: currentYPos, currentIndex: i)
            
            let currentDate = currentResult.date! as Date

            xPositions.append((currentXPos, currentDate))
            
            i = i + 1
        }
        
        AddToSuperViewXAxisLabelPositions()
        
        //addYAxisLabels(maximumWithRange)
        addXAxisSeparatorLine()
        
        return chartLine
    }
    
    private func drawLineChart(chartLine: UIBezierPath, currentXPos: CGFloat, currentYPos: CGFloat, currentIndex i : Int) {
        
        if i == 0 {
            
            if resultSet.count == 1 {
                
                chartLine.addArc(withCenter: CGPoint(x: currentXPos, y: currentYPos), radius: CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat.pi * 2, clockwise: true)
                
            } else {
                
                chartLine.move(to: CGPoint(x: currentXPos, y: currentYPos))
            }
            
        } else {
            
            chartLine.addLine(to: CGPoint(x: currentXPos, y: currentYPos))
        }
    }
    
    private func drawBarChart(chartLine: UIBezierPath, currentXPos: CGFloat, currentYPos: CGFloat, currentIndex i : Int) {
    
        chartLine.move(to: CGPoint(x: currentXPos, y: self.bounds.maxY - 5))
        chartLine.addLine(to: CGPoint(x: currentXPos, y: currentYPos))
    }
    
    private func AddToSuperViewXAxisLabelPositions() {
        
        if let resultChartView = self.superview as? ResultChartView {
            
            resultChartView.xPositions = self.xPositions
        }
    }
    
    private func addYAxisLabels(_ maximumWidthRange: CGFloat) {
        
        addYAxisSeparatorLine(maximumWidthRange)
        
        let yAxisLabelTexts = ["20", "40", "60"]
        
        let axisLabelHeight = self.bounds.height / 4
        
        for i in 0..<yAxisLabelTexts.count {
            
            let currentYPos = self.bounds.maxY - (self.bounds.height / 4) * CGFloat(i + 1)
            
            let label = UILabel(frame: CGRect(
                x: 5,
                y: currentYPos - axisLabelHeight / 2,
                width: maximumWidthRange,
                height: axisLabelHeight)
            )
            
            label.textAlignment = .center
            label.text = yAxisLabelTexts[i]
            //label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            label.adjustsFontSizeToFitWidth = false
            label.textColor = UIColor.white
            
            self.addSubview(label)

            addYSubLine(from: CGPoint(x: maximumWidthRange, y: currentYPos))
        }
    }
    
    private func addYAxisSeparatorLine(_ maximumWithRange: CGFloat) {
        
        let separatorLineYStartPos = CGFloat(0)
        let separatorLineYEndPos = self.frame.height
        
        separatorLine = UIBezierPath()
        
        separatorLine.move(to: CGPoint(x: maximumWithRange, y: separatorLineYStartPos))
        separatorLine.addLine(to: CGPoint(x: maximumWithRange, y: separatorLineYEndPos))
    }
    
    private func addYSubLine(from startPoint: CGPoint) {
        
        ySubLines.move(to: startPoint)
        ySubLines.addLine(to: CGPoint(x: self.bounds.maxX - 10, y: startPoint.y))
    }
    
    private func addXAxisSeparatorLine() {
        
        separatorLine.move(to: CGPoint(x: 5, y: 0))
        separatorLine.addLine(to: CGPoint(x: self.bounds.maxX - 10, y: 0))
        
        separatorLine.move(to: CGPoint(x: 5, y: self.bounds.maxY))
        separatorLine.addLine(to: CGPoint(x: self.bounds.maxX - 10, y: self.bounds.maxY))
    }
    
    override func draw(_ rect: CGRect) {
        
        lineColor.setStroke()
        lineColor.setFill()
        
        let chartLine = pathForChartLine()
        
        chartLine.lineJoinStyle = .round
        
        chartLine.lineCapStyle = .round
        
        chartLine.stroke()
        
        separatorLine.stroke()
//        
//        ySubLines.lineWidth = 1
//        
//        ySubLines.stroke()
    }

}
