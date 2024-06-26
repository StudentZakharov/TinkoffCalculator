//
//  ViewController.swift
//  TinkoffCalculator
//

import UIKit


enum CalculationError: Error {
    case divideByZero
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
  
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
            case
                .add: return number1+number2
            case
                .substract: return number1-number2
            case
                .multiply: return number1*number2
            case
                .divide: 
                if number2 == 0 {
                    throw CalculationError.divideByZero
                    }
                return number1/number2
            }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}


class ViewController: UIViewController {
   
    var lastResult: String? = nil
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText=sender.currentTitle else {return}
        
        if buttonText=="," && label.text?.contains(",")==true {
            return}
        
        if label.text=="0"  {
            label.text=buttonText}
        else      {
            label.text?.append(buttonText)}
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard 
            let buttonText=sender.currentTitle,
            let buttonOperation = Operation(rawValue: buttonText)
        else {return}
       
        guard 
            let labelText=label.text,
            let labelNumber=numberFormatter.number(from: labelText)?.doubleValue
        else {return}
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLabelText()
        
    }
    
    @IBAction func clearButtonPressed() {
        
        calculationHistory.removeAll()
        resetLabelText()
    }
    
    @IBAction func calculateButtonPressed() {
        
         guard
             let labelText=label.text,
             let labelNumber=numberFormatter.number(from: labelText)?.doubleValue
         else {return}
         
         calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {label.text = "Ошибка"}
        calculationHistory.removeAll()
        lastResult=label.text
    }
    
    
    @IBOutlet weak var label: UILabel!
    
    var calculationHistory: [CalculationHistoryItem]=[]
    
    
    
    lazy var numberFormatter: NumberFormatter={
       let numberFormatter=NumberFormatter()
        
        numberFormatter.usesGroupingSeparator=false
        numberFormatter.locale=Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    
    
    @IBAction func showCalculationsList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let CalculatonsListVC = sb.instantiateViewController(identifier: "CalculatonsListViewController")
        
        if let vc=CalculatonsListVC as? CalculationsListViewController {
            
            if lastResult == nil {
                vc.result = "NoData"
            }
            else{
                vc.result = lastResult
            }
                        
        }
        
        //show(CalculatonsListVC, sender: self)
        navigationController?.pushViewController(CalculatonsListVC, animated: true)
    }
    
    /*
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue)
    {
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier=="CALCULATIONS_LIST",
                let calculationListVC=segue.destination as? CalculationsListViewController else {return}
        calculationListVC.result = label.text
    }
    */
    
    func calculate() throws -> Double{
        
        guard case .number(let firstNumber) = calculationHistory[0] else {return 0}
        
        var currentResult=firstNumber
        
        for index in (stride(from: 1, to:calculationHistory.count-1 , by: 2)) {
            guard 
                case .operation(let operation)=calculationHistory[index],
                case .number(let number)=calculationHistory[index+1]
                else {break}
            
            currentResult = try operation.calculate(currentResult,number)
            
        }
        
        return currentResult
    }
    
    
    func resetLabelText() {
        label.text="0"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetLabelText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    

}

