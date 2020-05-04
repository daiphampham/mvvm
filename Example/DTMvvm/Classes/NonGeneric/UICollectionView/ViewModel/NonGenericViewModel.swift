//
//  NonGenericViewModel.swift
//  DTMvvm_Example
//
//  Created by pham.minh.tien on 5/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import DTMvvm
import Action
import RxSwift


class NonGenericSectionListPageViewModel: BaseListViewModel {
    
    let imageUrls = [
        "https://images.pexels.com/photos/371633/pexels-photo-371633.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI3cP_SZVm5g43t4U8slThjjp6v1dGoUyfPd6ncEvVQQG1LzDl",
        "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&h=350"
    ]
    
    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.add()) }
    }()
    
    lazy var sortAction: Action<Void, Void> = {
        return Action() { .just(self.sort()) }
    }()
    
    var tmpBag: DisposeBag?
    
    override func react() {
        itemsSource.asObservable()
            .subscribe(onNext: { sectionLists in
                self.tmpBag = DisposeBag()
                
                for sectionList in sectionLists {
                    if let cvm = sectionList.key as? SectionHeaderViewViewModel {
                        cvm.addAction
                            .executionObservables
                            .switchLatest()
                            .subscribe(onNext: self.addCell) => self.tmpBag
                    }
                }
            }) => disposeBag
    }
    
    private func addCell(_ vm: SectionHeaderViewViewModel) {
        if let sectionIndex = itemsSource.indexForSection(withKey: vm) {
            let randomIndex = Int.random(in: 0...1)
            
            // randomly show text cell or image cell
            if randomIndex == 0 {
                // ramdom image from imageUrls
                let index = Int.random(in: 0..<imageUrls.count)
                let url = imageUrls[index]
                let model = SectionImageModel(withUrl: url)
                
                itemsSource.append(NonGenericSectionImageCellViewModel(model: model), to: sectionIndex)
            } else {
                itemsSource.append(NonGenericSectionImageCellViewModel(model: SectionTextModel(withTitle: "Just a text cell title", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")), to: sectionIndex)
            }
        }
    }
    
    // add section
    private func add() {
        let vm = SectionHeaderViewViewModel(model: SimpleModel(withTitle: "Section title #\(itemsSource.count + 1)"))
        itemsSource.appendSection(SectionList<BaseCellViewModel>(vm))
    }
    
    private func sort() {
        guard itemsSource.count > 0 else { return }
        
        let section = Int.random(in: 0..<itemsSource.count)
        itemsSource.sort(by: { (cvm1, cvm2) -> Bool in
            if let m1 = cvm1.model as? NumberModel, let m2 = cvm2.model as? NumberModel {
                return m1.number < m2.number
            }
            return false
        }, at: section)
    }
}

class NonGenericTextCellViewModel: BaseCellViewModel {
    let rxTitle = BehaviorRelay<String?>(value: nil)
    let rxDesc = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        guard let viewModel = model as? SectionTextModel else {
            return
        }
        rxTitle.accept(viewModel.title)
        rxDesc.accept(viewModel.desc)
    }

}



class NonGenericSectionImageCellViewModel: BaseCellViewModel {
    
    let rxImage = BehaviorRelay(value: NetworkImage())
    
    override func react() {
        guard let model = model as? SectionImageModel else { return }
        
        rxImage.accept(NetworkImage(withURL: model.imageUrl, placeholder: .from(color: .lightGray)))
    }
}


