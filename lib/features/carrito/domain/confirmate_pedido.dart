import '../data/carrito_repository.dart';

class ConfirmarPedidoUseCase {
  final CarritoRepository repository;

  ConfirmarPedidoUseCase(this.repository);

  Future<int> execute({
    required int idUsuario,
    required String salsas,
  }) async {
    return await repository.confirmarPedido(idUsuario, salsas);
  }
}
