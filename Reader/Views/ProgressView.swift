
///  ProgressView.swift
///  Reader
///  Created by Joanne on 4/8/25.
///   - Handles the progress bar. 

import SwiftUI
import CoreData

struct PageProgressView: View {
    let book: ReaderBook
    let viewContext: NSManagedObjectContext
    
    @State private var currentPage: Double
    @Environment(\.dismiss) private var dismiss
    
    init(book: ReaderBook, viewContext: NSManagedObjectContext) {
        self.book = book
        self.viewContext = viewContext
        _currentPage = State(initialValue: Double(book.currentPage))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Book infomation header
                HStack(alignment: .top, spacing: 15) {
                    // Book cover image
                    if let imageURL = book.imageURL, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "book.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.gray)
                            case .empty:
                                SwiftUI.ProgressView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 80, height: 120)
                        .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title)
                            .font(.headline)
                        
                        Text(book.authorDisplay)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Total: \(Int(book.pageCount)) pages")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Slider section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Update Your Progress")
                        .font(.headline)
                    
                    // Current page display
                    HStack {
                        Text("Page")
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(Int(currentPage)) of \(Int(book.pageCount))")
                            .fontWeight(.medium)
                    }
                    
                    // The slider itself
                    Slider(
                        value: $currentPage,
                        in: 0...Double(book.pageCount),
                        step: 1
                    )
                    .accentColor(.blue)
                    
                    // Visual progress bar
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 20)
                            .foregroundColor(Color(.systemGray5))
                            .cornerRadius(10)
                        
                        if book.pageCount > 0 {
                            Rectangle()
                                .frame(width: (currentPage / Double(book.pageCount)) * (UIScreen.main.bounds.width - 40), height: 20)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                                .animation(.spring(), value: currentPage)
                            
                            Text("\(Int(currentPage * 100 / Double(book.pageCount)))%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.leading, 8)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Save button
                Button {
                    saveProgress()
                } label: {
                    Text("Save Progress")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Update Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveProgress() {
        book.currentPage = Int32(currentPage)
        try? viewContext.save()
        dismiss()
    }
}
