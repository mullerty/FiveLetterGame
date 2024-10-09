import Foundation

struct GameState: Codable {
    var targetWord: String
    var attempts: [String]
    var currentAttempt: String
    var isGameOver: Bool
    var didWin: Bool
}
