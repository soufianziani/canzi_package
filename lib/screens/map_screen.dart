import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

import '../widget/custom_input.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng selectedLocation = const LatLng(33.5731104, -7.5898434);
  late loc.LocationData currentLocation;
  final loc.Location locationService = loc.Location();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController manualAddressController = TextEditingController();
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  String selectedAddress = "Fetching address...";
  bool showSearchInput = false;

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyDaamh-_ZBH4nOHTdV7CMWCmHHIwn-BAPo");
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      var location = await locationService.getLocation();
      setState(() {
        currentLocation = location;
        selectedLocation = LatLng(location.latitude!, location.longitude!);
      });
      await _fetchAddress(selectedLocation);
      mapController
          .animateCamera(CameraUpdate.newLatLngZoom(selectedLocation, 14.0));
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void onMapTap(LatLng location) async {
    setState(() {
      selectedLocation = location;
    });
    await _fetchAddress(location);
  }

  Future<void> _fetchAddress(LatLng location) async {
    try {
      String? streetName =
          await getStreetName(location.latitude, location.longitude);
      setState(() {
        selectedAddress = streetName ?? "No address found.";
      });
    } catch (e) {
      print("Error fetching address: $e");
      setState(() {
        selectedAddress = "No address found.";
      });
    }
  }

  Future<String?> getStreetName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.street;
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  void searchPlace(String input) async {
    if (input.isNotEmpty) {
      var result = await googlePlace.autocomplete.get(input, region: "ma");
      if (result != null && result.predictions != null) {
        setState(() {
          predictions = result.predictions!;
        });
      }
    } else {
      setState(() {
        predictions = [];
      });
    }
  }

  void selectPlace(String placeId) async {
    var details = await googlePlace.details.get(placeId);
    if (details != null && details.result != null) {
      final location = details.result!.geometry!.location!;
      final latLng = LatLng(location.lat!, location.lng!);
      mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14.0));
      setState(() {
        selectedLocation = latLng;
        selectedAddress =
            details.result!.formattedAddress ?? "No address found.";
        predictions = [];
        searchController.text = details.result!.formattedAddress ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Select Location",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffFF0000),
        actions: [
          IconButton(
            icon: Icon(showSearchInput ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                showSearchInput = !showSearchInput;
                searchController.clear();
                predictions = [];
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation,
              zoom: 14.0,
            ),
            onTap: onMapTap,
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId("selected"),
                position: selectedLocation,
              ),
            },
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: showSearchInput
                ? CustomInput(
                    controller: searchController,
                    hintText: "Search for a location",
                    prefixIcon: Icons.search,
                    onChanged: searchPlace,
                    onIconPressed: () {
                      searchController.clear();
                      setState(() => predictions = []);
                    },
                  )
                : CustomInput(
                    controller: manualAddressController,
                    hintText: "Enter address manually...",
                    hasButton: false,
                  ),
          ),
          if (showSearchInput && predictions.isNotEmpty)
            Positioned(
              top: 70,
              left: 10,
              right: 10,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(predictions[index].description!),
                      onTap: () {
                        selectPlace(predictions[index].placeId!);
                      },
                    );
                  },
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Point Selection",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedAddress,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String manualAddress =
                            manualAddressController.text.trim();
                        Navigator.pop(context, {
                          'latitude': selectedLocation.latitude,
                          'longitude': selectedLocation.longitude,
                          'address': manualAddress.isNotEmpty
                              ? manualAddress
                              : selectedAddress
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF0000),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
