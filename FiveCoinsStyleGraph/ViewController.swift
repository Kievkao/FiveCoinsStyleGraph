//
//  ViewController.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/2/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var graph: FCSGraph!

    let NumValues = 100
    let MaxRandomValue: UInt32 = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillGraphWithData()
    }
    
    func fillGraphWithData() {
        var values = [Float]()
        
        for _ in 0..<NumValues {
            values.append(Float(arc4random_uniform(MaxRandomValue)))
        }
        
        self.graph.loadGraphValues(values: values)
    }
}

