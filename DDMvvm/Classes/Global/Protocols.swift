//
//  Protocols.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation
import RxSwift
import RxCocoa

public protocol IDestroyable: class {
    
    var disposeBag: DisposeBag? { get set }
    func destroy()
}

public protocol ITransionView: class {
    
    var animatorDelegate: AnimatorDelegate? { get set }
}

public protocol IView: IDestroyable {
    
    associatedtype ViewModelElement
    
    var viewModel: ViewModelElement? { get set }
    
    func initialize()
    func bindViewAndViewModel()
}

// MARK: - Viewmodel protocols

public protocol IGenericViewModel: IDestroyable {
    
    associatedtype ModelElement
    
    var model: ModelElement? { get set }
    
    func react()
}

public protocol IViewModel: IGenericViewModel {
    
    var viewState: BehaviorRelay<ViewState> { get }
    var showInlineLoader: BehaviorRelay<Bool> { get }
    
    var navigationService: INavigationService { get }
    
    init(model: ModelElement?)
}

public protocol IListViewModel: IViewModel {
    
    associatedtype CellViewModelElement: ICellViewModel
    
    var itemsSource: ReactiveCollection<CellViewModelElement> { get }
    var selectedItem: BehaviorRelay<CellViewModelElement?> { get }
    var selectedIndex: BehaviorRelay<IndexPath?> { get }
    
    func selectedItemDidChange(_ cellViewModel: CellViewModelElement)
}

public protocol ICellViewModel: IGenericViewModel, Equatable {
    
    init(model: ModelElement?)
}

















