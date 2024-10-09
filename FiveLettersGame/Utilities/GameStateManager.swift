//
//  GameStateManager.swift
//  FiveLettersGame
//
//  Created by Sobopov on 10.10.2024.
//

import Foundation

struct GameStateManager {
    
    static func createNewGameState() -> GameState {
        guard let newWord = WordsManager.shared.getRandomWord() else {
            fatalError("No words available")
        }
        return GameState(targetWord: newWord.uppercased(), attempts: [], currentAttempt: "", isGameOver: false, didWin: false)
    }
    
    static func loadGameState() -> GameState? {
        if let data = UserDefaults.standard.data(forKey: "gameState") {
            let decoder = JSONDecoder()
            if let state = try? decoder.decode(GameState.self, from: data) {
                return state
            }
        }
        return nil
    }
    
    static func saveGameState(gameState: GameState) {
        print(gameState)
        if !gameState.isGameOver {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(gameState) {
                UserDefaults.standard.set(data, forKey: "gameState")
            }
        } else {
            UserDefaults.standard.removeObject(forKey: "gameState")
        }
    }
    
    
}
