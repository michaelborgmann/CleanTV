//
//  CreatePizzaInteractor.swift
//  CleanTV
//
//  Created by Michael Borgmann on 26.03.20.
//  Copyright (c) 2020 Michael Borgmann. All rights reserved.
//

import UIKit

struct Pizza {
    
    enum Size: Int {
        case small = 0
        case medium
        case large
        case extraLarge
    
        var info: (name: String, price: Double) {
            let data: [(String, Double)] = [
                ("Small 10\" Pizza", 6.50),
                ("Medium 12\" Pizza", 8.50),
                ("Large 14\" Pizza", 10.50),
                ("Extra Large 16\" Pizza", 12.50)
            ]
          
            return data[rawValue]
        }
    }
    
    enum Crust: Int {
        case regular = 0
        case thinCrust
        case deepDish
        
        var info: (name: String, price: Double) {
            let data: [(String, Double)] = [
                ("Regular", 0.0),
                ("Thin Crust", 0.0),
                ("Deep Dish", 1.0),
            ]
          
            return data[rawValue]
        }
    }
    
    enum Toppings: Int {
        case cheese = 0
        case pepperoni
        case ham
        case chicken
        case sausage
        case anchovy
        case onion
        case bellPepper
        case mushroom
        case blackOlive
        case jalapeno
        case pepperoncini
        case pineapple
        
        var info: (name: String, price: Double) {
            let data: [(String, Double)] = [
                ("Cheese", 1.50),
                ("Pepperoni", 1.50),
                ("Ham", 1.50),
                ("Chicken", 1.50),
                ("Sausage", 1.50),
                ("Anchovy", 1.50),
                ("Onion", 0.50),
                ("Bell Pepper", 0.50),
                ("Mushroom", 0.75),
                ("Black Olive", 0.50),
                ("Jalapeno", 0.50),
                ("Pepperoncini", 0.50),
                ("Pineapple", 0.50)
            ]
          
            return data[rawValue]
        }
        
    }
    
}

enum TableSection: Int {
    case size = 0
    case crust
    case toppings
}

protocol CreatePizzaBusinessLogic {
    var pizzaSize: [Pizza.Size] { get }
    var pizzaCrust: [Pizza.Crust] { get }
    var pizzaToppings: [Pizza.Toppings] { get }
    func doSomething(request: CreatePizza.Something.Request)
    func selectPizzaSize(request: CreatePizza.SelectSize.Request)
    func selectCrust(request: CreatePizza.SelectCrust.Request)
    func addTopping(request: CreatePizza.SelectTopping.Request)
    func removeTopping(request: CreatePizza.SelectTopping.Request)
    func theWorks(request: CreatePizza.TheWorks.Request)
    func orderPizza(request: CreatePizza.OrderPizza.Request)
    func calculatePrice(request: CreatePizza.CalculatePrice.Request)
}

protocol CreatePizzaDataStore {
    //var name: String { get set }
    var size: Int { get set }
    var crust: Int { get set }
    var toppings: [Int] { get set }
}

class CreatePizzaInteractor: CreatePizzaBusinessLogic, CreatePizzaDataStore {
    
    var pizzaSize: [Pizza.Size] =  [.small, .medium, .large, .extraLarge]
    var pizzaCrust: [Pizza.Crust] = [.regular, .thinCrust, .deepDish]
    var pizzaToppings: [Pizza.Toppings] = [.cheese, .pepperoni, .ham, .chicken, .sausage, .anchovy, .onion, .bellPepper, .mushroom, .blackOlive, .jalapeno, .pepperoncini, .pineapple]
    
    var size = 0
    var crust = 0
    var toppings: [Int] = []
    
    var presenter: CreatePizzaPresentationLogic?
    var worker: CreatePizzaWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: CreatePizza.Something.Request) {
        worker = CreatePizzaWorker()
        worker?.doSomeWork()
        
        let response = CreatePizza.Something.Response()
        presenter?.presentSomething(response: response)
    }
    
    func selectPizzaSize(request: CreatePizza.SelectSize.Request) {
        size = request.index
        let response = CreatePizza.SelectSize.Response(index: request.index)
        presenter?.presentSelectedPizzaSize(response: response)
    }
    
    func selectCrust(request: CreatePizza.SelectCrust.Request) {
        crust = request.index
        let response = CreatePizza.SelectCrust.Response(index: request.index)
        presenter?.presentSelectedPizzaCrust(response: response)
    }
    
    func addTopping(request: CreatePizza.SelectTopping.Request) {
        toppings.append(request.index)
        let response = CreatePizza.SelectTopping.Response(toppings: toppings)
        presenter?.presentSelectedPizzaToppings(response: response)
    }
    
    func removeTopping(request: CreatePizza.SelectTopping.Request) {
        let item = toppings.firstIndex(of: request.index)
        toppings.remove(at: item!)
        let response = CreatePizza.SelectTopping.Response(toppings: toppings)
        presenter?.presentSelectedPizzaToppings(response: response)
    }
    
    func theWorks(request: CreatePizza.TheWorks.Request) {
        toppings.removeAll()
        toppings = pizzaToppings.map { $0.rawValue }
        
        let response = CreatePizza.SelectTopping.Response(toppings: toppings)
        presenter?.presentSelectedPizzaToppings(response: response)
    }
    
    func orderPizza(request: CreatePizza.OrderPizza.Request) {
        
    }
    
    func calculatePrice(request: CreatePizza.CalculatePrice.Request) {
        worker = CreatePizzaWorker()
        
        let total = worker?.calculatePrice(size: request.size, crust: request.crust, toppings: request.toppings)
        let response = CreatePizza.CalculatePrice.Response(price: total!)
        presenter?.presentTotalPrice(response: response)
    }
    
}
