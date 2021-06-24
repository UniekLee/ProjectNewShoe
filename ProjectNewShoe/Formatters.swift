//
//  Formatters.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 24/06/2021.
//

import Foundation

class Formatter {
    private static let shared: Formatter = Formatter()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

extension Formatter {
    static var date: DateFormatter { Formatter.shared.dateFormatter }
}
