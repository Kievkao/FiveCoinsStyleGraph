//
//  FCSGraphCollectionViewCell.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/2/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class FCSGraphCollectionViewCell: UICollectionViewCell, IdentifierProvider {
    
    var drawView: FCSCellDrawView!

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

        self.drawView = FCSCellDrawView(frame: CGRectInset(self.contentView.bounds, -FCSCellDrawView.dotRadius, 0))
        self.contentView.addSubview(self.drawView)
    }

    // MARK: IdentifierProvider protocol
    static func identifier() -> String {
        return "fcsGraphValueCellIdentifier"
    }
    
    // MARK: Drawing
    func drawDotAtY(y: Float, previous: Float) {
        self.drawView.drawDotAtY(y, previous: previous)
    }
}
