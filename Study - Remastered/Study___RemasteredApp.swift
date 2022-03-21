//___FILEHEADER___

import SwiftUI
import Firebase


 @main
struct StudyRemastered: App {
    var body: some Scene {
        WindowGroup {
//            EditableContent("this is editable content")
//            ContentView()
//            CardView(card: defaultCard)
//            test()
            
            TextEditor(initialText: "this is a text editor" )
                .environmentObject(TextEditorModel() )
        }
    }
}
