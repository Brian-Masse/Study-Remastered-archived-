//
//  RichTextEditor.swift
//  Study - Remastered
//
//  Created by Brian Masse on 3/12/22.
//

import Foundation
import SwiftUI
import RichEditorView

struct RichTextEditor: UIViewRepresentable {
  
  @Binding var htmlText: String
  
  func makeUIView(context: Context) -> UITextView {
let editor = RichEditorView(frame: .zero)
    editor.html = htmlText
    
      editor.isScrollEnabled = false
//      editor.delegate = context.coordinator
      
      let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
      toolbar.options = [
        RichEditorDefaultOption.clear,
        RichEditorDefaultOption.bold,
        RichEditorDefaultOption.italic,
        RichEditorDefaultOption.strike,
        RichEditorDefaultOption.underline,
        RichEditorDefaultOption.indent,
        RichEditorDefaultOption.outdent,
      ]
      toolbar.editor = editor
      
      editor.inputAccessoryView = toolbar
      
      
      let textView = UITextView()
      textView.text = "This is some sample Text that I would like to markup"
      textView.allowsEditingTextAttributes = true
      
      return textView
      
      
     
  }
  
  func updateUIView(_ uiView: UITextView, context: Context) {
  }
}
