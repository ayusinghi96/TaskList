//
//  Gradient.swift
//  TaskManager
//
//  Created by Ayush on 23/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class Gradient: UIView {
    
    var gradientLayer: CAGradientLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        gradientLayer = CAGradientLayer()
        let colorBottom = UIColor.white.cgColor
        let colorTop = UIColor(named: "Primary")!.cgColor
        colorTop.copy(alpha: 0.2)
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        gradientLayer.frame = frame
    }
    
}
