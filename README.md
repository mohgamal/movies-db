
# MoviesDB

A simple iOS app to browse popular movies and search for specific movies using The Movie Database (TMDb) API. This app is built with **Swift**, using the **MVVM** architectural pattern with **Combine** for reactive programming and **protocol-oriented programming** for testability.

---

## Features

- Display a list of **popular movies** from TMDb API.
- Search for movies by entering a query in the search bar.
- View detailed information about a selected movie, including:
  - **Movie Details** (title, description, release date, and runtime).
  - **Similar Movies** displayed in a horizontally scrollable collection view.
  - **Movie Credits**, including cast and crew members.
- Loading indicators for smooth user experience.
- Error handling with user-friendly messages for API failures.
- **Coordinator Pattern** for managing navigation.

---

## Screenshots

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/2d20b137-bbc9-4b13-aa38-0b4b76ad990d" width="45%" alt="Screenshot 1">
  <img src="https://github.com/user-attachments/assets/fc88e9f2-5100-4d81-ae66-610d334dacd1" width="45%" alt="Screenshot 2">
</p>

---

## Requirements

- iOS 14.0+
- Xcode 15.0+
- Swift 5.7+

---

## Architecture

This app follows the **MVVM (Model-View-ViewModel)** architectural pattern with **Coordinator Pattern** for navigation. Key principles include:

1. **Separation of Concerns**:
   - ViewModel handles business logic and communicates with the API.
   - Views are responsible for rendering the UI.

2. **Reactive Programming**:
   - Combine is used for binding UI elements with data streams.

3. **Testability**:
   - Protocols are used for the API services to enable mocking and unit testing.

---

## Project Structure

```
MoviesDB
├── Helpers           # Contains helper classes or extensions used throughout the app
├── AppFiles          # Application-specific files (e.g., AppDelegate, SceneDelegate)
├── Resources         # Assets, storyboards, and other resources
├── Modules           # Modular components for different parts of the app
├── Network           # API client and protocol-based networking services
└── Models            # Data models for API responses
```

---

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/MoviesDB.git
   cd MoviesDB
   ```

2. Open the project in Xcode:
   ```bash
   open MoviesDB.xcodeproj
   ```

3. Install dependencies (if any).

4. Replace the placeholder API key with your TMDb API key in the `Environment` or `Constants` file.

5. Build and run the project on the simulator or a physical device.

---

## Tests

The app includes unit tests for the following components:
- **MoviesViewModel**: Tests for fetching popular movies and searching movies, including success and failure cases.
- **MovieDetailsViewModel**: Tests for fetching movie details, similar movies, and credits.

### Running Tests

1. Open the project in Xcode.
2. Select the `MoviesDB` scheme.
3. Press `⌘U` or go to `Product > Test`.

---

## Future Enhancements

1. **Infinite Scrolling for Popular Movies**:
   - Implement pagination to fetch additional movies when the user scrolls to the bottom of the list.
   - Update the API calls to include page numbers.

2. **Search Pagination**:
   - Add support for paginated search results.
   - Fetch the next page of search results when the user scrolls to the end of the list.

3. **Improved Error Handling**:
   - Provide more detailed error messages and recovery options (e.g., retry button).

4. **Offline Mode**:
   - Cache popular movies and details locally using CoreData or Realm.
   - Display cached data when offline.

5. **Unit Tests Coverage**:
   - Expand test coverage to include UI tests for navigation and user interactions.


---

## License

This project is licensed under the APACHE License. See the `LICENSE` file for more details.

---

## Contact

For questions or suggestions, feel free to contact me at [dev.mohgamal@gmail.com].
