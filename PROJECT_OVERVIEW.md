# Mini Docto+ Flutter User App - Complete Project Overview

## 🏗️ Project Architecture

### **Clean Architecture Implementation**
```
lib/
├── core/                    # Shared utilities and services
├── features/                # Feature-based modules
├── global/                  # Global widgets and utilities
├── injection_container.dart # Dependency injection setup
└── main.dart                # App entry point
```

### **Architecture Layers**
1. **Presentation Layer**: UI components, BLoC state management
2. **Domain Layer**: Entities, use cases, repository interfaces
3. **Data Layer**: Models, data sources, repository implementations
4. **Core Layer**: Shared utilities, constants, and services

---

## 📱 Core Features

### **1. Authentication System**
- **Location**: `lib/features/authentication/`
- **Components**:
  - Login screen with email/password validation
  - Register screen with username, email, password, confirm password
  - JWT token management with automatic refresh
  - Form validation and error handling

**Key Files**:
```
authentication/
├── data/
│   ├── models/user_model.dart
│   ├── data_sources/remote_data_source/authentification_remote_data_source.dart
│   └── repository/user_repository_impl.dart
├── domain/
│   ├── entities/user.dart
│   ├── repository/user_repository.dart
│   └── usecases/[login_user_use_case.dart, sign_up_user_use_case.dart]
└── presentation/
    ├── bloc/auth_bloc.dart
    ├── pages/[login_screen.dart, register_screen.dart]
    └── widgets/[login_form.dart, register_form.dart, header_login.dart]
```

### **2. Doctor Discovery**
- **Location**: `lib/features/available_doctors_screen/`
- **Features**:
  - Browse available doctors with pagination
  - Doctor cards with profile info, ratings, specialties
  - Shimmer loading animations
  - Pull-to-refresh functionality
  - "Book Now" navigation to scheduling

### **3. Appointment Scheduling**
- **Location**: `lib/features/schedule_screen/`
- **Features**:
  - Schedule groups (date ranges) with availability counts
  - Time slot selection with morning/afternoon organization
  - Past time detection and user booking identification
  - Booking confirmation dialogs
  - Shimmer loading states
  - Responsive grid layouts

**Time Slot States**:
- Available (white background, primary border)
- Selected (primary background, white text)
- Past (grayed out, disabled)
- Booked by user (green background, check icon)
- Unavailable (gray background, disabled)

### **4. Appointment Management**
- **Location**: `lib/features/my_appointment_screen/`
- **Features**:
  - View all user appointments with pagination
  - Appointment cards with doctor info, dates, times
  - Status badges (Scheduled, Completed, Cancelled, No-show)
  - Cancel appointment with confirmation
  - Reschedule functionality
  - Shimmer loading for smooth UX

### **5. Profile Management**
- **Location**: `lib/features/profile_screen/`
- **Features**:
  - User profile information display
  - Logout functionality with confirmation dialog
  - Token clearing and navigation to login

### **6. Navigation System**
- **Location**: `lib/features/bottom_nav_bar/`
- **Features**:
  - Bottom navigation with 4 tabs:
    1. Available Doctors
    2. My Appointments  
    3. Messaging (placeholder)
    4. Profile

---

## 🛠️ Technical Implementation

### **State Management - BLoC Pattern**
Each feature implements the BLoC pattern:
```dart
// Example: Schedule BLoC
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  // Events: LoadScheduleGroups, SelectScheduleGroup, SelectTimeSlot, BookAppointment
  // States: Loading, Loaded, Error, BookingInProgress, BookingSuccess, BookingError
}
```

### **Dependency Injection - GetIt**
```dart
// injection_container.dart
final sl = GetIt.instance;

// Feature registration example:
sl.registerFactory(() => AuthBloc(loginUserUseCase: sl(), signUpUserUseCase: sl()));
sl.registerLazySingleton(() => LoginUserUseCase(userRepository: sl()));
sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(...));
```

