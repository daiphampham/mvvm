//
//  OptionalExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 2/7/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import UIKit

extension Optional where Wrapped == String {
    
    public var isNilOrEmpty: Bool {
        return self == nil || self!.isEmpty
    }
    
}
