// view_farm_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewFarmsScreen extends StatefulWidget {
  const ViewFarmsScreen({super.key});

  @override
  State<ViewFarmsScreen> createState() => _ViewFarmsScreenState();
}

class _ViewFarmsScreenState extends State<ViewFarmsScreen> {
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    try {
      final farmsSnapshot = await FirebaseFirestore.instance.collection('farms').get();
      final markers = farmsSnapshot.docs.map((doc) {
        final data = doc.data();
        final GeoPoint location = data['location'];
        final position = LatLng(location.latitude, location.longitude);
        
        return Marker(
          point: position,
          builder: (ctx) => const Icon(
            Icons.location_on,
            color: Colors.red,
            size : 30,
          ),
        );
      }).toSet();

      setState(() {
        _markers = markers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading farms: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Locations'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFarms,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                center: LatLng(12.0, 105.0),
                zoom: 5.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://{s}.tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=YOUR_API_KEY",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(markers: _markers.toList()),
              ],
            ),
    );
  }
}