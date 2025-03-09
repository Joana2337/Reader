# 📚 Reader App

A modern iOS application for tracking your reading journey, managing your book collections, and discovering new books to read.

## ✨ Features

- [x] Search books using Google Books API
- [x] Manage currently reading list
  - [x] Add books to currently reading
  - [x] Track reading progress
  - [x] Remove books from list
- [ ] Want to read functionality (Coming soon)
  - [ ] Save books for later
  - [ ] Organize reading wishlist

## 🛠 Technical Stack

- SwiftUI for modern UI development
- Google Books API for book data
- UserDefaults for local data persistence
- Async/await for API calls
- iOS 16.0+ support

## 🚀 Getting Started

### Prerequisites

- Xcode 14.0+
- iOS 16.0+
- Swift 5.5+

### Installation

1. Clone the repository
```bash
git clone https://github.com/Joana2337/Reader.git
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

3. **Want to Read (Coming Soon)**
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
