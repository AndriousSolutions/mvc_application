import 'package:mvc_application_example/src/view.dart';

import 'package:mvc_application_example/src/controller.dart';

class WordPairs extends StatefulWidget {
  const WordPairs({
    Key? key,
    this.title = 'Startup Name Generator',
  }) : super(key: key);
  final String title;

  @override
  State createState() => _WordPairsState();
}

/// Should always keep your State class 'hidden' with the leading underscore
class _WordPairsState extends StateMVC<WordPairs> {
  _WordPairsState() : super(WordPairsController()) {
    con = controller as WordPairsController;
  }
  late WordPairsController con;

  @override
  void initState() {
    super.initState();
    appCon = TemplateController();
  }

  late TemplateController appCon;

  /// Depending on the platform, run an 'Android' or 'iOS' style of Widget.
  @override
  Widget build(BuildContext context) => App.useMaterial
      ? _RandomWordsAndroid(state: this)
      : _RandomWordsiOS(state: this);
}

/// The Android-style of interface
class _RandomWordsAndroid extends StatelessWidget {
  //
  const _RandomWordsAndroid({Key? key, required this.state}) : super(key: key);
  final _WordPairsState state;

  @override
  Widget build(BuildContext context) {
    final widget = state.widget;
    final con = state.con;
    final appCon = state.appCon;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            key: const Key('listSaved'),
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          ),
          appCon.popupMenu(),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, i) {
            if (i.isOdd) {
              return const Divider();
            }
            con.build(i);
            return ListTile(
              title: Text(
                con.data,
                style: const TextStyle(fontSize: 25),
              ),
              trailing: con.trailing,
              onTap: () {
                con.onTap(i);
              },
            );
          }),
    );
  }

  void _pushSaved() {
    Navigator.of(state.context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = state.con.tiles();
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

/// The iOS-style of interface
class _RandomWordsiOS extends StatelessWidget {
  //
  const _RandomWordsiOS({Key? key, required this.state}) : super(key: key);
  final _WordPairsState state;
  @override
  Widget build(BuildContext context) {
    final widget = state.widget;
    final con = state.con;
    final appCon = state.appCon;
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(widget.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  key: const Key('listSaved'),
                  onPressed: _pushSaved,
                  child: const Icon(Icons.list),
                ),
                appCon.popupMenu(),
              ],
            ),
          ),
          SliverSafeArea(
            top: false,
            minimum: const EdgeInsets.only(top: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i.isOdd) {
                    return const Divider();
                  }
                  con.build(i);
                  return CupertinoListTile(
                    title: Text(con.data),
                    trailing: con.trailing,
                    onTap: () {
                      con.onTap(i);
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(state.context).push(
      CupertinoPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<Widget> tiles = state.con.tiles();
          final Iterator<Widget> it = tiles.iterator;
          it.moveNext();
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: <Widget>[
                const CupertinoSliverNavigationBar(
                  largeTitle: Text('Saved Suggestions'),
                ),
                SliverSafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(top: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final tile = it.current;
                        it.moveNext();
                        return tile;
                      },
                      childCount: tiles.length,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
