import EmojiSearch
import Fuse

/// <#Description#>
public struct FuseSearchProvider: EmojiSearchProvider {
    public typealias CompiledSearchTerm = Fuse.Pattern
    
    private let fuse: Fuse
    
    /// Create a new instance of the search provider.
    ///
    /// - SeeAlso: Fuse documentation for more information about the parameters. `threshold` default has been changed
    /// to `0.1` to provide more relevant results for Emoji since a lot of them have similar names.
    public init (location: Int = 0, distance: Int = 100, threshold: Double = 0.1, maxPatternLength: Int = 32, isCaseSensitive caseSensitive: Bool = false, tokenize: Bool = false) {
        fuse = Fuse(location: location, distance: distance, threshold: threshold, maxPatternLength: maxPatternLength, isCaseSensitive: caseSensitive, tokenize: tokenize)
    }
    
    /// See `EmojiSearchProvider`
    public func compileSearchTerm(from term: String) -> CompiledSearchTerm? {
        fuse.createPattern(from: term)
    }
    
    /// See `EmojiSearchProvider`
    public func search(for term: CompiledSearchTerm, in source: String) -> SearchResult {
        guard let score = fuse.search(term, in: source)?.score else { return 0 }
        return 1.0 - score // fuse rates 0.0 as exact match, we want to invert this score
    }
}
