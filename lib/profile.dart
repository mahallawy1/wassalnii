import 'package:flutter/material.dart';
import 'sql-helper.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _collegeIdController = TextEditingController();
  final mydatabaseclass db = mydatabaseclass();  // Instance of your database class

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _collegeIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      List<Map<String, dynamic>> queryRows = await db.reading("SELECT * FROM TABLE1 LIMIT 1");  // Assuming there's only one user profile
      if (queryRows.isNotEmpty) {
        setState(() {
          _nameController.text = queryRows[0]['FIRST NAME'];
          _ageController.text = queryRows[0]['SECOND NAME'].toString();
          _collegeIdController.text = queryRows[0]['EMAIL'];
        });
      }
    } catch (e) {
      print("An error occurred while loading data: $e");
      // Optionally show an error message to the user
    }
  }

  Future<void> _saveUserData() async {
    try {
      await db.writing(
          "INSERT INTO TABLE1 ('FIRST NAME', 'SECOND NAME', 'EMAIL') VALUES (?, ?, ?) ON CONFLICT(ID) DO UPDATE SET 'FIRST NAME' = ?, 'SECOND NAME' = ?, 'EMAIL' = ?",
          [_nameController.text, _ageController.text, _collegeIdController.text, _nameController.text, _ageController.text, _collegeIdController.text]
      );
      _loadUserData();
    } catch (e) {
      print("An error occurred while saving data: $e");
      // Optionally show an error message to the user
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.purple[500],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _collegeIdController,
              decoration: InputDecoration(labelText: 'College ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
