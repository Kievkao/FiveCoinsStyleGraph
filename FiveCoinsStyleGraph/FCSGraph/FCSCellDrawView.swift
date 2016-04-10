//
//  FCSCellDrawView.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/10/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

let dotDiameter: CGFloat = 5.0
let dotColor = UIColor.whiteColor().CGColor

class FCSCellDrawView: UIView {

    var dotY: CGFloat?
    var previous: CGFloat?

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
        let dotOrigin = CGPoint(x: self.bounds.size.width - dotDiameter - dotDiameter/2, y: y)
        let dotSize = CGSize(width: dotDiameter, height: dotDiameter)

        let context = UIGraphicsGetCurrentContext()

        CGContextSetFillColorWithColor(context, dotColor);
        CGContextSetAlpha(context, 1);
        CGContextFillEllipseInRect(context, CGRectMake(dotOrigin.x, dotOrigin.y, dotSize.width, dotSize.height));

        // previous line
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), dotColor)
        CGContextSetLineWidth(context, 1.0);

        CGContextMoveToPoint(context, dotOrigin.x + dotDiameter/2, dotOrigin.y + dotDiameter/2);
        CGContextAddLineToPoint(context, 0, prevY + dotDiameter/2);

        CGContextStrokePath(context);
    }
}
