import '../data/carrito_repository.dart';
import '../data/carrito_model.dart';

class AddToCarritoUseCase {
  final CarritoRepository repository;

  AddToCarritoUseCase(this.repository);

  Future<void> execute({
    required int idComida,
    required int cantidad,
    required double precioUnitario,
  }) async {
    final subtotal = cantidad * precioUnitario;

    final item = CarritoItem(

      idPedido: 0,  // o el id del pedido actual si ya lo tienes
      idComida: idComida,
      cantidad: cantidad,
      subtotal: subtotal,

    );

    await repository.addItem(item);
  }
}
