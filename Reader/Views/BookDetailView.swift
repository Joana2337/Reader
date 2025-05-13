
///  BookDetailView.swift
///  Reader
///  Created by Joanne on 4/8/25.


import SwiftUI

struct BookDetailView: View {
    let book: ReaderBook
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Cover
                if let imageURL = book.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    .frame(width: 150, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color(.systemGray).opacity(0.5), radius: 5, x: 0, y: 3)
                }
                
                // Title and author
                VStack(spacing: 8) {
                    Text(book.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("by \(book.authorDisplay)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    // Reading status badge
                    if book.listType == ReadingListType.currentlyReading.rawValue {
                        Text("Currently Reading")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(20)
                    } else if book.listType == ReadingListType.wantToRead.rawValue {
                        Text("Want to Read")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(20)
                    }
                }
                
                // Progress if currently reading
                if book.listType == ReadingListType.currentlyReading.rawValue {
                    VStack(spacing: 8) {
                        Text("\(Int(book.currentPage)) of \(Int(book.pageCount)) pages")
                            .font(.subheadline)
                        
                        // Enhanced progress bar
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(height: 8)
                                .foregroundColor(Color(.systemGray5))
                                .cornerRadius(4)
                            
                            Rectangle()
                                .frame(width: CGFloat(book.currentPage) / CGFloat(book.pageCount) * (UIScreen.main.bounds.width - 40), height: 8)
                                .foregroundColor(.blue)
                                .cornerRadius(4)
                        }
                        
                        Text("\(Int(Double(book.currentPage) / Double(book.pageCount) * 100))% complete")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Book details card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Book Details")
                        .font(.headline)
                    
                    Divider()
                    
                    // Only using properties we know exist
                    HStack {
                        Image(systemName: "book")
                            .foregroundColor(.secondary)
                        Text("Pages: \(Int(book.pageCount))")
                    }
                                        
                    HStack {
                        Image(systemName: "number")
                            .foregroundColor(.secondary)
                        Text("ID: \(book.id)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color(.systemGray).opacity(0.1), radius: 2, x: 0, y: 1)
                
                // Description if available
                if let description = book.bookDescription, !description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        Divider()
                        
                        Text(description)
                            .font(.body)
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(color: Color(.systemGray).opacity(0.1), radius: 2, x: 0, y: 1)
                }
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}
