//
//  EditableTextUtilitis.swift
//  Study - Remastered
//
//  Created by Brian Masse on 3/15/22.
//

import Foundation
import UIKit


class EditableTextUtilities {
    
    static func applyTraitTo(_ content: UITextView, with trait: UIFontDescriptor.SymbolicTraits) {
        
        var range = content.selectedRange
        
        //make sure there is text in the view
        if let text = content.attributedText {
            
            let formattedText = NSMutableAttributedString(attributedString: text)
            
            // select all if nothing is selected
            if range.lowerBound == text.length {
                range = NSRange(location: 0 , length: range.lowerBound)
            }
            
            var fonts: [ (NSRange, UIFont) ] = []
            var currentStartbound = range.lowerBound
            
        
            // This will get all the different font styles in the text,and the ranges that they are in effect on
            while currentStartbound < range.upperBound {
                
                var returningRange = NSRange()
                
                let attribute = text.attribute(NSAttributedString.Key.font, at: currentStartbound, effectiveRange: &returningRange)
    
                let endBound = min( returningRange.upperBound, range.upperBound )
                let safeRange = NSMakeRange(currentStartbound, endBound - currentStartbound)
                
                
                if let font = attribute as? UIFont {
                    fonts.append( ( safeRange, font ) )
                }
                
                currentStartbound = endBound
            }
            
            // nil if all have trait applied, int if they dont
            let notApplied: Int? = fonts.firstIndex(where: { range, font in
                if !font.hasTrait(trait) { return true }
                return false
            })
            
            // add or remove trait to all the current font schemes (based on the var above)
            for tuple in fonts {
                
                var boldFont: UIFont!
                
                //all have trait applied, remove trait
                if notApplied == nil {  boldFont = tuple.1.withoutTraits(trait)  }
                else {  boldFont = tuple.1.withTraits(trait)  }
                
                let boldAttribute = [ NSAttributedString.Key.font: boldFont ]
                
                formattedText.addAttributes(boldAttribute as [NSAttributedString.Key : Any], range: tuple.0)
            }
        
            // apply the formatted Tecxt To The Old Text
            content.attributedText = formattedText
            content.selectedRange = range
        }
    }
}



extension UIFont {

    func hasTrait( _ trait: UIFontDescriptor.SymbolicTraits ) -> Bool {
        return (trait.rawValue & fontDescriptor.symbolicTraits.rawValue) > 0
    }
    
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        //this perameter can be euther a list of traits, or a single trait (there is an init for a sequence of traits that apparently is automatically called)
        
        var traitList: [ UIFontDescriptor.SymbolicTraits ] = [fontDescriptor.symbolicTraits]
        
        // this tests if the current selection already has the trait that is trying to be applied
        if (traits.rawValue & fontDescriptor.symbolicTraits.rawValue) <= 0 {
            traitList.append( traits )
        }
        
        let list = UIFontDescriptor.SymbolicTraits( traitList )
    
        guard let fd = fontDescriptor.withSymbolicTraits( list ) else { return self }
        return UIFont(descriptor: fd, size: pointSize)
    }
    
    func withoutTraits( _ traits: UIFontDescriptor.SymbolicTraits ) -> UIFont {
        
        let orginalTraitsRaw = fontDescriptor.symbolicTraits.rawValue
        let newTraitsRaw = ( orginalTraitsRaw & ~traits.rawValue )
        
        let newTraits = UIFontDescriptor.SymbolicTraits(rawValue: newTraitsRaw)
        guard let fd = fontDescriptor.withSymbolicTraits( newTraits ) else { return self }
        return UIFont(descriptor: fd, size: pointSize)
        
    }
}



