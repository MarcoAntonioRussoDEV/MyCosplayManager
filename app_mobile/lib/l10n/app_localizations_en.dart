// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Cosplay Manager';

  @override
  String get loginSubtitle => 'Manage your cosplay materials inventory';

  @override
  String get loginWithGoogle => 'Sign in with Google';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navShoppingList => 'Shopping list';

  @override
  String get navSettings => 'Settings';

  @override
  String get inventoryEmpty => 'No items yet. Tap + to scan or add one.';

  @override
  String get addItem => 'Add item';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String get enterBarcodeManually => 'Enter barcode manually';

  @override
  String get productFound => 'Product found';

  @override
  String get productNotFound => 'No product found for this barcode';

  @override
  String get createNewProduct => 'Create new product';

  @override
  String get fieldBarcode => 'Barcode';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldBrand => 'Brand';

  @override
  String get fieldCategory => 'Category';

  @override
  String get fieldDaysAfterOpening => 'Days after opening';

  @override
  String get fieldQuantity => 'Quantity';

  @override
  String get fieldUnit => 'Unit';

  @override
  String get fieldPrice => 'Price';

  @override
  String get fieldLocation => 'Location in the lab';

  @override
  String get fieldExpiryDate => 'Expiry date';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get statusSealed => 'Sealed';

  @override
  String get statusOpened => 'Opened';

  @override
  String get statusConsumed => 'Consumed';

  @override
  String get statusDiscarded => 'Discarded';

  @override
  String get markOpened => 'Mark as opened';

  @override
  String get markConsumed => 'Mark as consumed';

  @override
  String get markDiscarded => 'Mark as discarded';

  @override
  String get remainingQuantity => 'Remaining quantity';

  @override
  String get shoppingListEmpty => 'Shopping list is empty.';

  @override
  String get addToShoppingList => 'Add to shopping list';

  @override
  String get itemName => 'Item name';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get notificationDaysBefore => 'Notify me this many days before expiry';

  @override
  String get language => 'Language';

  @override
  String get teamInviteCode => 'Team invite code';

  @override
  String get logout => 'Log out';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get confirmDeleteTitle => 'Delete item?';

  @override
  String get confirmDeleteMessage => 'This cannot be undone.';

  @override
  String get navProjects => 'Projects';

  @override
  String get projectsEmpty => 'No projects yet. Tap + to create one.';

  @override
  String get addProject => 'New project';

  @override
  String get editProject => 'Edit project';

  @override
  String get projectName => 'Project name';

  @override
  String get projectDescription => 'Description';

  @override
  String get laborHours => 'Labor hours';

  @override
  String get laborRatePerHour => 'Hourly rate (€/h)';

  @override
  String get materials => 'Materials';

  @override
  String get addMaterial => 'Add material';

  @override
  String get materialsCost => 'Materials cost';

  @override
  String get laborCost => 'Labor cost';

  @override
  String get totalCost => 'Total cost';

  @override
  String get selectFromInventory => 'Pick from inventory';

  @override
  String get noInventoryItems => 'No inventory items to use as a material.';

  @override
  String get deleteProject => 'Delete project?';

  @override
  String get confirmDeleteProjectMessage =>
      'Its materials will be deleted too. This cannot be undone.';

  @override
  String get deleteMaterial => 'Remove material?';

  @override
  String get estimatedFromCategory => 'Estimated from category';

  @override
  String get fromInventoryTab => 'From inventory';

  @override
  String get searchProductTab => 'Search product';

  @override
  String get searchProductHint => 'Search by name or brand';

  @override
  String get noSearchResults => 'No product found';

  @override
  String get priceRangeInCategory => 'Typical price in this category';

  @override
  String get fieldNote => 'Note';

  @override
  String get productOptional => 'Product (optional)';

  @override
  String get noProductChosen => 'None - estimated from category range';

  @override
  String get noProductOption => 'No specific product';

  @override
  String get chooseCategoryFirst => 'Choose a category first';

  @override
  String get notesSection => 'Notes';

  @override
  String get addNote => 'Add note';

  @override
  String get editNote => 'Edit note';

  @override
  String get noteTextField => 'What to do';

  @override
  String get dueDateField => 'Notification date';

  @override
  String get notifyDaysBeforeField => 'Notify (days before)';

  @override
  String get noNotes => 'No notes yet for this project.';

  @override
  String get deleteNoteConfirm => 'Delete this note?';

  @override
  String get notifyTimeField => 'Notification time';

  @override
  String get notifyExplainer =>
      'You will get a push notification at this date and time.';

  @override
  String get taskDateField => 'Task date';

  @override
  String get taskTimeField => 'Task time';

  @override
  String get taskSectionLabel => 'When it needs doing';

  @override
  String get notifySectionLabel => 'Reminder';
}
