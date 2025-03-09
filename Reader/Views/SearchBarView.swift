

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onCommit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search books...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .onSubmit(onCommit)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    SearchBar(text: .constant(""), onCommit: {})
        .padding()
}
