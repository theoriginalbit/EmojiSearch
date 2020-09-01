import Foundation

public protocol EmojiDefinition {
    var searchTerms: [String] { get }
}

public protocol EmojiDataSource {
    associatedtype Emoji: EmojiDefinition
    
    var emojis: [Emoji] { get }
}
