import 'package:flutter/material.dart';
import 'package:interfaces/busca.dart';
import 'package:interfaces/perfil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Estado para controlar a aba selecionada

  // Função para definir o estado e atualizar a tela
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Método para definir qual tela mostrar
  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 1:
        return const BuscaScreen(); // Tela de busca
      case 2:
        return const PerfilScreen(); // Tela de perfil
      default:
        return _buildHomeContent(); // Conteúdo da tela inicial
    }
  }

  // Conteúdo da tela inicial (Home)
  Widget _buildHomeContent() {
    return Column(
      children: [
        // Seção de categorias
        Container(
          height: 100,
          color: Colors.orange[100],
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              categoryCard('Promoções', Icons.local_offer),
              categoryCard('Salgados', Icons.fastfood),
              categoryCard('Bebidas', Icons.local_drink),
            ],
          ),
        ),
        // Lista de restaurantes
        Expanded(
          child: ListView(
            children: [
              restaurantCard('Restaurante 1', 'Desconto de 20%', '4.5'),
              restaurantCard('Restaurante 2', 'Entrega grátis', '4.2'),
              restaurantCard('Restaurante 3', 'Novo', '4.8'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(244, 140, 44, 1),
        title: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Logo');
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Ação do carrinho de compras
            },
          ),
        ],
      ),
      body: _getSelectedScreen(), // Mostra a tela selecionada
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget categoryCard(String title, IconData icon) {
    return Container(
      width: 100,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget restaurantCard(String name, String description, String rating) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.restaurant, color: Colors.orange),
        title: Text(name),
        subtitle: Text(description),
        trailing: Text(rating),
      ),
    );
  }
}
