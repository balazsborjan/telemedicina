//
//  TestView.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 04. 26..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit

class TestView: UIView {

    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(
            x: self.frame.width / 5,
            y: 0,
            width: self.frame.width / 5,
            height: self.frame.width / 5)
        )
        
        self.addSubview(imageView)
        
        label = UILabel(frame: CGRect(
            x: imageView.frame.maxX,
            y: imageView.frame.minY,
            width: self.frame.width / 5 * 3,
            height: imageView.frame.height)
        )
        
        label.textAlignment = .left
        
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
