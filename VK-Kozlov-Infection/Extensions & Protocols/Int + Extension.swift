extension Int {
    
    static func convertStringToInt(from text: String?) -> Int? {
        guard let value = text else { return nil }
        
        guard let number = Int(value) else { return nil }
        
        return number
    }
}
