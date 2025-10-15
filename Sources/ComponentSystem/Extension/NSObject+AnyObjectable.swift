//
//  File.swift
//  ComponentSystem
//
//  Created by 박지연 on 10/15/25.
//

import Foundation

public protocol AnyObjectable {
    static var getClassName: String { get }
}

extension NSObject: AnyObjectable {
    public static var getClassName: String {
        return String(describing: self)
    }
}
