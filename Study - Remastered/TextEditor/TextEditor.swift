//
//  TextEditor.swift
//  Study - Remastered
//
//  Created by Brian Masse on 3/16/22.
//

import Foundation
import SwiftUI


class TextEditorModel: ObservableObject {
    
    @Published var isEditing: Bool = false
    
    var currentTextField: UITextView = UITextView()
    
}

struct TextEditor: View {
    
    let initialText: String
    let totalWrapper: EditableContentWrapper
    
    @EnvironmentObject var textEditorModel: TextEditorModel
    
    init( initialText: String ) {
        self.initialText = initialText
        
        totalWrapper = EditableContentWrapper(initialText)
    }
    
    var body: some View {
        VStack {
            if textEditorModel.isEditing {
                HStack {
                    Button(action: { EditableTextUtilities.applyTraitTo( textEditorModel.currentTextField, with: .traitBold) }) {
                        Text("BOLD")
                    }.padding()

                    Button(action: { EditableTextUtilities.applyTraitTo( textEditorModel.currentTextField, with: .traitMonoSpace) }) {
                        Text("MONO")
                    }

                    Button(action: { EditableTextUtilities.applyTraitTo( textEditorModel.currentTextField, with: .traitItalic) }) {
                        Text("ITALICS")
                    }

                    Button(action: { EditableTextUtilities.applyTraitTo( textEditorModel.currentTextField, with: .traitExpanded) }) {
                        Text("EXPANDED")
                    }
                }
            }
                
            totalWrapper
                .environmentObject(textEditorModel)
        }
        .background(Rectangle().foregroundColor(.red))
    }
        
}

//this model communicates in both directions. It is passed down to view below to collect information, and then 'reports' back up to a WrapperModel
class ObjectModel: ObservableObject {
    
    var viewText: String = ""

    let upwardsModel: WrapperModel
    
    init( upwardsModel: WrapperModel ) {
        self.upwardsModel = upwardsModel
    }
    
    func setText(_ text: String, deletion: String) {
        viewText = text
        checkDeletion(with: deletion)
    }
    
    func checkDeletion( with text: String ) {
        if viewText == text {
            upwardsModel.removeView(with: self )
        }
        
    }
    
}

struct EditableObject: View {
    let view: AnyView
    
//    @EnvironmentObject var upwardsModel: WrapperModel
    // this is the model of the editableContent ABOVE this one. ( there will be a wrapper, with a model, and that model will have a list of these views, and this view has a copy of THAT model, not of any model beneath it!  )
    // this object is for passing data UPWARDS ( I will be deleting myself from the list above me that contains me )
    
    
    var downwardsModel: ObjectModel
    // this will handle the communicaton / collection of all the children of this view, it should give this to the children and they should automiatically provide a formatterd version of their text to it (this will be different if it is a math equaiton vs plain editbale content)
    
    var body: some View {
        view
            .environmentObject(downwardsModel)
            .onTapGesture {
                print(self)
            }
    }
}

protocol EditableObjectContents {
    
    //swift is a pain, but all EditableObjectContents should have an EnvironmentObject objectModel, which gets the ```downwardsModel``` passed into it from the EditableContent
    //I cannot reasonably declare this in a protocol however, so it much be implimented manualy in each class that conforms to this 
    
    func returnContentsAsString(_ text: String) -> Void
    // this function shoudl automatically be called whenever the text of the class conforming to this protocol is changed
    
    var deletionText: String { get }
    // this is the string that tells it when to be delted
}

struct EditableContentWrapper: View {
    
    @State var isEditing = false

    @ObservedObject var model: WrapperModel
    @EnvironmentObject var textEditorModel: TextEditorModel
    
    let defaultText: String
    
    var isEmpty: Bool {
        model.views.count == 0
    }
    
    init ( _ text: String = "Default Text" ) {
        model = WrapperModel()
        defaultText = text
    }
    
    var body: some View {
            
        HStack(alignment: .center) {
            ForEach(0..<model.views.count, id: \.self ) { index in
                model.views[index]
                    .environmentObject( ObjectModel( upwardsModel: model ) )
//                    .environmentObject(model)
            }
        }
        .background(Rectangle().foregroundColor(.blue))
        .onAppear() {
            let editableContent = AnyView(EditableContent( defaultText ))
            let newObjectModel = ObjectModel(upwardsModel: model)
            
            model.addView(with:  EditableObject( view: editableContent, downwardsModel: newObjectModel )   )
        }
        
        //TEMP
        .onTapGesture {
            
//            let frac = Fraction(num: EditableContentWrapper("numerator"), denom: EditableContentWrapper("denomenator"))
//            let integral = Integral(upperBound: EditableContentWrapper("a"), lowerBound: EditableContentWrapper("b"), function: EditableContentWrapper("penis"))
//            let root = Root(power: EditableContentWrapper("3"), function: EditableContentWrapper("function"))
            let abs = Abs(function: EditableContentWrapper( "function" )  )
//
//            model.addView(with: abs)
            
        }
    }
}

//struct WrapperModel {
//
//    //this will either be a EditableContent, or an impict wrapper (like a fraction or SquraeRoot)
//    var views: [ AnyView ] = []
//
//    init() { }
//
//    init( with initialView: AnyView) {
//        views.append(initialView)
//    }
//
//    mutating func addView<anyView: View>( with view: anyView ) {
//
//        views.append( AnyView(view) )
//    }
//}


class WrapperModel: ObservableObject {
    
    //this will either be a EditableContent, or an impict wrapper (like a fraction or SquraeRoot)
    @Published var views: [ EditableObject ] = []
    
    init() { }
    
    init( with initialView: EditableObject) {
        addView(with: initialView)
    }
    
    func addView<anyView: View>( with view: anyView ) {
        if let object = view as? EditableObject {
            views.append( object )
        }
    }
    
    func removeView( with model: ObjectModel ) {
        guard let index = views.firstIndex(where: { editableObject in
            editableObject.downwardsModel.viewText == model.viewText
        }) else { return }

        views.remove(at: index)
    }
}


protocol Content {
    var vc: VC { get set }
}

