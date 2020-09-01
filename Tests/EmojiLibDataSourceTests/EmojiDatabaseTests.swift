import XCTest
@testable import EmojiLibDataSource
import EmojiSearch

final class EmojiSearchTests: XCTestCase {
    func testEmojiDatabase() {
        guard let database = EmojiLibDataSource() else {
            return XCTFail("Unable to construct database")
        }
        
        let searchProvider = EmojiSearch(dataSource: database)
        
        XCTAssertEqual(try XCTUnwrap(searchProvider.search(for: "snail", limit: 1).first).char, "🐌")
        XCTAssertEqual(try XCTUnwrap(searchProvider.search(for: "smile", limit: 1).first).char, "😃")
        XCTAssertEqual(try XCTUnwrap(searchProvider.search(for: "strong", limit: 1).first).char, "💪")
        XCTAssertEqual(try XCTUnwrap(searchProvider.search(for: "dog", limit: 1).first).char, "🐶")
    }
}

extension EmojiLibModel: CustomStringConvertible {
    public var description: String { char }
}
