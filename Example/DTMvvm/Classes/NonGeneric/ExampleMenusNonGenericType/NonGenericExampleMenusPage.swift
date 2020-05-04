//
//  NonGenericExampleMenusPage.swift
//  DTMvvm_Example
//
//  Created by pham.minh.tien on 5/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DTMvvm
import RxCocoa
import RxSwift
import Action

class NonGenericExampleMenusPage: BaseListPage {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .singleLine
        tableView.register(cellType:MenuTableViewCell.self)
    }
    
    // Register event: Connect view to ViewModel.
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? NonGenericHomeMenuPageViewModel else { return }
        viewModel.rxPageTitle ~> rx.title => disposeBag
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
    
    override func cellIdentifier(_ cellViewModel: Any) -> String {
        return MenuTableViewCell.identifier
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? NonGenericHomeMenuPageViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    // Not recommended for use. override selectedItemDidChange on ViewModel.
    override func selectedItemDidChange(_ cellViewModel: Any) { }

}

/// Menu for home page
class NonGenericHomeMenuPageViewModel: BaseListViewModel {
    
    let rxPageTitle = BehaviorRelay(value: "")
    
    override func react() {
        super.react()
        fetchData()
        rxPageTitle.accept("MVVM Examples")
    }
    
    func fetchData() {
        let mvvm = MenuTableCellViewModel(model: MenuModel(withTitle: "MVVM Examples",
                                                           desc: "Examples about different ways to use base classes Page, ListPage and CollectionPage."))
        let dataBinding = MenuTableCellViewModel(model: MenuModel(withTitle: "Data Binding Examples", desc: "Examples about how to use data binding."))
        let transition = MenuTableCellViewModel(model: MenuModel(withTitle: "Transition Examples", desc: "Examples about how to create a custom transitioning animation and apply it."))
        itemsSource.append([mvvm, dataBinding, transition])
    }
    
    func pageToNavigate(_ cellViewModel: BaseCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            page = NonGenericExampleMenusPage(model: NonGenericMvvmMenuPageViewModel(model: cellViewModel.model))
        case 1:
//            page = ExampleMenuPage(viewModel: DataBindingMenuPageViewModel(model: cellViewModel.model))
            ()
        case 2: ()

        case 3:
//            page = ExampleMenuPage(viewModel: TransitionMenuPageViewModel(model: cellViewModel.model))
()
        default: ()
        }
        return page
    }
    
    override func selectedItemDidChange(_ cellViewModel: BaseCellViewModel) {
        if let page = pageToNavigate(cellViewModel) {
            navigationService.push(to: page, options: .defaultOptions)
        }
    }
}


/// Menu for MVVM examples
class NonGenericMvvmMenuPageViewModel: NonGenericHomeMenuPageViewModel {

    override func fetchData() {
        let listPage = MenuTableCellViewModel(model: MenuModel(withTitle: "ListPage Examples", desc: "Demostration on how to use ListPage"))
        let collectionPage = MenuTableCellViewModel(model: MenuModel(withTitle: "CollectionPage Examples", desc: "Demostration on how to use CollectionPage"))
        let advanced = MenuTableCellViewModel(model: MenuModel(withTitle: "Advanced Example 1", desc: "When using MVVM, we should forget about Delegate as it is against to MVVM rule.\nThis example is to demostrate how to get result from other page without using Delegate"))
        let searchBar = MenuTableCellViewModel(model: MenuModel(withTitle: "Advanced Example 2", desc: "An advanced example on using Search Bar to search images on Flickr."))
        itemsSource.append([listPage, collectionPage, advanced, searchBar])
    }
    
    func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }
        
        var page: UIViewController?
        switch indexPath.row {
        case 0:
            let vm = TPExampleMenuPageViewModel(model: cellViewModel.model)
            page = ExampleMenuPage(viewModel: vm)
            
        case 1:
            let vm = CPExampleMenuPageViewModel(model: cellViewModel.model)
            page = ExampleMenuPage(viewModel: vm)
            
        case 2:
            let vm = ContactListPageViewModel(model: cellViewModel.model)
            page = ContactListPage(viewModel: vm)
            
        case 3:
            
            DependencyManager.shared.registerService(Factory<FlickrService> {
                FlickrService()
            })
            
            let vm = FlickrSearchPageViewModel(model: cellViewModel.model)
            page = FlickrSearchPage(viewModel: vm)
            
        default: ()
        }
        
        return page
    }
}
