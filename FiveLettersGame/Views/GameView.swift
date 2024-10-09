import UIKit

final class GameView: UIView{
    
    var gridLabels: [[UILabel]] = []
    var keyboardButtons: [UIButton] = []
    var letterButtonMapping: [UIButton: String] = [:]
    var checkButton: UIButton = UIButton(type: .system)
    var backspaceButton: UIButton = UIButton(type: .system)
    var delegate: GameViewDelegate!
    
    init(frame: CGRect, delegate: GameViewDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        backgroundColor = .black
        let gridBottomAnchor = setupGrid()
        setupKeyboard(gridBottomAnchor: gridBottomAnchor)
    }
    
    // MARK: Setup Grid UI
    private func setupGrid() -> NSLayoutYAxisAnchor {
        let gridContainer = UIStackView()
        gridContainer.axis = .vertical
        gridContainer.spacing = 6
        gridContainer.alignment = .center
        gridContainer.distribution = .fillEqually
        gridContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(gridContainer)
        
        fillGrid(gridContainer: gridContainer)
        
        NSLayoutConstraint.activate([
            gridContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            gridContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            gridContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 80/812)
        ])
        
        return gridContainer.bottomAnchor
    }
    
    private func fillGrid(gridContainer: UIStackView){
        let screenWidth = UIScreen.main.bounds.width
        let horizontalPadding: CGFloat = 16 * 2
        let totalSpacing: CGFloat = 6 * 4
        let gridElementWidth = (screenWidth - horizontalPadding - totalSpacing) / 5
        
        for _ in 0..<6 {
            var rowLabels: [UILabel] = []
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 6
            rowStack.alignment = .center
            rowStack.distribution = .fillEqually
            gridContainer.addArrangedSubview(rowStack)
            
            for _ in 0..<5 {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 24)
                label.textColor = .white
                label.backgroundColor = UIColor.clear
                label.layer.borderColor = UIColor.white.cgColor
                label.layer.borderWidth = 1
                label.layer.cornerRadius = 8
                label.clipsToBounds = true
                
                NSLayoutConstraint.activate([
                    label.widthAnchor.constraint(equalToConstant: gridElementWidth),
                    label.heightAnchor.constraint(equalTo: label.widthAnchor)
                ])
                
                rowStack.addArrangedSubview(label)
                rowLabels.append(label)
            }
            gridLabels.append(rowLabels)
        }
    }
    
    // MARK: Setup Keyboard UI
    private func setupKeyboard(gridBottomAnchor: NSLayoutYAxisAnchor){
        let keyboardContainer = UIStackView()
        keyboardContainer.axis = .vertical
        keyboardContainer.spacing = 6
        keyboardContainer.alignment = .center
        keyboardContainer.distribution = .fillEqually
        keyboardContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(keyboardContainer)
        
        let lettersRow1 = ["Й","Ц","У","К","Е","Н","Г","Ш","Щ","З","Х","Ъ"]
        let lettersRow2 = ["Ф","Ы","В","А","П","Р","О","Л","Д","Ж","Э"]
        let lettersRow3 = ["Я","Ч","С","М","И","Т","Ь","Б","Ю"]
        
        let row1Stack = createKeyboardRow(with: lettersRow1)
        keyboardContainer.addArrangedSubview(row1Stack)
        
        let row2Stack = createKeyboardRow(with: lettersRow2, leftPadding: 14)
        keyboardContainer.addArrangedSubview(row2Stack)
        
        let row3Stack = createKeyboardRowWithActions(letters: lettersRow3)
        keyboardContainer.addArrangedSubview(row3Stack)
        
        NSLayoutConstraint.activate([
            keyboardContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            keyboardContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            keyboardContainer.topAnchor.constraint(equalTo: gridBottomAnchor, constant: 40),
            keyboardContainer.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func createKeyboardRow(with letters: [String], leftPadding: CGFloat = 0) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 6
        rowStack.alignment = .fill
        rowStack.distribution = .fillEqually
        rowStack.layoutMargins = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: leftPadding)
        rowStack.isLayoutMarginsRelativeArrangement = true
        
        for letter in letters {
            let button = createLetterButton(letter: letter)
            rowStack.addArrangedSubview(button)
            keyboardButtons.append(button)
            letterButtonMapping[button] = letter
        }
        return rowStack
    }
    
    func createLetterButton(letter: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(letter, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(letterPressed(_:)), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 24/375).isActive = true
        
        return button
    }
    
    func createKeyboardRowWithActions(letters: [String]) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 5
        rowStack.alignment = .fill
        rowStack.distribution = .fillProportionally
        rowStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        rowStack.isLayoutMarginsRelativeArrangement = true

        checkButton = createActionButton(with: UIImage(systemName: "checkmark")!)
        checkButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        checkButton.isEnabled = false
        updateActionButtonAppearance(button: checkButton)
        rowStack.addArrangedSubview(checkButton)

        checkButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 38/375).isActive = true
        checkButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        for letter in letters {
            let button = createLetterButton(letter: letter)
            rowStack.addArrangedSubview(button)
            keyboardButtons.append(button)
            letterButtonMapping[button] = letter
        }

        backspaceButton = createActionButton(with: UIImage(systemName: "delete.left")!)
        backspaceButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        backspaceButton.isEnabled = false
        updateActionButtonAppearance(button: backspaceButton)
        rowStack.addArrangedSubview(backspaceButton)

        backspaceButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 38/375).isActive = true
        backspaceButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        for button in rowStack.arrangedSubviews {
            if let btn = button as? UIButton {
                btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
        }

        return rowStack
    }
    
    @objc private func letterPressed(_ sender: UIButton) {
        guard let letter = sender.title(for: .normal) else { return }
        delegate?.didPressLetter(letter)
    }
    
    @objc private func donePressed() {
        delegate?.didPressDone()
    }
    
    @objc private func deletePressed() {
        delegate?.didPressDelete()
    }
    
    func createActionButton(with image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .white // Initial tint color for disabled state
        button.backgroundColor = .gray // Initial background color for disabled state
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        // Height constraint is set in the stack view
        return button
    }
    
    // MARK: - Update UI
    func updateUI() {
        UIView.animate(withDuration: 0.3){[weak self] in
            guard let self = self else {return}
            updateGrid()
            
            updateKeyboardLetterButtons()
            updateKeyboardActionButtons()
        }
    }
    
    // MARK: - Update Grid UI
    private func updateGrid(){
        // Update grid with entered words
        let attempts = delegate.getAttempts()
        for (rowIndex, attempt) in attempts.enumerated() {
            for (colIndex, char) in attempt.enumerated() {
                let label = gridLabels[rowIndex][colIndex]
                label.text = String(char)
                label.backgroundColor = delegate?.getColorForLetter(attemptLetter: char, position: colIndex)
                label.textColor = label.backgroundColor == .gray ? .white : .black
                label.layer.borderColor = delegate?.getColorForLetter(attemptLetter: char, position: colIndex).cgColor
            }
        }
        
        // Update current attempt
        let isGameOver = delegate.getGameOverState()
        if !isGameOver && attempts.count < 6 {
            let currentRowIndex = attempts.count
            for (colIndex, label) in gridLabels[currentRowIndex].enumerated() {
                label.text = delegate.getCurrentAttemptSymbol(colIndex: colIndex)
                label.backgroundColor = UIColor.clear
                label.textColor = .white
                label.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    
    // MARK: - Update Keyboard UI
    
    func updateKeyboardLetterButtons() {
        for button in keyboardButtons {
            if let letter = letterButtonMapping[button] {
                let (backgroundColor, borderColor, titleColor): (UIColor, UIColor, UIColor) = delegate?.getColorsForLetterButton(letter: letter) ?? (.black, .gray, .white)
                button.backgroundColor = backgroundColor
                button.layer.borderColor = borderColor.cgColor
                button.setTitleColor(titleColor, for: .normal)
            }
        }
    }
    
    func updateKeyboardActionButtons() {
        let (checkButtonState, backspaceButtonState) = delegate.getActionButtonsState()
        if checkButton.isEnabled != checkButtonState {
            checkButton.isEnabled = checkButtonState
            updateActionButtonAppearance(button: checkButton)
        }
        if backspaceButton.isEnabled != backspaceButtonState {
            backspaceButton.isEnabled = backspaceButtonState
            updateActionButtonAppearance(button: backspaceButton)
        }
    }
    
    func updateActionButtonAppearance(button: UIButton) {
        if button.isEnabled {
            button.backgroundColor = .white
            button.tintColor = .black
        } else {
            button.backgroundColor = .gray
            button.tintColor = .white
        }
    }
    
    func resetGrid() {
        for (rowIndex, row) in gridLabels.enumerated() {
            for (colIndex, label) in row.enumerated() {
                let delay = 0.1 * Double(rowIndex) + 0.05 * Double(colIndex)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    UIView.animate(withDuration: 0.2) {
                        label.text = ""
                        label.backgroundColor = UIColor.clear
                        label.layer.borderColor = UIColor.white.cgColor
                    }
                }
            }
        }
    }
    
    func resetKeyboard(){
        var colIndex = 0.0
        for button in keyboardButtons {
            let delay = 0.1 + 0.025 * colIndex
            colIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIView.animate(withDuration: 0.2) {
                    button.backgroundColor = .clear
                    button.layer.borderColor = UIColor.white.cgColor
                    button.setTitleColor(.white, for: .normal)
                }
            }
            
        }
    }
}
