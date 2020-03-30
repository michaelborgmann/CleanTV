//
//  CreatePizzaWorker.swift
//  CleanTV
//
//  Created by Michael Borgmann on 26.03.20.
//  Copyright (c) 2020 Michael Borgmann. All rights reserved.
//

import UIKit

class CreatePizzaWorker {
    
    func doSomeWork() {
    }

    func calculatePrice(size: Double, crust: Double, toppings: [Double]) -> Double {
        return size + crust + toppings.reduce(0, +)
    }
    
}
