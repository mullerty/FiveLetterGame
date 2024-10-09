//
//  GameViewDelegate.swift
//  FiveLettersGame
//
//  Created by Sobopov on 10.10.2024.
//

import UIKit

protocol GameViewDelegate {
    func didPressLetter(_ letter: String)
    func didPressDone()
    func didPressDelete()
    func getColorForLetter(attemptLetter: Character, position: Int) -> UIColor
    func getColorsForLetterButton(letter: String) -> (UIColor, UIColor, UIColor)
    func getActionButtonsState() -> (Bool, Bool)
    func getAttempts() -> [String]
    func getGameOverState() -> Bool
    func getCurrentAttemptSymbol(colIndex: Int) -> String
}
