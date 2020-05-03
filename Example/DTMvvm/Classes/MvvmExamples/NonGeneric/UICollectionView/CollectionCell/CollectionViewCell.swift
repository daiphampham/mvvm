//
//  CollectionViewCell.swift
//  DTMvvm_Example
//
//  Created by pham.minh.tien on 5/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DTMvvm

class NonGenericCPTextCell: BaseCollectionCell {
    
    let titleLbl = UILabel()
    let descLbl = UILabel()
    
    override func initialize() {
        cornerRadius = 5
        backgroundColor = .black
        
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 0
        titleLbl.font = Font.system.bold(withSize: 17)
        
        descLbl.textColor = .white
        descLbl.numberOfLines = 0
        descLbl.font = Font.system.normal(withSize: 15)
        
        let layout = StackLayout().direction(.vertical).children([
            titleLbl,
            descLbl
        ])
        contentView.addSubview(layout)
        layout.autoPinEdgesToSuperviewEdges(with: .all(5))

    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? NonGenericTextCellViewModel  else { return }
        viewModel.rxTitle ~> titleLbl.rx.text => disposeBag
        viewModel.rxDesc ~> descLbl.rx.text => disposeBag
        
    }
    
    override class func getSize(withItem data: Any?) -> CGSize? {
        return CGSize(width: 170, height: 60)
    }
}
