import EmojiSearch

public struct EmojiLibModel: EmojiDefinition {
    public let name: String
    public let keywords: [String]
    public let char: String
    public let category: String

    public var searchTerms: [String] {
        [name] + keywords
    }
}
