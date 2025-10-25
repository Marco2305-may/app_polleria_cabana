import '../data/carrito_repository.dart';

class RemoveFromCarritoUseCase {
  final CarritoRepository repository;

  RemoveFromCarritoUseCase(this.repository);

  Future<void> execute(int idCarrito) async {
    await repository.removeItem(idCarrito);
  }
}