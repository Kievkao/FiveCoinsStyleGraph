//
//  FCSGraphCollectionViewCell.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/2/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class FCSGraphCollectionViewCell: UICollectionViewCell, IdentifierProvider {
    
    let dotDiameter: CGFloat = 5.0
    let dotColor = UIColor.whiteColor().CGColor
    
    var dotY: CGFloat?
    var previous: CGFloat?
    
    // MARK: View setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: IdentifierProvider protocol
    static func identifier() -> String {
        return "fcsGraphValueCellIdentifier"
    }
    
    // MARK: Drawing
    func drawDotAtY(y: Float, previous: Float) {
        self.dotY = CGFloat(y)
        self.previous = CGFloat(previous)
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        guard let y = self.dotY, prevY = previous else {
            return
        }
        
        // value dot
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, dotColor);
        CGContextSetAlpha(context, 1);
        CGContextFillEllipseInRect(context, CGRectMake(self.bounds.size.width - dotDiameter, y, dotDiameter, dotDiameter));
        
        // previous line
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), dotColor)
        CGContextSetLineWidth(context, 1.0);
        
        CGContextMoveToPoint(context, 0, prevY + dotDiameter/2);
        CGContextAddLineToPoint(context, self.bounds.size.width - dotDiameter/2, y + dotDiameter/2);
        
        CGContextStrokePath(context);
    }
    
}
