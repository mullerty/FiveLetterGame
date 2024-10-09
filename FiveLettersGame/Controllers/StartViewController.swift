import UIKit

final class StartViewController: UIViewController {
    
    private let menuView = MenuView()
    
    override func loadView() {
        view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func setupActions() {
        menuView.startNewGameButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        menuView.continueGameButton.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
    }
    
    func updateUI() {
        menuView.continueGameButton.isHidden = !hasSavedGame()
    }
    
    func hasSavedGame() -> Bool {
        if let data = UserDefaults.standard.data(forKey: "gameState") {
            let decoder = JSONDecoder()
            if let gameState = try? decoder.decode(GameState.self, from: data) {
                return !gameState.isGameOver
            }
        }
        return false
    }
    
    @objc func startNewGame() {
        let gameVC = GameViewController()
        gameVC.gameState = GameStateManager.createNewGameState()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc func continueGame() {
        let gameVC = GameViewController()
        if let savedGameState = GameStateManager.loadGameState() {
            gameVC.gameState = savedGameState
            navigationController?.pushViewController(gameVC, animated: true)
        } else {
            gameVC.gameState = GameStateManager.createNewGameState()
            navigationController?.pushViewController(gameVC, animated: true)
        }
    }
}
