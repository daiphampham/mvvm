//
//  NonGenericTablePage.swift
//  DTMvvm_Example
//
//  Created by ToanDK on 8/14/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import DTMvvm
import RxCocoa
import RxSwift
import Action

class NonGenericTablePage: BaseListPage {
    @IBOutlet weak var addButton: UIButton!
    
    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        tableView.estimatedRowHeight = 100
        tableView.register(NonGenericSimpleListPageCell.self, forCellReuseIdentifier: NonGenericSimpleListPageCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel as? NonGenericTableViewModel else { return }
        addButton.rx.bind(to: viewModel.addAction, input: ())
    }
    
    override func destroy() {
        super.destroy()
        viewModel?.destroy()
    }
    
    override func cellIdentifier(_ cellViewModel: Any) -> String {
        return NonGenericSimpleListPageCell.identifier
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? NonGenericTableViewModel else { return nil }
        return viewModel.itemsSource
    }
}

class NonGenericTableViewModel: BaseListViewModel {
    
    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.add()) }
    }()
    
    private func add() {
        let number = Int.random(in: 1000...10000)
        let title = "This is your random number: \(number)"
//        let cvm = SimpleListPageCellViewModel(model: SimpleModel(withTitle: title))
        let cvm = NonGenericSimpleListPageCellViewModel(model: SimpleModel(withTitle: title))
        itemsSource.append(cvm)
    }
}
