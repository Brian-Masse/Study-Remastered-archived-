//
//  EditableText.swift
//  Study - Remastered
//
//  Created by Brian Masse on 3/15/22.
//

import Foundation
import SwiftUI
import UIKit


struct EditableContentView: View {
    var text: String
    init(_ text: String = "1, 2, 3") {
        self.text = text
    }
    var body: some View {
        Text(text)
            .padding(5)
            .font(.custom("sladkgh", size: 12))
            .lineLimit(0)
            .minimumScaleFactor(1)
            .foregroundColor(.clear)
            .background(.clear)
    }
}



class VC: UIViewController, UITextViewDelegate, ObservableObject {
    
    let hostingController = SelfSizingHostingController(rootView: EditableContentView(""))
    let textView = UITextView()
    
    @Published var text: String = "" {
        didSet {
            hostingController.rootView = EditableContentView("\(text)")
            textView.text = text
        }
    }
    
    @Published var currentlyEditing: Bool = false

    override func viewDidLoad() {
    
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.backgroundColor = .clear
        view.backgroundColor = .clear
    
        setConsstraints()
        view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
    
        textView.text = text
        textView.allowsEditingTextAttributes = true
        textView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        view.addSubview(textView)

        textView.topAnchor.constraint(equalTo: hostingController.view.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor).isActive = true

        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
    
    }
    
    override func viewDidLayoutSubviews() {
        preferredContentSize = view.bounds.size
    }
    
    func textViewDidChange(_ textView: UITextView) {
        text = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        currentlyEditing = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        currentlyEditing = false
    }
    
    func setConsstraints() {
        view.topAnchor.constraint(equalTo: hostingController.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor).isActive = true
    }
}


class SelfSizingHostingController<Content>: UIHostingController<Content> where Content: View {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
    }
}


struct VCRep: UIViewControllerRepresentable {
    
    var text: String
    let vc = VC()
    
    func makeUIViewController(context: Context) -> VC {
        vc.text = text
        return vc
    }
    
    func updateUIViewController(_ vc: VC, context: Context) { vc.text = text }

    typealias UIViewControllerType = VC
}



struct EditableContent: View, Content, EditableObjectContents {
    
    let textField: VCRep
    let deletionText: String = "delete"
    
    @ObservedObject var vc: VC
    @EnvironmentObject var textEditorModel: TextEditorModel
    @EnvironmentObject var editableObjectModel: ObjectModel
    
    func returnContentsAsString(_ text: String ) {
        editableObjectModel.setText(text, deletion: deletionText)
    }
    
    init( _ text: String ) {
        textField = VCRep(text: text)
        vc = textField.vc
    }
    
    
    var body: some View {
        VStack {
            textField
                .fixedSize()
        }
        .onChange(of: vc.currentlyEditing) { value in
            textEditorModel.currentTextField = vc.textView
            textEditorModel.isEditing = value
        }
        .onChange(of: vc.text) { newValue in
            returnContentsAsString(newValue)
            
        }
    }
}
