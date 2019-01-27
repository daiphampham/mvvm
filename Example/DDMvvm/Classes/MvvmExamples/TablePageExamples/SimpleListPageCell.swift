//
//  SimpleListPageCell.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 10/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import DDMvvm

class SimpleListPageCell: TableCell<SimpleListPageCellViewModel> {

    let titleLbl = UILabel()
    
    override func initialize() {
        contentView.addSubview(titleLbl)
        titleLbl.autoPinEdgesToSuperviewEdges(with: .topBottom(10, leftRight: 15))
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
    }
}

class SimpleListPageCellViewModel: CellViewModel<SimpleModel> {
    
    let rxTitle = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        rxTitle.accept(model?.title)
    }
}











