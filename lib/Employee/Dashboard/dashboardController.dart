// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/Break/breakStartModel.dart';
import 'package:crm_milan_creations/Employee/Break/breakendModel.dart';
import 'package:crm_milan_creations/Employee/Dashboard/Models/checkinModel.dart';
import 'package:crm_milan_creations/Employee/Dashboard/Models/checkoutModel.dart';
import 'package:crm_milan_creations/Employee/check%20clockin%20status/check-In-StatusController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class DashboardController extends GetxController {
  final RxBool isClockedIn = false.obs;
  final Rx<File?> image = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  var breakStartTime = false.obs;
  final RxList<Offset> points = <Offset>[].obs;
  CheckClockInController checkClockInController = Get.put(
    CheckClockInController(checkpagestatus: "login"),
  );

  RxString position = ''.obs;

  RxString fullName = ''.obs;
  var checkInData = false.obs;
  var checkOut = false.obs;
  var breakData = false.obs;
  var picture = ''.obs;
  var imageurl = ''.obs;
 

  final Rx<LatLng> currentLocation = LatLng(0, 0).obs;
  GoogleMapController? mapController;
  StreamSubscription<Position>? positionStream;

  // Current location
  var location = 'Fetching location...'.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    startLiveLocation();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }

  void startLiveLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      location.value = 'Location services are disabled';
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        location.value = 'Location permissions are denied';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      location.value = 'Location permissions are permanently denied';
      return;
    }

    // Get initial position
    Position position = await Geolocator.getCurrentPosition();
    currentLocation.value = LatLng(position.latitude, position.longitude);
    latitude.value = position.latitude;
    longitude.value = position.longitude;

    // Set up location stream
    positionStream = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
      // Update every 10 meters
    ).listen((Position position) {
      currentLocation.value = LatLng(position.latitude, position.longitude);
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(currentLocation.value),
        );
      }
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Move camera to current location when map is created
    if (currentLocation.value != LatLng(0, 0)) {
      controller.animateCamera(CameraUpdate.newLatLng(currentLocation.value));
    }
  }

  Future<void> loadPosition() async {
    print('Loading position from shared preferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    position.value = prefs.getString('designation') ?? 'Not Available';
    fullName.value = prefs.getString('fullname') ?? 'Null';
    imageurl.value = prefs.getString('picture') ?? '';
    update();
        print("Full Name: ${prefs.getString('fullname')}");
  }

  Future<void> pickImageFromCamera() async {
    print('Picking image from camera...');
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      print('Image captured: ${pickedFile.path}');
    } else {
      Get.snackbar("No Image", "Please capture an image to proceed.");
      print('No image captured');
    }
  }

  Future<void> clockInProcess(BuildContext context) async {
    print('Starting clock in process...');
    final position = await _getCurrentPosition(context);
    if (position == null) return;

    final double lat = position.latitude;
    final double long = position.longitude;

    print('Location retrieved: Latitude $lat, Longitude $long');
    await _clockInWithImageAndLocation(context, lat, long);
  }

  Future<void> _clockInWithImageAndLocation(
    BuildContext context,
    double lat,
    double long,
  ) async {
    print('Clocking in with image and location...');
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print('Token not found, user is unauthenticated');
      _handleUnauthenticated();
      return;
    }

    if (image.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please capture an image first.")),
      );
      print('No image selected for clock in');
      return;
    }

    try {
      isLoading.value = true;
      print('Preparing to send clock-in request...');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.checkIn),
      );
      request.headers['Authorization'] = 'Bearer $token';

      final imageFile = image.value!;
      final extension = imageFile.path.split('.').last.toLowerCase();
      final mimeType =
          {
            'jpg': MediaType('image', 'jpeg'),
            'jpeg': MediaType('image', 'jpeg'),
            'png': MediaType('image', 'png'),
            'gif': MediaType('image', 'gif'),
          }[extension];

      if (mimeType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Only .jpg, .png, and .gif formats are allowed."),
          ),
        );
        print('Invalid image format: $extension');
        return;
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'picture',
          imageFile.path,
          contentType: mimeType,
        ),
      );

      request.fields['latitude'] = lat.toString();
      request.fields['longitude'] = long.toString();

      final response = await http.Response.fromStream(await request.send());
      print('Clock-in request sent, awaiting response...');

      if (response.statusCode == 200) {
        var checkinModel = checkinModelFromJson(response.body);
        await prefs.setString('check_in', checkinModel.data.checkIn.toString());

        _handleApiResponse(
          response,
          onSuccess: () {
            isClockedIn.value = true;
            latitude.value = lat;
            longitude.value = long;
             checkClockInController.checkInTime.value = checkinModel.data.checkIn.toString();

            checkInData.value = false;
            checkOut.value = true;
            breakData.value = true;
            checkClockInController.checkInTime.value =
                checkinModel.data.checkIn.toString();

                checkClockInController.checkOutTime.value = checkinModel.data.checkOut.toString();
            update();
             isLoading.value = false;
           Get.snackbar(
              'Success',
              'Clocked in successfully!',
              backgroundColor: CRMColors.success,
              colorText: CRMColors.textWhite,
            );
           
           
          },
        );
      } else {
        print('Clock-in failed with status code: ${response.statusCode}');
        _handleApiResponse(response, onSuccess: () {});
      }
    } catch (e) {
      print('Clock-in error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Clock In Failed: $e")));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkoutController(BuildContext context) async {
    print('Starting checkout process...');
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    print("Token in check out api function:- $token");

    if (token == null) {
      print('Token not found, user is unauthenticated');
      _handleUnauthenticated();
      return;
    }

    try {
      isLoading.value = true;
      final uri = Uri.parse(ApiConstants.checkOut);
      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      print("Check out URL:- $uri");
      print("Check out API Response:- $response");
      print("Check out URL _handleApiResponse:- $_handleApiResponse");
      if (response.statusCode == 200) {
        print('Checkout request sent. Status Code: ${response.statusCode}');

        var checkoutModel = checkOutModelFromJson(response.body);
        await prefs.setString(
          'checkout',
          checkoutModel.data.checkOut.toString(),
        );
        // checkouttime = RxString( checkoutModel.data.checkOut.toString());
        // checkouttime.value = checkoutModel.data.checkOut.toString();
         checkClockInController.checkOutTime.value = checkoutModel.data.checkOut.toString();
        _handleApiResponse(
          response,
          onSuccess: () async {
            // Clear relevant shared preferences if needed
            // await prefs.remove('check_in');
            // await prefs.remove('picture');

            // Update UI state
            isClockedIn.value = false;
            checkInData.value = false;
            checkOut.value = false;
            breakData.value = false;
            // image.value = null;
            update();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Checked Out Successfully!")),
            );

            print('Checked out successfully and local data cleared.');
          },
        );
      }
    } catch (e) {
      print('Checkout API error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Checkout failed: $e")));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> breakIn(BuildContext context) async {
    print('Starting break-in process...');
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    print("Token in Start break controller:- $token");

    if (token == null) {
      print('Token not found, user is unauthenticated');
      _handleUnauthenticated();
      return;
    }

    try {
      isLoading.value = true;
      print('Sending break-in request...');
      final response = await http.post(
        Uri.parse(ApiConstants.breakstart),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print('Break-in request sent, awaiting response...');
      print("status code in start break:- ${response.statusCode}");
      print("Body in start break:- ${response.body}");

      if (response.statusCode == 200) {
        var breakStartModel = breakStartModelFromJson(response.body);
        await prefs.setString(
          'breakin',
          breakStartModel.data.breakStart.toString(),
        );
        breakStartTime.value = true;

       checkClockInController.breackinTime.value = breakStartModel.data.breakStart.toString();

        update();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Break started")));
      } else {
        // Handle other status codes
      }
    } catch (e) {
      print('Break-in error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> breakOut(BuildContext context) async {
    print('Starting break-out process...');
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    print("Token in End break controller:- $token");

    if (token == null) {
      print('Token not found, user is unauthenticated');
      _handleUnauthenticated();
      return;
    }

    try {
      isLoading.value = true;
      print('Sending break-out request...');
      final response = await http.post(
        Uri.parse(ApiConstants.breakOut),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        var breakEndModel = breakEndModelFromJson(response.body);

        await prefs.setString(
          'breakout',
          breakEndModel.data.breakEnd.toString(),
        );
        checkClockInController.breackOutTime.value = (breakEndModel.data.breakEnd.toString());
        breakStartTime.value = false;

        update();

        _handleApiResponse(
          response,
          onSuccess: () {
            print('Break ended successfully');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Break ended")));
          },
        );
      } else {
        // Handle other status codes
        print('Break-out failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Break-out failed: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      isLoading.value = false;
      print('Break-out exception error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error occurred during break-out")),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<Position?> _getCurrentPosition(BuildContext context) async {
    print('Attempting to get current location...');
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return null;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(
        'Location retrieved: Latitude ${position.latitude}, Longitude ${position.longitude}',
      );
      return position;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to get location.")));
      print('Failed to get location: $e');
      return null;
    }
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    print('Checking location permission...');
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      print('Location services are disabled');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        print('Location permission denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permission permanently denied."),
        ),
      );
      print('Location permission permanently denied');
      return false;
    }

    return true;
  }

  void _handleApiResponse(
    http.Response response, {
    required Function onSuccess,
  }) {
    print('Handling API response: ${response.statusCode}');
    try {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String errorMessage =
          responseData['message'] ?? 'Something went wrong';

      switch (response.statusCode) {
        case 200:
          print('API request successful: ${response.statusCode}');
          onSuccess();
          break;
        case 400:
        case 403:
        case 404:
        case 409:
        case 422:
          _showError(errorMessage);
          break;
        case 401:
          print('Unauthorized request, logging out...');
          _handleUnauthenticated();
          break;
        case 500:
        case 502:
        case 503:
          _showError('Server error. Please try again later.');
          break;
        default:
          _showError(errorMessage);
      }
    } catch (e) {
      _showError('Unexpected error occurred. Code: ${response.statusCode}');
      print('Error handling API response: $e');
    }
  }

  void _showError(String message) {
    print('Error: $message');
    Get.snackbar(
      'Error',
      message,
      backgroundColor: CRMColors.error,
      colorText: CRMColors.textWhite,
    );
  }

  void _handleUnauthenticated() async {
    clearSharedPreferences();
    print('User is unauthenticated, clearing session...');
    Get.snackbar(
      'Session Expired',
      'Please login again.',
      backgroundColor: CRMColors.error,
      colorText: CRMColors.textWhite,
    );
    Get.offAll(() => LoginScreen());
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.snackbar(
      'Logout',
      'Login session expired',
      backgroundColor: CRMColors.error,
      colorText: CRMColors.textWhite,
    );
    Get.offAll(LoginScreen());
  }

  Future<void> getCurrentLocation() async {
    try {
      // Step 1: Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        location.value = 'Location services are disabled';
        return;
      }

      // Step 2: Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          location.value = 'Location permission denied';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        location.value = 'Location permission permanently denied';
        return;
      }

      // Step 3: Get current position
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best, // higher accuracy
        timeLimit: const Duration(seconds: 10),
      );

      // Save coordinates
      latitude = RxDouble(pos.latitude);
      longitude = RxDouble(pos.longitude);
      print("Latitude: ${latitude.value}, Longitude: ${longitude.value}");

      // Step 4: Get human-readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        location.value = [
          place.name,
          place.subLocality,
          place.locality,
        ].where((e) => e != null && e!.isNotEmpty).join(', ');
      } else {
        location.value = 'No address available';
      }
    } catch (e) {
      location.value = 'Error retrieving location';
      print('Error: $e');
    }
  }

  void generateBellCurve() {
    points.clear();
    for (double x = -3; x <= 3; x += 0.1) {
      double y = (1 / sqrt(2 * pi)) * exp(-0.5 * x * x);
      points.add(Offset(x, y));
    }
  }
}
