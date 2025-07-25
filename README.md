# 🏠 ResidenceHub

**A comprehensive community management platform for residential buildings**

ResidenceHub streamlines residential community management with features for ticketing, proposals & voting, financial ledger, and announcements.

## ✨ Features

### 🎫 **Ticket Management**
- Create, view, edit, and delete support tickets
- File attachments with image support
- Status tracking (Open, In Progress, Resolved)
- Category filtering (General, Maintenance, Finance, Other)
- Advanced search and filtering

### 🗳️ **Proposals & Voting**
- Community proposal creation and management
- Real-time voting system
- Visual results with progress indicators
- Vote tracking and transparency

### 💰 **Financial Ledger**
- Monthly expense tracking
- Payment record management
- Due amount monitoring
- Receipt management with file uploads

### 📢 **Announcements**
- Community announcements with priority levels
- Image attachments support
- Admin-controlled publishing

### 👤 **User Management**
- Profile completion and management
- Authentication with Supabase
- Apartment-based access control

## 🛠️ Tech Stack

- **Frontend**: Flutter (Material 3 Design)
- **State Management**: Riverpod with MVVM architecture
- **Backend**: Supabase (PostgreSQL, Authentication, Storage)
- **Architecture**: Clean Architecture with Repository pattern
- **Navigation**: GoRouter
- **Data Models**: Freezed + JSON serialization

## 🚀 Getting Started

### Prerequisites
- Flutter 3.0.0 or higher
- Dart SDK
- iOS Simulator / Android Emulator
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://gitlab.com/your-username/residence-hub.git
   cd residence-hub
   ```

2. **Install dependencies**
   ```bash
   cd apartment_superapp
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Supabase**
   - Update `lib/main.dart` with your Supabase URL and anon key
   - Set up database tables (see Database Schema below)

5. **Run the app**
   ```bash
   flutter run
   ```

## 🗃️ Database Schema

### Tables
- `profiles` - User profiles and apartment information
- `tickets` - Support ticket management
- `proposals` - Community proposals
- `votes` - Voting records
- `expenses` - Financial expense tracking
- `payments` - Payment records
- `announcements` - Community announcements

### Setup SQL scripts available in `/database` folder

## 📁 Project Structure

```
lib/
├── app.dart                 # App configuration
├── main.dart               # Entry point
└── features/
    ├── auth/               # Authentication
    ├── tickets/            # Ticket management
    ├── proposals/          # Proposals & voting
    ├── ledger/            # Financial ledger
    ├── announcements/     # Community announcements
    ├── profile/           # User profiles
    └── home/              # Dashboard
```

## 🎯 Architecture

ResidenceHub follows Clean Architecture principles with:

- **MVVM Pattern**: Clear separation of UI, business logic, and data
- **Repository Pattern**: Abstracted data access layer
- **Riverpod**: Reactive state management
- **Freezed**: Immutable data models
- **Material 3**: Modern, accessible UI design

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Merge Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support, email your-email@example.com or create an issue in this repository.

---

**ResidenceHub** - Making residential community management simple and efficient! 🏠✨ 