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
    
    var dotY: Float?
    
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
    func drawDotAtY(y: Float) {
        self.dotY = y
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        guard let y = self.dotY else {
            return
        }
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, dotColor);
        CGContextSetAlpha(context, 1);
        CGContextFillEllipseInRect(context, CGRectMake(self.bounds.size.width/2, CGFloat(y), dotDiameter, dotDiameter));
    }
    
}
