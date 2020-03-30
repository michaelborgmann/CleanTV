//
//  CreatePizzaViewController.swift
//  CleanTV
//
//  Created by Michael Borgmann on 26.03.20.
//  Copyright (c) 2020 Michael Borgmann. All rights reserved.
//

import UIKit

protocol CreatePizzaDisplayLogic: class {
    func displaySomething(viewModel: CreatePizza.Something.ViewModel)
    func displaySelectePizzaSize(viewModel: CreatePizza.SelectSize.ViewModel)
    func displaySelectedPizzaCrust(viewModel: CreatePizza.SelectCrust.ViewModel)
    func displaySelectedPizzaToppings(viewModel: CreatePizza.SelectTopping.ViewModel)
    func displayPrice(viewModel: CreatePizza.CalculatePrice.ViewModel)
}

class CreatePizzaViewController: UIViewController, CreatePizzaDisplayLogic {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pizzaImage: UIImageView!
    @IBOutlet weak var choicesSegment: UISegmentedControl!
    @IBOutlet weak var theWorks: UIButton!
    
    var interactor: CreatePizzaBusinessLogic?
    var router: (NSObjectProtocol & CreatePizzaRoutingLogic & CreatePizzaDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CreatePizzaInteractor()
        let presenter = CreatePizzaPresenter()
        let router = CreatePizzaRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        
        createPizzaImage()
        calculatePizzaPrice()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        let request = CreatePizza.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: CreatePizza.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
    
    private func createPizzaImage() {
        let pizzaBase = UIImage(named: "PizzaBase")
        
        UIGraphicsBeginImageContextWithOptions(pizzaBase!.size, false, 1.0)
        
        pizzaBase?.draw(at: .zero)
        
        selectedPizzaToppings.forEach { index in
            let name = Pizza.Toppings(rawValue: index)?.info.name
            let topping = UIImage(named: name!)
            topping?.draw(at: .zero)
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        pizzaImage.image = finalImage
    }
    
    private var tableSection = TableSection.size
    
    @IBAction func crustOrToppings(_ sender: UISegmentedControl) {
        tableSection = TableSection(rawValue: sender.selectedSegmentIndex)!
        tableView.reloadData()
    }
    
    @IBAction func theWorks(_ sender: UIButton) {
        let request = CreatePizza.TheWorks.Request()
        interactor?.theWorks(request: request)
    }
    
    @IBAction func orderPizza(_ sender: UIButton) {
        let request = CreatePizza.OrderPizza.Request(size: selectedPizzaSize,
                                                     crust: selectedPizzaCrust,
                                                     toppings: selectedPizzaToppings)
        interactor?.orderPizza(request: request)
    }
    
    private var selectedPizzaSize = 0
    
    func displaySelectePizzaSize(viewModel: CreatePizza.SelectSize.ViewModel) {
        selectedPizzaSize = viewModel.index
        tableView.reloadData()
        calculatePizzaPrice()
    }
    
    private var selectedPizzaCrust = 0
    
    func displaySelectedPizzaCrust(viewModel: CreatePizza.SelectCrust.ViewModel) {
        selectedPizzaCrust = viewModel.index
        tableView.reloadData()
        calculatePizzaPrice()
    }
    
    private var selectedPizzaToppings = [Int]()
    
    func displaySelectedPizzaToppings(viewModel: CreatePizza.SelectTopping.ViewModel) {
        selectedPizzaToppings = viewModel.toppings
        tableView.reloadData()
        calculatePizzaPrice()
    }
    
    private func calculatePizzaPrice() {
        let sizePrice = Pizza.Size(rawValue: selectedPizzaSize)?.info.price         // NOTE: Move logic to interactor
        let crustPrice = Pizza.Crust(rawValue: selectedPizzaCrust)?.info.price
        let toppingPrices = selectedPizzaToppings.map { Pizza.Toppings(rawValue: $0)!.info.price }
        
        let request = CreatePizza.CalculatePrice.Request(size: sizePrice!, crust: crustPrice!, toppings: toppingPrices)
        interactor?.calculatePrice(request: request)
    }
    
    func displayPrice(viewModel: CreatePizza.CalculatePrice.ViewModel) {
        priceLabel.text = "Total: \(viewModel.total)€"
    }
    
}

// MARK: - Table View

extension CreatePizzaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaStuff", for: indexPath)
        
        switch tableSection {
        case .size:
            let pizza = Pizza.Size(rawValue: indexPath.row)
            cell.textLabel?.text = pizza?.info.name
            cell.detailTextLabel?.text = "\(pizza?.info.price ?? 0)€"
            cell.accessoryType = selectedPizzaSize == indexPath.row ? .checkmark : .none
        case .crust:
            let crust = Pizza.Crust(rawValue: indexPath.row)
            cell.textLabel?.text = crust?.info.name
            cell.detailTextLabel?.text = "\(crust?.info.price ?? 0)€"
            cell.accessoryType = selectedPizzaCrust == indexPath.row ? .checkmark : .none
        case .toppings:
            let toppings = Pizza.Toppings(rawValue: indexPath.row)
            cell.textLabel?.text = toppings?.info.name
            cell.detailTextLabel?.text = "\(toppings?.info.price ?? 0)€"
            cell.accessoryType = selectedPizzaToppings.contains(indexPath.row) ? .checkmark : .none
        }
        
        theWorks.isEnabled = tableSection == .toppings ? true : false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableSection {
        case .size:
            let request = CreatePizza.SelectSize.Request(index: indexPath.row)
            interactor?.selectPizzaSize(request: request)
        case .crust:
            let request = CreatePizza.SelectCrust.Request(index: indexPath.row)
            interactor?.selectCrust(request: request)
        case .toppings:
            let cell = tableView.cellForRow(at: indexPath)
            
            if cell?.accessoryType == UITableViewCell.AccessoryType.none {
                let request = CreatePizza.SelectTopping.Request(index: indexPath.row)
                interactor?.addTopping(request: request)
            } else if cell?.accessoryType == .checkmark {
                let request = CreatePizza.SelectTopping.Request(index: indexPath.row)
                interactor?.removeTopping(request: request)
            }
            
            createPizzaImage()
        }
    }
    
}

extension CreatePizzaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableSection {
        case .size:
            return interactor?.pizzaSize.count ?? 0
        case .crust:
            return interactor?.pizzaCrust.count ?? 0
        case .toppings:
            return interactor?.pizzaToppings.count ?? 0
        }
    }
    
}
