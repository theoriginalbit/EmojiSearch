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

class MockSearchProvider: EmojiSearchProvider {
    typealias CompiledSearchTerm = String
    
    func compileSearchTerm(from term: String) -> String? { term }
    
    func search(for term: String, in source: String) -> SearchResult {
        if term == source {
            return 1.0
        }
        if source.hasPrefix(term) {
            return 0.7
        }
        if source.contains(term) {
            return 0.5
        }
        if source.hasSuffix(term) {
            return 0.3
        }
        return 0.0
    }
}
