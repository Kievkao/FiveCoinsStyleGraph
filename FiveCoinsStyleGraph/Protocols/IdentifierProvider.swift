//
//  IdentifierProvider.swift
//  FiveCoinsStyleGraph
//
//  Created by Andrii Kravchenko on 4/2/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import Foundation

protocol IdentifierProvider {
    static func identifier() -> String
}
