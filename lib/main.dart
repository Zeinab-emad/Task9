import 'package:flutter/material.dart';

/// Flutter code sample for [NavigationBar] with nested [Navigator] destinations.

void main() {
  runApp(const MaterialApp(home: Home(),debugShowCheckedModeBanner: false,));}
class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();}
class _HomeState extends State<Home> with TickerProviderStateMixin<Home> {
  static const List<Destination> allDestinations = <Destination>[
    Destination(0, 'Home', Icons.home, Colors.teal),
    Destination(1, 'Shopping', Icons.shopping_cart  , Colors.cyan),
    Destination(2, 'Category', Icons.search_rounded, Colors.blue),
    Destination(3, 'New', Icons.favorite, Colors.red),
    Destination(4, 'Save', Icons.bookmark, Colors.blue),
    Destination(5, 'Me', Icons.person, Colors.blue),];
  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<GlobalKey> destinationKeys;
  late final List<AnimationController> destinationFaders;
  late final List<Widget> destinationViews;
  int selectedIndex = 0;
  AnimationController buildFaderController() {
    final AnimationController controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {}); }}); // Rebuild unselected destinations offstage.
    return controller;}
  @override
  void initState() {
    super.initState();
    navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
        allDestinations.length, (int index) => GlobalKey()).toList();
    destinationFaders = List<AnimationController>.generate(
        allDestinations.length, (int index) => buildFaderController()).toList();
    destinationFaders[selectedIndex].value = 1.0;
    destinationViews = allDestinations.map((Destination destination) {
      return FadeTransition(
        opacity: destinationFaders[destination.index]
            .drive(CurveTween(curve: Curves.fastOutSlowIn)),
        child: DestinationView(
          destination: destination,
          navigatorKey: navigatorKeys[destination.index],
        ),);}).toList();}
  @override
  void dispose() {
    for (final AnimationController controller in destinationFaders) {
      controller.dispose();}
    super.dispose();}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState navigator =
        navigatorKeys[selectedIndex].currentState!;
        if (!navigator.canPop()) {
          return true;}
        navigator.pop();
        return false;},
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: allDestinations.map((Destination destination) {
              final int index = destination.index;
              final Widget view = destinationViews[index];
              if (index == selectedIndex) {
                destinationFaders[index].forward();
                return Offstage(offstage: false, child: view);
              } else {
                destinationFaders[index].reverse();
                if (destinationFaders[index].isAnimating) {
                  return IgnorePointer(child: view);}
                return Offstage(child: view);}}).toList(),),),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {selectedIndex = index;});},
          destinations: allDestinations.map((Destination destination) {
            return NavigationDestination(
              icon: Icon(destination.icon, color: destination.color),
              label: destination.title,);
          }).toList(),
        ),
      ),);}}

