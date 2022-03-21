//
//  CardView.swift
//  Study - Remastered
//
//  Created by Brian Masse on 3/12/22.
//

import Foundation
import SwiftUI


let defaultCard = Card(frontText: "Front Text",
                       backText: "Back Text",
                       frontFormatter: returnText,
                       backFormatter: returnText2)


func returnText( _ text: String ) -> Text {
    Text( text )
        .bold()
        .italic()
        .foregroundColor(.blue)
}

func returnText2( _ text: String ) -> Text {
    Text( text )
        .foregroundColor(.red)
}

struct CardView: View {
    
    var card: Card
    
    var body: some View {
            
        card.frontFormatter("This is the front text" )
        card.backFormatter( "This is the back Text" )
        
        
    }
}
