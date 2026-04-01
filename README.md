<img width="720" height="1600" alt="Screenshot_20260331-224707" src="https://github.com/user-attachments/assets/0efc59db-d986-4c72-8598-a0206f934f2d" /># 🎬 PopcornPals – Movie Discovery App

PopcornPals is a modern movie discovery mobile application built using **Flutter**, powered by **Firebase** and the **TMDB API**.  
It allows users to explore movies, watch trailers, manage favorites, and get personalized recommendations.

---

## ✨ Features

### 🔍 Movie Exploration
- Search movies with real-time debounce
- Browse Popular, Top Rated, Upcoming, and Now Playing movies

### 🎬 Movie Details
- View detailed movie information
- Watch trailers (YouTube integration)
- Cast & crew section
- Smooth hero animations

### ❤️ Personalization
- Add/remove favorites (Firebase Firestore)
- Manage watchlist
- Recently viewed tracking
- Real-time UI updates

### 🎯 Smart Recommendations
- Similar movies
- Recommended movies (TMDB API)

### 🔐 Authentication
- Firebase Authentication (Email & Password)
- Secure login & registration system

### ⚙️ Settings & Profile
- Profile page with user info
- Settings page (app info, logout, etc.)
- Dark mode UI design

### 🚀 UI/UX
- Netflix-style modern UI
- Blur background effects
- Animated splash screen
- Smooth transitions

---

## 🛠️ Tech Stack

- **Flutter (Dart)**
- **Firebase**
  - Authentication
  - Cloud Firestore
- **TMDB API**
- **REST API integration**
- **Material UI**

---

## Screenshots

<img width="320" alt="Screenshot_20260331-121618" src="https://github.com/user-attachments/assets/ac68dfea-670b-40c2-acde-3cc3163a0c75" />
<img width="720" height="1600" alt="Screenshot_20260331-224617" src="https://github.com/user-attachments/assets/fe2ee067-33de-4b73-adff-682c9add0d83" />
<img width="320"  alt="Screenshot_20260331-223619" src="https://github.com/user-attachments/assets/45bcc747-2f5a-4dc0-bde1-44f1851cdce2" /><br>
<img width="320" alt="Screenshot_20260331-223712" src="https://github.com/user-attachments/assets/76a4d20e-0ee1-4f8d-8418-6c0feaf2a48e" />
<img width="720" height="1600" alt="Screenshot_20260331-223701" src="https://github.com/user-attachments/assets/e3aba4be-f309-4d1a-a386-2d5de044b869" />
<img width="720" height="1600" alt="Screenshot_20260331-223740" src="https://github.com/user-attachments/assets/641c5160-0af3-4b40-982d-8d0bf1ff020f" /><br>
<img width="720" height="1600" alt="Screenshot_20260331-224707" src="https://github.com/user-attachments/assets/88df5496-30bf-4d6e-adce-1331c3925242" />
## 🔑 API Used

- TMDB API  
👉 https://www.themoviedb.org/documentation/api

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/Fawas-Mohamed/movie_app.git
cd movie_app-main
flutter pub get
```
### 2. Install dependencies
```bash
flutter pub get
```
### 3. Add TMDB API Key
- lib/core/constants.dart

### 4. Setup Firebase
- Create a Firebase project
- Enable Authentication (Email/Password)
- Create Firestore database
- Add your config file:
```bash
android/app/google-services.json
```

### 5. Run the App
```bash
flutter run
```
---
### 🧠 What I Learned
- API integration and JSON parsing
- Firebase Authentication & Firestore
- State management and UI structuring
- Building scalable app architecture
- Real-time updates and user-based data

---
### 🚀 Future Improvements
- 🎥 Continue Watching feature
- 📊 Advanced user analytics
- 📱 Push notifications
- 💾 Offline support

---
### ⭐ If you like this project, consider giving it a star!

