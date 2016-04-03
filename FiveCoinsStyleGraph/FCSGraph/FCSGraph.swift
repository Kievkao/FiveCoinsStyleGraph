//
//  FCSGraph.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/2/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class FCSGraph: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    
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
    }
    
    private func collectionViewSetup() {
        
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: FCSGraphCollectionViewFlowLayout())
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
        return CGSize(width: 80.0, height: self.bounds.height)
    }
}
