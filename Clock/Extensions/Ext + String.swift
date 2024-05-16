//
//  Ext + String.swift
//  Clock
//
//  Created by Sergey Dolgikh on 13.02.2023.
//

import Foundation


extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
