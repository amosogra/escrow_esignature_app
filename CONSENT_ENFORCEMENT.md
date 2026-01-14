# Consent Enforcement & Access Control

## Overview
The app now enforces e-signature consent requirements. When a user withdraws their consent, they are **restricted from accessing features that require electronic signatures** and are prompted to re-consent if they attempt to use those features.

## What Happens When Consent is Withdrawn

### Immediate Effects

1. **Dashboard Status Updates**
   - E-Signature Consent card shows "Withdrawn" with warning icon (orange)
   - Card becomes clickable to navigate to consent management
   - Visual indicator alerts user to the status change

2. **Feature Access Restrictions**
   Users **cannot access**:
   - ❌ Create new escrow transactions
   - ❌ Setup Anchor bank account (ACH agreements require e-signature)
   - ❌ Sign any electronic documents
   - ❌ Initiate electronic fund transfers requiring authorization

3. **Features Still Available**
   Users **can still access**:
   - ✅ View dashboard and account information
   - ✅ View transaction history
   - ✅ Access account settings
   - ✅ Manage consent (to re-consent)
   - ✅ View privacy policy
   - ✅ Contact support
   - ✅ Logout

## User Experience Flow

### Attempting to Use Restricted Feature

When a user without consent tries to create a transaction:

1. **Consent Guard Dialog Appears**
   ```
   ⚠️ E-Signature Consent Required

   To use New Transaction, you need to provide
   electronic signature consent.

   📋 Current Status
   Your e-signature consent has been withdrawn. You
   previously chose to receive documents via paper mail.

   What you can do:
   1. Provide consent again to use electronic features
   2. Continue without consent (limited functionality)
   3. Contact support for assistance

   [Cancel]  [Manage Consent]
   ```

2. **If User Clicks "Manage Consent"**
   - Navigates to Consent Management Screen
   - Shows current status and options
   - User can click "Provide Consent Again"

3. **If User Provides Consent Again**
   - Goes through full E-Signature disclosure
   - Must scroll to bottom and check consent box
   - New consent record created with timestamp and IP
   - Returns to previous screen
   - Feature access is now granted

4. **If User Cancels**
   - Returns to dashboard
   - Feature remains inaccessible
   - Can try again later

## Technical Implementation

### Consent Guard Service

Located at `lib/services/consent_guard_service.dart`, this service provides:

```dart
// Check if user has active consent
bool hasConsent = await ConsentGuardService.instance.hasActiveConsent();

// Guard a feature (shows dialog if no consent)
bool canProceed = await ConsentGuardService.instance.guardFeature(
  context,
  featureName: 'New Transaction',
  customMessage: 'Custom message explaining why consent is needed',
);

// Show simple snackbar notification
ConsentGuardService.instance.showConsentRequiredMessage(
  context,
  'Feature Name'
);
```

### Protected Features

#### Dashboard (`lib/screens/dashboard_screen.dart`)

**New Transaction Button**
```dart
Future<void> _handleNewTransaction() async {
  final canProceed = await ConsentGuardService.instance.guardFeature(
    context,
    featureName: 'New Transaction',
    customMessage: 'Creating escrow transactions requires electronic signature consent...',
  );

  if (canProceed) {
    // Proceed with transaction creation
  }
}
```

**Anchor Account Setup**
```dart
Future<void> _handleSetupAnchorAccount() async {
  final canProceed = await ConsentGuardService.instance.guardFeature(
    context,
    featureName: 'Anchor Account Setup',
    customMessage: 'Setting up an Anchor account requires electronic signature consent...',
  );

  if (canProceed && mounted) {
    // Navigate to Anchor setup
  }
}
```

**Status Cards**
```dart
_buildStatusCard(
  'E-Signature Consent',
  _hasConsent ? 'Accepted' : 'Withdrawn',
  _hasConsent ? Icons.draw : Icons.warning_amber,
  _hasConsent ? Colors.green : Colors.orange,
  onTap: !_hasConsent ? _handleManageConsent : null,  // Clickable if withdrawn
),
```

### Adding Protection to New Features

To protect a new feature with consent guard:

```dart
Future<void> myProtectedFeature() async {
  // Add consent check
  final canProceed = await ConsentGuardService.instance.guardFeature(
    context,
    featureName: 'My Feature Name',
    customMessage: 'Optional: explain why this feature needs consent',
  );

  if (canProceed) {
    // User has active consent - proceed with feature
    // Your feature code here
  }
  // If canProceed is false, the guard already handled
  // showing the dialog and potential navigation
}
```

