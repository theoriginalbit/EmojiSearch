/// <#Description#>
public protocol EmojiSearchProvider {
    associatedtype CompiledSearchTerm
    
    /// The score from 0...1 to indicate the similarity between the search term and the source. 0 being the least
    /// similarity and 1 being exactly similar.
    typealias SearchResult = Double
    
    /// Performs steps to pre-processes the search term to improve performance where possible
    ///
    /// - Parameter term: the input to search for, typically text entered by a user
    func compileSearchTerm(from term: String) -> CompiledSearchTerm?
    
    /// Perform a comparison between the supplied `term` and `source` checking for similarity between the two inputs and
    /// returning a search result.
    ///
    /// - Parameters:
    ///   - term: the input to search for, typically text entered by a user
    ///   - source: the string to search with the term, typically an entity in the data source
    /// - Returns: A result representing the similarity between the term and source
    func search(for term: CompiledSearchTerm, in source: String) -> SearchResult
}
