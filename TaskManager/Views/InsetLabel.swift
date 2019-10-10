//
//  InsetLabel.swift
//  TaskManager
//
//  Created by Ayush on 30/09/19.
//  Copyright © 2019 FiftyfiveTech. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {

   
    var contentInsets = UIEdgeInsets.zero
    
    var insets : UIEdgeInsets = UIEdgeInsets.zero
    
    func set(text: String, color: UIColor, back: UIColor, padding: Int) {
       
        self.text = text
        self.sizeToFit()
        let f = self.frame
        self.frame = CGRect(x: 0,
                            y: 0, width: Int(f.width)+(padding*2),
                            height: Int(f.height)+(padding*2))
        insets = UIEdgeInsets(top: CGFloat(padding),
                              left: CGFloat(padding),
                              bottom: CGFloat(padding),
                              right: CGFloat(padding))
    }
    override func drawText(in rect: CGRect) {
        
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
