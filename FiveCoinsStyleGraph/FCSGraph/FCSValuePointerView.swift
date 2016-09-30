//
//  FCSValuePointerView.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/12/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class FCSValuePointerView: UIView {

    let circleLayer = CAShapeLayer()

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
        self.backgroundColor = UIColor.clear

        let path = UIBezierPath(ovalIn: self.bounds)
        self.circleLayer.frame = self.bounds
        self.circleLayer.path = path.cgPath
        self.circleLayer.strokeColor = UIColor.white.cgColor
        self.circleLayer.fillColor = UIColor.clear.cgColor
        self.circleLayer.lineDashPattern = [5]
        self.circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.circleLayer.add(self.spinAnimation(), forKey: "rotationAnimation")

        self.layer.addSublayer(self.circleLayer)
    }

    private func spinAnimation() -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = M_PI * 2.0
        rotation.duration = 2.0
        rotation.repeatCount = MAXFLOAT

        return rotation
    }
}
