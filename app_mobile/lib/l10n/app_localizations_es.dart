// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'My Cosplay Manager';

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
  String get addedToShoppingList => 'Anadido a la lista de compras';

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

  @override
  String get navProjects => 'Proyectos';

  @override
  String get projectsEmpty => 'Aun no hay proyectos. Toca + para crear uno.';

  @override
  String get addProject => 'Nuevo proyecto';

  @override
  String get editProject => 'Editar proyecto';

  @override
  String get projectName => 'Nombre del proyecto';

  @override
  String get projectDescription => 'Descripcion';

  @override
  String get laborHours => 'Horas de trabajo';

  @override
  String get laborRatePerHour => 'Tarifa por hora (€/h)';

  @override
  String get materials => 'Materiales';

  @override
  String get addMaterial => 'Anadir material';

  @override
  String get materialsCost => 'Costo de materiales';

  @override
  String get laborCost => 'Costo de mano de obra';

  @override
  String get totalCost => 'Costo total';

  @override
  String get selectFromInventory => 'Elegir del inventario';

  @override
  String get noInventoryItems =>
      'No hay productos en el inventario para usar como material.';

  @override
  String get deleteProject => 'Eliminar el proyecto?';

  @override
  String get confirmDeleteProjectMessage =>
      'Tambien se eliminaran sus materiales. Esta accion no se puede deshacer.';

  @override
  String get deleteMaterial => 'Quitar el material?';

  @override
  String get estimatedFromCategory => 'Estimado por categoria';

  @override
  String get fromInventoryTab => 'Del inventario';

  @override
  String get searchProductTab => 'Buscar producto';

  @override
  String get searchProductHint => 'Buscar por nombre o marca';

  @override
  String get noSearchResults => 'Ningun producto encontrado';

  @override
  String get priceRangeInCategory => 'Precio tipico en esta categoria';

  @override
  String get fieldNote => 'Nota';

  @override
  String get productOptional => 'Producto (opcional)';

  @override
  String get noProductChosen => 'Ninguno - estimado por rango de categoria';

  @override
  String get noProductOption => 'Ningun producto especifico';

  @override
  String get chooseCategoryFirst => 'Elige primero una categoria';

  @override
  String get notesSection => 'Notas';

  @override
  String get addNote => 'Anadir nota';

  @override
  String get editNote => 'Editar nota';

  @override
  String get noteTextField => 'Que hay que hacer';

  @override
  String get dueDateField => 'Fecha de notificacion';

  @override
  String get notifyDaysBeforeField => 'Aviso (dias antes)';

  @override
  String get noNotes => 'Aun no hay notas para este proyecto.';

  @override
  String get deleteNoteConfirm => 'Eliminar esta nota?';

  @override
  String get notifyTimeField => 'Hora de notificacion';

  @override
  String get notifyExplainer =>
      'Recibiras una notificacion push en esta fecha y hora.';

  @override
  String get taskDateField => 'Fecha de la tarea';

  @override
  String get taskTimeField => 'Hora de la tarea';

  @override
  String get taskSectionLabel => 'Cuando hay que hacerlo';

  @override
  String get notifySectionLabel => 'Recordatorio';
}
