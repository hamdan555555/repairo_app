import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  final double latitude = 35.5308;

  final double longitude = 35.7906;

  bool isSearched = false;
  LatLng currentpos = const LatLng(0, 0);

  LocationData? currentLocation;
  final Location location = Location();
  final MapController mapController = MapController();
  bool access = false;
  late PermissionStatus _permissionGranted;

  Future<void> getLocation() async {
    bool _serviceEnabled;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    final loc = await location.getLocation();
    setState(() {
      currentLocation = loc;
    });
  }

  late double widgetsize = 0;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        widgetsize = _controller.size;
        print("Current Draggable Sheet size: $widgetsize");
      });
    });

    getLocation();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            // onPositionChanged: (MapCamera cam, bool ischanged) {
            //   setState(() {
            //     currentpos = cam.center;
            //   });
            // },
            initialCenter: currentLocation == null
                ? LatLng(latitude, longitude)
                : LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
            initialZoom: 13.0,
            minZoom: 7.0,
            maxZoom: 19.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.app',
            ),
            // MarkerLayer(
            //   markers: [
            //     Marker(
            //       point: LatLng(latitude, longitude),
            //       width: 40,
            //       height: 100,
            //       child: Column(
            //         children: [
            //           Icon(Icons.location_pin, size: 40, color: Colors.red),
            //           Text(
            //             professionalName,
            //             style: TextStyle(fontSize: 12),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 12, top: 37),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            print("here is stsssss $_permissionGranted");
                            print(currentLocation!.latitude!);
                            if (_permissionGranted ==
                                PermissionStatus.granted) {
                              print("dfdfdfd");
                              mapController.move(
                                  LatLng(currentLocation!.latitude!,
                                      currentLocation!.longitude!),
                                  15);
                            }
                          });
                        },
                        icon: Icon(
                          Icons.my_location_rounded,
                          color: Colors.deepPurpleAccent,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    flex: 6,
                    child: TextField(
                      cursorColor: Colors.deepPurple,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "ابحث عن مهني  ...",
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: !isSearched,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearched = !isSearched;
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Text(
                          "ابحث هنا ",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 17),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !isSearched,
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.person_pin_circle_outlined,
              size: 40,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        DraggableScrollableSheet(
          controller: _controller,
          initialChildSize: 0.2,
          minChildSize: 0.1,
          maxChildSize: 0.88,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    //blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(children: [
                Center(
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: widgetsize < 0.8
                          ? Lottie.asset('assets/images/lottie/swipeup.json',
                              fit: BoxFit.cover)
                          : Icon(Icons.keyboard_arrow_down_sharp)),
                ),
                Center(
                    child: Text(
                  "المهنيين في المنطقة المختارة",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
                Expanded(
                  child: ListView.builder(
                    clipBehavior: Clip.hardEdge,
                    // physics: NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    controller: scrollController,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("المهني رقم ${index + 1}"),
                      );
                    },
                  ),
                ),
              ]),
            );
          },
        ),
      ]),
    );
  }
}
