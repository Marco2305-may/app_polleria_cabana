import '../data/carrito_repository.dart';

class ConfirmarPedidoUseCase {
  final CarritoRepository repository;

  ConfirmarPedidoUseCase(this.repository);

  // Solo idUsuario, ningún otro parámetro
  Future<int> execute(int idUsuario) async {
    return await repository.confirmarPedido(idUsuario);
  }
}

