
///  SearchResultRow.swift
///  Reader
///  Created by Joanne on 3/18/25.
import SwiftUI

struct SearchResultRow: View {
    let book: Book
    let onCurrentlyReading: () -> Void
    let onWantToRead: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Book cover
            if let imageURL = book.volumeInfo.imageLinks?.secureImageURL {
                AsyncImage(url: imageURL) { phase in
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
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 60, height: 90)
                .cornerRadius(6)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 90)
                    .cornerRadius(6)
                    .overlay(
                        Image(systemName: "book.fill")
                            .foregroundColor(.white)
                    )
            }
            
            // Book details
            VStack(alignment: .leading, spacing: 4) {
                Text(book.volumeInfo.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(book.volumeInfo.authorDisplay)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let pageCount = book.volumeInfo.pageCount {
                    Text("\(pageCount) pages")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 12) {
                    Button {
                        // Using withAnimation to make the tap more responsive
                        withAnimation {
                            onCurrentlyReading()
                        }
                    } label: {
                        Label("Reading", systemImage: "book.fill")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.3))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                    .buttonStyle(BorderlessButtonStyle()) // - this to prevent tap propagation
                    
                    Button {
                        // Using withAnimation to make the tap more responsive
                        withAnimation {
                            onWantToRead()
                        }
                    } label: {
                        Label("Want", systemImage: "bookmark.fill")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.green.opacity(0.3))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                    .buttonStyle(BorderlessButtonStyle()) // -this to prevent tap propagation
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemGray6)) 
        .cornerRadius(12)
    }
}
