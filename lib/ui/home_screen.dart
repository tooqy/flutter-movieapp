import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:movie_app/utility/check_conectivity.dart';
import 'package:movie_app/widgets/genres.dart';
import 'package:movie_app/widgets/now_playing.dart';
import 'package:movie_app/widgets/persons.dart';
import 'package:movie_app/widgets/top_movies.dart';
import '../style/theme.dart' as Style;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map _source = {ConnectivityResult.none: false};
  CheckConnectivity _connectivity = CheckConnectivity.instance;

  String _connectionStatus;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  void checkInternetConnection() {
    String connectionStatus;
    bool isOffLine;

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      // switch (source.keys.toList()[0]) {
      //   case ConnectivityResult.none:
      //     connectionStatus = "Ooops, Internet offline";
      //     isOffLine = true;
      //     break;
      //   case ConnectivityResult.mobile:
      //     connectionStatus = "Mobile: Online";
      //     isOffLine = false;
      //     break;
      //   case ConnectivityResult.wifi:
      //     isOffLine = false;
      //     connectionStatus = "WiFi: Online";
      //     break;
      // }
      setState(() {
        _connectionStatus = _connectivity.getConnectionType();
        _isOffline = _connectivity.getStatusOnline(); //isOffLine;

        print("IS OFFLINE : "+_isOffline.toString());
      });
    });
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        leading: Icon(
          EvaIcons.menu2Outline,
          color: Colors.white,
        ),
        title: Text("Movie App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              EvaIcons.searchOutline,
              color: Colors.white,
            ),
            onPressed: null,
          )
        ],
      ),
      // body: ListView(
      //   children: <Widget>[
      //     NowPlaying(),
      //     GenresScreen(),
      //     PersonList(),
      //     TopMovies(),
      //   ],
      // ),

      body: (_isOffline)
          ? Center(
              child: GestureDetector(
                onTap: () {
                  checkInternetConnection();
                },
                child: Text(
                  _connectionStatus.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                  ),
                ),
              ),
            )
          : ListView(
              children: <Widget>[
                NowPlaying(),
                GenresScreen(),
                PersonList(),
                TopMovies(),
              ],
            ),

      // body: Builder(
      //   builder: (BuildContext context) {
      //     return OfflineBuilder(
      //       connectivityBuilder: (
      //         BuildContext context,
      //         ConnectivityResult connectivity,
      //         Widget child,
      //       ) {
      //         print("isOFF : " + _isOffline.toString());
      //         if (connectivity == ConnectivityResult.none) {
      //           return Container(
      //             color: Colors.white,
      //             child: Center(
      //               child: GestureDetector(
      //                 onTap: () {},
      //                 child: Text(
      //                   "Oops, \n\nNow we are Offline!",
      //                   style: TextStyle(color: Colors.black),
      //                 ),
      //               ),
      //             ),
      //           );
      //         } else {
      //           // checkInet(connectivity);
      //           if (_isOffline) {
      //             return Container(
      //               color: Colors.white,
      //               child: Center(
      //                 child: GestureDetector(
      //                   onTap: () {},
      //                   child: Text(
      //                     "No Internet!",
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //             );
      //           } else {
      //             return child;
      //           }
      //         }
      //       },
      //       child: Center(
      //         child: Text(
      //           "ONLINE Or OFFLINE",
      //           style: TextStyle(color: Colors.white),
      //         ),
      //       ),
      //     );
      //   },
      // )

      //         // return Stack(
      //         //   fit: StackFit.expand,
      //         //   children: [
      //         //     child,
      //         //     Positioned(
      //         //       left: 0.0,
      //         //       right: 0.0,
      //         //       height: 32.0,
      //         //       child: AnimatedContainer(
      //         //         duration: const Duration(milliseconds: 300),
      //         //         color: connected
      //         //             ? null /* Color(0xFF00EE44) */ : Color(0xFFEE4400),
      //         //         child: connected
      //         //             ? null
      //         //             // ? Row(
      //         //             //     mainAxisAlignment: MainAxisAlignment.center,
      //         //             //     children: <Widget>[
      //         //             //       Text(
      //         //             //         "ONLINE",
      //         //             //         style: TextStyle(color: Colors.white),
      //         //             //       ),
      //         //             //     ],
      //         //             //   )
      //         //             : Row(
      //         //                 mainAxisAlignment: MainAxisAlignment.center,
      //         //                 children: <Widget>[
      //         //                   Text(
      //         //                     "OFFLINE",
      //         //                     style: TextStyle(color: Colors.white),
      //         //                   ),
      //         //                   SizedBox(
      //         //                     width: 8.0,
      //         //                   ),
      //         //                   SizedBox(
      //         //                     width: 12.0,
      //         //                     height: 12.0,
      //         //                     child: CircularProgressIndicator(
      //         //                       strokeWidth: 2.0,
      //         //                       valueColor: AlwaysStoppedAnimation<Color>(
      //         //                           Colors.white),
      //         //                     ),
      //         //                   ),
      //         //                 ],
      //         //               ),
      //         //       ),
      //         //     ),
      //         //   ],
      //         // );
      //       },
      // child: Center(
      //   child: Text("ONLINE Or OFFLINE"),
      // ),
      //       child: ListView(
      //         children: <Widget>[
      //           NowPlaying(),
      //           GenresScreen(),
      //           PersonList(),
      //           TopMovies(),
      //         ],
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
