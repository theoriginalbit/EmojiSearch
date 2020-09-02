import Foundation

/// <#Description#>
public struct EmojiSearch<SearchProvider: EmojiSearchProvider, DataSource: EmojiDataSource> {
    struct SearchResult {
        let emoji: DataSource.Emoji
        let score: Double
        
        init?(emoji: DataSource.Emoji, score: Double) {
            guard 0.0 ... 1.0 ~= score else {
                assertionFailure("SearchProvider has supplied score outside of required 0...1 range")
                return nil
            }
            self.emoji = emoji
            self.score = score
        }
    }
    
    private let dataSource: DataSource
    private let searchProvider: SearchProvider
        
    /// Creates a new emoji search with the provided options
    ///
    /// - Parameters:
    ///   - searchProvider: <#searchProvider description#>
    ///   - dataSource: the source to retreive the emoji data
    public init(searchProvider: SearchProvider, dataSource: DataSource) {
        self.searchProvider = searchProvider
        self.dataSource = dataSource
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
        guard let term = searchProvider.compileSearchTerm(from: search) else {
            return Array(dataSource.emojis.prefix(limit))
        }
        
        /// A function that finds the best matching search term for the supplied emoji, this may not be the best
        /// term for the pattern, but it's the best term for **this** emoji.
        func bestMatch(in emoji: DataSource.Emoji) -> SearchResult? {
            emoji.searchTerms
                .compactMap { SearchResult(emoji: emoji, score: searchProvider.search(for: term, in: $0)) }
                .sorted(by: \.score, order: .descending)
                .first
        }
        
        // Search baby search
        return dataSource.emojis
            .compactMap(bestMatch(in:))
            .sorted(by: \.score, order: .descending)
            .prefix(limit)
            .map { $0.emoji }
    }
}
