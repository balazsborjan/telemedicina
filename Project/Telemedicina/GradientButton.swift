//
//  GradientButton.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 05. 18..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit

class GradientButton: UIButton {

    let btnGradient = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        
        btnGradient.frame = self.bounds
        btnGradient.colors = [UIColor.chartViewColor0().cgColor, UIColor.chartViewColor1().cgColor, UIColor.chartViewColor2().cgColor]
        btnGradient.locations = [0.3, 0.5, 0.9]
        self.layer.insertSublayer(btnGradient, at: 0)
        
        self.contentEdgeInsets.left = 10
        self.contentEdgeInsets.right = 10
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.layer.sublayers?.remove(at: 0)
        btnGradient.frame = self.bounds
        self.layer.insertSublayer(btnGradient, at: 0)
    }

}
