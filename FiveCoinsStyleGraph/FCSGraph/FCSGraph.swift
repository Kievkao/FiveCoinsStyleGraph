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
                let neededInitialOffset = (self.collectionView.collectionViewLayout as! FCSGraphCollectionViewFlowLayout).targetContentOffset(forProposedContentOffset: self.collectionView.contentOffset, withScrollingVelocity: CGPoint.zero)
                self.collectionView.setContentOffset(neededInitialOffset, animated: true)

                self.placeValueIndicator()
        }
    }

    private func adjustValues() {
        guard let data = self.originalData else {
            return
        }

        let maxValue = Float((data.max())!)

        let k = Float(self.bounds.height) / maxValue
        self.adjustedData = data.map{(maxValue - $0) * k}
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.placeValueIndicator()
    }

    func placeValueIndicator() {
        let centerPoint = CGPoint(x: self.collectionView.center.x + self.collectionView.contentOffset.x,
                                  y: self.collectionView.center.y + self.collectionView.contentOffset.y)

        guard let centerIndexPath = self.collectionView.indexPathForItem(at: centerPoint) else {
            return
        }

        let centerPointInCell = self.collectionView.convert(centerPoint, to: self.collectionView.cellForItem(at: centerIndexPath))

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
        self.valueIndicator = FCSValuePointerView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: valueIndicatorDiameter, height: valueIndicatorDiameter)))
        self.valueIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.valueIndicator)
        
        let centerXConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: -FCSCellDrawView.dotRadius)

        let widthConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: valueIndicatorDiameter)

        let heightConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: valueIndicatorDiameter)

        self.valueIndicatorTopConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        
        self.addConstraints([centerXConstraint, self.valueIndicatorTopConstraint, widthConstraint, heightConstraint])
    }
    
    private func collectionViewSetup() {
        
        let layout = FCSGraphCollectionViewFlowLayout()
        layout.cellWidth = cellWidth
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.collectionView)
        
        let viewsDict: [String: UIView] = ["collectionView" :collectionView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:  viewsDict))
        
        self.collectionView.register(FCSGraphCollectionViewCell.self, forCellWithReuseIdentifier: FCSGraphCollectionViewCell.identifier())
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    // MARK: UICollectionViewDataSource, UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let graphData = self.adjustedData else {
            return 0
        }
        return graphData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FCSGraphCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: FCSGraphCollectionViewCell.identifier(), for: indexPath) as! FCSGraphCollectionViewCell
        
        if let graphData = self.adjustedData , graphData.count > 0 {
            let previous = indexPath.item > 0 ? Float(graphData[indexPath.item - 1]) : Float(graphData[0])
            cell.drawDotAtY(y: graphData[indexPath.item], previous: previous)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
}
