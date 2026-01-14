# E-Signature Consent Withdrawal Guide

## Overview
The app now includes a complete consent management system that allows users to withdraw their electronic signature consent at any time and re-provide consent if needed. This is a critical E-SIGN Act compliance requirement.

## Features

### 1. Access Consent Management
Users can access consent management through:
- Dashboard → Settings & Support → E-Signature Consent

### 2. View Consent Status
The consent management screen displays:
- **Current Status**: Active or Withdrawn
- **Consent Details**:
  - Status (Accepted/Withdrawn)
  - Date and time of last action
  - IP address used for consent
- **Consent History**: Complete timeline of all consent actions

### 3. Withdraw Consent
Users who have active consent can:
1. Click "Withdraw Consent" button
2. Confirm the withdrawal action
3. Receive confirmation that consent has been withdrawn

**What happens when consent is withdrawn:**
- Consent status changes to "Withdrawn"
- Timestamp and IP address are recorded
- Previous electronic transactions remain valid
- User is informed they will need to handle documents via paper mail
- The action is added to consent history

### 4. Provide Consent Again
Users who withdrew consent can:
1. Click "Provide Consent Again" button
2. Review the full E-Signature disclosure (same as during registration)
3. Scroll through all disclosure text
4. Check the consent checkbox
5. Click "I Agree - Continue" to re-consent

**What happens when re-consenting:**
- User goes through the full consent flow again
- New consent record is created with current timestamp and IP
- Consent status changes back to "Active"
- User can resume electronic transactions
- The action is added to consent history

### 5. Request Paper Copies
Users can access contact information to request paper copies:
- Email: support@escrowplatform.com
- Phone: 1-800-555-0123

## Technical Implementation

### Consent Service Methods
Located in `lib/services/consent_service.dart`:

```dart
// Save consent (accept or withdraw)
await ConsentService.instance.saveConsent(
  consentType: 'esignature',
  consentGiven: true/false,
  ipAddress: 'user.ip.address',
);

// Withdraw consent
await ConsentService.instance.withdrawConsent('esignature');

// Check if user has active consent
bool hasConsent = await ConsentService.instance.hasConsent('esignature');

// Get current consent record
Map<String, dynamic>? record = await ConsentService.instance.getConsent('esignature');

// Get complete consent history
List<Map<String, dynamic>> history = await ConsentService.instance.getConsentHistory();
```

### Consent Data Structure
Each consent record includes:
```dart
{
  'type': 'esignature',
  'given': true/false,
  'timestamp': '2026-01-14T10:30:00.000Z',
  'ipAddress': '192.168.1.1'
}
```

### Screen Components

#### Consent Management Screen (`lib/screens/consent_management_screen.dart`)
- Full-featured consent management interface
- Status display with visual indicators
- Withdraw consent functionality
- Re-consent capability
- Consent history timeline
- Information about consent implications

#### Dashboard Integration (`lib/screens/dashboard_screen.dart`)
- "E-Signature Consent" link in Settings & Support
- Navigates to consent management screen
- Refreshes dashboard data when returning

## User Flow

### Withdrawing Consent
1. User logs into dashboard
2. Navigates to Settings & Support
3. Clicks "E-Signature Consent"
4. Views current status (Active)
5. Clicks "Withdraw Consent"
6. Confirms withdrawal in dialog
7. Receives confirmation message
8. Status updates to "Withdrawn"
9. Action recorded in history

### Re-Providing Consent
1. User with withdrawn consent navigates to consent management
2. Views current status (Withdrawn)
3. Clicks "Provide Consent Again"
4. Navigates to full E-Signature disclosure screen
5. Reads complete disclosure (must scroll to bottom)
6. Checks consent checkbox
7. Clicks "I Agree - Continue"
8. Returns to consent management
9. Status updates to "Active"
10. Action recorded in history

## Compliance Benefits

### E-SIGN Act Requirements Met
✅ **Section 101(c)(1)(C)(ii)**: Right to withdraw consent
- ✓ Explained in disclosure
- ✓ Implemented in app
- ✓ No fees charged
- ✓ Contact information provided

✅ **Consent Record Keeping**:
- ✓ Timestamp of consent/withdrawal
- ✓ IP address captured
- ✓ Complete audit trail
- ✓ History preserved

✅ **User Control**:
- ✓ Easy access to manage consent
- ✓ Clear status display
- ✓ Ability to change mind (re-consent)
- ✓ Transparent process

## Testing

### Test Scenarios

**Scenario 1: Withdraw Active Consent**
1. Register new account with e-signature consent
2. Navigate to dashboard
3. Access consent management
4. Verify status shows "Active"
5. Withdraw consent
6. Verify status changes to "Withdrawn"
7. Check history shows withdrawal record

**Scenario 2: Re-Provide Consent**
1. Start with withdrawn consent
2. Navigate to consent management
3. Verify status shows "Withdrawn"
4. Click "Provide Consent Again"
5. Complete full disclosure flow
6. Verify status changes to "Active"
7. Check history shows new consent record

**Scenario 3: Multiple Withdrawals**
1. Withdraw consent
2. Re-provide consent
3. Withdraw again
4. Verify history shows all 3 actions
5. Verify each record has unique timestamp

## Production Considerations

When moving to production:

1. **Audit Logging**: Send consent actions to backend server
2. **Email Notifications**: Notify user via email when consent is withdrawn
3. **Compliance Reporting**: Generate reports of consent status
4. **Legal Review**: Have legal team review consent language
5. **User Communication**: Send confirmation emails for consent changes
6. **Data Retention**: Ensure consent records are retained per legal requirements (typically 7 years)

## Support

For questions about consent management:
- Technical: review code in `lib/services/consent_service.dart`
- Legal compliance: consult legal team
- User questions: support@escrowplatform.com or 1-800-555-0123
