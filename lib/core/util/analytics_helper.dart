import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsHelper {
  /// Hash an email for privacy-compliant analytics (simple hash)
  static String hashEmail(String email) {
    final cleanEmail = email.toLowerCase().trim();
    return cleanEmail.hashCode.abs().toString();
  }
  
  /// Anonymize doctor name to category
  static String anonymizeDoctorName(String? doctorName) {
    if (doctorName == null || doctorName.isEmpty) return 'unknown';
    return 'doctor_${hashEmail(doctorName).substring(0, 6)}';
  }
  
  /// Get user consent for analytics
  static bool hasAnalyticsConsent() {
    // Implement your consent logic here
    // Return user's consent status
    return true; // Placeholder - implement proper consent management
  }
  
  /// Log event only if user consented
  static void logEventIfConsented(String eventName, Map<String, Object> parameters) {
    if (hasAnalyticsConsent()) {
      FirebaseAnalytics.instance.logEvent(
        name: eventName,
        parameters: parameters,
      );
    }
  }
  
  /// Clean parameters to remove PII
  static Map<String, Object> cleanParameters(Map<String, dynamic> params) {
    final cleanParams = <String, Object>{};
    
    params.forEach((key, value) {
      if (key.contains('email') && value is String) {
        // Hash email values
        cleanParams['${key}_hash'] = hashEmail(value);
      } else if (key.contains('name') && value is String && key.contains('doctor')) {
        // Anonymize doctor names
        cleanParams[key.replaceAll('name', 'category')] = anonymizeDoctorName(value);
      } else if (value != null) {
        // Keep other parameters as-is (ensuring they're not null)
        cleanParams[key] = value;
      }
    });
    
    return cleanParams;
  }
}
