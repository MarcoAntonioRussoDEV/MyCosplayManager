// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cosplay Inventory';

  @override
  String get loginSubtitle =>
      'Gestiona el inventario de tus materiales de cosplay';

  @override
  String get loginWithGoogle => 'Iniciar sesion con Google';

  @override
  String get navInventory => 'Inventario';

  @override
  String get navShoppingList => 'Lista de compras';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get inventoryEmpty =>
      'Aun no hay productos. Toca + para escanear o anadir uno.';

  @override
  String get addItem => 'Anadir producto';

  @override
  String get scanBarcode => 'Escanear codigo de barras';

  @override
  String get enterBarcodeManually => 'Introducir codigo manualmente';

  @override
  String get productFound => 'Producto encontrado';

  @override
  String get productNotFound =>
      'No se encontro ningun producto para este codigo';

  @override
  String get createNewProduct => 'Crear nuevo producto';

  @override
  String get fieldBarcode => 'Codigo de barras';

  @override
  String get fieldName => 'Nombre';

  @override
  String get fieldBrand => 'Marca';

  @override
  String get fieldCategory => 'Categoria';

  @override
  String get fieldDaysAfterOpening => 'Dias tras la apertura';

  @override
  String get fieldQuantity => 'Cantidad';

  @override
  String get fieldUnit => 'Unidad';

  @override
  String get fieldPrice => 'Precio';

  @override
  String get fieldLocation => 'Ubicacion en el taller';

  @override
  String get fieldExpiryDate => 'Fecha de caducidad';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get statusSealed => 'Cerrado';

  @override
  String get statusOpened => 'Abierto';

  @override
  String get statusConsumed => 'Consumido';

  @override
  String get statusDiscarded => 'Descartado';

  @override
  String get markOpened => 'Marcar como abierto';

  @override
  String get markConsumed => 'Marcar como consumido';

  @override
  String get markDiscarded => 'Marcar como descartado';

  @override
  String get remainingQuantity => 'Cantidad restante';

  @override
  String get shoppingListEmpty => 'La lista de compras esta vacia.';

  @override
  String get addToShoppingList => 'Anadir a la lista de compras';

  @override
  String get itemName => 'Nombre del producto';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get notificationDaysBefore =>
      'Avisame con estos dias de antelacion a la caducidad';

  @override
  String get language => 'Idioma';

  @override
  String get teamInviteCode => 'Codigo de invitacion del taller';

  @override
  String get logout => 'Cerrar sesion';

  @override
  String get errorGeneric => 'Algo salio mal. Intentalo de nuevo.';

  @override
  String get confirmDeleteTitle => 'Eliminar producto?';

  @override
  String get confirmDeleteMessage => 'Esta accion no se puede deshacer.';
}
