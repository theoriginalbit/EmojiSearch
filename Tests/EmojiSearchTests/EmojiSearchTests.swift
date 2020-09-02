import XCTest
@testable import EmojiSearch

final class EmojiSearchTests: XCTestCase {
    func testEmojiSearch() {
        let grinning = Emoji(terms: "grinning", "face", "smile", "happy", ":)")
        let grimacing = Emoji(terms: "grimacing", "face", "grimace", "teeth")
        let expressionless = Emoji(terms: "expressionless", "face", "indifferent", "-_-", "meh", "deadpan")
        
        let emojis: [Emoji] = [grinning, grimacing, expressionless]
        let dataSource = MockEmojiDataSource(emojis: emojis)
        let emojiSearch = EmojiSearch(searchProvider: MockSearchProvider(), dataSource: dataSource)
        
        // "in" is at the start of "indifferent" within "expressionless"
        XCTAssertEqual(emojiSearch.search(for: "in", limit: 1), [expressionless])
        
        // it's an ordered list of closest match
        XCTAssertEqual(emojiSearch.search(for: "in", limit: 2), [expressionless, grinning])
        XCTAssertEqual(emojiSearch.search(for: "in"), [expressionless, grinning, grimacing])
        XCTAssertEqual(emojiSearch.search(for: ":)"), [grinning])
        XCTAssertEqual(emojiSearch.search(for: "smi"), [grinning])
    }
}
