//
//  CreatePizzaPresenter.swift
//  CleanTV
//
//  Created by Michael Borgmann on 26.03.20.
//  Copyright (c) 2020 Michael Borgmann. All rights reserved.
//

import UIKit

protocol CreatePizzaPresentationLogic {
    func presentSomething(response: CreatePizza.Something.Response)
    func presentSelectedPizzaSize(response: CreatePizza.SelectSize.Response)
    func presentSelectedPizzaCrust(response: CreatePizza.SelectCrust.Response)
    func presentSelectedPizzaToppings(response: CreatePizza.SelectTopping.Response)
    func presentTotalPrice(response: CreatePizza.CalculatePrice.Response)
}

class CreatePizzaPresenter: CreatePizzaPresentationLogic {
    
    weak var viewController: CreatePizzaDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: CreatePizza.Something.Response) {
        let viewModel = CreatePizza.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
    
    func presentSelectedPizzaSize(response: CreatePizza.SelectSize.Response) {
        let viewModel = CreatePizza.SelectSize.ViewModel(index: response.index)
        viewController!.displaySelectePizzaSize(viewModel: viewModel)
    }
    
    func presentSelectedPizzaCrust(response: CreatePizza.SelectCrust.Response) {
        let viewModel = CreatePizza.SelectCrust.ViewModel(index: response.index)
        viewController!.displaySelectedPizzaCrust(viewModel: viewModel)
    }
    
    func presentSelectedPizzaToppings(response: CreatePizza.SelectTopping.Response) {
        let viewModel = CreatePizza.SelectTopping.ViewModel(toppings: response.toppings)
        viewController!.displaySelectedPizzaToppings(viewModel: viewModel)
    }
    
    func presentTotalPrice(response: CreatePizza.CalculatePrice.Response) {
        let viewModel = CreatePizza.CalculatePrice.ViewModel(total: response.price)
        viewController?.displayPrice(viewModel: viewModel)
    }

}
