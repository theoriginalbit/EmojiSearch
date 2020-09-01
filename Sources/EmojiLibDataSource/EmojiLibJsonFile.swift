import Foundation

struct EmojiLibJsonFile: Decodable {
    let emojis: [EmojiLibModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        emojis = try container.allKeys.reduce(into: []) { result, codingKey in
            let partial = try container.decode(PartialEmojiModel.self, forKey: codingKey)
            result.append(EmojiLibModel(name: codingKey.stringValue,
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

struct DynamicCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        self.intValue = intValue
        stringValue = String(describing: intValue)
    }
}
