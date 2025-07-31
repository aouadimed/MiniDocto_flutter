# Firebase Analytics Events - Mini Docto+ Flutter App

Ce document liste tous les événements Firebase Analytics intégrés dans l'application Mini Docto+.

## 📊 Événements d'Authentification

### Login Screen
- **`login_attempt`** - Tentative de connexion
  - `email`: Email de l'utilisateur
  - `timestamp`: Horodatage

- **`login_success`** - Connexion réussie
  - `user_email`: Email de l'utilisateur
  - `user_role`: Rôle de l'utilisateur
  - `timestamp`: Horodatage

- **`login_failed`** - Échec de connexion
  - `error_message`: Message d'erreur
  - `timestamp`: Horodatage

- **`navigate_to_register`** - Navigation vers l'écran d'inscription
  - `source`: 'login_screen'
  - `timestamp`: Horodatage

### Register Screen
- **`registration_attempt`** - Tentative d'inscription
  - `username`: Nom d'utilisateur
  - `email`: Email
  - `timestamp`: Horodatage

- **`registration_success`** - Inscription réussie
  - `username`: Nom d'utilisateur
  - `email`: Email
  - `timestamp`: Horodatage

- **`registration_failed`** - Échec d'inscription
  - `error_message`: Message d'erreur
  - `timestamp`: Horodatage

- **`navigate_to_login`** - Navigation vers l'écran de connexion
  - `source`: 'register_screen'
  - `timestamp`: Horodatage

## 👨‍⚕️ Événements des Docteurs Disponibles

### Available Doctors Screen
- **`view_available_doctors`** - Visualisation de la liste des docteurs
  - `action`: 'initial_load'
  - `timestamp`: Horodatage

- **`load_more_doctors`** - Chargement de plus de docteurs
  - `current_page`: Page actuelle
  - `total_doctors_loaded`: Nombre total de docteurs chargés
  - `timestamp`: Horodatage

- **`select_doctor_for_booking`** - Sélection d'un docteur pour réservation
  - `doctor_id`: ID du docteur
  - `doctor_name`: Nom du docteur
  - `doctor_category`: Catégorie du docteur
  - `doctor_score`: Score du docteur
  - `timestamp`: Horodatage

## 📅 Événements de Planification

### Schedule Screen
- **`view_doctor_schedule`** - Visualisation du planning d'un docteur
  - `doctor_id`: ID du docteur
  - `timestamp`: Horodatage

- **`select_schedule_group`** - Sélection d'un groupe de planning
  - `group_id`: ID du groupe
  - `date_range`: Plage de dates
  - `available_count`: Nombre de créneaux disponibles
  - `timestamp`: Horodatage

- **`select_time_slot`** - Sélection d'un créneau horaire
  - `slot_id`: ID du créneau
  - `slot_time`: Heure du créneau
  - `slot_period`: Période (AM/PM)
  - `slot_type`: Type (morning/afternoon)
  - `timestamp`: Horodatage

- **`confirm_appointment_booking`** - Confirmation de réservation
  - `doctor_id`: ID du docteur
  - `slot_id`: ID du créneau
  - `date_range`: Plage de dates
  - `time_slot`: Créneau horaire complet
  - `timestamp`: Horodatage

- **`appointment_booked_successfully`** - Rendez-vous réservé avec succès
  - `doctor_id`: ID du docteur
  - `booking_message`: Message de confirmation
  - `timestamp`: Horodatage

- **`appointment_booking_failed`** - Échec de réservation
  - `doctor_id`: ID du docteur
  - `error_message`: Message d'erreur
  - `timestamp`: Horodatage

## 📋 Événements des Rendez-vous

### My Appointments Screen
- **`view_my_appointments`** - Visualisation des rendez-vous
  - `timestamp`: Horodatage

- **`appointment_cancelled_successfully`** - Annulation réussie
  - `timestamp`: Horodatage

- **`appointment_cancellation_failed`** - Échec d'annulation
  - `error_message`: Message d'erreur
  - `timestamp`: Horodatage

### Appointment Card
- **`reschedule_appointment_clicked`** - Clic sur reprogrammer
  - `appointment_id`: ID du rendez-vous
  - `doctor_id`: ID du docteur
  - `doctor_name`: Nom du docteur
  - `current_status`: Statut actuel
  - `timestamp`: Horodatage

- **`cancel_appointment_dialog_shown`** - Affichage du dialog d'annulation
  - `appointment_id`: ID du rendez-vous
  - `doctor_id`: ID du docteur
  - `doctor_name`: Nom du docteur
  - `appointment_status`: Statut du rendez-vous
  - `timestamp`: Horodatage

