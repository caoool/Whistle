//
//  RDLabel.swift
//  Whistle
//
//  Created by Lu Cao on 7/5/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

class RDLabel: UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        let newRect = CGRectMake(10, 0, rect.width-20, rect.height)
        super.drawTextInRect(newRect)
    }
}