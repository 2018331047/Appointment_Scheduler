import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:appointment_scheduler/utils/service/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'appointment_description.dart';

/// Class for showing google map screen
class GoogleMapView extends StatefulWidget {
  // to see which whether the appointment is regular or instant
  final String appointmentType;
  const GoogleMapView({Key? key, required this.appointmentType})
      : super(key: key);

  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  //set of map markers
  Set<Marker> _markers = {};
  late GoogleMapController _mapController;
  // notifier to check if the location of user has acquired or not
  ValueNotifier<bool> locationNotifier = ValueNotifier<bool>(false);
  final _auth = FirebaseAuth.instance;
  // student inforamtions
  late Map<String, dynamic> studentInfo;

  /// method for getting student information from database
  Future getStudentData(String id) async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .get()
        .then((value) => studentInfo = value.data()!);
  }

  /// list of appointments need to be rendered
  List<DocumentSnapshot> appointments = [];

  /// method which is invoked on map creation
  /// this method sets all the map markers and theri functionalities
  void _onMapCreated(GoogleMapController mapController) {
    _mapController = mapController;

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('me'),
          position: LatLng(lat, long),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      );
      appointments.forEach((element) {
        _markers.add(
          Marker(
            markerId: MarkerId('${element['student name']}'),
            position: LatLng(element['lat'], element['long']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentDescription(
                      courseName: element['course title'],
                      accepted: true,
                      appointmentID: element.id,
                      name: element['student name'],
                      title: element['title'],
                      date: element['date'],
                      image: element['student image'],
                      dept: studentInfo['dept'],
                      description: element['description'],
                      lat: element['lat'],
                      long: element['long'],
                      regNo: studentInfo['reg'],
                      time: element['time'],
                      phone: studentInfo['phone'],
                    ),
                  ),
                );
              },
              title: element['student name'],
              snippet: element['title'],
            ),
          ),
        );
      });
    });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _getLocation();
    super.initState();
  }

  //latitude and longitude of the user
  late double lat;
  late double long;

  ///method for getting the location of the user
  Future _getLocation() async {
    Position position = await Locator.determinePosition();
    lat = position.latitude;
    long = position.longitude;
    locationNotifier.value = true;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.my_location_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(lat, long),
                    zoom: 14,
                  ),
                ),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: locationNotifier,
              builder: (context, value, _) {
                return (locationNotifier.value)
                    ? GoogleMap(
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat, long),
                          zoom: 12,
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 100,
                ),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('appointments')
                        .orderBy('date')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        final User user = _auth.currentUser!;
                        List<DocumentSnapshot> acceptedAppointments = snapshot
                            .data!.docs
                            .where((element) =>
                                element['status'] == "requested" &&
                                element['other id'] == user.uid &&
                                DateFormat('MM/dd/yyyy HH:mm a')
                                    .parse(
                                        "${element['date']} ${element['time']}")
                                    .isAfter(DateTime.now()))
                            .toList();

                        appointments = acceptedAppointments;
                        return ListView.builder(
                          itemCount: acceptedAppointments.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DocumentSnapshot acceptedAppointment =
                                acceptedAppointments[index];
                            getStudentData(acceptedAppointment['student id']);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  _mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(
                                            acceptedAppointment['lat'],
                                            acceptedAppointment['long']),
                                        zoom: 14,
                                      ),
                                    ),
                                  );
                                  _mapController.showMarkerInfoWindow(MarkerId(
                                      acceptedAppointment['student name']));
                                },
                                child: Container(
                                  width: 240,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(2, 2),
                                        blurRadius: 5,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[100],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        child: CircleAvatar(
                                          radius: 25,
                                          foregroundImage: NetworkImage(
                                              acceptedAppointment[
                                                  'student image']),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              acceptedAppointment[
                                                  'student name'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              acceptedAppointment['title'],
                                              softWrap: true,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
