//
//  Model.swift
//  dailydota2
//
//  Created by Dao Duy Duong on 6/4/15.
//  Copyright (c) 2015 Nover. All rights reserved.
//

import Foundation
import ObjectMapper

public class Model: NSObject, Mappable {
    
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    public func mapping(map: Map) {}
    
}







