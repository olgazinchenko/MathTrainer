//
//  TrainViewController.swift
//  MathTrainer
//
//  Created by ozinchenko.dev on 26/02/2024.
//

import UIKit

final class TrainViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Properties
    var delegate: TrainViewControllerDelegate? // Delegate property
    
    var type: MathTypes = .add {
        didSet {
            switch type {
            case .add:
                sign = "+"
            case .subtract:
                sign = "-"
            case .multiply:
                sign = "*"
            case .divide:
                sign = "/"
            }
        }
    }

    private var firstNumber = 0
    private var secondNumber = 0
    private var sign: String = ""
    private var count: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(count)"
        }
    }
    
    private var answer: Int {
        switch type {
        case .add:
            return firstNumber + secondNumber
        case .subtract:
            return firstNumber - secondNumber
        case .multiply:
            return firstNumber * secondNumber
        case .divide:
            return firstNumber / secondNumber
        }
    }
    
    private let correctAnswerColor: UIColor = .systemMint
    private let incorrectAnswerColor: UIColor = .systemPink
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureQuestion()
        configureButtons()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.update(score: count, for: type)
    }
    
    // MARK: - IBActions
    @IBAction func leftButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
        updateQuesionAndButtons()
    }
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
        updateQuesionAndButtons()
    }
    
    // MARK: - Methods
    private func configureButtons() {
        let buttonsArray = [leftButton, rightButton]
        
        // Set main color to buttons
        buttonsArray.forEach { button in
            button?.backgroundColor = .systemYellow
        }
        // Add shadow
        buttonsCollection.forEach { button in
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.4
            button.layer.shadowRadius = 3
        }
        
        // Set random and right answers to random buttons
        let isRightButton = Bool.random()
        let randomAnswer = getRandomAnswer()
        rightButton.setTitle(isRightButton ? String(answer) : String(randomAnswer), for: .normal)
        leftButton.setTitle(isRightButton ? String(randomAnswer) : String(answer), for: .normal)
    }
    
    private func configureQuestion() {
        firstNumber = Int.random(in: 1...99)
        secondNumber = Int.random(in: 1...99)
        
        if type == .divide {
            // Avoiding situations when a divider more than a dividend
            if firstNumber < secondNumber {
                let number = firstNumber
                firstNumber = secondNumber
                secondNumber = number
            }
            if firstNumber % secondNumber != 0 {
                let divisionRemainder = firstNumber % secondNumber
                let randomMultiplayer = Int.random(in: 1...3)
                firstNumber -= divisionRemainder
                // Avoiding situations when a dividend equals zero
                firstNumber = firstNumber * randomMultiplayer
            }
        }

        questionLabel.text = "\(firstNumber) \(sign) \(secondNumber) ="
    }

    private func getRandomAnswer() -> Int {
        var randomAnswer: Int
        repeat {
            randomAnswer = Int.random(in: (answer - 10)...(answer + 10))
            // Avoiding situations when random answer less than zero
            if type == .divide && randomAnswer < 0 {
                randomAnswer = -randomAnswer
            }
        } while randomAnswer == answer
        
        return randomAnswer
    }
    
    private func check(answer: String, for button: UIButton) {
        let isRightAnswer = Int(answer) == self.answer
        
        button.backgroundColor = isRightAnswer ? correctAnswerColor : incorrectAnswerColor
        
        if isRightAnswer {
            let isSecondAttempt: Bool = leftButton.backgroundColor == incorrectAnswerColor || rightButton.backgroundColor == incorrectAnswerColor
            count += isSecondAttempt ? 0 : 1
        }
    }
    
    private func updateQuesionAndButtons() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.configureQuestion()
            self?.configureButtons()
        }
    }
}

// MARK: - Protocols
protocol TrainViewControllerDelegate: UIViewController {
    func update(score: Int, for mathType: MathTypes)
}
