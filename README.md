# 📚 Reader App

A modern iOS reading tracker built with SwiftUI that helps you manage your reading journey. Search for books using the Google Books API, track your reading progress with actual page numbers, and manage your reading lists.

## ✨ Features

### Implemented
- [x] Book Search & Discovery
  - [x] Search using Google Books API
  - [x] View book details (title, author, description)
  - [x] See actual page counts for books
  - [x] View book cover images

- [x] Currently Reading
  - [x] Add books to currently reading list
  - [x] Track reading progress by page numbers
  - [x] View progress as both pages and percentage
  - [x] Remove books from list
  - [x] View all currently reading books in one place

- [x] Want to Read
  - [x] Save books for later reading
  - [x] Manage reading wishlist
  - [x] Move books between lists

### Technical Features
- SwiftUI for modern UI development
- Google Books API integration
- Local data persistence using UserDefaults
- Async/await for API calls
- iOS 16.0+ support

## 🛠 Technical Requirements

- Xcode 14.0+
- iOS 16.0+
- Swift 5.5+
- Google Books API Key

## 📱 Installation

1. Clone the repository
```bash
git clone https://github.com/Joana2337/Reader.git
```

2. Open `Reader.xcodeproj` in Xcode

3. Add your Google Books API key in `APIKeys.swift`:
```swift
struct APIKeys {
    static let googleBooksAPI = "YOUR_API_KEY_HERE"
}
```

4. Build and run the project

## 📖 Usage

### Search Books
- Use the search bar to find books by title or author
- View detailed book information including:
  - Cover image
  - Title and author
  - Description
  - Page count

### Track Your Reading
- Add books to "Currently Reading"
- Track progress by entering current page number
- View progress bar and completion percentage
- Remove books when finished

### Plan Future Reading
- Save interesting books to "Want to Read"
- Build your reading wishlist
- Move books to "Currently Reading" when ready

## 🗂 Project Structure

```
Reader/
├── Views/
│   ├── HomeView.swift         # Search and main navigation
│   ├── CurrentlyReadingView.swift
│   ├── WantToReadView.swift
│   └── Components/           # Reusable UI components
├── Models/
│   └── BookModel.swift       # Data models and API interfaces
├── Resources/
└── Support/
    └── APIKeys.swift         # API configuration
```

## 🔒 Security

- API keys are stored securely
- User data is persisted locally
- HTTPS for all API requests

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

---

Made with 📚 by [Joana2337](https://github.com/Joana2337)git clone https://github.com/Joana2337/Reader.git
```

2. Open `Reader.xcodeproj` in Xcode

3. Add your Google Books API key
   - Create a new file called `APIKeys.swift`
   - Add your API key as shown in the example below:
```swift
enum APIKeys {
    static let googleBooksAPI = "YOUR_API_KEY_HERE"
}
```

4. Build and run the project

## 📱 Usage

1. **Search Books**
   - Use the search bar to find books by title or author
   - View book details including cover, title, and author

2. **Currently Reading**
   - Add books to your Currently Reading list
   - Track reading progress for each book
   - Remove books when finished
   - View all currently reading books in one place

3. **Want to Read**
   - Save books you want to read later
   - Build your reading wishlist

## 🔒 Security

- API keys are kept secure and not tracked in git
- Sensitive data is stored locally on device
- User data privacy is maintained

## 🗂 Project Structure

```
Reader/
├── Views/
│   ├── HomeView.swift         # Main search and navigation
│   ├── CurrentlyReadingView.swift
│   └── Components/           # Reusable UI components
├── Models/
│   └── BookModel.swift       # Data models and API interfaces
├── Resources/
└── Support/
    └── APIKeys.swift         # API keys (not tracked in git)
```

## 📝 Notes

- The app uses UserDefaults for data persistence
- Books are fetched from Google Books API
- Reading progress is stored locally

## 🔜 Upcoming Features

- [ ] Want to Read list implementation
- [ ] Book recommendations
- [ ] Reading statistics
- [ ] Social sharing features
- [ ] Custom book collections

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!


---

Made by [Joana2337](https://github.com/Joana2337)
