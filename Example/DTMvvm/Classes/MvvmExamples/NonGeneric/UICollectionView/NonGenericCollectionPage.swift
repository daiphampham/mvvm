//
//  NonGenericCollectionPage.swift
//  DTMvvm_Example
//
//  Created by pham.minh.tien on 4/30/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DTMvvm
import Action
import RxSwift
import RxCocoa


class NonGenericCollectionPage: BaseCollectionPage {

    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? XSimpleListPageViewModel else { return }
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }
    
    override func getItemSource() -> RxCollection? {
        guard let viewModel = viewModel as? XSimpleListPageViewModel else { return nil }
        return viewModel.itemsSource
    }
    
    override func registerNibWithColletion(_ collectionView: UICollectionView) {
        collectionView.register(SectionHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCell.identifier)
        collectionView.register(collectionViewCell: NonGenericCPTextCell.self)
        
//        collectionView.register(collectionViewCell: CPTextCell.self)
        
        
//        collectionView.register(CPTextCell.self, forCellWithReuseIdentifier: CPTextCell.identifier)
//        collectionView.register(CPImageCell.self, forCellWithReuseIdentifier: CPImageCell.identifier)
        
    }
    
    override func cellIdentifier(_ cellViewModel: Any, _ isClass: Bool = false) -> String {
        if isClass {
            return NSStringFromClass(NonGenericCPTextCell.self)
        }
        return NonGenericCPTextCell.identifier
    }
    
}
