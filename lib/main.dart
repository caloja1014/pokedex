import 'package:flutter/material.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/services/poke_api.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Pokemon> pokemons = [];
  final PokeApi _pokeApi = PokeApi.instance;
  late Future<List<Pokemon>> _pokemons;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  double width = 0;
  double height = 0;
  @override
  void initState() {
    super.initState();
    _pokemons = _pokeApi.getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    print(_pokemons);
    _pokemons.then((pokemons) {
      print(pokemons);
    });
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, height * 0.08, 0, 0),
        child: Column(
          children: <Widget>[
            Center(
              child: Stack(
                children: [
                  Text(
                    'Pokedex',
                    style: TextStyle(
                      fontFamily: 'Pokefont',
                      fontSize: 50,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.blue[700]!,
                    ),
                  ),
                  Text(
                    'Pokedex',
                    style: TextStyle(
                      fontFamily: 'Pokefont',
                      fontSize: 50,
                      color: Colors.yellow[700]!,
                    ),
                  ),
                ],
              ),
            ),
            _buildCarousel()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Pokedex',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Favoritos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCarousel() {
    return Container(
      height: 0.6 * height,
      child: FutureBuilder<List<Pokemon>>(
        future: _pokemons,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? _buildLoading()
              : CarouselSlider.builder(
                  itemCount: 20,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    var data = snapshot.data![itemIndex];
                    return _buildCard(data);
                  },
                  options: CarouselOptions(
                    reverse: false,
                    height: 0.6 * height,
                    autoPlay: false,
                    enlargeCenterPage: true,
                  ),
                );
          
        },
      ),
    );
  }

  Widget _buildCard(Pokemon e) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
              height: 0.4 * height,
              width: 0.8 * width,
              child: Container(
                color: Colors.grey[100],
                child: Image.network(
                  e.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "N. " + getStringId(e.id),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Opensans',
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    capitalize(e.name),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Opensans',
                      color: Colors.grey[700],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: e.types
                          .map((val) => Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  5,
                                  10,
                                  5,
                                ),
                                margin: const EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  15,
                                  0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[500],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  capitalize(val),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Opensans',
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    margin: EdgeInsets.fromLTRB(
                      0,
                      height * 0.01,
                      0,
                      0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  getStringId(int id) {
    const strId = '000';
    return strId.substring(0, 3 - id.toString().length) + id.toString();
  }
}
