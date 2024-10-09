import UIKit

final class MenuView: UIView{
    
    let startNewGameButton = UIButton(type: .system)
    let continueGameButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMenuUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMenuUI(){
        self.backgroundColor = .black
        
        setupButton(startNewGameButton, title: "Начать новую игру")
        setupButton(continueGameButton, title: "Продолжить текущую игру")
        
        NSLayoutConstraint.activate([
            startNewGameButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startNewGameButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            startNewGameButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            startNewGameButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            startNewGameButton.heightAnchor.constraint(equalToConstant: 56),
            
            continueGameButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            continueGameButton.bottomAnchor.constraint(equalTo: startNewGameButton.topAnchor, constant: -12),
            continueGameButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            continueGameButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            continueGameButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
    }
}
