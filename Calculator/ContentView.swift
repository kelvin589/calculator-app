//
//  ContentView.swift
//  Calculator
//
//  Created by Kelvin on 21/03/2021.
//  Copyright © 2021 Kelvin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    enum Operation: String, CaseIterable {
        case adddition = "+"
        case subtraction = "-"
        case multiplication = "*"
        case division = "/"
    }
    
    @State private var result = ""
    @State private var tempNumber = ""
    @State private var previousNumber = ""
    @State private var calculated = false
    @State private var currentOperation = Operation.adddition
    @State private var operationButtonPressed = false
    
    func operationPressed(_ op: Operation) {
        self.currentOperation = op
    }
    
    func equalsPressed() {
        let num1 = Float(previousNumber) ?? 0
        let num2 = Float(tempNumber) ?? 0
        
        switch currentOperation {
            case .adddition:
                result = String(num1 + num2)
            case .subtraction:
                result = String(num1 - num2)
            case .multiplication:
                result = String(num1 * num2)
            case .division:
                result = String(num1 / num2)
        }
        
        previousNumber = result
        calculated = true
        
        debugPrint("Actual calculation: \(num1) \(currentOperation.rawValue) \(num2)")
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ForEach(0..<10) { number in
                        Button("\(number)") {
                            if (self.operationButtonPressed || self.result == "0") {
                                self.previousNumber = self.tempNumber
                                self.tempNumber = String(number)
                                self.operationButtonPressed = false
                            } else {
                                self.tempNumber += String(number)
                            }
                            self.result = self.tempNumber
                        }
                    }
                    Button(".") {
                        self.tempNumber += "."
                    }
                }
                
                HStack {
                    ForEach(Operation.allCases, id: \.self) { operation in
                        Button("\(operation.rawValue)") {
                            self.operationButtonPressed = true
                            if (self.calculated) {
                                self.tempNumber = self.previousNumber
                                self.calculated = false
                            }
                            self.operationPressed(operation)
                        }
                    }
                    Button("=") {
                        self.operationButtonPressed = true
                        self.equalsPressed()
                    }
                }
                
                Text("\(result)")
                Text("Num1: \(previousNumber)")
                Text("Operator: \(currentOperation.rawValue)")
                Text("Num2: \(tempNumber)")
                
                Button("Clear All") {
                    self.result = ""
                    self.tempNumber = ""
                    self.previousNumber = ""
                    self.calculated = false
                }
            }
            .navigationBarTitle("Calculator")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
