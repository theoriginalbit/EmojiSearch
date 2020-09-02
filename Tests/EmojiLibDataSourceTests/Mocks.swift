import EmojiSearch

class MockSearchProvider: EmojiSearchProvider {
    typealias CompiledSearchTerm = String
    
    func compileSearchTerm(from term: String) -> String? { term }
    
    func search(for term: String, in source: String) -> SearchResult {
        if term == source {
            return 1.0
        }
        if source.contains(term) {
            return 0.5
        }
        return 0.0
    }
}
