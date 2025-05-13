/// HomeView serves as the main interface for the Reader app
/// Responsibilities:
/// - Manages book search functionality
/// - Displays search results in a scrollable list
/// - Provides quick access to reading lists
/// - Created by: Joana

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var books: [Book] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingError = false
    @State private var showingSuccess = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with dark styling
            VStack(spacing: 8) {
                Text("Reader")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                
                Text("Discover and track your reading journey")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Dark themed search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search books by title or author", text: $searchText)
                    .foregroundColor(.white)
                    .submitLabel(.search)
                    .onSubmit {
                        performSearch()
                    }
                    .autocorrectionDisabled()
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                
                Button("Search") {
                    performSearch()
                }
                .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemGray6)) // Dark gray in dark mode
            .cornerRadius(10)
            .padding()
            
            //HomeView with dark theme
            ZStack {
                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.2)
                            .padding()
                        Text("Searching for books...")
                            .foregroundColor(.gray)
                    }
                } else if !books.isEmpty {
                    List {
                        ForEach(books) { book in
                            SearchResultRow(
                                book: book,
                                onCurrentlyReading: { addToCurrentlyReading(book) },
                                onWantToRead: { addToWantToRead(book) }
                            )
                            .listRowBackground(Color.black) // Dark background for list rows
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.black)
                } else if !searchText.isEmpty {
                    ContentUnavailableView("No Results",
                        systemImage: "magnifyingglass",
                        description: Text("Try searching for another book"))
                        .foregroundColor(.gray)
                } else {
                    ContentUnavailableView {
                        Label("Search Books", systemImage: "book.circle.fill")
                    } description: {
                        Text("Enter a book title or author to begin")
                    }
                    .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .background(Color.black) 
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
        .alert("Success", isPresented: $showingSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Book added successfully!")
        }
    }
    
    func addToCurrentlyReading(_ book: Book) {
        // Check if book already exists in either list
        let fetchRequest: NSFetchRequest<ReaderBook> = ReaderBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id)
        
        do {
            let existingBooks = try viewContext.fetch(fetchRequest)
            
            // If book exists in any list, remove it first
            for existingBook in existingBooks {
                viewContext.delete(existingBook)
            }
            
            // Now add the book to "Currently Reading"
            let readerBook = ReaderBook(context: viewContext)
            readerBook.id = book.id
            readerBook.title = book.volumeInfo.title
            readerBook.authors = book.volumeInfo.authors ?? []
            readerBook.bookDescription = book.volumeInfo.description
            readerBook.imageURL = book.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
            readerBook.pageCount = Int32(book.volumeInfo.pageCount ?? 0)
            readerBook.currentPage = 0
            readerBook.listType = ReadingListType.currentlyReading.rawValue
            readerBook.dateAdded = Date()
            
            try viewContext.save()
            showingSuccess = true
        } catch {
            errorMessage = "Failed to add book: \(error.localizedDescription)"
            showingError = true
        }
    }

    func addToWantToRead(_ book: Book) {
        // Check if book already exists in either list
        let fetchRequest: NSFetchRequest<ReaderBook> = ReaderBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id)
        
        do {
            let existingBooks = try viewContext.fetch(fetchRequest)
            
            // If book exists in any list, remove it first
            for existingBook in existingBooks {
                viewContext.delete(existingBook)
            }
            
            // Now add the book to "Want to Read"
            let readerBook = ReaderBook(context: viewContext)
            readerBook.id = book.id
            readerBook.title = book.volumeInfo.title
            readerBook.authors = book.volumeInfo.authors ?? []
            readerBook.bookDescription = book.volumeInfo.description
            readerBook.imageURL = book.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
            readerBook.pageCount = Int32(book.volumeInfo.pageCount ?? 0)
            readerBook.currentPage = 0
            readerBook.listType = ReadingListType.wantToRead.rawValue
            readerBook.dateAdded = Date()
            
            try viewContext.save()
            showingSuccess = true
        } catch {
            errorMessage = "Failed to add book: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isLoading = true
        books = []
        
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        Task {
            do {
                let url = "https://www.googleapis.com/books/v1/volumes?q=\(encodedText)"
                guard let searchURL = URL(string: url) else {
                    throw URLError(.badURL)
                }
                
                let (data, _) = try await URLSession.shared.data(from: searchURL)
                let results = try JSONDecoder().decode(BookResult.self, from: data)
                
                await MainActor.run {
                    books = results.items
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isLoading = false
                }
            }
        }
    }
}

//#Preview {
//    HomeView()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
