//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  Logger.swift
//
//  Created by Andrés Boedo on 11/13/20.
//

import Foundation

@objc(RCLogLevel) public enum LogLevel: Int {

    case debug, info, warn, error

    func description() -> String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warn: return "WARN"
        case .error: return "ERROR"
        }
    }
}

class Logger {

    static var logLevel: LogLevel = .info
    static var logHandler: (LogLevel, String) -> Void = { level, message in
        NSLog("[\(frameworkDescription)] - \(level.description()): \(message)")
    }

    private static let frameworkDescription = "Purchases"

    static func log(level: LogLevel, message: String) {
        guard self.logLevel.rawValue <= level.rawValue else { return }
        logHandler(level, message)
    }

    static func log(level: LogLevel, intent: LogIntent, message: String) {
        let messageWithPrefix = "\(intent.suffix) \(message)"
        Logger.log(level: level, message: messageWithPrefix)
    }

    static func debug(_ message: String) {
        log(level: .debug, intent: .info, message: message)
    }

    static func info(_ message: String) {
        log(level: .info, intent: .info, message: message)
    }

    static func warn(_ message: String) {
        log(level: .warn, intent: .warning, message: message)
    }

    static func error(_ message: String) {
        log(level: .error, intent: .rcError, message: message)
    }

}

extension Logger {

    static func appleError(_ message: String) {
        log(level: .error, intent: .appleError, message: message)
    }

    static func appleWarning(_ message: String) {
        log(level: .warn, intent: .appleError, message: message)
    }

    static func purchase(_ message: String) {
        log(level: .debug, intent: .purchase, message: message)
    }

    static func rcPurchaseSuccess(_ message: String) {
        log(level: .info, intent: .rcPurchaseSuccess, message: message)
    }

    static func rcSuccess(_ message: String) {
        log(level: .debug, intent: .rcSuccess, message: message)
    }

    static func user(_ message: String) {
        log(level: .debug, intent: .user, message: message)
    }

}