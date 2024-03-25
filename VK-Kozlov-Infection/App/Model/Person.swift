import Foundation

struct Person {
    private var isInfected: Bool = false
}

extension Person {
    
    mutating func tryToInfect() -> Bool {
        if !isInfected {
            isInfected = true
            return true
        }
        return false
    }
    
    func checkIsInfected() -> Bool {
        isInfected
    }
}
