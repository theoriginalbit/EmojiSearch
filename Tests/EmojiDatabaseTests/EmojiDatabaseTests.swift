import XCTest
@testable import EmojiDatabase
import EmojiSearch

final class EmojiSearchTests: XCTestCase {
    func testEmojiDatabase() {
        guard let database = EmojiDatabase() else {
            return XCTFail("Unable to construct database")
        }
        
        let searchProvider = EmojiSearch(dataSource: database)
        print(searchProvider.search(for: "snail", limit: 10))
        print("####")
    }
}
