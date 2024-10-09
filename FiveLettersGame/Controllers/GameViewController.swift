import UIKit

final class GameViewController: UIViewController, GameViewDelegate{
    
    var gameState: GameState!
    var gameView = GameView()
    
    override func loadView() {
        gameView.delegate = self
        view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        gameView.updateUI()
    }
    
    // MARK: - Navigation Bar Setup
    func setupNavigationBar() {
        self.title = "5 букв"
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let backImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonPressed() {
        GameStateManager.saveGameState(gameState: gameState)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Game Alerts
    func showWinAlert() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Вы угадали слово!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Играть ещё", style: .default, handler: { _ in
            self.startNewRound()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showLoseAlert() {
        let message = "К сожалению, попытки закончились — загаданное слово было \(gameState.targetWord), но вы можете сыграть ещё."
        let alert = UIAlertController(title: "Игра окончена", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Выйти из игры", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Сыграть ещё", style: .default, handler: { _ in
            self.startNewRound()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Start New Round
    func startNewRound() {
        guard let newWord = WordsManager.shared.getRandomWord() else { return }
        gameState = GameState(targetWord: newWord.uppercased(), attempts: [], currentAttempt: "", isGameOver: false, didWin: false)
        
        gameView.resetGrid()
        gameView.resetKeyboard()
        
        gameView.updateUI()
    }
    
}

// MARK: GameViewDelegate extension
extension GameViewController {
    
    func didPressLetter(_ letter: String) {
        guard !gameState.isGameOver else { return }
        guard gameState.currentAttempt.count < 5 else { return }
        gameState.currentAttempt.append(letter)
        gameView.updateUI()
    }
    
    func didPressDelete() {
        guard !gameState.isGameOver else { return }
        if !gameState.currentAttempt.isEmpty {
            gameState.currentAttempt.removeLast()
            gameView.updateUI()
        }
    }
    
    func didPressDone() {
        guard !gameState.isGameOver else { return }
        guard gameState.currentAttempt.count == 5 else { return }
        gameState.currentAttempt = gameState.currentAttempt.uppercased()
        gameState.attempts.append(gameState.currentAttempt)
        if gameState.currentAttempt == gameState.targetWord {
            gameState.isGameOver = true
            gameState.didWin = true
            showWinAlert()
        } else if gameState.attempts.count >= 6 {
            gameState.isGameOver = true
            gameState.didWin = false
            showLoseAlert()
        } else {
            gameState.currentAttempt = ""
        }
        GameStateManager.saveGameState(gameState: gameState)
        gameView.updateUI()
    }
    
    func getColorForLetter(attemptLetter: Character, position: Int) -> UIColor {
        let targetWord = gameState.targetWord
        if targetWord.contains(attemptLetter) {
            if targetWord[targetWord.index(targetWord.startIndex, offsetBy: position)] == attemptLetter {
                return .green
            } else {
                return .white
            }
        } else {
            return .gray
        }
    }
    
    func getColorsForLetterButton(letter: String) -> (UIColor, UIColor, UIColor){
        var backgroundColor: UIColor = .black
        var borderColor: UIColor = .gray
        var titleColor: UIColor = .white
        for attempt in gameState.attempts {
            for (index, char) in attempt.enumerated() {
                if String(char) == letter {
                    let targetChar = gameState.targetWord[gameState.targetWord.index(gameState.targetWord.startIndex, offsetBy: index)]
                    if char == targetChar {
                        backgroundColor = .green
                        borderColor = .green
                        titleColor = .black
                    } else if gameState.targetWord.contains(char) {
                        if backgroundColor != .green {
                            backgroundColor = .white
                            borderColor = .white
                            titleColor = .black
                        }
                    } else {
                        if backgroundColor != .green && backgroundColor != .white {
                            backgroundColor = .gray
                            borderColor = .gray
                            titleColor = .white
                        }
                    }
                }
            }
        }
        return (backgroundColor, borderColor, titleColor)
    }
    
    func getActionButtonsState() -> (Bool, Bool){
        let checkButtonState = gameState.currentAttempt.count == 5
        let backspaceButtonState = !gameState.currentAttempt.isEmpty
        return (checkButtonState, backspaceButtonState)
    }
    
    func getAttempts() -> [String] {
        return gameState.attempts
    }
    
    func getGameOverState() -> Bool {
        return gameState.isGameOver
    }
    
    func getCurrentAttemptSymbol(colIndex: Int) -> String {
        if colIndex < gameState.currentAttempt.count {
            let index = gameState.currentAttempt.index(gameState.currentAttempt.startIndex, offsetBy: colIndex)
            return String(gameState.currentAttempt[index])
        }
        return ""
    }
}
