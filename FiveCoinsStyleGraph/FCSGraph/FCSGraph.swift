//
//  FCSGraph.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/2/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class FCSGraph: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let cellWidth: CGFloat = 100.0
    private let tmpIconHalfRadius: CGFloat = 8.0
    
    private var collectionView: UICollectionView!
    
    private var valueIndicator: UIImageView!
    private var valueIndicatorTopConstraint: NSLayoutConstraint!
    
    var data: [Float]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let centerPoint = CGPointMake(self.collectionView.center.x + self.collectionView.contentOffset.x,
                                      self.collectionView.center.y + self.collectionView.contentOffset.y)
        let centerIndexPath = self.collectionView.indexPathForItemAtPoint(centerPoint)
        
        if let indexPath = centerIndexPath {
            
            let constraintValue = indexPath.item > 0 ? CGFloat(self.data![indexPath.item - 1]) : tmpIconHalfRadius
            self.valueIndicatorTopConstraint.constant = constraintValue - tmpIconHalfRadius
        }
    }
    
    private func valueIndicatorSetup() {
        self.valueIndicator = UIImageView(image: UIImage(named: "sun"))
        self.valueIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.valueIndicator)
        
        let centerXConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        self.valueIndicatorTopConstraint = NSLayoutConstraint(item: self.valueIndicator, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 30)
        
        self.addConstraints([centerXConstraint, self.valueIndicatorTopConstraint])
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
        guard let graphData = self.data else {
            return 0
        }
        
        return graphData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FCSGraphCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(FCSGraphCollectionViewCell.identifier(), forIndexPath: indexPath) as! FCSGraphCollectionViewCell
        
        if let graphData = self.data {
            let previous = indexPath.item > 0 ? Float(graphData[indexPath.item - 1]) : Float(0)
            cell.drawDotAtY(graphData[indexPath.item], previous: previous)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: self.bounds.height)
    }
}
