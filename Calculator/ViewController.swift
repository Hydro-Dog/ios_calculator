//
//  ViewController.swift
//  Calculator
//
//  Created by Vlad Babaev on 23.01.2024.
//

import UIKit
import SnapKit

let NUMBERS = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

class ViewController: UIViewController {
    private let calculatorTable = UIStackView()
    private let calculatorDisplay = UIView()
    private let calculatorDisplayLabel = UILabel()
    private let rowsItems = [
        ["AC", "+/-", "%", "/"],
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", "", "", "="]
    ]
    private var currentOperation = ""
    private var displayValue = ""
    private var prevValue = "0"
    private var currentValue = ""
    
    private var arithmeticValues: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(calculatorTable)
        view.addSubview(calculatorDisplay)
        initCalculatorTable()
        initCalculatorDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(calculatorTable.subviews[0].bounds.height)
        print(calculatorTable.subviews.count)
        
        for (index, item) in calculatorTable.subviews.enumerated() {
            initRowCells(item as! UIStackView, index)
        }
        
        initDisplayLabel()
    }
    
    private func initCalculatorTable() {
        calculatorTable.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(4 * view.bounds.height / 6)
            make.bottom.equalTo(0)
        }
        calculatorTable.backgroundColor = .black
        calculatorTable.axis = .vertical
        calculatorTable.spacing = 4
        calculatorTable.distribution = .fillEqually
        
        rowsItems.forEach {item in
            calculatorTable.addArrangedSubview(initRowStack())
        }
    }
    
    private func initRowStack() -> UIStackView {
        let rowStack = UIStackView()
        rowStack.backgroundColor = .black
        rowStack.spacing = 4
        rowStack.axis = .horizontal
        rowStack.distribution = .fillEqually
        
        return rowStack
    }
    
    private func initRowCells (_ rowStack: UIStackView, _ index: Int) {
        print("initRowCells", index)
        for (i, item) in rowsItems[index].enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(rowsItems[index][i], for: .normal)
            button.backgroundColor = .systemRed
            button.titleLabel?.font = UIFont.systemFont(ofSize: rowStack.bounds.height * 0.25)
            button.setTitleColor(.black, for: .normal)
            rowStack.addArrangedSubview(button)
            
            button.addTarget(self, action: #selector(elementTapped(_:)), for: .touchUpInside)

        }
    }
    
    private func initCalculatorDisplay() {
        calculatorDisplay.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(2 * view.bounds.height / 6)
        }
        calculatorDisplay.backgroundColor = .black
    }
    
    private func initDisplayLabel() {
        calculatorDisplayLabel.text = "0"
        calculatorDisplayLabel.textColor = .red
        calculatorDisplay.addSubview(calculatorDisplayLabel)
        calculatorDisplayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(calculatorDisplay)
        }
    }
    
    @objc private func elementTapped(_ sender: UIButton) {
        if let value = sender.titleLabel?.text {
            if(NUMBERS.contains(value)) {
                currentValue = currentValue + value
                calculatorDisplayLabel.text = currentValue
            } else if (value == "=") {
                numberInputFinished()
                equalTapped()
            } else {
                numberInputFinished()
                operationTapped(value)
            }
            
            
        }
    }
    
    private func numberInputFinished() {
        if let value = Int(currentValue) {
            arithmeticValues.append(value)
            if(arithmeticValues.count > 2) {
                arithmeticValues.removeFirst()
            }
        }
    }
    
    private func operationTapped(_ value: String) {
        currentValue = ""
        if(["+", "-", "X", "/"].contains(value)) {
            if(arithmeticValues.count == 1) {
                currentOperation = value
            } else if (arithmeticValues.count == 2) {
                print("start: ", arithmeticValues)
                var result = 0
                switch currentOperation {
                case "+":
                    result = arithmeticValues[0] + arithmeticValues[1]
                case "-":
                    result = arithmeticValues[0] - arithmeticValues[1]
                case "X":
                    result = arithmeticValues[0] * arithmeticValues[1]
                case "/":
                    result = arithmeticValues[0] / arithmeticValues[1]
                default:
                    break
                }
                arithmeticValues = [result]
                currentOperation = value
                calculatorDisplayLabel.text = String(result)
                
                
                print("end: ", arithmeticValues)
            }
        }
        
    }
    
    private func equalTapped() {
        print("start: ", arithmeticValues, currentOperation, currentValue)
        if (arithmeticValues.count == 2) {

            var result = 0
            switch currentOperation {
            case "+":
                result = arithmeticValues[0] + arithmeticValues[1]
            case "-":
                result = arithmeticValues[0] - arithmeticValues[1]
            case "X":
                result = arithmeticValues[0] * arithmeticValues[1]
            case "/":
                result = arithmeticValues[0] / arithmeticValues[1]
            default:
                break
            }
            currentValue = ""
            arithmeticValues = [result]
            currentOperation = ""
            calculatorDisplayLabel.text = String(result)
            
            
            print("end: ", arithmeticValues)
        }
    }
    
}
