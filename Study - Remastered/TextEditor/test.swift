//
//  test.swift
//  Study - Remastered
//
//  Created by Brian Masse on 3/15/22.
//

import Foundation
import SwiftUI


struct Block: View {
    var text: String
    init(_ text: String = "1, 2, 3") {
        self.text = text
    }
    var body: some View {
        Text(text)
            .padding()
            .lineLimit(0)
            .minimumScaleFactor(1)
            .background(.red)
//            .background(Color(UIColor.systemBackground))
//        Text("")
    }
}



class VCTest: UIViewController, UITextViewDelegate {
    let hostingController = SelfSizingHostingController(rootView: Block("Inside VC"))
    
    var text: String = "" {
        didSet { hostingController.rootView = Block("\(text)") }
    }

    override func viewDidLoad() {
        
        let textView = UITextView()
        textView.text = "This is some text inside of a textView"
        textView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        addChild(hostingController)
    
        view.addSubview(hostingController.view)
//        view.addSubview(textView)
//
//        textView.topAnchor.constraint(equalTo: hostingController.view.topAnchor).isActive = true
//        textView.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor).isActive = true
//        textView.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor).isActive = true
//        textView.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor).isActive = true
//
//        textView.backgroundColor = .blue
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.delegate = self
        
        setConsstraints()
        view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        preferredContentSize = view.bounds.size
    }
    
    func textViewDidChange(_ textView: UITextView) {
        text = textView.text
    }
    
    func setConsstraints() {
        view.topAnchor.constraint(equalTo: hostingController.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor).isActive = true
    }
}


struct VCRepTest: UIViewControllerRepresentable {
    var text: String
    
    func makeUIViewController(context: Context) -> VCTest { VCTest() }
    
    func updateUIViewController(_ vc: VCTest, context: Context) { vc.text = text }

    typealias UIViewControllerType = VCTest
}




struct ContentView: View {
    @State var alignmentIndex = 0
    @State var additionalCharacterCount = 0
    
    var alignment: HorizontalAlignment {
        [HorizontalAlignment.leading, HorizontalAlignment.center, HorizontalAlignment.trailing][alignmentIndex % 3]
    }
    
    var additionalCharacters: String {
        Array(repeating: "x", count: additionalCharacterCount).joined(separator: "")
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: 0) {
            Button {
                self.alignmentIndex += 1
            } label: {
                Text("Change Alignment")
            }
            Button {
                self.additionalCharacterCount += 1
            } label: {
                Text("Add characters")
            }
            Block()
            Block().environment(\.colorScheme, .dark)
            VCRepTest(text: additionalCharacters)
                .fixedSize()
//                .environment(\.colorScheme, .dark)
                .background(Rectangle().foregroundColor(.red))
        }
    }
}

