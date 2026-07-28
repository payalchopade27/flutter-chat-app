# 💬 Flutter Chat App

A modern real-time messaging application built using **Flutter**, **Firebase**, and **Cloudinary**. The application enables users to securely authenticate, exchange instant messages, and share images through a clean, responsive, and intuitive user interface.

---

## 🚀 Overview

Flutter Chat App is a cross-platform messaging application developed to gain hands-on experience in Flutter development and backend integration.

The project demonstrates secure user authentication, real-time communication, cloud database integration, image uploading, and responsive UI design.

One of the major improvements made in this project was replacing **Firebase Storage** with **Cloudinary** for image uploads due to Firebase Storage billing requirements while keeping Firebase Authentication and Firestore intact.

---

## ✨ Features

- 🔐 Secure User Authentication
- 👤 User Registration & Login
- 💬 Real-Time Messaging
- 🖼 Image Sharing using Cloudinary
- ☁ Cloud Firestore Integration
- 📱 Clean & Responsive Material Design UI
- ⚡ Fast Real-Time Updates
- 🔒 Secure Cloud-Based Backend

---

## 🛠 Tech Stack

### Frontend
- Flutter
- Dart

### Backend
- Firebase Authentication
- Cloud Firestore

### Cloud Storage
- Cloudinary

### UI
- Material Design

---

## 📦 Packages Used

- firebase_auth
- cloud_firestore
- cloudinary_public
- image_picker
- firebase_core
- flutter

---

## 🏗 Architecture

```
Flutter App
      │
      │
Firebase Authentication
      │
      │
Cloud Firestore
      │
      │
Cloudinary
```

---

## 📂 Project Structure

```
lib/
│
├── screens/
│   ├── auth/
│   ├── chat/
│
├── widgets/
│
├── models/
│
├── services/
│
├── utils/
│
└── main.dart
```

---

## 📸 Screenshots

> Screenshots will be added soon.

| Login | Chat |
|-------|------|
| Image | Image |

| Image Upload | Signup |
|--------------|---------|
| Image | Image |

---

## ⚙️ Installation

### Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/flutter-chat-app.git
```

### Go to Project

```bash
cd flutter-chat-app
```

### Install Packages

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

---

## 🔥 Challenges Solved

During development, Firebase Storage required enabling billing for image uploads.

Instead of relying on Firebase Storage, **Cloudinary** was integrated for image storage while continuing to use:

- Firebase Authentication
- Cloud Firestore

This reduced cost constraints and maintained the application's functionality.

---

## 🎯 Learning Outcomes

This project helped strengthen my understanding of:

- Flutter UI Development
- Firebase Authentication
- Cloud Firestore
- Cloudinary Integration
- Image Uploading
- Responsive UI Design
- Mobile App Architecture
- State Management
- REST API Integration

---

## 🔮 Future Improvements

- 👥 Group Chats
- 🎙 Voice Messages
- 📞 Audio & Video Calling
- 😀 Emoji Reactions
- ❤️ Message Reactions
- 🔍 Chat Search
- 🌙 Dark Mode
- 🔔 Push Notifications
- 🟢 Online Status
- 📌 Pinned Messages

---

## 🤝 Contributing

Contributions, suggestions, and improvements are welcome.

Feel free to fork this repository and submit a Pull Request.

---

## 👩‍💻 Developer

**Payal Sandeep Chopade**

Computer Engineering Student

Flutter Developer | Learning Backend | Exploring AI & MLOps

---

## ⭐ Show Your Support

If you found this project helpful, consider giving it a ⭐ on GitHub!

---

## 📄 License

This project is licensed under the MIT License.
