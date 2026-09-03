// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Cosplay Inventory';

  @override
  String get loginSubtitle =>
      'Gestisci l\'inventario dei tuoi materiali cosplay';

  @override
  String get loginWithGoogle => 'Accedi con Google';

  @override
  String get navInventory => 'Inventario';

  @override
  String get navShoppingList => 'Lista spesa';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get inventoryEmpty =>
      'Nessun prodotto ancora. Tocca + per scansionare o aggiungerne uno.';

  @override
  String get addItem => 'Aggiungi prodotto';

  @override
  String get scanBarcode => 'Scansiona barcode';

  @override
  String get enterBarcodeManually => 'Inserisci barcode manualmente';

  @override
  String get productFound => 'Prodotto trovato';

  @override
  String get productNotFound => 'Nessun prodotto trovato per questo barcode';

  @override
  String get createNewProduct => 'Crea nuovo prodotto';

  @override
  String get fieldBarcode => 'Barcode';

  @override
  String get fieldName => 'Nome';

  @override
  String get fieldBrand => 'Marca';

  @override
  String get fieldCategory => 'Categoria';

  @override
  String get fieldDaysAfterOpening => 'Giorni dopo l\'apertura';

  @override
  String get fieldQuantity => 'Quantita\'';

  @override
  String get fieldUnit => 'Unita\'';

  @override
  String get fieldPrice => 'Prezzo';

  @override
  String get fieldLocation => 'Posizione in laboratorio';

  @override
  String get fieldExpiryDate => 'Data di scadenza';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get edit => 'Modifica';

  @override
  String get statusSealed => 'Chiuso';

  @override
  String get statusOpened => 'Aperto';

  @override
  String get statusConsumed => 'Consumato';

  @override
  String get statusDiscarded => 'Scartato';

  @override
  String get markOpened => 'Segna come aperto';

  @override
  String get markConsumed => 'Segna come consumato';

  @override
  String get markDiscarded => 'Segna come scartato';

  @override
  String get remainingQuantity => 'Quantita\' residua';

  @override
  String get shoppingListEmpty => 'La lista della spesa e\' vuota.';

  @override
  String get addToShoppingList => 'Aggiungi alla lista spesa';

  @override
  String get itemName => 'Nome prodotto';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get notificationDaysBefore =>
      'Avvisami con questi giorni di anticipo sulla scadenza';

  @override
  String get language => 'Lingua';

  @override
  String get teamInviteCode => 'Codice invito laboratorio';

  @override
  String get logout => 'Esci';

  @override
  String get errorGeneric => 'Qualcosa e\' andato storto. Riprova.';

  @override
  String get confirmDeleteTitle => 'Eliminare il prodotto?';

  @override
  String get confirmDeleteMessage => 'L\'operazione non e\' reversibile.';
}
