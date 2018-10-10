//
//  Views.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 10/7/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import UIKit
import RxSwift

/// Based UIView that support ViewModel
open class View<VM: IGenericViewModel>: UIView, IView {
    
    public typealias ViewModelElement = VM
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    private var _viewModel: VM?
    public var viewModel: VM? {
        get { return _viewModel }
        set {
            if newValue != _viewModel {
                destroy()
                
                _viewModel = newValue
                viewModelChanged()
            }
        }
    }
    
    public var anyViewModel: Any? {
        get { return _viewModel }
        set { viewModel = newValue as? VM }
    }
    
    public init(viewModel: VM? = nil) {
        self._viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    public init(frame: CGRect, viewModel: VM? = nil) {
        self._viewModel = viewModel
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        initialize()
        viewModelChanged()
    }
    
    private func viewModelChanged() {
        bindViewAndViewModel()
        viewModel?.react()
    }
    
    open func initialize() {}
    open func bindViewAndViewModel() {}
    
    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }
}

/// Master based cell for CollectionPage
open class CollectionCell<VM: IGenericViewModel>: UICollectionViewCell, IView {
    
    public typealias ViewModelElement = VM
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    private var _viewModel: VM?
    public var viewModel: VM? {
        get { return _viewModel }
        set {
            if newValue != _viewModel {
                destroy()
                
                _viewModel = newValue
                viewModelChanged()
            }
        }
    }
    
    public var anyViewModel: Any? {
        get { return _viewModel }
        set { viewModel = newValue as? VM }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        destroy()
    }
    
    private func setup() {
        backgroundColor = .clear
        initialize()
    }
    
    private func viewModelChanged() {
        bindViewAndViewModel()
        viewModel?.react()
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }
    
    open func initialize() {}
    open func bindViewAndViewModel() {}
}

/// Master cell for ListPage
open class TableCell<VM: IGenericViewModel>: UITableViewCell, IView {
    
    public typealias ViewModelElement = VM
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    private var _viewModel: VM?
    public var viewModel: VM? {
        get { return _viewModel }
        set {
            if newValue != _viewModel {
                destroy()
                
                _viewModel = newValue
                viewModelChanged()
            }
        }
    }
    
    public var anyViewModel: Any? {
        get { return _viewModel }
        set { viewModel = newValue as? VM }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        destroy()
    }
    
    private func setup() {
        backgroundColor = .clear
        separatorInset = .zero
        layoutMargins = .zero
        preservesSuperviewLayoutMargins = false
        
        initialize()
    }
    
    private func viewModelChanged() {
        bindViewAndViewModel()
        viewModel?.react()
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }
    
    open func initialize() {}
    open func bindViewAndViewModel() {}
}










