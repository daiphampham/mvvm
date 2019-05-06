//
//  StringExtensions.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

extension String {
    
    public func toURL() -> URL? {
        return URL(string: self)
    }
    
    public func toURLRequest() -> URLRequest? {
        if let url = toURL() {
            return URLRequest(url: url)
        }
        return nil
    }
    
    public func toHex() -> Int? {
        return Int(self, radix: 16)
    }
    
    public func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}




