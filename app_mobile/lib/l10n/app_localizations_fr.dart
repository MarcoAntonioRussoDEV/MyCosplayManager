// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Cosplay Inventory';

  @override
  String get loginSubtitle => 'Gerez l\'inventaire de vos materiaux cosplay';

  @override
  String get loginWithGoogle => 'Se connecter avec Google';

  @override
  String get navInventory => 'Inventaire';

  @override
  String get navShoppingList => 'Liste de courses';

  @override
  String get navSettings => 'Parametres';

  @override
  String get inventoryEmpty =>
      'Aucun produit pour l\'instant. Touchez + pour scanner ou en ajouter un.';

  @override
  String get addItem => 'Ajouter un produit';

  @override
  String get scanBarcode => 'Scanner le code-barres';

  @override
  String get enterBarcodeManually => 'Saisir le code-barres manuellement';

  @override
  String get productFound => 'Produit trouve';

  @override
  String get productNotFound => 'Aucun produit trouve pour ce code-barres';

  @override
  String get createNewProduct => 'Creer un nouveau produit';

  @override
  String get fieldBarcode => 'Code-barres';

  @override
  String get fieldName => 'Nom';

  @override
  String get fieldBrand => 'Marque';

  @override
  String get fieldCategory => 'Categorie';

  @override
  String get fieldDaysAfterOpening => 'Jours apres ouverture';

  @override
  String get fieldQuantity => 'Quantite';

  @override
  String get fieldUnit => 'Unite';

  @override
  String get fieldPrice => 'Prix';

  @override
  String get fieldLocation => 'Emplacement dans l\'atelier';

  @override
  String get fieldExpiryDate => 'Date de peremption';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get statusSealed => 'Ferme';

  @override
  String get statusOpened => 'Ouvert';

  @override
  String get statusConsumed => 'Consomme';

  @override
  String get statusDiscarded => 'Jete';

  @override
  String get markOpened => 'Marquer comme ouvert';

  @override
  String get markConsumed => 'Marquer comme consomme';

  @override
  String get markDiscarded => 'Marquer comme jete';

  @override
  String get remainingQuantity => 'Quantite restante';

  @override
  String get shoppingListEmpty => 'La liste de courses est vide.';

  @override
  String get addToShoppingList => 'Ajouter a la liste de courses';

  @override
  String get itemName => 'Nom du produit';

  @override
  String get settingsTitle => 'Parametres';

  @override
  String get notificationDaysBefore =>
      'Me prevenir ce nombre de jours avant la peremption';

  @override
  String get language => 'Langue';

  @override
  String get teamInviteCode => 'Code d\'invitation de l\'atelier';

  @override
  String get logout => 'Se deconnecter';

  @override
  String get errorGeneric => 'Une erreur est survenue. Reessayez.';

  @override
  String get confirmDeleteTitle => 'Supprimer le produit ?';

  @override
  String get confirmDeleteMessage => 'Cette action est irreversible.';
}
