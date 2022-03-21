//
//  Card.swift
//  
//
//  Created by Brian Masse on 3/12/22.
//

import Foundation
import SwiftUI

struct Card {
    
    let frontText: String
    let backText: String
    
    let frontFormatter: (String) -> Text
    let backFormatter: (String) -> Text
    
    init( frontText: String, backText: String, frontFormatter: @escaping (String) -> Text, backFormatter: @escaping (String) -> Text ) {
        self.frontText = frontText
        self.backText = backText
        
        self.frontFormatter = frontFormatter
        self.backFormatter = backFormatter
    }
    
}

