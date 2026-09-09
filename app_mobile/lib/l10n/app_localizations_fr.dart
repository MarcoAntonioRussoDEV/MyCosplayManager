// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'My Cosplay Manager';

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

  @override
  String get navProjects => 'Projets';

  @override
  String get projectsEmpty =>
      'Aucun projet pour l\'instant. Touchez + pour en creer un.';

  @override
  String get addProject => 'Nouveau projet';

  @override
  String get editProject => 'Modifier le projet';

  @override
  String get projectName => 'Nom du projet';

  @override
  String get projectDescription => 'Description';

  @override
  String get laborHours => 'Heures de travail';

  @override
  String get laborRatePerHour => 'Taux horaire (€/h)';

  @override
  String get materials => 'Materiaux';

  @override
  String get addMaterial => 'Ajouter un materiau';

  @override
  String get materialsCost => 'Cout des materiaux';

  @override
  String get laborCost => 'Cout de la main-d\'oeuvre';

  @override
  String get totalCost => 'Cout total';

  @override
  String get selectFromInventory => 'Choisir dans l\'inventaire';

  @override
  String get noInventoryItems =>
      'Aucun produit dans l\'inventaire a utiliser comme materiau.';

  @override
  String get deleteProject => 'Supprimer le projet ?';

  @override
  String get confirmDeleteProjectMessage =>
      'Ses materiaux seront aussi supprimes. Cette action est irreversible.';

  @override
  String get deleteMaterial => 'Retirer le materiau ?';

  @override
  String get estimatedFromCategory => 'Estime par categorie';

  @override
  String get fromInventoryTab => 'Depuis l\'inventaire';

  @override
  String get searchProductTab => 'Rechercher un produit';

  @override
  String get searchProductHint => 'Rechercher par nom ou marque';

  @override
  String get noSearchResults => 'Aucun produit trouve';

  @override
  String get priceRangeInCategory => 'Prix habituel dans cette categorie';

  @override
  String get fieldNote => 'Note';

  @override
  String get productOptional => 'Produit (optionnel)';

  @override
  String get noProductChosen => 'Aucun - estime par la categorie';

  @override
  String get noProductOption => 'Aucun produit specifique';

  @override
  String get chooseCategoryFirst => 'Choisissez d\'abord une categorie';

  @override
  String get notesSection => 'Notes';

  @override
  String get addNote => 'Ajouter une note';

  @override
  String get editNote => 'Modifier la note';

  @override
  String get noteTextField => 'Quoi faire';

  @override
  String get dueDateField => 'Echeance';

  @override
  String get notifyDaysBeforeField => 'Rappel (jours avant)';

  @override
  String get noNotes => 'Aucune note pour ce projet pour l\'instant.';

  @override
  String get deleteNoteConfirm => 'Supprimer cette note ?';

  @override
  String get notifyTimeField => 'Heure';
}
