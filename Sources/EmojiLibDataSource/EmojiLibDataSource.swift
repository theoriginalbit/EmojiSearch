import EmojiSearch
import Foundation

public struct EmojiLibDataSource: EmojiDataSource {
    public var emojis: [EmojiLibModel]
    
    public init?() {
        guard let url = Bundle.module.url(forResource: "emojis", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let container = try? JSONDecoder().decode(EmojiLibJsonFile.self, from: data)
        else { return nil }
        
        emojis = container.emojis
    }
}
