//
//  YCoreTests.swift
//  
//
//  Created by Felix Heilmeyer on 24.09.20.
//

import XCTest
@testable import yjsSwift

final class YCoreTests: XCTestCase {
    func testLoadingYJSLibrary() {
        let returnValue = YCore.shared.context.evaluateScript(
        """
            const doc = new yjs.Doc()
            const array = doc.getArray('test')
            array.insert(0,['a'])
            array.insert(0,['b'])
            array.toJSON()
        """)
        let returnString = returnValue?.toString()
        XCTAssertNotNil(returnString)
        XCTAssertEqual("b,a", returnString)
    }

    static var allTests = [
        ("testLoadingYJSLibrary", testLoadingYJSLibrary),
    ]
}