- **`cancel_appointment_confirmed`** - Confirmation d'annulation
  - `appointment_id`: ID du rendez-vous
  - `doctor_id`: ID du docteur
  - `doctor_name`: Nom du docteur
  - `appointment_status`: Statut du rendez-vous
  - `timestamp`: Horodatage

## 👤 Événements de Profil

### Profile Screen
- **`logout_dialog_shown`** - Affichage du dialog de déconnexion
  - `timestamp`: Horodatage

- **`logout_confirmed`** - Confirmation de déconnexion
  - `user_email`: Email de l'utilisateur
  - `timestamp`: Horodatage

- **`logout_completed`** - Déconnexion terminée
  - `timestamp`: Horodatage

## 🧭 Événements de Navigation

### Bottom Navigation Bar
- **`bottom_nav_tab_selected`** - Sélection d'un onglet
  - `tab_name`: Nom de l'onglet (doctors/appointments/messaging/profile)
  - `tab_index`: Index de l'onglet
  - `previous_tab`: Onglet précédent
  - `timestamp`: Horodatage

## 🔍 Comment Utiliser ces Données

### Tableaux de Bord Recommandés

1. **Funnel d'Authentification**
   - login_attempt → login_success/login_failed
   - registration_attempt → registration_success/registration_failed

2. **Funnel de Réservation**
   - view_available_doctors → select_doctor_for_booking → view_doctor_schedule → select_schedule_group → select_time_slot → confirm_appointment_booking → appointment_booked_successfully

3. **Engagement Utilisateur**
   - Navigation entre onglets
   - Actions sur les rendez-vous (annulation, reprogrammation)
   - Utilisation des fonctionnalités

4. **Performance et Erreurs**
   - Taux d'échec des connexions
   - Erreurs de réservation
   - Problèmes d'annulation

### Métriques Clés à Surveiller

- **Taux de Conversion** : login_attempt → login_success
- **Abandon de Réservation** : select_doctor_for_booking → appointment_booked_successfully
- **Engagement** : Nombre de sessions par utilisateur
- **Rétention** : Utilisateurs qui reviennent pour voir leurs rendez-vous
- **Problèmes Techniques** : Ratio d'événements d'erreur

## 🎯 Événements Personnalisés Supplémentaires Suggérés

Pour une analyse plus approfondie, considérez ajouter :

1. **Durée de Session** : Temps passé sur chaque écran
2. **Recherche de Docteurs** : Filtres utilisés, préférences
3. **Notifications** : Taux d'ouverture, actions prises
4. **Performance** : Temps de chargement des écrans
5. **Géolocalisation** : Préférences de localisation pour les docteurs

## 🛡️ Considérations de Confidentialité et Sécurité

### ⚠️ Données Sensibles à Éviter
- **Emails complets** : Utiliser des hash ou supprimer
- **Noms complets** : Remplacer par des catégories ou ID anonymes
- **Données médicales** : Ne jamais tracker d'informations de santé
- **Informations personnelles** : Éviter PII (Personally Identifiable Information)

### ✅ Bonnes Pratiques Recommandées
1. **Hash les emails** : `user_email_hash` au lieu de `user_email`
2. **IDs techniques uniquement** : `doctor_id`, `appointment_id` sont OK
3. **Anonymisation** : Utiliser des catégories plutôt que des noms
4. **Consentement** : Informer les utilisateurs du tracking
5. **Rétention de données** : Configurer la suppression automatique

### 🔧 Modifications Suggérées
```dart
// ❌ À éviter
FirebaseAnalytics.instance.logEvent(
  name: 'login_success',
  parameters: {
    'user_email': 'john.doe@email.com', // PII sensible
    'doctor_full_name': 'Dr. Jean Dupont', // Information personnelle
  },
);

// ✅ Meilleure approche
FirebaseAnalytics.instance.logEvent(
  name: 'login_success',
  parameters: {
    'user_id_hash': hashEmail(userEmail), // Email hashé
    'user_role': 'USER', // Catégorie anonyme
    'doctor_category': 'cardiologist', // Catégorie au lieu du nom
  },
);
```

### 📋 RGPD/CCPA Compliance
- **Consentement explicite** pour le tracking
- **Droit à l'oubli** : Possibilité de supprimer les données
- **Transparence** : Informer sur les données collectées
- **Minimisation** : Ne collecter que les données nécessaires

## 📱 Intégration avec Firebase Console

Tous ces événements sont automatiquement disponibles dans :
- **Firebase Analytics Dashboard**
- **Google Analytics 4**
- **BigQuery** (pour les projets Blaze)
- **Data Studio** pour la visualisation avancée

Les événements incluent des horodatages ISO 8601 pour une analyse temporelle précise et des paramètres détaillés pour un segmentation fine des utilisateurs.
