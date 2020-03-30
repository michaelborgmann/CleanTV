//
//  CreatePizzaRouter.swift
//  CleanTV
//
//  Created by Michael Borgmann on 26.03.20.
//  Copyright (c) 2020 Michael Borgmann. All rights reserved.
//

import UIKit

@objc protocol CreatePizzaRoutingLogic {
    func routeToOrderPizza(segue: UIStoryboardSegue?)
}

protocol CreatePizzaDataPassing {
    var dataStore: CreatePizzaDataStore? { get }
}

class CreatePizzaRouter: NSObject, CreatePizzaRoutingLogic, CreatePizzaDataPassing {
    
    weak var viewController: CreatePizzaViewController?
    var dataStore: CreatePizzaDataStore?
    
    // MARK: Routing

    func routeToOrderPizza(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! OrderPizzaViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "OrderPizzaViewController") as! OrderPizzaViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
            navigateToSomewhere(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: CreatePizzaViewController, destination: OrderPizzaViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(source: CreatePizzaDataStore, destination: inout OrderPizzaDataStore) {
        //destination.name = source.name
        destination.size = source.size
        destination.crust = source.crust
        destination.toppings = source.toppings
    }
    
}
