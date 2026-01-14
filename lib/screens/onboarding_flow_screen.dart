import 'package:flutter/material.dart';
import 'basic_info_screen.dart';
import 'esignature_consent_screen.dart';
import 'terms_of_service_screen.dart';
import 'account_setup_complete_screen.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  int _currentStep = 0;
  final Map<String, dynamic> _userData = {};

  final List<String> _stepTitles = [
    'Basic Information',
    'E-Signature Consent',
    'Terms of Service',
    'Complete Setup',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Setup'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: List.generate(_stepTitles.length, (index) {
                final isActive = index == _currentStep;
                final isCompleted = index < _currentStep;
                
                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (index > 0)
                            Expanded(
                              child: Container(
                                height: 2,
                                color: isCompleted ? Colors.blue : Colors.grey[300],
                              ),
                            ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted
                                  ? Colors.blue
                                  : isActive
                                      ? Colors.blue
                                      : Colors.grey[300],
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: isActive ? Colors.white : Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                            ),
                          ),
                          if (index < _stepTitles.length - 1)
                            Expanded(
                              child: Container(
                                height: 2,
                                color: isCompleted ? Colors.blue : Colors.grey[300],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _stepTitles[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? Colors.blue : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          
          // Content Area
          Expanded(
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return BasicInfoScreen(
          onContinue: (data) {
            setState(() {
              _userData.addAll(data);
              _currentStep++;
            });
          },
        );
      case 1:
        return ESignatureConsentScreen(
          onConsent: () {
            setState(() {
              _userData['eSignatureConsent'] = true;
              _userData['eSignatureConsentDate'] = DateTime.now().toIso8601String();
              _currentStep++;
            });
          },
          onBack: () {
            setState(() {
              _currentStep--;
            });
          },
        );
      case 2:
        return TermsOfServiceScreen(
          onAccept: () {
            setState(() {
              _userData['termsAccepted'] = true;
              _userData['termsAcceptedDate'] = DateTime.now().toIso8601String();
              _currentStep++;
            });
          },
          onBack: () {
            setState(() {
              _currentStep--;
            });
          },
        );
      case 3:
        return AccountSetupCompleteScreen(
          userData: _userData,
        );
      default:
        return const Center(child: Text('Unknown step'));
    }
  }
}
