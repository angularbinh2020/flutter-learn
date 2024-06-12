import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "Fhnib",
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var randomText = appState.current;
    Widget page;
    switch (currentPageIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritePage();
        break;
      default:
        throw UnimplementedError('No widget for $currentPageIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
            extended: false,
            destinations: [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text("Home")),
              NavigationRailDestination(
                  icon: Icon(Icons.favorite), label: Text("Favorites"))
            ],
            selectedIndex: currentPageIndex,
            onDestinationSelected: (selectedIndex) => setState(() {
              currentPageIndex = selectedIndex;
            }),
          )),
          Expanded(
              child: Container(
            child: page,
            color: Theme.of(context).colorScheme.primaryContainer,
          )),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var randomText = appState.current;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('A random idea:'),
          ),
          SizedBox(
            height: 10,
          ),
          RandomText(randomText: randomText),
          ActionMenu(appState: appState)
        ],
      ),
    );
  }
}

class ActionMenu extends StatelessWidget {
  const ActionMenu({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    IconData likeIcon;
    likeIcon = appState.favorites.contains(appState.current)
        ? Icons.favorite
        : Icons.favorite_border;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: appState.toggleFavorite,
          label: Text("Like"),
          icon: Icon(likeIcon),
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next')),
      ],
    );
  }
}

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('placeholder');
  }
}

class RandomText extends StatelessWidget {
  const RandomText({
    super.key,
    required this.randomText,
  });

  final WordPair randomText;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text("${randomText.first} ${randomText.second}", style: style),
      ),
    );
  }
}
