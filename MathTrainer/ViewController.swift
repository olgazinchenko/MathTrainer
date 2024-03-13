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
        
        // Present the TrainViewController and set a delegate
        let trainVC = TrainViewController()
        trainVC.delegate = self
        self.present(trainVC, animated: true, completion: nil)
        
        configureButtons()
        updateScoreOnLabels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScoreOnLabels()
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
    
    func update(score: Int, for mathType: MathTypes) {
        if (mathTypeScore[mathType] != nil) {
            print(mathTypeScore.values)
            mathTypeScore[mathType]! += score
            print(mathTypeScore.values)
        }
    }
    
    func updateScoreOnLabels() {
        for (key, value) in mathTypeScore {
            if key == .add {
                self.addLabel.text = String(value)
            }
            if key == .divide {
                divideLabel.text = String(value)
            }
            if key == .multiply {
                multiplyLabel.text = String(value)
            }
            if key == .subtract {
                subtractLabel.text = String(value)
                
            }
        }
    }
}
