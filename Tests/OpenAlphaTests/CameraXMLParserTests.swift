import Foundation
import XCTest
@testable import OpenAlpha

// MARK: - `CameraXMLParserTests` -

final class CameraXMLParserTests: XCTestCase {
    
    // MARK: - `Tests` -
    
    // A7-M2
    func test_parseA7M2Items() async throws {
        do {
            let result = try await ItemXMLParser(with: .A7M2).parse()
            XCTAssert(!result.isEmpty)
            let item = result[0].resource
            XCTAssertNotNil(item.thumbnail)
            XCTAssertNotNil(item.small)
            XCTAssertNotNil(item.large)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // A7-M3
    func test_parseA7M3Items() async throws {
        do {
            let result = try await ItemXMLParser(with: .A7M3).parse()
            XCTAssert(!result.isEmpty)
            let item = result[0].resource
            XCTAssertNotNil(item.thumbnail)
            XCTAssertNotNil(item.small)
            XCTAssertNotNil(item.large)
            XCTAssertNotNil(item.original)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - `ItemXMLParser` -

fileprivate extension ItemXMLParser {
    convenience init(with camera: Camera) async throws {
        let response = try Bundle.response(for: camera)
        self.init(response)
    }
}
