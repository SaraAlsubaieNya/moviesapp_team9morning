# Project Overview
This project is a SwiftUI-based Movie application that follows the MVVM (Model–View–ViewModel) architecture.
The app fetches movie data from an external API (Airtable), displays movie information, and manages user authentication state. The goal of the project is to demonstrate clean architecture, API integration, and proper error handling with user feedback.
CRUD Operations & API Integration
The application integrates with an external API using URLSession and modern Swift concurrency (async/await). Networking logic is isolated in a dedicated service layer to maintain separation of concerns.
# Read 
Movie data is fetched from the Airtable API.
The MoviesService handles HTTP requests, response validation, and JSON decoding.
API responses are decoded into Swift models using Codable.
Fetched movies are stored in the MoviesViewModel and displayed in the UI.
This is the primary CRUD operation used in the app.
# Create 
The app supports user authentication by validating user data retrieved from the API.
Login information is processed and stored as session state.
# Update 
Updating movie data is not included in this version of the app.
The architecture supports future expansion to include update operations if needed.
# Delete 
Deleting movies or user data is not part of the current app scope.
# API Integration Details
The app uses URLSession for networking, which is Apple’s standard and secure API for handling HTTP requests.
Asynchronous requests are implemented using async/await to ensure the UI remains responsive while waiting for network responses.
The API key is stored securely in a plist file and is not hardcoded in the source code.
HTTP responses are validated, and errors are handled gracefully.
# Error Handling & User Feedback
Errors are handled centrally in the ViewModel using do/try/catch.
System-generated error messages are provided using localizedDescription.
The app uses loading states to inform users when data is being fetched.
Error messages are presented to the user to ensure clarity and transparency when something goes wrong.
# User Session Management
User authentication state is managed using a UserSession object.
Login state is persisted locally so the user remains logged in even after restarting the app.
SwiftUI automatically updates the UI based on the session state.

# UIs 
<img width="1206" height="2622" alt="simulator_screenshot_2D30DD3D-2581-43FB-AC01-2B9811A23829" src="https://github.com/user-attachments/assets/bb91a3c0-4636-4bee-82c3-64e4b059bb32" />
<img width="1206" height="2622" alt="simulator_screenshot_C6992822-296F-460A-9A27-15B57CAEE3A8" src="https://github.com/user-attachments/assets/c14c71f0-b660-48f8-9a67-326d40c4fe05" />
<img width="1206" height="2622" alt="simulator_screenshot_933303E2-B98F-4DA8-878C-666A8E13D55B" src="https://github.com/user-attachments/assets/f3222a43-b05f-441a-8ea7-5abde3a8404c" />
<img width="1206" height="2622" alt="simulator_screenshot_9480B646-640B-467F-A206-1FAC3C8D8937" src="https://github.com/user-attachments/assets/3a9de562-a148-4d3a-abcc-58a58069b8e0" />



