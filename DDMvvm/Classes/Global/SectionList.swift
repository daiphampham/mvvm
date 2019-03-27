//
//  SectionList.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

public enum ChangeSet {
    case deleteSection(section: Int)
    case insertSection(section: Int)
    case deleteElements(elementIndice: [Int], section: Int)
    case insertElements(elementIndice: [Int], section: Int)
}

/// Section list data sources
public class SectionList<T> where T: Equatable {
    
    public let key: Any
    
    private var innerSources = [T]()
    
    public subscript(index: Int) -> T {
        get { return innerSources[index] }
        set(newValue) { insert(newValue, at: index) }
    }
    
    public var count: Int {
        return innerSources.count
    }
    
    public var first: T? {
        return innerSources.first
    }
    
    public var last: T? {
        return innerSources.last
    }
    
    public var allElements: [T] {
        return innerSources
    }
    
    public init(_ key: Any, initialElements: [T] = []) {
        self.key = key
        innerSources.append(contentsOf: initialElements)
    }
    
    public func forEach(_ body: ((Int, T) -> ())) {
        for (i, element) in innerSources.enumerated() {
            body(i, element)
        }
    }
    
    public func insert(_ element: T, at index: Int) {
        innerSources.insert(element, at: index)
    }
    
    public func insert(_ elements: [T], at index: Int) {
        innerSources.insert(contentsOf: elements, at: index)
    }
    
    public func append(_ element: T) {
        innerSources.append(element)
    }
    
    public func append(_ elements: [T]) {
        innerSources.append(contentsOf: elements)
    }
    
    @discardableResult
    public func remove(at index: Int) -> T? {
        return innerSources.remove(at: index)
    }
    
    public func remove(at indice: [Int]) {
        let newSources = innerSources.enumerated().compactMap { indice.contains($0.offset) ? nil : $0.element }
        innerSources = newSources
    }
    
    public func removeAll() {
        innerSources.removeAll()
    }
    
    @discardableResult
    public func firstIndex(of element: T) -> Int? {
        return innerSources.firstIndex(of: element)
    }
    
    @discardableResult
    public func lastIndex(of element: T) -> Int? {
        return innerSources.lastIndex(of: element)
    }
    
    @discardableResult
    public func firstIndex(where predicate: (T) throws -> Bool) rethrows -> Int? {
        return try innerSources.firstIndex(where: predicate)
    }
    
    @discardableResult
    public func lastIndex(where predicate: (T) throws -> Bool) rethrows -> Int? {
        return try innerSources.lastIndex(where: predicate)
    }
    
    public func map<U>(_ transform: (T) throws -> U) rethrows -> [U] {
        return try innerSources.map(transform)
    }
    
    public func compactMap<U>(_ transform: (T) throws -> U?) rethrows -> [U] {
        return try innerSources.compactMap(transform)
    }
}

public class ReactiveCollection<T> where T: Equatable {
    
    private var innerSources: [SectionList<T>] = []
    
    private let publisher = PublishRelay<ChangeSet>()
    private let rxInnerSources = BehaviorRelay<[SectionList<T>]>(value: [])
    
    public let collectionChanged: Observable<ChangeSet>
    
    public subscript(index: Int, section: Int) -> T {
        get { return innerSources[section][index] }
        set(newValue) { insert(newValue, at: index, of: section) }
    }
    
    public subscript(index: Int) -> SectionList<T> {
        get { return innerSources[index] }
        set(newValue) { insertSection(newValue, at: index) }
    }
    
    public var count: Int {
        return innerSources.count
    }
    
    public var first: SectionList<T>? {
        return innerSources.first
    }
    
    public var last: SectionList<T>? {
        return innerSources.last
    }
    
    public init() {
        collectionChanged = publisher.asObservable()
    }
    
    public func forEach(_ body: ((Int, SectionList<T>) -> ())) {
        for (i, section) in innerSources.enumerated() {
            body(i, section)
        }
    }
    
    public func countElements(at section: Int = 0) -> Int {
        guard section >= 0 && section < innerSources.count else { return 0 }
        return innerSources[section].count
    }
    
    // MARK: - section manipulations
    
    public func reset(_ sources: [[T]]) {
        removeAll()
        
        for sectionList in sources {
            appendSection("", elements: sectionList)
        }
    }
    
    public func reset(_ sources: [SectionList<T>]) {
        removeAll()
        
        for sectionList in sources {
            appendSection(sectionList)
        }
    }
    
    public func insertSection(_ key: Any, elements: [T], at index: Int) {
        insertSection(SectionList<T>(key, initialElements: elements), at: index)
    }
    
