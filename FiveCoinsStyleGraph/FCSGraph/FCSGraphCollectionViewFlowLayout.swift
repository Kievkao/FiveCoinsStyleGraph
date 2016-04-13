//
//  FCSGraphCollectionViewFlowLayout.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/2/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class FCSGraphCollectionViewFlowLayout: UICollectionViewFlowLayout {

    var cellWidth: CGFloat!
    
    override init() {
        super.init()
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.scrollDirection = .Horizontal
        self.minimumInteritemSpacing = 0.0
        self.minimumLineSpacing = 0.0
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let cvBounds = self.collectionView!.bounds
        let halfWidth = cvBounds.size.width/2 + cellWidth/2
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        
        if let attributesForVisibleCells = self.layoutAttributesForElementsInRect(cvBounds) as [UICollectionViewLayoutAttributes]? {
            
            var candidateAttributes : UICollectionViewLayoutAttributes?
            for attributes in attributesForVisibleCells {
                
                // == Skip comparison with non-cell items (headers and footers) == //
                if attributes.representedElementCategory != UICollectionElementCategory.Cell {
                    continue
                }
                
                if let candAttrs = candidateAttributes {
                    let a = attributes.center.x - proposedContentOffsetCenterX
                    let b = candAttrs.center.x - proposedContentOffsetCenterX
                    
                    if fabsf(Float(a)) < fabsf(Float(b)) {
                        candidateAttributes = attributes;
                    }
                }
                else { // == First time in the loop == //
                    candidateAttributes = attributes;
                    continue;
                }
            }
            
            return CGPoint(x: round(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
        }
        else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
    }
}
