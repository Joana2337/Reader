/// HomeView serves as the main interface for the Reader app
/// Responsibilities:
/// - Manages book search functionality
/// - Displays search results in a scrollable list
/// - Provides quick access to reading lists
/// - Handles error and success states
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
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onCommit: performSearch)
                    .padding()
                
                ZStack {
                    if isLoading {
                        ProgressView("Searching...")
                    } else if !books.isEmpty {
                        List(books) { book in
                            SearchResultRow(
                                book: book,
                                onCurrentlyReading: { addToCurrentlyReading(book) },
                                onWantToRead: { addToWantToRead(book) }
                            )
                        }
                        .listStyle(PlainListStyle())
                    } else if !searchText.isEmpty {
                        ContentUnavailableView("No Results",
                            systemImage: "magnifyingglass",
                            description: Text("Try searching for another book"))
                    } else {
                        ContentUnavailableView("Search Books",
                            systemImage: "book.circle",
                            description: Text("Enter a book title or author to begin"))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(spacing: 16) {
                    NavigationLink(destination: CurrentlyReadingView()) {
                        QuickAccessButton(
                            title: "Currently Reading",
                            icon: "book.fill",
                            color: .blue
                        )
                    }
                    
                    NavigationLink(destination: WantToReadView()) {
                        QuickAccessButton(
                            title: "Want to Read",
                            icon: "bookmark.fill",
                            color: .green
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Reader")
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
    }
    
    func addToCurrentlyReading(_ book: Book) {
        let readerBook = ReaderBook(context: viewContext)
        readerBook.id = book.id
        readerBook.title = book.volumeInfo.title
        readerBook.authors = book.volumeInfo.authors ?? []
        readerBook.bookDescription = book.volumeInfo.description
        readerBook.imageURL = book.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
        readerBook.pageCount = Int32(book.volumeInfo.pageCount ?? 0)
        readerBook.currentPage = 0
        readerBook.listType = ReadingListType.currentlyReading.rawValue
        
        try? viewContext.save()
        showingSuccess = true
    }
    
    func addToWantToRead(_ book: Book) {
        let readerBook = ReaderBook(context: viewContext)
        readerBook.id = book.id
        readerBook.title = book.volumeInfo.title
        readerBook.authors = book.volumeInfo.authors ?? []
        readerBook.bookDescription = book.volumeInfo.description
        readerBook.imageURL = book.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
        readerBook.pageCount = Int32(book.volumeInfo.pageCount ?? 0)
        readerBook.currentPage = 0
        readerBook.listType = ReadingListType.wantToRead.rawValue
        
        try? viewContext.save()
        showingSuccess = true
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
                let results = try JSONDecoder().decode(BookResult.self, from: data)  // Changed to BookResult
                
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

struct QuickAccessButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
