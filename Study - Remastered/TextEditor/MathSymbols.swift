//
//  MathSymbols.swift
//  Study - Remastered
//
//  Created by Brian Masse on 3/12/22.
//

import Foundation
import SwiftUI


struct Fraction: View, EditableObjectContents {
    
    var deletionText: String
    
    func returnContentsAsString(_ text: String) {
        
    }
    
    var num: EditableContentWrapper
    var denom: EditableContentWrapper
    
    var body: some View {
        VStack {
            num .overlay(
            VStack {
                Spacer()
                Rectangle()
                    .offset(y: 5)
                    .frame(maxHeight: 2)
            })
            denom .overlay(
            VStack {
                Rectangle()
                    .offset(y: -5)
                    .frame(maxHeight: 2)
                Spacer()
            })
        }
    }
}

struct Integral: View {
    
    var upperBound: EditableContentWrapper
    var lowerBound: EditableContentWrapper
    
    var function: EditableContentWrapper
    
    var body: some View {
        
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                upperBound
                lowerBound
            }
            
            Image("Integral")
                .interpolation(.none)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 20)

            function
        }
    }
}


struct Root: View {

    var power: EditableContentWrapper
    var function: EditableContentWrapper
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 0) {
            ZStack(alignment: .topLeading) {
                Image("Root")
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                power
                    .frame(height: 10)
                    .offset(x: -5, y: -5)
            }

            function
                .offset(y: 3)
                .overlay(VStack {
                Rectangle()
                    .frame(height: 1)
                    .offset(x: -6)
                Spacer()
            })
        }
    }
}


struct Abs: View {
    
    var function: EditableContentWrapper
    
    var body: some View {
        
        function
            .overlay(HStack {
            Rectangle()
                .frame(width: 1)
                .offset(x: -3)
            Spacer()
            Rectangle()
                .frame(width: 1)
                .offset(x: 3)
        }) 
        
    }
}


protocol MathEquation {
    
    func isEmpty() -> Bool 
    
}
