//
//  Log.swift
//  
//
//  Created by Felix Heilmeyer on 24.09.20.
//

import Foundation
import os.log

extension OSLog {
    private static let subsystem = Bundle.module.bundleIdentifier!
    static let javascript = OSLog(subsystem: subsystem, category: "javascript")
}