    public func insertSection(_ sectionList: SectionList<T>, at index: Int) {
        innerSources.insert(sectionList, at: index)
        rxInnerSources.accept(innerSources)
        publisher.accept(.insertSection(section: index))
    }
    
    public func appendSections(_ sectionLists: [SectionList<T>]) {
        for sectionList in sectionLists {
            appendSection(sectionList)
        }
    }
    
    public func appendSection(_ key: Any, elements: [T]) {
        appendSection(SectionList<T>(key, initialElements: elements))
    }
    
    public func appendSection(_ sectionList: SectionList<T>) {
        let section = innerSources.count == 0 ? 0 : innerSources.count
        
        innerSources.append(sectionList)
        rxInnerSources.accept(innerSources)
        publisher.accept(.insertSection(section: section))
    }
    
    @discardableResult
    public func removeSection(at index: Int) -> SectionList<T> {
        let element = innerSources.remove(at: index)
        rxInnerSources.accept(innerSources)
        publisher.accept(.deleteSection(section: index))
        
        return element
    }
    
    public func removeAll() {
        innerSources.removeAll()
        rxInnerSources.accept(innerSources)
        publisher.accept(.deleteSection(section: -1))
    }
    
    // MARK: - section elements manipulations
    
    public func insert(_ element: T, at index: Int, of section: Int = 0) {
        if innerSources[section].count == 0 {
            innerSources[section].append(element)
            rxInnerSources.accept(innerSources)
            
            publisher.accept(.insertElements(elementIndice: [index], section: 0))
        } else if index < innerSources[section].count {
            innerSources[section].insert(element, at: index)
            rxInnerSources.accept(innerSources)
            
            publisher.accept(.insertElements(elementIndice: [index], section: section))
        }
    }
    
    public func insert(_ elements: [T], at index: Int, of section: Int = 0) {
        innerSources[section].insert(elements, at: index)
        rxInnerSources.accept(innerSources)
        
        let indice = elements.count == 0 ? [] : Array(0..<elements.count)
        publisher.accept(.insertElements(elementIndice: indice, section: section))
    }
    
    public func append(_ element: T, to section: Int = 0) {
        if innerSources.count == 0 {
            appendSection(SectionList<T>("", initialElements: [element]))
            return
        }
        
        let index = innerSources[section].count == 0 ? 0 : innerSources[section].count
        innerSources[section].append(element)
        rxInnerSources.accept(innerSources)
        publisher.accept(.insertElements(elementIndice: [index], section: section))
    }
    
    public func append(_ elements: [T], to section: Int = 0) {
        if innerSources.count == 0 {
            appendSection("", elements: elements)
            return
        }
        
        let indice: [Int]
        if elements.count == 0 {
            indice = []
        } else {
            let startIndex = innerSources[section].count == 0 ? 0 : innerSources[section].count
            let endIndex = (startIndex + (elements.count - 1))
            indice = Array(startIndex...endIndex)
        }
        
        innerSources[section].append(elements)
        rxInnerSources.accept(innerSources)
        publisher.accept(.insertElements(elementIndice: indice, section: section))
    }
    
    @discardableResult
    public func remove(at index: Int, of section: Int = 0) -> T? {
        let element = innerSources[section].remove(at: index)
        rxInnerSources.accept(innerSources)
        publisher.accept(.deleteElements(elementIndice: [index], section: section))
        
        return element
    }
    
    public func remove(at indice: [Int], of section: Int = 0) {
        innerSources[section].remove(at: indice)
        rxInnerSources.accept(innerSources)
        publisher.accept(.deleteElements(elementIndice: indice, section: section))
    }
    
    public func asObservable() -> Observable<[SectionList<T>]> {
        return rxInnerSources.asObservable()
    }
    
    public func indexForSection(withKey key: AnyObject) -> Int? {
        return innerSources.firstIndex(where: { key.isEqual($0.key) })
    }
    
    @discardableResult
    public func firstIndex(of element: T, at section: Int = 0) -> Int? {
        return innerSources[section].firstIndex(of: element)
    }
    
    @discardableResult
    public func lastIndex(of element: T, at section: Int) -> Int? {
        return innerSources[section].lastIndex(of: element)
    }
    
    @discardableResult
    public func firstIndex(where predicate: (T) throws -> Bool, at section: Int) rethrows -> Int? {
        return try innerSources[section].firstIndex(where: predicate)
    }
    
    @discardableResult
    public func lastIndex(where predicate: (T) throws -> Bool, at section: Int) rethrows -> Int? {
        return try innerSources[0].lastIndex(where: predicate)
    }
}
