//
//  ViewController.swift
//  MathTrainer
//
//  Created by ozinchenko.dev on 25/02/2024.
//

import UIKit

enum MathTypes: Int {
    case add, subtract, multiply, divide
}

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var subtractLabel: UILabel!
    @IBOutlet weak var multiplyLabel: UILabel!
    @IBOutlet weak var divideLabel: UILabel!
    
    // MARK: - Properties
    private var selectedType: MathTypes = .add
    static var mathTypeScore: [MathTypes: Int] = [
        .add: 0,
        .subtract: 0,
        .multiply: 0,
        .divide: 0] {
            didSet {
                NotificationCenter.default.post(name: Notification.Name("DictionaryDidChange"), object: nil)
            }
        }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        
        // Register observer for dictionary changes
        NotificationCenter.default.addObserver(self, selector: #selector(updateScore), name: Notification.Name("DictionaryDidChange"), object: nil)
        
        // Update label with initial dictionary values
        updateScore()
    }
    
    // MARK: - Actions
    @IBAction func buttonAction(_ sender: UIButton) {
        selectedType = MathTypes(rawValue: sender.tag) ?? .add
        performSegue(withIdentifier: "goToNext", sender: sender)
    }
    
    @IBAction func unwindAction(unwindSeque: UIStoryboardSegue) { }
    
    // MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TrainViewController {
            viewController.type = selectedType
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
    
    @objc func updateScore() {
        addLabel.text = String(ViewController.mathTypeScore[.add] ?? 0)
        subtractLabel.text = String(ViewController.mathTypeScore[.subtract] ?? 0)
        multiplyLabel.text = String(ViewController.mathTypeScore[.multiply] ?? 0)
        divideLabel.text = String(ViewController.mathTypeScore[.divide] ?? 0)
    }

}

