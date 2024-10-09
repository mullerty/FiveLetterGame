import Foundation

class WordsManager {
    static let shared = WordsManager()
    var words: [String] = []
    
    private init() {
        loadWords()
    }
    
    private func loadWords() {
        if let url = Bundle.main.url(forResource: "words", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let wordsArray = json["words"] as? [String] {
                    words = wordsArray
                }
            } catch {
                print("Error loading words: \(error)")
            }
        }
    }
    
    func getRandomWord() -> String? {
        return words.randomElement()
    }
}
