//
//  RDTextField.swift
//  Whistle
//
//  Created by Lu Cao on 7/7/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

class RDTextField: UITextField {
    
    override func drawTextInRect(rect: CGRect) {
        let newRect = CGRectMake(10, -10, rect.width-20, rect.height+20)
        super.drawTextInRect(newRect)
    }
}
