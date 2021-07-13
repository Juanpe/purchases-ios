//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  SwiftStyleGuide.swift
//  PurchasesCoreSwift
//
//  Created by Andrés Boedo on 7/12/21.
//

// imports should be alphabetized
import Foundation

// keep one empty line after type declarations, and one before the end of it
protocol ValuePrintable {

    // make protocol variables read-only unless needed
    func foo() -> String

}

// use protocol extensions for default implementations of protocols for types
extension ValuePrintable where Self: NSNumber {

    func foo() -> String {
        return "the number as float is: \(self.floatValue)"
    }

}

// prefer structs to classes whenever possible.
// keep in mind that structs are value types.
// More info here: https://developer.apple.com/documentation/swift/choosing_between_structures_and_classes

// documentation is required for each public entity.
// Use jazzy-compatible syntax for documentation: https://github.com/realm/jazzy#supported-documentation-keywords
/// The MyStruct struct is responsible for ...
struct MyStruct {

    // don't explicitly define types unless needed.
    // prefer let to var whenever possible.

    // public properties, then internal, then private.
    /// mercury is used for ...
    public let mercury = false
    // use `maybe` prefix for optionals
    /// maybeVenus is used for ...
    public var maybeVenus: String?

    /// eath is used for ...
    public static var Earth = "earth"

    // use public private(set) when a public var is only written to within the class scope
    /// this variable will be readonly to the outside, but variable from inside the scope
    public private(set) var onlyReadFromOutside = 2.0

    // for internal properties, omit `internal` keyword since it's default
    let mars = 4.0

    private var jupiter = 2

    // use the valuesByKey naming convention for dictionary types
    private var productsByIdentifier: [String: Product]

    // public methods in the main declaration

}

// separate protocol conformance into extension
// so methods from the protocol are easy to locate
extension MyStruct: MyProtocol {

    // return can be omitted for one-liners
    func foo() -> String { "foo" }

}

// use protocol-oriented programming to add behaviors to types
// https://developer.apple.com/videos/play/wwdc2015/408/
extension MyStruct: PrettyPrintable { }

// add error extensions to make it easy to map errors to situations
enum MyCustomError: Error {

    case invalidDateComponents(_ dateComponents: DateComponents)
    case networkError

}

// private methods in an extension
private extension MyStruct {

    func somethingPrivate() -> String {
        return Bool.random() ? .saturn : .nepturn
    }

    func someMethodThatThrows() throws {
        throw Bool.random() ? MyCustomError.invalidDateComponents(DateComponents())
                            : MyCustomError.networkError
    }

}

// use private extensions of basic types to define constants
private extension String {

    static let saturn = "saturn"
    static let neptune = "neptune"

}
