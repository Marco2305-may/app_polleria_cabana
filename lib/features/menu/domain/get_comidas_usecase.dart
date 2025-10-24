import '../data/menu_repository.dart';
import '../data/comida_model.dart';

class GetComidasUseCase {
  final MenuRepository repository;

  GetComidasUseCase(this.repository);

  Future<List<Comida>> execute() async {
    return await repository.getComidas();
  }
}
