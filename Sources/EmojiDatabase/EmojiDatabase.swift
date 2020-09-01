import EmojiSearch
import Foundation

public struct EmojiDatabase: EmojiDataSource {
    public var emojis: [EmojiModel]
    
    init?() {
        guard let url = Bundle.module.url(forResource: "emojis", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let container = try? JSONDecoder().decode(EmojiFile.self, from: data)
        else { return nil }
        
        emojis = container.emojis
    }
}

struct EmojiFile: Decodable {
    let emojis: [EmojiModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        emojis = try container.allKeys.reduce(into: []) { result, codingKey in
            let partial = try container.decode(PartialEmojiModel.self, forKey: codingKey)
            result.append(EmojiModel(name: codingKey.stringValue,
                                     keywords: partial.keywords,
                                     char: partial.char,
                                     category: partial.category))
         }
    }
    
    struct PartialEmojiModel: Decodable {
        let keywords: [String]
        let char: String
        let category: String
    }
}
