//
//  ViewController.swift
//  Calculator
//
//  Created by Виктор Васильков on 4.03.22.
//

import UIKit

class ViewController: UIViewController {
    
// MARK: - Public properties
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet weak var resultLabel:   UILabel!
    @IBOutlet weak var cButton: UIButton!
    var firstZero = false
    var firstNumber: Double?
    var mathSign: String = ""
    var mathSigntoThree: String = ""
    var haveDot = false
    var changedButton = false
    var currentInput: Double {
        get {
            if resultLabel.text == "Ошибка"{
                return 0
            }else{
                return Double(resultLabel.text!)!
            }
        }
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                resultLabel.text = "\(valueArray[0])"
            }else{
                resultLabel.text = "\(newValue)"
            }
            firstZero = false
        }
    }
    
    var accumulator: Double = 0.0
    var userInput = ""
    var numStack: [Double] = []
    var opStack: [String] = []

// MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rounding()
        rightSwipe()
    }
// MARK: - Public methods
    
    func refreshbuttons() {
            allButtons[13].backgroundColor = UIColor(red: 233/255, green: 157/255, blue: 57/255, alpha: 1)
            allButtons[13].tintColor = .white
            allButtons[14].backgroundColor = UIColor(red: 233/255, green: 157/255, blue: 57/255, alpha: 1)
            allButtons[14].tintColor = .white
            allButtons[15].backgroundColor = UIColor(red: 233/255, green: 157/255, blue: 57/255, alpha: 1)
            allButtons[15].tintColor = .white
            allButtons[16].backgroundColor = UIColor(red: 233/255, green: 157/255, blue: 57/255, alpha: 1)
        allButtons[16].tintColor = .white
        }
    
    @discardableResult
    func pushedButton (_senderTag: Int) -> Int {
            allButtons[_senderTag].backgroundColor = .white
            allButtons[_senderTag].tintColor = UIColor(red: 233/255, green: 157/255, blue: 57/255, alpha: 1)
        return _senderTag
    }
    
    func rounding () {
            for button in allButtons{
                button.layoutIfNeeded()
                button.layer.cornerRadius = button.frame.height / 2
            }
    }
    
    func updateDisplay() {
        guard !(accumulator.isNaN || accumulator.isInfinite) else {
            return resultLabel.text = "Ошибка"
        }
        let iAcc = Int(accumulator)
        if accumulator - Double(iAcc) == 0 {
            resultLabel.text = "\(iAcc)"
        } else {
            resultLabel.text = "\(accumulator)"
        }
    }
    func doMath(newOp: String) {
        if resultLabel.text != "" && !numStack.isEmpty {
            if newOp == "/" && accumulator == 0{
                resultLabel.text = "Ошибка"
            }else{
                let stackOp = opStack.last
                if !((stackOp == "+" || stackOp == "-") && (newOp == "*" || newOp == "/")) {
                    
                    let oper = ops[opStack.removeLast()]
                    accumulator = oper!(numStack.removeLast(), accumulator)
                    
                }
            }
        }
        opStack.append(newOp)
        numStack.append(accumulator)
        currentInput = 0
        print(opStack)
        print(numStack)
        updateDisplay()
        changedButton = false
    }
    func doEquals() {
        if resultLabel.text == "" {
            return
        }
        if !numStack.isEmpty {
            let oper = ops[opStack.removeLast()]
            accumulator = oper!(numStack.removeLast(), accumulator)
            if !opStack.isEmpty {
                doEquals()
            }
        }
        currentInput = 0
        updateDisplay()
        }
    func changeCButton(){
        let attributedText = NSAttributedString(string: "AC", attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 28)!])
        cButton.setAttributedTitle(attributedText, for: .normal)
    }
    func changefirstCButton(){
        let attributedText = NSAttributedString(string: "C", attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 28)!])
        cButton.setAttributedTitle(attributedText, for: .normal)
    }
    func rightSwipe() {
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeByUser(_:)) )
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    @objc func rightSwipeByUser(_ gesture:UISwipeGestureRecognizer) {
        var dropLast = String(resultLabel.text!)
        dropLast = String(dropLast.dropLast())
        if dropLast.count == 0{
            resultLabel.text = "0"
            firstZero = false
        }else{
            resultLabel.text = dropLast
            accumulator = Double(dropLast)!
        }
    }
    
// MARK: - IBActions
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        let number = sender.tag
        refreshbuttons()
        changefirstCButton()
        if firstZero {
            resultLabel.text = resultLabel.text! + String(number)
        } else {
            resultLabel.text = String(number)
            firstZero = true
        }
        accumulator = Double((resultLabel.text! as NSString).doubleValue)
        print(accumulator)
        haveDot = false
        
    }
    
    @IBAction func mathAction(_ sender: UIButton) {
        if changedButton == false {
            pushedButton(_senderTag: sender.tag)
            changedButton = true
        }else {
            refreshbuttons()
            mathSign = String(sender.tag)
            changedButton = true
        }
        if sender.tag == 16{
            doMath(newOp: "+")
        }else if sender.tag == 15{
            doMath(newOp: "-")
        }else if sender.tag == 14{
            doMath(newOp: "*")
        }else if sender.tag == 13{
            doMath(newOp: "/")
        }
    }
    
    @IBAction func equalitySigh(_ sender: UIButton) {
        doEquals()
    }
    

    
    @IBAction func acButton(_ sender: UIButton) {
        currentInput = 0
        resultLabel.text = "0"
        firstZero = false
        mathSign = ""
        haveDot = false
        refreshbuttons()
        changeCButton()
        accumulator = 0
        numStack.removeAll()
        opStack.removeAll()
        
    }
    @IBAction func minusButton(_ sender: UIButton) {
        currentInput = -currentInput
        accumulator = -accumulator
    }
    @IBAction func percentButton(_ sender: UIButton) {
        
        if numStack.count == 0 {
            accumulator = accumulator / 100.0
        } else {
            accumulator = Double(numStack.last!) * accumulator / 100
        }
        currentInput = accumulator
    }
    @IBAction func dotButton(_ sender: UIButton) {
        if firstZero && !haveDot {
            resultLabel.text = resultLabel.text! + "."
            haveDot = true
        }else if firstZero == false && haveDot == false {
            resultLabel.text = "0."
        }
    }
    

    
}
