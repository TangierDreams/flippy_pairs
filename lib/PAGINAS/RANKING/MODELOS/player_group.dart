//------------------------------------------------------------------------------
// Clase que representa a un grupo de jugadores en la estadistica
//------------------------------------------------------------------------------
class PlayerGroup {
  final int posicion;
  final String title;
  final List<Map<String, dynamic>> players;
  final String giphy;

  PlayerGroup({required this.posicion, required this.title, required this.players, required this.giphy});
}
