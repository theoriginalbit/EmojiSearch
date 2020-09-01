import EmojiSearch

struct MockEmojiDataSource: EmojiDataSource {
    var emojis: [Emoji]
}

class Emoji: EmojiDefinition, CustomDebugStringConvertible, Equatable, Decodable {
    let searchTerms: [String]
    
    init(terms: String...) {
        searchTerms = terms
    }
    
    var debugDescription: String {
        searchTerms.first!
    }
    
    public static func ==(lhs: Emoji, rhs: Emoji) -> Bool {
        lhs.searchTerms == rhs.searchTerms
    }
}
