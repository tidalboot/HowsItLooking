//
//  Extensions.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import Foundation

extension KeyValuePairs where Key == String {
    func queryParams() -> String {
        guard isEmpty == false else { return "" }
        return "?" + compactMap({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    }
}
