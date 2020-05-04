//
//  MenuTableViewCell.swift
//  DTMvvm_Example
//
//  Created by pham.minh.tien on 5/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DTMvvm
import RxCocoa


class MenuTableViewCell: BaseTableCell {
    @IBOutlet private weak var titleLbl:UILabel!
    @IBOutlet private weak var descLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        accessoryType = .disclosureIndicator
    }
    
    override func initialize() {
        guard let viewModel = viewModel as? MenuTableCellViewModel else { return }
        accessoryType = .disclosureIndicator
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel as? MenuTableCellViewModel else { return }
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        viewModel.rxDesc ~> descLbl.rx.text => disposeBag
    }
    
}


class MenuTableCellViewModel: BaseCellViewModel {
    
    let rxTitle = BehaviorRelay<String?>(value: nil)
    let rxDesc = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        guard let viewModel = model as? MenuModel else {
            return
        }
        rxTitle.accept(viewModel.title)
        rxDesc.accept(viewModel.desc)
    }
}
