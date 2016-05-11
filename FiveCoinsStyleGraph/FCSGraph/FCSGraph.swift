//
//  FCSGraph.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/2/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class FCSGraph: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let cellWidth: CGFloat = 50.0
    private let valueIndicatorDiameter: CGFloat = 16.0

    private var collectionView: UICollectionView!
    
    private var valueIndicator: FCSValuePointerView!
    private var valueIndicatorTopConstraint: NSLayoutConstraint!
    
    private var originalData: [Float]?
    private var adjustedData: [Float]?

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
        self.collectionViewSetup()
        self.valueIndicatorSetup()
    }

    func loadGraphValues(values: [Float]) {
        self.originalData = values
        self.adjustValues()

        self.collectionView.performBatchUpdates({ 
            self.collectionView.reloadData()
            }) { (success) in
                let neededInitialOffset = (self.collectionView.collectionViewLayout as! FCSGraphCollectionViewFlowLayout).targetContentOffsetForProposedContentOffset(self.collectionView.contentOffset, withScrollingVelocity: CGPointZero)
                self.collectionView.setContentOffset(neededInitialOffset, animated: true)

                self.placeValueIndicator()
        }
    }

    private func adjustValues() {
        guard let data = self.originalData else {
            return
        }

        let maxValue = Float((data.maxElement())!)

        let k = Float(self.bounds.height) / maxValue
        self.adjustedData = data.map{(maxValue - $0) * k}
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.placeValueIndicator()
    }

    func placeValueIndicator() {
        let centerPoint = CGPointMake(self.collectionView.center.x + self.collectionView.contentOffset.x,
                                      self.collectionView.center.y + self.collectionView.contentOffset.y)

        guard let centerIndexPath = self.collectionView.indexPathForItemAtPoint(centerPoint) else {
            return
        }

        let centerPointInCell = self.collectionView.convertPoint(centerPoint, toView: self.collectionView.cellForItemAtIndexPath(centerIndexPath))

        let rightValue = CGFloat(self.adjustedData![centerIndexPath.item])
        let leftValue = centerIndexPath.item > 0 ? CGFloat(self.adjustedData![centerIndexPath.item - 1]) : CGFloat(self.adjustedData![0])

        var min: CGFloat = leftValue
        var max: CGFloat = 0

        if rightValue < leftValue {
            min = rightValue
            max = leftValue
        }
        else {
            min = leftValue
            max = rightValue
        }

        let k: CGFloat = (rightValue - leftValue) / cellWidth
        let valueIndicatorOffset: CGFloat = -valueIndicatorDiameter/2;

        var y: CGFloat = k * centerPointInCell.x + valueIndicatorOffset
        y = (rightValue > leftValue) ? y + min : y + max

        self.valueIndicatorTopConstraint.constant = y
    }

    private func valueIndicatorSetup() {
        self.valueIndicator = FCSValuePointerView(frame: CGRectMake(0, 0, valueIndicatorDiameter, valueIndicatorDiameter))
        self.valueIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.valueIndicator)
        
        let centerXConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: -FCSCellDrawView.dotRadius)

        let widthConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: valueIndicatorDiameter)

        let heightConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: valueIndicatorDiameter)

        self.valueIndicatorTopConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0)
        
        self.addConstraints([centerXConstraint, self.valueIndicatorTopConstraint, widthConstraint, heightConstraint])
    }
    
    private func collectionViewSetup() {
        
        let layout = FCSGraphCollectionViewFlowLayout()
        layout.cellWidth = cellWidth
        
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.collectionView)
        
        let viewsDict = ["collectionView" :collectionView]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:  viewsDict))
        
        self.collectionView.registerClass(FCSGraphCollectionViewCell.self, forCellWithReuseIdentifier: FCSGraphCollectionViewCell.identifier())
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    // MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let graphData = self.adjustedData else {
            return 0
        }
        return graphData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FCSGraphCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(FCSGraphCollectionViewCell.identifier(), forIndexPath: indexPath) as! FCSGraphCollectionViewCell
        
        if let graphData = self.adjustedData where graphData.count > 0 {
            let previous = indexPath.item > 0 ? Float(graphData[indexPath.item - 1]) : Float(graphData[0])
            cell.drawDotAtY(graphData[indexPath.item], previous: previous)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
}
