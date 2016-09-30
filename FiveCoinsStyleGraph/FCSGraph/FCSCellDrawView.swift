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

    let dotColor = UIColor.white.cgColor

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
        self.backgroundColor = UIColor.clear
    }

    func drawDotAtY(y: Float, previous: Float) {
        self.dotY = CGFloat(y)
        self.previous = CGFloat(previous)
        self.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let y = self.dotY, let prevY = previous else {
            return
        }

        let dotOrigin = CGPoint(x: self.bounds.size.width - FCSCellDrawView.dotDiameter - FCSCellDrawView.dotRadius, y: y)
        let dotSize = CGSize(width: FCSCellDrawView.dotDiameter, height: FCSCellDrawView.dotDiameter)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(dotColor);
        context.setAlpha(1);
        context.fillEllipse(in: CGRect(origin: CGPoint(x: dotOrigin.x, y: dotOrigin.y), size: CGSize(width: dotSize.width, height:dotSize.height)));

        // previous line
        UIGraphicsGetCurrentContext()!.setStrokeColor(dotColor)
        context.setLineWidth(FCSCellDrawView.lineWidth);

        context.move(to: CGPoint(x: dotOrigin.x + FCSCellDrawView.dotRadius, y: dotOrigin.y + FCSCellDrawView.dotRadius))
        context.addLine(to: CGPoint(x: 0, y: prevY + FCSCellDrawView.dotRadius))

        context.strokePath();
    }
}