class Destination {
  const Destination(this.index, this.title, this.icon, this.color);
  final int index;
  final String title;
  final IconData icon;
  final MaterialColor color;
}
//
// class RootPage extends StatelessWidget {
//   const RootPage({super.key, required this.destination});
//
//   final Destination destination;
//
//   Widget _buildDialog(BuildContext context) {
//     return AlertDialog(
//       title: Text('${destination.title} AlertDialog'),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('OK'),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final TextStyle headlineSmall = Theme.of(context).textTheme.headlineSmall!;
//     final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
//       backgroundColor: destination.color,
//       visualDensity: VisualDensity.comfortable,
//       padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 150),
//       textStyle: headlineSmall,
//
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${destination.title} RootPage - /'),
//         backgroundColor: destination.color,
//       ),
//       backgroundColor: destination.color[50],
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             ElevatedButton(
//               style: buttonStyle,
//               onPressed: () {
//                 Navigator.pushNamed(context, '/list');},
//               child:Image(image: NetworkImage('https://th.bing.com/th/id/R.edc77f4c3960a894d5cef020e0028aca?rik=1Nt6Ad6tLkGlFg&riu=http%3a%2f%2f1.bp.blogspot.com%2f-89M__hdqv3A%2fUaxEarA57II%2fAAAAAAAAB0o%2fqFITLv5EALU%2fs1600%2fhijab%2bwoman%2bbeauty%2bmuslim%2bmodest%2bfashion%2bshow%2bindonesia%2bislamic%2bfashion%2bfair%2b2013%2bhijaber%2bislam%2bkerudung%2bmaxi%2bdress%2bskirt%2bstyle%2bhijabi%2b3.JPG&ehk=ZIWz6jmLCDjIWWSqDwx%2b%2fef%2b3%2bEFwZKEN9gMR3coOao%3d&risl=&pid=ImgRaw&r=0'),),),
//            SizedBox(),
//             ElevatedButton(
//               style: buttonStyle,
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   useRootNavigator: false,
//                   builder: _buildDialog,);},
//               child: Image(image: NetworkImage('https://th.bing.com/th/id/OIP.y3y_HxAZPlnESY-SNo3mlwHaHa?pid=ImgDet&rs=1'),)
//               ,
//             ),
//             const SizedBox(),
//             ElevatedButton(
//               style: buttonStyle,
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   useRootNavigator: true,
//                   builder: _buildDialog,
//                 );
//               },
//               child: const Text('Root Dialog'),
//             ),
//             const SizedBox(height: 16),
//             Builder(
//               builder: (BuildContext context) {
//                 return ElevatedButton(
//                   style: buttonStyle,
//                   onPressed: () {
//                     showBottomSheet(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return Container(
//                           padding: const EdgeInsets.all(16),
//                           width: double.infinity,
//                           child: Text(
//                             '${destination.title} BottomSheet\n'
//                                 'Tap the back button to dismiss',
//                             style: headlineSmall,
//                             softWrap: true,
//                             textAlign: TextAlign.center,
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: const Text('Local BottomSheet'),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    const int itemCount = 50;
    final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: destination.color,
      fixedSize: const Size.fromHeight(128),
      textStyle: Theme.of(context).textTheme.headlineSmall,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${destination.title} ListPage - /list'),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color[50],
      body: SizedBox.expand(
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: OutlinedButton(
                style: buttonStyle.copyWith(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.lerp(destination.color[100], Colors.white,
                        index / itemCount)!,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/text');
                },
                child: Text('Push /text [$index]'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TextPage extends StatefulWidget {
  const TextPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: 'Sample Text');
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.destination.title} TextPage - /list/text'),
        backgroundColor: widget.destination.color,
      ),
      backgroundColor: widget.destination.color[50],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: TextField(
          controller: textController,
          style: theme.primaryTextTheme.headlineMedium?.copyWith(
            color: widget.destination.color,
          ),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.destination.color,
                width: 3.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DestinationView extends StatefulWidget {
  const DestinationView({
    super.key,
    required this.destination,
    required this.navigatorKey,
  });

  final Destination destination;
  final Key navigatorKey;

  @override
  State<DestinationView> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                // return RootPage(destination: widget.destination);
              case '/list':
                return ListPage(destination: widget.destination);
              case '/text':
                return TextPage(destination: widget.destination);
            }
            assert(false);
            return const SizedBox();
          },
        );
      },
    );
  }
}
class Backdrop extends StatefulWidget {

  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({

    required this.frontLayer,
    required this.backLayer,
    required this.frontTitle,
    required this.backTitle,
    Key? key,
  }) : super(key: key);

  @override
  _BackdropState createState() => _BackdropState();
}class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  // TODO: Add AnimationController widget (104)

  // TODO: Add BuildContext and BoxConstraints parameters to _buildStack (104)
  Widget _buildStack() {
    return Stack(
      key: _backdropKey,
      children: <Widget>[
        // TODO: Wrap backLayer in an ExcludeSemantics widget (104)
        widget.backLayer,
        widget.frontLayer,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      // TODO: Replace leading menu icon with IconButton (104)
      // TODO: Remove leading property (104)
      // TODO: Create title with _BackdropTitle parameter (104)
      leading: Icon(Icons.menu),
      title: Text('SHRINE'),
      actions: <Widget>[
        // TODO: Add shortcut to login screen from trailing icons (104)
        IconButton(
          icon: Icon(
            Icons.search,
            semanticLabel: 'search',
          ),
          onPressed: () {
            // TODO: Add open login (104)
          },
        ),
        IconButton(
          icon: Icon(
            Icons.tune,
            semanticLabel: 'filter',
          ),
          onPressed: () {
            // TODO: Add open login (104)
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      // TODO: Return a LayoutBuilder widget (104)
      body: _buildStack(),
    );
  }
}