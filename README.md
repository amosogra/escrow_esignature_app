# Escrow E-Signature App

A comprehensive Flutter application for escrow services with electronic signature consent, user authentication, and Anchor by Stripe integration.

## Features

### Core Features
- **User Registration & Authentication** - Full signup and login system
- **E-Signature Consent** - ESIGN Act compliant electronic signature disclosure
- **Consent Management** - Withdraw and re-provide consent at any time
- **Terms of Service** - Platform terms acceptance
- **Anchor Integration** - Bank account connection via Anchor by Stripe
- **User Dashboard** - Complete account management interface
- **Privacy Policy** - Comprehensive privacy disclosure

### Technical Features
- Simulated backend with local storage (ready for production API integration)
- IP address detection for consent compliance
- Session management
- Form validation
- Responsive UI design
- Material Design 3

## Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
   ```bash
   cd escrow_esignature_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage

### First Time Users
1. Launch the app and tap "Get Started"
2. Fill in your basic information (including password)
3. Review and accept the E-Signature consent
4. Accept the Terms of Service
5. Your account will be created automatically
6. Optionally setup your Anchor bank account
7. Access your dashboard

### Returning Users
1. Launch the app and tap "Already have an account? Sign in"
2. Enter your email and password
3. Access your dashboard

### Demo Mode
- **Test Anchor Account**: Use routing number `110000000` and any account number (min 8 digits)
- **Clear Data**: Use the "Clear Demo Data" option in dashboard settings to reset
- **Test Consent Withdrawal**: Withdraw consent from dashboard settings, then try to create a transaction to see consent enforcement in action

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   ├── welcome_screen.dart           # Landing page
│   ├── onboarding_flow_screen.dart   # Multi-step onboarding
│   ├── basic_info_screen.dart        # User registration form
│   ├── esignature_consent_screen.dart # E-signature disclosure
│   ├── terms_of_service_screen.dart  # Terms acceptance
│   ├── account_setup_complete_screen.dart # Registration completion
│   ├── login_screen.dart             # User authentication
│   ├── dashboard_screen.dart         # Main user interface
│   ├── anchor_setup_screen.dart      # Bank account connection
│   ├── consent_management_screen.dart # Consent withdrawal & re-consent
│   └── privacy_policy_screen.dart    # Privacy disclosure
└── services/
    ├── consent_service.dart          # Consent management
    ├── consent_guard_service.dart    # Consent enforcement & access control
    ├── backend_service.dart          # User & account data
    └── ip_service.dart               # IP detection
```

## Compliance

### E-SIGN Act Compliance
- ✅ Clear disclosure of electronic signature terms
- ✅ Hardware and software requirements
- ✅ Right to withdraw consent (explained)
- ✅ **Withdraw consent functionality (implemented in app)**
- ✅ **Re-consent capability for users who withdrew**
- ✅ **Consent enforcement (features blocked without consent)**
- ✅ **Consent required dialogs guide users to re-consent**
- ✅ Right to request paper copies
- ✅ Contact information provided
- ✅ Scroll verification
- ✅ Explicit consent checkbox
- ✅ IP address and timestamp recording
- ✅ **Consent history tracking**

See [CONSENT_ENFORCEMENT.md](CONSENT_ENFORCEMENT.md) for details on access control.

### Privacy
- Comprehensive privacy policy
- Data collection disclosure
- User rights explained
- Contact information for privacy concerns

## Next Steps for Production

See [ENHANCEMENTS.md](ENHANCEMENTS.md) for a detailed list of enhancements and production readiness checklist.

Key items:
- Replace simulated backend with real API
- Integrate actual Anchor by Stripe SDK
- Implement secure password hashing
- Add proper authentication tokens
- Set up real-time notifications
- Implement transaction management

## Documentation

- [ENHANCEMENTS.md](ENHANCEMENTS.md) - Detailed enhancement summary
- [Flutter Documentation](https://docs.flutter.dev/)
- [Anchor by Stripe Docs](https://stripe.com/docs/anchor)

## License

This project is a demonstration/template application.
