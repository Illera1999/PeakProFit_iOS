//
//  ExtensionString.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 25/3/26.
//

extension String {
    var capitalizedFirstLetter: String {
        guard let first else { return self }
        return first.uppercased() + dropFirst()
    }
}
