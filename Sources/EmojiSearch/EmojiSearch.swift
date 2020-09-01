import Foundation
import Fuse

public struct EmojiSearch<DataSource: EmojiDataSource> {
    private typealias SearchResult = (emoji: DataSource.Emoji, score: Double)
    
    private let dataSource: DataSource
    private let fuse = Fuse()
    
    public init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    public func search(for search: String, limit: Int? = nil) -> [DataSource.Emoji] {
        let limit = limit ?? dataSource.emojis.count
        
        // Improve performance by creating the fuse pattern up front, returning all emojis if the pattern is invalid
        guard let pattern = fuse.createPattern(from: search) else { return Array(dataSource.emojis.prefix(limit)) }
        
        // Search baby search
        return dataSource.emojis
            .compactMap { self.bestMatch(for: pattern, in: $0) }
            .sorted(by: { $0.score < $1.score })
            .prefix(limit)
            .map { $0.emoji }
    }
    
    private func bestMatch(for pattern: Fuse.Pattern, in emoji: DataSource.Emoji) -> SearchResult? {
        emoji.searchTerms
            .compactMap {
                guard let result = fuse.search(pattern, in: $0) else { return nil }
                return SearchResult(emoji: emoji, score: result.score)
            }
            .sorted(by: { $0.score < $1.score })
            .first
    }
}
