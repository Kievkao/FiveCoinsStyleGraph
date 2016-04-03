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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillGraphWithData()
    }
    
    func fillGraphWithData() {
        var values = [Float]()
        
        for _ in 0..<25 {
            values.append(Float(arc4random_uniform(100) + 5))
        }
        
        self.graph.data = values
    }
}

