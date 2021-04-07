//
//  ContentView.swift
//  Calculator
//
//  Created by Kelvin on 21/03/2021.
//  Copyright © 2021 Kelvin. All rights reserved.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
            .font(.title)
            .padding()
            .border(Color.blue)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
        
            
    }
}

struct ResultStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
            .font(.system(size: 60))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .border(Color.blue)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
    }
}

extension View {
    func buttonStyle() -> some View {
        self.modifier(ButtonStyle())
    }
    
    func resultStyle() -> some View {
        self.modifier(ResultStyle())
    }
}

struct ContentView: View {

    enum Operation: String, CaseIterable {
        case division = "/"
        case multiplication = "*"
        case subtraction = "-"
        case adddition = "+"
    }
    private let numbers = [ ["7", "8", "9"],
                            ["4", "5", "6"],
                            ["1", "2", "3"],
                            [" ", "0", "."] ]
    
    @State private var result = "0"
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
        debugPrint("Result: \(result)")
        debugPrint("Num1: \(previousNumber)")
        debugPrint("Operator: \(currentOperation.rawValue)")
        debugPrint("Num2: \(tempNumber)")
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("\(result)")
                    .resultStyle()
                
                HStack {
                    VStack {
                        HStack {
                            Button("Clear All") {
                                self.result = "0"
                                self.tempNumber = ""
                                self.previousNumber = ""
                                self.calculated = false
                            }.buttonStyle()
                        }
                        VStack {
                            ForEach(numbers, id: \.self) { number in
                                HStack {
                                    ForEach(number, id: \.self) { number in
                                        Button("\(number)") {
                                            if (number == " ") {
                                                return
                                            }
                                            if (self.operationButtonPressed || self.result == "0") {
                                                self.previousNumber = self.tempNumber
                                                self.tempNumber = String(number)
                                                self.operationButtonPressed = false
                                            } else {
                                                self.tempNumber += String(number)
                                            }
                                            self.result = self.tempNumber
                                        }.buttonStyle()
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        ForEach(Operation.allCases, id: \.self) { operation in
                            Button("\(operation.rawValue)") {
                                self.operationButtonPressed = true
                                if (self.calculated) {
                                    self.tempNumber = self.previousNumber
                                    self.calculated = false
                                }
                                self.operationPressed(operation)
                            }.buttonStyle()
                        }
                        Button("=") {
                            self.operationButtonPressed = true
                            self.equalsPressed()
                        }.buttonStyle()
                    }
                }
            }
        }
    }
}

    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
