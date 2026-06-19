# ❤️ Charity App (HopeConnect)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![VS Code](https://img.shields.io/badge/VS_Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## 📖 Description

HopeConnect (Charity App) is a complete role-based Flutter application designed to bridge the gap between donors, charity organizations, and volunteers. It provides a secure, transparent, and efficient platform for raising funds, volunteering, managing campaigns, and verifying requests.

---

## ✨ Features

- **Secure Authentication & Roles**: Role-based redirection and dashboard management for Donors, Organizations, Volunteers, and Admins.
- **Donor Feed & Filters**: Active approved charity request lists, progress bars tracking target vs raised amounts, and category-based filtering.
- **Dummy Payment System**: Multi-method simulated payment gateway (UPI, Credit/Debit Card, Net Banking, Wallet) with automatic database logging, receipt generation, and transaction history.
- **Notification System**: Unified in-app notifications for campaign approvals/rejections, donation receipts, and admin announcements.
- **Organization Campaign Dashboard**: Category choices, Supabase storage bucket image uploading, campaign metrics progress tracker, and tab-based status listing.
- **Volunteer Verification Panel**: Role assigned by admin to verify or reject charity campaigns and report verification news.
- **Admin Control Suite**: Analytics reports with category progress charts, user management (enable/disable/delete), and transaction refund processing.

---

## 🛠️ Technology Stack & Architecture

- **Frontend**: Flutter (Dart) - clean responsive UI layouts with gradients, smooth cards, and animations.
- **Database**: Google Firebase Firestore (NoSQL) for user profiles, login credentials, campaigns, news, transactions, and notification logs.
- **Authentication**: Firebase Authentication for secure signups and logins.
- **Storage**: Supabase Storage for uploading, archiving, and retrieving avatars and charity campaign images.

---

## 📂 Firestore Database Schema

### `users`
- `name`: String
- `email`: String
- `dob`: String
- `address`: String
- `post`: String
- `pin`: String
- `phone`: String
- `gender`: String
- `blood`: String
- `created at`: Timestamp
- `imageurl`: String (Supabase storage reference)

### `organization`
- `name`: String
- `email`: String
- `phone`: String
- `place`: String
- `post`: String
- `pin`: String
- `district`: String
- `created at`: Timestamp
- `imageurl`: String
- `verfiedby`: String ('admin', 'rejected by admin', or 'null')

### `volunteers`
- `name`: String
- `email`: String
- `dob`: String
- `phone`: String
- `gender`: String
- `created at`: Timestamp
- `imageurl`: String

### `login`
- `username`: String (Email address)
- `password`: String (Plaintext password)
- `role`: String ('admin', 'user', 'vol', 'org', 'pending', or 'disabled')

### `charity`
- `purpose`: String (Campaign title)
- `description`: String
- `goal_amount`: String (Target funds needed)
- `collected_amount`: Double (Funds raised so far)
- `deadline`: String (DD/MM/YYYY)
- `category`: String
- `organization_id`: String (UID of the host org)
- `status`: String ('pending', 'processing', 'approved', 'rejected')
- `assigned`: String (Volunteer UID or 'null')
- `verfiedby`: String
- `imageurl`: String
- `created_at`: Timestamp

### `transactions`
- `transactionId`: String (Unique ID)
- `charityId`: String
- `charityName`: String
- `donorId`: String
- `donorName`: String
- `amount`: Double
- `paymentMethod`: String
- `status`: String ('success', 'refunded', 'failed')
- `timestamp`: Timestamp

### `donations`
- `donationId`: String (Unique ID)
- `transactionId`: String
- `charityId`: String
- `charityName`: String
- `donorId`: String
- `donorName`: String
- `amount`: Double
- `timestamp`: Timestamp

### `notifications`
- `userId`: String (Recipient UID)
- `title`: String
- `body`: String
- `type`: String ('donation', 'approval', 'rejection', 'announcement', 'general')
- `read`: Boolean
- `timestamp`: Timestamp

### `news`
- `title`: String
- `description`: String
- `user`: String ('admin', 'vol', 'org')
- `id`: String (Creator UID)
- `verify`: String ('pending', 'approved', 'rejected')
- `like`: List<String> (Array of user UIDs)
- `date`: Timestamp

---

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (v3.6.0 or higher)
- Android Studio / VS Code with Dart & Flutter plugins
- Firebase CLI (for configuration)

### Steps
1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/prajilprabhan/charity_App.git
   ```
2. Initialize and configure Firebase for your platforms. The current project imports default settings via [firebase_options.dart](file:///c:/FLUTTER%20PROJECT/seechange/lib/firebase_options.dart).
3. Set up a Supabase project and create an public storage bucket named `images`.
4. Install all package dependencies:
   ```bash
   flutter pub get
   ```
5. Run the application:
   ```bash
   flutter run
   ```

---

## 🎯 Running Tests
To run unit and integration helper tests:
```bash
flutter test test/app_test.dart
```

---

## 🤝 Contributing

Contributions are welcome.

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to your branch
5. Create a Pull Request

---

## 📄 License

This project is licensed under the MIT License.
