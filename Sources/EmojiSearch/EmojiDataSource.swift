import Foundation

/// <#Description#>
public protocol EmojiDefinition {
    /// <#Description#>
    var searchTerms: [String] { get }
}

/// <#Description#>
public protocol EmojiDataSource {
    associatedtype Emoji: EmojiDefinition
    
    /// <#Description#>
    var emojis: [Emoji] { get }
}
