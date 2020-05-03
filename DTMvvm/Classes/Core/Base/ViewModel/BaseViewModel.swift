//
//  BaseViewModel.swift
//  Action
//
//  Created by pham.minh.tien on 5/3/20.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: Nongeneric Type
// Base view model sẽ đi với View tương ứng.
// Mỗi View model sẽ đi với một Base Model tưng ứng.

open class BaseViewModel: NSObject, IViewModel, IReactable {
    
    public typealias ModelElement = Model
    
    private var _model: Model?
    public var model: Model? {
        get { return _model }
        set {
            _model = newValue
            modelChanged()
        }
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    public let rxViewState = BehaviorRelay<ViewState>(value: .none)
    public let rxShowLocalHud = BehaviorRelay(value: false)
    
    public let navigationService: INavigationService = DependencyManager.shared.getService()
    
    var isReacted = false
    
    required public init(model: Model? = nil) {
        _model = model
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
    deinit {
        destroy()
    }
    
    /**
     Everytime model changed, this method will get called. Good place to update our viewModel
     */
    open func modelChanged() {}
    
    /**
     This method will be called once. Good place to initialize our viewModel (listen, subscribe...) to any signals
     */
    open func react() {}
    
    func reactIfNeeded() {
        guard !isReacted else { return }
        isReacted = true
        
        react()
    }
}

open class BaseListViewModel: BaseViewModel, IListViewModel {
    
    public typealias CellViewModelElement = BaseCellViewModel
    
    public typealias ItemsSourceType = [SectionList<BaseCellViewModel>]
    
    public let itemsSource = ReactiveCollection<BaseCellViewModel>()
    public let rxSelectedItem = BehaviorRelay<BaseCellViewModel?>(value: nil)
    public let rxSelectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    required public init(model: Model? = nil) {
        super.init(model: model)
    }
    
    open override func destroy() {
        super.destroy()
        
        itemsSource.forEach { (_, sectionList) in
            sectionList.forEach({ (_, cvm) in
                cvm.destroy()
            })
        }
    }
    
    open func selectedItemDidChange(_ cellViewModel: BaseCellViewModel) { }
}

/**
A based ViewModel for TableCell and CollectionCell

The difference between ViewModel and CellViewModel is that CellViewModel does not contain NavigationService. Also CellViewModel
contains its own index
*/

open class BaseCellViewModel: NSObject, IGenericViewModel, IIndexable, IReactable {
    
    public typealias ModelElement = Model
    
    private var _model: Model?
    public var model: Model? {
        get { return _model }
        set {
            _model = newValue
            modelChanged()
        }
    }
    
    /// Each cell will keep its own index path
    /// In some cases, each cell needs to use this index to create some customizations
    public internal(set) var indexPath: IndexPath?
    public internal(set) var  isLastRow: Bool = false
    /// Bag for databindings
    public var disposeBag: DisposeBag? = DisposeBag()
    
    var isReacted = false
    
    public required init(model: Model? = nil) {
        _model = model
    }

    open func modelChanged() {}
    open func react() {}
    
    func reactIfNeeded() {
        guard !isReacted else { return }
        isReacted = true
        react()
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
}

