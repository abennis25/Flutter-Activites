# Projet Flutter

Ce projet a été réalisé avec Dart et Flutter
## Utilisateurs de Test

Pour tester l'application, vous pouvez utiliser les identifiants suivants :

- **Utilisateur Normal** :
  - Nom d'utilisateur : abennis
  - Mot de passe : password
  - Nom d'utilisateur : user1
  - Mot de passe : user1
- **Administrateur** :
  - Nom d'utilisateur : admin
  - Mot de passe : admin

## Fonctionnalités Réalisées

- **Liste d'Activités** : Les utilisateurs peuvent voir une liste d'activités disponibles dans l'application.
- **Panier** : Les utilisateurs peuvent ajouter des activités à leur panier et les consulter.
- **Gestion des Utilisateurs** : Inscription et connexion des utilisateurs via Firebase.
- **Connexion avec Firebase** : Utilisation de Firebase pour l'authentification et le stockage des données utilisateur.

## Fonctionnalités Additionnelles

- **Page d'Inscription** : Les nouveaux utilisateurs peuvent s'inscrire dans l'application en fournissant leurs informations personnelles.
- **Rôles Administrateurs** : Les administrateurs peuvent ajouter ou supprimer des utilisateurs et des activités dans l'application.
- **Ajout d'Utilisateurs et d'Activités** : En plus de gérer les utilisateurs existants, les administrateurs peuvent également ajouter de nouvelles activités à la liste disponible pour les utilisateurs.

## Collections Firebase

Dans ce projet, les données sont organisées dans les collections Firebase suivantes :

- **Utilisateurs** : Contient les informations sur les utilisateurs .
- **Activités** : Stocke les détails des activités que les administrateurs peuvent ajouter et que les utilisateurs peuvent parcourir.
- **Panier** : Une collection de liaison qui relie les utilisateurs à leurs activités sélectionnées, représentant le panier de l'utilisateur.
- **Jaime** : Semblable à la collection Panier, cette collection de liaison permet aux utilisateurs d'aimer des activités(pas au point).
