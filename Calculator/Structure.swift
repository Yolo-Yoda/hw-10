
import Foundation
func addition(a: Double, b: Double) -> Double {
    let result = a + b
    return result
}
func subtraction(a: Double, b: Double) -> Double {
    let result = a - b
    return result
}
func multiplication(a: Double, b: Double) -> Double {
    let result = a * b
    return result
}
func division(a: Double, b: Double) -> Double {
    let result = a / b
    return result
}

typealias Binop = (Double, Double) -> Double
let ops: [String: Binop] = [ "+" : addition,
                             "-" : subtraction,
                             "*": multiplication,
                             "/": division]
