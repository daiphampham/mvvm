//
//  ArrayExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import Foundation

extension Array {
    
    public func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

extension Array where Element: Model {
    
    public func toCellViewModels<T: IGenericViewModel>() -> [T] where T.ModelElement == Element {
        return self.flatMap { [T(model: $0)] }
    }
}
