# Mini Docto+ 🏥

A comprehensive Flutter application for booking medical appointments and managing healthcare services. Built with Clean Architecture, BLoC state management, and Firebase integration.

## 📱 App Screenshots

### Authentication & Onboarding
<div align="center">Screenshot_1753979914/Screenshot_1753979912
  <img src="phone screenshots/Screenshot_1753979912.png" width="200" alt="Profile Screen"/>
  <img src="phone screenshots/Screenshot_1753979914.png" width="200" alt="Navigation"/>
</div>

*Secure user authentication with email validation and account creation*

### Doctor Discovery & Booking
<div align="center">
  <img src="phone screenshots/Screenshot_1753979854.png" width="200" alt=""/>
  <img src="phone screenshots/Screenshot_1753979612.png" width="200" alt=""/>
  <img src="phone screenshots/Screenshot_1753979837.png" width="200" alt=""/>
  <img src="phone screenshots/Screenshot_1753979842.png" width="200" alt=""/>
  <img src="phone screenshots/Screenshot_1753979845.png" width="200" alt=""/>
  <img src="phone screenshots/Screenshot_1753979846.png" width="200" alt=""/>
  <img src="phone screenshots/Screenshot_1753979849.png" width="200" alt=""/>
</div>

*Browse available doctors, view profiles, and select appointment time slots*

### Appointment Management
<div align="center">

  <img src="phone screenshots/Screenshot_1753979866.png" width="200" alt="Appointment Details"/>

</div>

*Manage appointments, view details, and access user profile settings*

## 🚀 Features

- **User Authentication**: Secure login and registration with Firebase Auth
- **Doctor Discovery**: Browse available healthcare professionals
- **Smart Scheduling**: View doctor availability and book appointments
- **Appointment Management**: Track, reschedule, and cancel bookings
- **Analytics Tracking**: Comprehensive user behavior analytics with Firebase
- **Responsive Design**: Optimized for various screen sizes

## 🏗️ Architecture

This app follows **Clean Architecture** principles with:

- **Presentation Layer**: BLoC state management
- **Domain Layer**: Use cases and business logic
- **Data Layer**: Repository pattern with local and remote data sources
- **Dependency Injection**: GetIt for service locator pattern

## 🔧 Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: BLoC (Business Logic Component)
- **Backend**: Firebase (Auth, Firestore, Analytics)
- **Architecture**: Clean Architecture
- **Dependency Injection**: GetIt
- **Routing**: Named routes with custom route management
- **UI**: Material Design 3 with custom theming
- **Animations**: Lottie animations
- **Networking**: HTTP with error handling

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_analytics: ^10.7.4
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4
  dartz: ^0.10.1
  equatable: ^2.0.5
  connectivity_plus: ^5.0.2
  shared_preferences: ^2.2.2
  lottie: ^2.7.0
```

## 🛠️ Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mini-docto-plus.git
   cd mini-docto-plus
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Enable Authentication, Firestore, and Analytics

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔐 Firebase Configuration

The app uses Firebase for:
- **Authentication**: Email/password login and registration
- **Database**: Firestore for storing user data and appointments
- **Analytics**: Comprehensive user behavior tracking
- **Security**: Firestore security rules for data protection

## 📊 Analytics Events

The app tracks 25+ user interactions including:
- Authentication flows (login, registration)
- Doctor browsing and selection
- Appointment booking and management
- Navigation patterns
- Error tracking and performance metrics

For detailed analytics documentation, see [FIREBASE_ANALYTICS_EVENTS.md](FIREBASE_ANALYTICS_EVENTS.md)

## 🌐 Localization

Supports multiple languages:
- **Arabic (ar)**: Right-to-left layout support
- **French (fr)**: Complete translation
- **English (en)**: Default language

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11.0+)
- ✅ **Web** (Progressive Web App)
- ✅ **Windows** (Desktop support)
- ✅ **macOS** (Desktop support)
- ✅ **Linux** (Desktop support)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

Built with ❤️ using Flutter

---

**Mini Docto+** - Making healthcare accessible and convenient for everyone.
