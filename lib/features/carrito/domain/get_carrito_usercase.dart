import '../data/carrito_repository.dart';
import '../presentation/carrito_item_ui.dart';

class GetCarritoUseCase {
  final CarritoRepository repository;

  GetCarritoUseCase(this.repository);

  Future<List<CarritoItemUI>> execute() async {
    return await repository.getCarrito(); // <- método actualizado del repo
  }
}
