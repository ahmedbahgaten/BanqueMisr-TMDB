# TMDB App

- This is an iOS app that allows users to browse a curated list of movies sourced from The Movie Database (TMDB) API.
- This app is built using clean architecture principles to ensure maintainability, testability, and scalability.
- It supports iOS 15 and above.

# Features
- Browse a list of Now Playing , Popular, and Upcoming movies
- View details of each movie, including title, poster, release date, overview, budget,spoken languages,runtime and genres.

# Bonus Features
- Pagination for loading movies.
- Implemented In-Memory cache for images to enhance UX
- Implemented database caching using CoreData.

# Architecture
The app follows the principles of clean architecture, separating concerns into distinct layers:

- Presentation Layer: Responsible for displaying data to the user and handling user input. Implemented using UIKit for the user interface and ViewModels to manage UI logic.

- Domain Layer: Contains business logic and use cases that are independent of any specific framework. This layer defines entities and interacts with repositories.
  
- Data Layer: Handles data retrieval and storage. It communicates with external data sources (TMDB API) and local data storage (Core Data). Repositories act as an abstraction layer between the domain and data layers.

The clean architecture allows for easy testing, maintenance, and future modifications, as each layer is independent and loosely coupled.


# Unit Tests
- The project includes a comprehensive suite of unit tests to ensure the correctness of the app's logic and functionality. Unit tests are written using XCTest and cover various aspects of the app, including ViewModel logic, data parsing, and network requests. Running the unit tests provides confidence in the app's behavior and helps maintain stability during development and refactoring.


# Project Branches
- The app is developed on the Development branch 
