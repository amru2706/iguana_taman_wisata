import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DamkarScreen extends StatefulWidget {
  @override
  _DamkarScreenState createState() => _DamkarScreenState();
}

class _DamkarScreenState extends State<DamkarScreen> {
  Map<String, dynamic> profile = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final response = await http.get(Uri.parse('http://mobilecomputing.my.id/api_amru/profile.php?nama_instansi=Pemadam%20Kebakaran'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          profile = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load profile: ${response.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load profile: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pemadam Kebakaran'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red, Colors.orange],
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/damkar.png',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Nama Instansi: ${profile['nama_instansi']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Card(
                color: Colors.white.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Email: ${profile['email']}', style: TextStyle(fontSize: 18)),
                ),
              ),
              Card(
                color: Colors.white.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Kantor: ${profile['kantor']}', style: TextStyle(fontSize: 18)),
                ),
              ),
              Card(
                color: Colors.white.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Alamat: ${profile['alamat']}', style: TextStyle(fontSize: 18)),
                ),
              ),
              Card(
                color: Colors.white.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Call Center: ${profile['call_center']}', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
