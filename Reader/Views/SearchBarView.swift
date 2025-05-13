



import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onCommit: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search books by title or author", text: $text, onCommit: onCommit)
                .foregroundColor(colorScheme == .dark ? .white : .primary)
                .disableAutocorrection(true)
                .overlay(
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .opacity(text.isEmpty ? 0 : 1)
                    }
                    .padding(.trailing, 8),
                    alignment: .trailing
                )
            
            Button(action: onCommit) {
                Text("Search")
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
        }
        .padding(10)
        .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray6))
        .cornerRadius(10)
    }
}
