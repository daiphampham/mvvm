//
//  ListPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

open class ListPage<VM: IListViewModel>: Page<VM>, UITableViewDataSource, UITableViewDelegate {
    
    public typealias CVM = VM.CellViewModelElement
    
    public let tableView: UITableView
    
    public init(viewModel: VM? = nil, style: UITableView.Style = .plain) {
        tableView = UITableView(frame: .zero, style: style)
        super.init(viewModel: viewModel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        super.viewDidLoad()
    }
    
    open override func initialize() {
        tableView.autoPinEdgesToSuperviewEdges(with: .zero)
    }
    
    open override func destroy() {
        super.destroy()
        tableView.removeFromSuperview()
    }
    
    open override func bindViewAndViewModel() {
        tableView.reloadData()
        
        tableView.rx.itemSelected.asObservable().subscribe(onNext: onItemSelected) => disposeBag
        viewModel?.itemsSource.collectionChanged.subscribe(onNext: onDataSourceChanged) => disposeBag
    }
    
    open override func localHudToggled(_ value: Bool) {
        tableView.isHidden = value
    }
    
    private func onItemSelected(_ indexPath: IndexPath) {
        guard let viewModel = self.viewModel else { return }
        let cellViewModel = viewModel.itemsSource[indexPath.row, indexPath.section]
        
        viewModel.rxSelectedItem.accept(cellViewModel)
        viewModel.rxSelectedIndex.accept(indexPath)
        
        viewModel.selectedItemDidChange(cellViewModel)
        
        selectedItemDidChange(cellViewModel)
    }
    
    private func onDataSourceChanged(_ changeSet: ChangeSet) {
        switch changeSet {
        case .insertSection(let section):
            tableView.insertSections([section], with: .top)
            
        case .deleteSection(let section):
            if section < 0 {
                if tableView.numberOfSections > 0 {
                    let sections = IndexSet(0...tableView.numberOfSections - 1)
                    tableView.deleteSections(sections, with: .bottom)
                }
            } else {
                tableView.deleteSections([section], with: .bottom)
            }
            
        case .insertElements(let indice, let section):
            let indexPaths = indice.map { IndexPath(row: $0, section: section) }
            tableView.insertRows(at: indexPaths, with: .top)
            
        case .deleteElements(let indice, let section):
            let indexPaths = indice.map { IndexPath(row: $0, section: section) }
            tableView.deleteRows(at: indexPaths, with: .bottom)
        }
    }
    
    // MARK: - Abstract for subclasses
    
    /**
     Subclasses have to override this method to return correct cell identifier based `CVM` type.
     */
    open func cellIdentifier(_ cellViewModel: CVM) -> String {
        fatalError("Subclasses have to implement this method.")
    }
    
    /**
     Subclasses override this method to handle cell pressed action.
     */
    open func selectedItemDidChange(_ cellViewModel: CVM) { }
    
    // MARK: - Table view datasources
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.itemsSource.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.itemsSource.countElements(at: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        let cellViewModel = viewModel.itemsSource[indexPath.row, indexPath.section]
        
        // set index for each cell
        (cellViewModel as? IndexableCellViewModel)?.setIndexPath(indexPath)
        
        let identifier = cellIdentifier(cellViewModel)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let cell = cell as? IAnyView {
            cell.anyViewModel = cellViewModel
        }
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table view delegates
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }
}









