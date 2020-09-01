import Foundation
import Fuse

public struct EmojiSearch<DataSource: EmojiDataSource> {
    private typealias SearchResult = (emoji: DataSource.Emoji, score: Double)
    
    private let dataSource: DataSource
    private let fuse: Fuse
        
    /// Creates a new emoji search with the provided options
    ///
    /// - Parameters:
    ///   - dataSource: the source to retreive the emoji data
    ///   - searchThreshold: the cutoff threshold for searching, the lower the number the closer the match.
    ///   The higher the value the longer the search will take. The default value is `0.1`.
    public init(dataSource: DataSource, searchThreshold threshold: Double = 0.1) {
        self.dataSource = dataSource
        self.fuse = Fuse(threshold: threshold)
    }
    
    /// Search the emoji data source for any emojis matching the supplied search string, up to the provided limit or all
    /// matches if no limit is provided.
    ///
    /// - Parameters:
    ///   - search: the search term
    ///   - limit: the maximum number of items to return
    /// - Returns: the emojis that match the search term
    public func search(for search: String, limit: Int? = nil) -> [DataSource.Emoji] {
        let limit = limit ?? dataSource.emojis.count
        
        // Improve performance by creating the fuse pattern up front, returning all emojis if the pattern is invalid
        guard let pattern = fuse.createPattern(from: search) else { return Array(dataSource.emojis.prefix(limit)) }
        
        /// A function that finds the best matching search term for the supplied emoji, this may not be the best
        /// term for the pattern, but it's the best term for **this** emoji.
        func bestMatch(in emoji: DataSource.Emoji) -> SearchResult? {
            emoji.searchTerms
                .compactMap {
                    guard let result = fuse.search(pattern, in: $0) else { return nil }
                    print(emoji.searchTerms.first!, result.score)
                    return SearchResult(emoji: emoji, score: result.score)
                }
                .sorted(by: \.score, order: .ascending) // the lower the score the better
                .first
        }
        
        // Search baby search
        return dataSource.emojis
            .compactMap(bestMatch(in:))
            .sorted(by: \.score, order: .ascending) // the lower the score the better
            .prefix(limit)
            .map { $0.emoji }
    }
}
