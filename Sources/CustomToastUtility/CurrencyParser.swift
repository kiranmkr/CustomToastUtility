//
//  CurrencyParser.swift
//  SwiftCoreUtilities
//
//  Created by macpro on 17/06/2026.
//

import Foundation

public struct CurrencyParser {
    
    public static func parse(_ string: String) -> (value: Double, symbol: String)? {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.isLenient = true
        
        guard let number = formatter.number(from: trimmed) else {
            let plainFormatter = NumberFormatter()
            plainFormatter.numberStyle = .decimal
            if let plainNumber = plainFormatter.number(from: trimmed) {
                return (plainNumber.doubleValue, "")
            }
            return nil
        }
        
        let characterSet = CharacterSet(charactersIn: "0123456789., \u{A0}")
        let symbol = trimmed.components(separatedBy: characterSet).joined().trimmingCharacters(in: .whitespaces)
        
        return (number.doubleValue, symbol)
    }
    
    public static func parseCurrency(_ string: String) -> (value: Double, symbol: String, isLeft: Bool) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let symbol = trimmed.filter { !"0123456789., ".contains($0) }
        let finalSymbol = symbol.isEmpty ? "$" : symbol
        
        let numericString = trimmed.filter { "0123456789.".contains($0) || $0 == "," }
        let cleanNumeric = numericString.replacingOccurrences(of: ",", with: "")
        let value = Double(cleanNumeric) ?? 0.0
        
        let isLeft = trimmed.hasPrefix(finalSymbol)
        
        return (value, finalSymbol, isLeft)
    }
}
