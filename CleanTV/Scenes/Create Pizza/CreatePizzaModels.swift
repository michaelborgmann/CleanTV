//
//  CreatePizzaModels.swift
//  CleanTV
//
//  Created by Michael Borgmann on 26.03.20.
//  Copyright (c) 2020 Michael Borgmann. All rights reserved.
//

import UIKit

enum CreatePizza {
    
    // MARK: Use cases
    
    enum Something {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
        
    }
    
    enum SelectSize {
        
        struct Request {
            var index: Int
        }
        
        struct Response {
            var index: Int
        }
        
        struct ViewModel {
            var index: Int
        }
        
    }
    
    enum SelectCrust {
        
        struct Request {
            var index: Int
        }
        
        struct Response {
            var index: Int
        }
        
        struct ViewModel {
            var index: Int
        }
        
    }
    
    enum SelectTopping {
        
        struct Request {
            var index: Int
        }
        
        struct Response {
            var toppings: [Int]
        }
        
        struct ViewModel {
            var toppings: [Int]
        }
        
    }
    
    enum TheWorks {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
        
    }
    
    enum OrderPizza {
        
        struct Request {
            var size: Int
            var crust: Int
            var toppings: [Int]
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
        
    }
    
    enum CalculatePrice {
        
        struct Request {
            var size: Double
            var crust: Double
            var toppings: [Double]
        }
        
        struct Response {
            var price: Double
        }
        
        struct ViewModel {
            var total: Double
        }
        
    }
    
}
