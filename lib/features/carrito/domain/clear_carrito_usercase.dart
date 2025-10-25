import '../data/carrito_repository.dart';

class ClearCarritoUseCase {
  final CarritoRepository repository;

  ClearCarritoUseCase(this.repository);

  Future<void> execute() async {
    await repository.clearCarrito();
  }
}
