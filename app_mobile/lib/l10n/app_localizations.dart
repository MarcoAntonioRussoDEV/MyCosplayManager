import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cosplay Manager'**
  String get appTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your cosplay materials inventory'**
  String get loginSubtitle;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get loginWithGoogle;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// No description provided for @navShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get navShoppingList;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @inventoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items yet. Tap + to scan or add one.'**
  String get inventoryEmpty;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scanBarcode;

  /// No description provided for @enterBarcodeManually.
  ///
  /// In en, this message translates to:
  /// **'Enter barcode manually'**
  String get enterBarcodeManually;

  /// No description provided for @productFound.
  ///
  /// In en, this message translates to:
  /// **'Product found'**
  String get productFound;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'No product found for this barcode'**
  String get productNotFound;

  /// No description provided for @createNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Create new product'**
  String get createNewProduct;

  /// No description provided for @fieldBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get fieldBarcode;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get fieldBrand;

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fieldCategory;

  /// No description provided for @fieldDaysAfterOpening.
  ///
  /// In en, this message translates to:
  /// **'Days after opening'**
  String get fieldDaysAfterOpening;

  /// No description provided for @fieldQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get fieldQuantity;

  /// No description provided for @fieldUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get fieldUnit;

  /// No description provided for @fieldPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get fieldPrice;

  /// No description provided for @fieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Location in the lab'**
  String get fieldLocation;

  /// No description provided for @fieldExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get fieldExpiryDate;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @statusSealed.
  ///
  /// In en, this message translates to:
  /// **'Sealed'**
  String get statusSealed;

  /// No description provided for @statusOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get statusOpened;

  /// No description provided for @statusConsumed.
  ///
  /// In en, this message translates to:
  /// **'Consumed'**
  String get statusConsumed;

  /// No description provided for @statusDiscarded.
  ///
  /// In en, this message translates to:
  /// **'Discarded'**
  String get statusDiscarded;

  /// No description provided for @markOpened.
  ///
  /// In en, this message translates to:
  /// **'Mark as opened'**
  String get markOpened;

  /// No description provided for @markConsumed.
  ///
  /// In en, this message translates to:
  /// **'Mark as consumed'**
  String get markConsumed;

  /// No description provided for @markDiscarded.
  ///
  /// In en, this message translates to:
  /// **'Mark as discarded'**
  String get markDiscarded;

  /// No description provided for @remainingQuantity.
  ///
  /// In en, this message translates to:
  /// **'Remaining quantity'**
  String get remainingQuantity;

  /// No description provided for @shoppingListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Shopping list is empty.'**
  String get shoppingListEmpty;

  /// No description provided for @addToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Add to shopping list'**
  String get addToShoppingList;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @notificationDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'Notify me this many days before expiry'**
  String get notificationDaysBefore;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @teamInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Team invite code'**
  String get teamInviteCode;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete item?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get confirmDeleteMessage;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @projectsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No projects yet. Tap + to create one.'**
  String get projectsEmpty;

  /// No description provided for @addProject.
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get addProject;

  /// No description provided for @editProject.
  ///
  /// In en, this message translates to:
  /// **'Edit project'**
  String get editProject;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get projectName;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get projectDescription;

  /// No description provided for @laborHours.
  ///
  /// In en, this message translates to:
  /// **'Labor hours'**
  String get laborHours;

  /// No description provided for @laborRatePerHour.
  ///
  /// In en, this message translates to:
  /// **'Hourly rate (€/h)'**
  String get laborRatePerHour;

  /// No description provided for @materials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get materials;

  /// No description provided for @addMaterial.
  ///
  /// In en, this message translates to:
  /// **'Add material'**
  String get addMaterial;

  /// No description provided for @materialsCost.
  ///
  /// In en, this message translates to:
  /// **'Materials cost'**
  String get materialsCost;

  /// No description provided for @laborCost.
  ///
  /// In en, this message translates to:
  /// **'Labor cost'**
  String get laborCost;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total cost'**
  String get totalCost;

  /// No description provided for @selectFromInventory.
  ///
  /// In en, this message translates to:
  /// **'Pick from inventory'**
  String get selectFromInventory;

  /// No description provided for @noInventoryItems.
  ///
  /// In en, this message translates to:
  /// **'No inventory items to use as a material.'**
  String get noInventoryItems;

  /// No description provided for @deleteProject.
  ///
  /// In en, this message translates to:
  /// **'Delete project?'**
  String get deleteProject;

  /// No description provided for @confirmDeleteProjectMessage.
  ///
  /// In en, this message translates to:
  /// **'Its materials will be deleted too. This cannot be undone.'**
  String get confirmDeleteProjectMessage;

  /// No description provided for @deleteMaterial.
  ///
  /// In en, this message translates to:
  /// **'Remove material?'**
  String get deleteMaterial;

  /// No description provided for @estimatedFromCategory.
  ///
  /// In en, this message translates to:
  /// **'Estimated from category'**
  String get estimatedFromCategory;

  /// No description provided for @fromInventoryTab.
  ///
  /// In en, this message translates to:
  /// **'From inventory'**
  String get fromInventoryTab;

  /// No description provided for @searchProductTab.
  ///
  /// In en, this message translates to:
  /// **'Search product'**
  String get searchProductTab;

  /// No description provided for @searchProductHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or brand'**
  String get searchProductHint;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No product found'**
  String get noSearchResults;

  /// No description provided for @priceRangeInCategory.
  ///
  /// In en, this message translates to:
  /// **'Typical price in this category'**
  String get priceRangeInCategory;

  /// No description provided for @fieldNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get fieldNote;

  /// No description provided for @productOptional.
  ///
  /// In en, this message translates to:
  /// **'Product (optional)'**
  String get productOptional;

  /// No description provided for @noProductChosen.
  ///
  /// In en, this message translates to:
  /// **'None - estimated from category range'**
  String get noProductChosen;

  /// No description provided for @noProductOption.
  ///
  /// In en, this message translates to:
  /// **'No specific product'**
  String get noProductOption;

  /// No description provided for @chooseCategoryFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a category first'**
  String get chooseCategoryFirst;

  /// No description provided for @notesSection.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesSection;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// No description provided for @noteTextField.
  ///
  /// In en, this message translates to:
  /// **'What to do'**
  String get noteTextField;

  /// No description provided for @dueDateField.
  ///
  /// In en, this message translates to:
  /// **'Notification date'**
  String get dueDateField;

  /// No description provided for @notifyDaysBeforeField.
  ///
  /// In en, this message translates to:
  /// **'Notify (days before)'**
  String get notifyDaysBeforeField;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet for this project.'**
  String get noNotes;

  /// No description provided for @deleteNoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get deleteNoteConfirm;

  /// No description provided for @notifyTimeField.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get notifyTimeField;

  /// No description provided for @notifyExplainer.
  ///
  /// In en, this message translates to:
  /// **'You will get a push notification at this date and time.'**
  String get notifyExplainer;

  /// No description provided for @taskDateField.
  ///
  /// In en, this message translates to:
  /// **'Task date'**
  String get taskDateField;

  /// No description provided for @taskTimeField.
  ///
  /// In en, this message translates to:
  /// **'Task time'**
  String get taskTimeField;

  /// No description provided for @taskSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'When it needs doing'**
  String get taskSectionLabel;

  /// No description provided for @notifySectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get notifySectionLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
