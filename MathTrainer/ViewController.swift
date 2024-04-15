//
//  ViewController.swift
//  MathTrainer
//
//  Created by ozinchenko.dev on 25/02/2024.
//

import UIKit

enum MathTypes: Int, CaseIterable {
    case add, subtract, multiply, divide
    
    var key: String {
        switch self {
        case .add:
            return "addCount"
        case .subtract:
            return "subtractCount"
        case .multiply:
            return "multiplyCount"
        case .divide:
            return "divideCount"
        }
    }
}

class ViewController: UIViewController, TrainViewControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var subtractLabel: UILabel!
    @IBOutlet weak var multiplyLabel: UILabel!
    @IBOutlet weak var divideLabel: UILabel!
    
    // MARK: - Properties
    private var selectedType: MathTypes = .add
    private var mathTypeScore: [MathTypes: Int] = [
        .add: 0,
        .subtract: 0,
        .multiply: 0,
        .divide: 0]
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        setCountLabels()
    }
    
    // MARK: - Actions
    @IBAction func buttonAction(_ sender: UIButton) {
        selectedType = MathTypes(rawValue: sender.tag) ?? .add
        performSegue(withIdentifier: "goToNext", sender: sender)
    }
    
    @IBAction func unwindAction(unwindSeque: UIStoryboardSegue) {
        setCountLabels()
    }
    
    // MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TrainViewController {
            viewController.type = selectedType
            viewController.delegate = self
        }
    }
    
    private func setCountLabels() {
        MathTypes.allCases.forEach { type in
            let key = type.key
            guard let count = UserDefaults.standard.object(forKey: key)
                    as? Int else { return }
            let stringValue = String(count)
            
            switch type {
            case .add:
                addLabel.text = stringValue
            case .subtract:
                subtractLabel.text = stringValue
            case .multiply:
                multiplyLabel.text = stringValue
            case .divide:
                divideLabel.text = stringValue
            }
        }
    }
    
    private func configureButtons() {
        // Add shadow
        buttonsCollection.forEach { button in
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.4
            button.layer.shadowRadius = 3
        }
    }
}

// MARK: - Extensions
extension ViewController {
    func update(score: Int, for mathType: MathTypes) {
        mathTypeScore[mathType]! += score
        let totalScore = String(mathTypeScore[mathType] ?? 0)
        switch mathType {
        case .add:
            addLabel.text = totalScore
        case .subtract:
            subtractLabel.text = totalScore
        case .multiply:
            multiplyLabel.text = totalScore
        case .divide:
            divideLabel.text = totalScore
        }
    }
}
