// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'My Cosplay Manager';

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

  @override
  String get navProjects => 'Progetti';

  @override
  String get projectsEmpty =>
      'Nessun progetto ancora. Tocca + per crearne uno.';

  @override
  String get addProject => 'Nuovo progetto';

  @override
  String get editProject => 'Modifica progetto';

  @override
  String get projectName => 'Nome progetto';

  @override
  String get projectDescription => 'Descrizione';

  @override
  String get laborHours => 'Ore di lavoro';

  @override
  String get laborRatePerHour => 'Tariffa oraria (€/h)';

  @override
  String get materials => 'Materiali';

  @override
  String get addMaterial => 'Aggiungi materiale';

  @override
  String get materialsCost => 'Costo materiali';

  @override
  String get laborCost => 'Costo manodopera';

  @override
  String get totalCost => 'Costo totale';

  @override
  String get selectFromInventory => 'Scegli dall\'inventario';

  @override
  String get noInventoryItems =>
      'Nessun prodotto in inventario da usare come materiale.';

  @override
  String get deleteProject => 'Eliminare il progetto?';

  @override
  String get confirmDeleteProjectMessage =>
      'Verranno eliminati anche i materiali collegati. L\'operazione non e\' reversibile.';

  @override
  String get deleteMaterial => 'Rimuovere il materiale?';

  @override
  String get estimatedFromCategory => 'Stimato dalla categoria';

  @override
  String get fromInventoryTab => 'Dall\'inventario';

  @override
  String get searchProductTab => 'Cerca prodotto';

  @override
  String get searchProductHint => 'Cerca per nome o marca';

  @override
  String get noSearchResults => 'Nessun prodotto trovato';

  @override
  String get priceRangeInCategory => 'Prezzo tipico in questa categoria';

  @override
  String get fieldNote => 'Nota';

  @override
  String get productOptional => 'Prodotto (opzionale)';

  @override
  String get noProductChosen => 'Nessuno - stima dal range di categoria';

  @override
  String get noProductOption => 'Nessun prodotto specifico';

  @override
  String get chooseCategoryFirst => 'Scegli prima una categoria';

  @override
  String get notesSection => 'Note';

  @override
  String get addNote => 'Aggiungi nota';

  @override
  String get editNote => 'Modifica nota';

  @override
  String get noteTextField => 'Cosa devi fare';

  @override
  String get dueDateField => 'Data notifica';

  @override
  String get notifyDaysBeforeField => 'Preavviso notifica (giorni prima)';

  @override
  String get noNotes => 'Nessuna nota ancora per questo progetto.';

  @override
  String get deleteNoteConfirm => 'Eliminare questa nota?';

  @override
  String get notifyTimeField => 'Ora notifica';

  @override
  String get notifyExplainer =>
      'Riceverai una notifica push a questa data e ora.';

  @override
  String get taskDateField => 'Data compito';

  @override
  String get taskTimeField => 'Ora compito';

  @override
  String get taskSectionLabel => 'Quando va fatto';

  @override
  String get notifySectionLabel => 'Promemoria';
}
