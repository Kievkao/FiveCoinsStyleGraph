//
//  FCSCellDrawView.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/10/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class FCSCellDrawView: UIView {

    static let dotDiameter: CGFloat = 5.0
    static let dotRadius = FCSCellDrawView.dotDiameter/2
    static let lineWidth: CGFloat = 1.0

    let dotColor = UIColor.whiteColor().CGColor

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
        let dotOrigin = CGPoint(x: self.bounds.size.width - FCSCellDrawView.dotDiameter - FCSCellDrawView.dotRadius, y: y)
        let dotSize = CGSize(width: FCSCellDrawView.dotDiameter, height: FCSCellDrawView.dotDiameter)

        let context = UIGraphicsGetCurrentContext()

        CGContextSetFillColorWithColor(context, dotColor);
        CGContextSetAlpha(context, 1);
        CGContextFillEllipseInRect(context, CGRectMake(dotOrigin.x, dotOrigin.y, dotSize.width, dotSize.height));

        // previous line
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), dotColor)
        CGContextSetLineWidth(context, FCSCellDrawView.lineWidth);

        CGContextMoveToPoint(context, dotOrigin.x + FCSCellDrawView.dotRadius, dotOrigin.y + FCSCellDrawView.dotRadius);
        CGContextAddLineToPoint(context, 0, prevY + FCSCellDrawView.dotRadius);

        CGContextStrokePath(context);
    }
}