### **Token Management System**
```dart
// TokenManager class handles:
class TokenManager {
  - JWT token storage and retrieval
  - Automatic token refresh when expired
  - Token validation and expiry checking
  - Logout with API call and local cleanup
}
```

### **HTTP Client with Authentication**
- Base URL: `http://10.0.2.2:8081/` (Android emulator localhost)
- Automatic Bearer token injection
- Network connectivity checking
- Error handling and failure mapping

### **Shimmer Loading States**
Comprehensive shimmer animations for:
- Available doctors list
- Schedule screen (groups + time slots)
- Appointment cards
- All implemented with `shimmer_animation` package

---

## 🎨 UI/UX Implementation

### **Design System**
- **Primary Color**: Custom primary color defined in `core/constants/appcolors.dart`
- **Typography**: Poppins font family
- **Responsive Design**: Flutter ScreenUtil for adaptive layouts
- **Loading States**: Shimmer effects for smooth user experience

### **Form Validation**
- Email format validation
- Password strength requirements
- Confirm password matching
- Username validation
- Real-time error display

## 📡 API Integration

### **Authentication Endpoints**
```
POST /auth/login
POST /auth/signup  
POST /auth/refresh
POST /auth/logout
```

### **Doctor & Scheduling Endpoints**
```
GET /availability/available-doctors
GET /availability/doctors/{doctorId}
POST /appointments/book
GET /appointments/my-appointments
DELETE /appointments/{appointmentId}
```

### **Data Flow Example**
```
User Action → BLoC Event → Use Case → Repository → Remote Data Source → API
API Response → Data Source → Repository → Use Case → BLoC State → UI Update
```

---

### **Prerequisites**
1. Flutter SDK 3.7.2+
2. Android/iOS development environment
3. Backend server running on port 8081

### **Setup Instructions**
```bash
# 1. Get dependencies
flutter pub get

# 2. Run the app
flutter run
```

## 📂 Project Structure Details

### **Feature Structure Template**
```
feature_name/
├── data/
│   ├── models/              # JSON serializable models
│   ├── data_sources/        # Remote/Local data sources
│   └── repository/          # Repository implementations
├── domain/
│   ├── entities/            # Business objects
│   ├── repository/          # Repository interfaces
│   └── usecases/           # Business logic
└── presentation/
    ├── bloc/               # State management
    ├── pages/              # Screen widgets
    └── widgets/            # Reusable UI components
```

### **Global Components**
```
global/
├── common_widget/          # Shared UI components
│   ├── app_bar.dart       # Custom app bar
│   ├── text_form_field.dart # Form inputs
│   └── pop_up_msg.dart    # Snackbar utilities
└── utils/                 # Utility functions
    └── form_validator.dart # Form validation logic
```

---

## 🔐 Security Features

### **Token Security**
- JWT tokens stored securely in SharedPreferences
- Automatic token refresh to prevent session expiry
- Secure logout with server-side token invalidation

### **Input Validation**
- Client-side form validation
- XSS prevention through proper input sanitization
- Network request validation

### **Error Handling**
- Comprehensive error states in BLoC
- User-friendly error messages
- Graceful degradation for network issues

---

## 🔄 Data Flow Architecture

### **Authentication Flow**
1. User enters credentials
2. AuthBloc validates and sends LoginEvent
3. LoginUserUseCase calls repository
4. Repository calls remote data source
5. API response processed and tokens saved
6. Navigation to main app

### **Appointment Booking Flow**
1. User selects doctor from available list
2. Navigate to schedule screen
3. Load schedule groups and time slots
4. User selects date and time
5. Confirmation dialog shown
6. BookAppointment event triggers API call
7. Success/error feedback to user

---

## 🎯 Best Practices Implemented

### **Code Organization**
- Feature-based architecture
- Separation of concerns
- Dependency injection
- Error handling at every layer

### **User Experience**
- Loading states with shimmer animations
- Pull-to-refresh functionality
- Confirmation dialogs for destructive actions
- Real-time form validation

### **Performance**
- Pagination for large data sets
- Lazy loading of dependencies
- Efficient state management
- Image optimization

---