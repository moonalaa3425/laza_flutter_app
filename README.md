# Laza – E-commerce Mobile App

## 1. Project Overview
**Project Name:** Laza – E-commerce Mobile App  
**Platforms:** iOS & Android (Flutter – single codebase)  
**Goal:** Build a simplified, functional e-commerce MVP based on the Laza UI Kit.  
The app allows users to browse products, view product details, add/remove items from the cart, manage favorites, and perform a mock checkout. Minimal user data (cart + favorites) is stored in Firestore.

---

## 2. Features

### 2.1 Authentication
- Email/password signup & login using Firebase Authentication
- Password reset
- Auto-login (persist login state)
- Store minimal user data in Firestore:
  - `users/{uid}`: email, createdAt

### 2.2 Home & Catalog
- Browse products from Platzi Fake Store API (`GET /products`)
- Basic local search filter
- Product details screen with:
  - Image, Title, Price, Description
  - Add to cart
  - Add to favorites

### 2.3 Cart & Checkout
- Firestore structure:
  - `carts/{userId}/items/{productId}`
  - Add/remove items
  - Update quantity
  - Checkout button → shows Success screen and clears cart

### 2.4 Favorites
- Add/remove items
- Favorites screen lists saved items

### 2.5 Profile & Settings
- Display user email
- Logout button

### 2.6 Error Handling & Empty States
- Alert dialogs for errors
- Loading indicators
- Empty states for empty cart or no favorites

---

## 3. Project Scope

**In Scope:**
- Mobile app (Flutter)
- Firebase Authentication (Email/Password)
- Firestore (simple structure: cart + favorites)
- Product listing & details
- Cart & mock checkout
- Lightweight Appium tests (2 tests)
- Basic documentation

**Out of Scope:**
- Full accessibility support
- Pixel-perfect UI
- Extensive automated tests

---

## 4. Project Structure

/lib
/assets
/components
/models
/screens
/test
/appium_tests
/docs
/screenshots
/results
/builds
/apk
/ios_instructions
/video
pubspec.yaml
main.dart
firebase.json
firestore.rules
README.md

yaml
Copy code

- **lib/**: Flutter source code  
- **components/**: Reusable widgets (ProductCard, BrandTile, Headline)  
- **models/**: Data models (Product, Brand)  
- **screens/**: Screens (Home, ProductDetails, Cart, Wishlist, Profile, Search)  
- **appium_tests/**: End-to-end Appium test scripts  
- **docs/**: Documentation & test results  
- **assets/**: Images, icons, fonts  
- **firestore.rules**: Firebase rules for users, carts, favorites  

---

## 5. Prerequisites

- Flutter SDK >= 3.0  
- Dart SDK >= 3.0  
- Android Studio / VS Code  
- Firebase project with Firestore & Authentication enabled  

---

## 6. Installation & Setup

### 6.1 Clone Repository
```bash
git clone https://github.com/username/laza-ecommerce.git
cd laza-ecommerce
6.2 Install Dependencies
bash
Copy code
flutter pub get
6.3 Firebase Setup
Create a Firebase project.

Add Android & iOS apps to Firebase.

Download config files:

Android: google-services.json → place in /android/app/

iOS: GoogleService-Info.plist → place in /ios/Runner/

Enable Firestore and Authentication (Email/Password).

6.4 Run the App
bash
Copy code
flutter run
7. Firestore Structure & Rules
7.1 Collections
bash
Copy code
users/{uid} -> { email, createdAt }
carts/{userId}/items/{productId} -> { productId, quantity }
favorites/{userId}/items/{productId} -> { productId }
7.2 Firestore Rules
js
Copy code
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /carts/{userId}/items/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /favorites/{userId}/items/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
8. Running Appium Tests
8.1 Prerequisites
Appium installed

Node.js >= 18

Android Emulator / iOS Simulator

8.2 Test Scripts
Auth Test:

Open app → signup → login → reach Home screen

Cart Test:

Open product → add to cart → open cart → validate item exists

8.3 Running Tests
bash
Copy code
cd appium_tests
npm install
npx appium
# run your test script

9. Notes
MVP follows general layout of Laza UI Kit (Figma), pixel-perfect UI not required

Only main screens implemented

Clean, modular folder structure for readability

10. References
Platzi Fake Store API: https://fakestoreapi.com/docs

Firebase Docs: https://firebase.google.com/docs

Flutter Docs: https://flutter.dev/docs

yaml