## Consent Status Tracking

### Real-time Status Updates

The dashboard loads consent status on:
- Initial load
- Return from consent management screen
- Return from any navigation

```dart
Future<void> _loadUserData() async {
  final hasConsent = await ConsentService.instance.hasConsent('esignature');
  setState(() {
    _hasConsent = hasConsent;
  });
}
```

### Visual Indicators

| Status | Icon | Color | Action |
|--------|------|-------|--------|
| Active | ✓ Draw icon | Green | View only |
| Withdrawn | ⚠️ Warning | Orange | Tap to manage |

## Compliance Benefits

### E-SIGN Act Requirements

✅ **Consent Enforcement**
- Users without consent cannot sign electronically
- Clear messaging about limitations
- Easy path to re-consent

✅ **User Control**
- Users can withdraw consent at any time
- Features gracefully degrade when consent is withdrawn
- No hidden restrictions

✅ **Transparency**
- Status clearly displayed on dashboard
- Dialog explains why consent is needed
- Information about alternatives (paper mail)

✅ **Audit Trail**
- Every consent check is visible to user
- Clear distinction between consented and non-consented actions
- History tracks all changes

## Testing Scenarios

### Test Case 1: Withdraw and Attempt Transaction
1. Login with active consent
2. Navigate to Consent Management
3. Withdraw consent
4. Return to dashboard
5. Verify status shows "Withdrawn" (orange)
6. Click "New Transaction"
7. Verify consent guard dialog appears
8. Click "Cancel"
9. Verify transaction is not created

### Test Case 2: Re-Consent and Use Feature
1. Start with withdrawn consent
2. Try to create transaction
3. Click "Manage Consent" in dialog
4. Click "Provide Consent Again"
5. Complete full consent flow
6. Return to dashboard
7. Verify status shows "Accepted" (green)
8. Try transaction again
9. Verify transaction creation proceeds

### Test Case 3: Anchor Setup with No Consent
1. Login without consent
2. Status card shows "Anchor Account: Not Connected"
3. Click the Anchor Account card
4. Verify consent guard dialog appears
5. User must provide consent before proceeding

### Test Case 4: Dashboard Status Indicators
1. Withdraw consent
2. Observe dashboard updates immediately
3. Consent card becomes clickable
4. Icon and color change to warning state
5. Click card to access consent management

## Production Considerations

### Backend Integration

When moving to production, enhance consent checks:

```dart
// Add backend verification
Future<bool> hasActiveConsent() async {
  // Check local cache first
  final localHasConsent = await ConsentService.instance.hasConsent('esignature');

  // Verify with backend
  final backendResponse = await api.get('/user/consent/status');
  final serverHasConsent = backendResponse.data['hasConsent'];

  // Return most restrictive
  return localHasConsent && serverHasConsent;
}
```

### Logging

Add consent check logging:

```dart
// Log every consent check
await analytics.logEvent(
  'consent_check',
  parameters: {
    'feature': featureName,
    'has_consent': hasConsent,
    'user_id': currentUserId,
  },
);

// Log consent dialogs shown
await analytics.logEvent(
  'consent_dialog_shown',
  parameters: {
    'feature': featureName,
    'action': userAction, // 'cancelled', 'managed', 'consented'
  },
);
```

### Error Handling

Handle edge cases:

```dart
try {
  final hasConsent = await ConsentGuardService.instance.hasActiveConsent();
} catch (e) {
  // If consent check fails, assume no consent (fail closed)
  // Log error for investigation
  logger.error('Consent check failed', error: e);
  return false;
}
```

## Future Enhancements

### Partial Consent

Allow granular consent for different features:
- Transaction signing consent
- ACH authorization consent
- Marketing communications consent
- Data sharing consent

### Consent Expiration

Implement consent expiration:
- Request re-consent after certain period
- Remind users before expiration
- Graceful degradation when expired

### Consent Levels

Implement consent tiers:
- Basic consent: View-only features
- Standard consent: Limited transactions
- Full consent: All features including high-value transactions

## Support

For questions about consent enforcement:
- Code: `lib/services/consent_guard_service.dart`
- Implementation: `lib/screens/dashboard_screen.dart`
- User flow: This document
- Legal compliance: Consult legal team
