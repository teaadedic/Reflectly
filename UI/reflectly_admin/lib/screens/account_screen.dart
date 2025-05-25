import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  static const purple = Color.fromARGB(255, 108, 104, 243);

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String name = "";
  String username = "";
  String gender = "Male";
  String phone = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('profile_name') ?? "Albert Florest";
      username = prefs.getString('profile_username') ?? "albertflorest_";
      gender = prefs.getString('profile_gender') ?? "Male";
      phone = prefs.getString('profile_phone') ?? "+44 1632 960860";
      email = prefs.getString('profile_email') ?? "albertflorest@email.com";
    });
  }

  void _updateProfile({
    required String name,
    required String username,
    required String gender,
    required String phone,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_username', username);
    await prefs.setString('profile_gender', gender);
    await prefs.setString('profile_phone', phone);
    await prefs.setString('profile_email', email);
    setState(() {
      this.name = name;
      this.username = username;
      this.gender = gender;
      this.phone = phone;
      this.email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          const SizedBox(height: 18),
          Center(
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  username,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Material(
            color: AccountScreen.purple.withOpacity(0.13),
            borderRadius: BorderRadius.circular(16),
            child: ListTile(
              leading: Icon(Icons.edit, color: AccountScreen.purple),
              title: const Text(
                "Edit Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: 18,
              ),
              onTap: () async {
                final result = await Navigator.of(
                  context,
                ).push<Map<String, String>>(
                  MaterialPageRoute(
                    builder:
                        (context) => EditProfileScreen(
                          name: name,
                          username: username,
                          gender: gender,
                          phone: phone,
                          email: email,
                        ),
                  ),
                );
                if (result != null) {
                  _updateProfile(
                    name: result['name']!,
                    username: result['username']!,
                    gender: result['gender']!,
                    phone: result['phone']!,
                    email: result['email']!,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String username;
  final String gender;
  final String phone;
  final String email;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.username,
    required this.gender,
    required this.phone,
    required this.email,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String username;
  late String gender;
  late String phone;
  late String email;

  static const purple = Color.fromARGB(255, 108, 104, 243);

  @override
  void initState() {
    super.initState();
    name = widget.name;
    username = widget.username;
    gender = widget.gender;
    phone = widget.phone;
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Name"),
                onChanged: (val) => name = val,
                validator:
                    (val) =>
                        val == null || val.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: username,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Username"),
                onChanged: (val) => username = val,
                validator:
                    (val) =>
                        val == null || val.isEmpty ? "Enter a username" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: gender,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Gender"),
                items:
                    ["Male", "Female", "Other"].map((g) {
                      return DropdownMenuItem(value: g, child: Text(g));
                    }).toList(),
                onChanged: (val) => setState(() => gender = val ?? gender),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: phone,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Phone Number"),
                keyboardType: TextInputType.phone,
                onChanged: (val) => phone = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: email,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Email"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => email = val,
                validator:
                    (val) =>
                        val == null || !val.contains("@")
                            ? "Enter a valid email"
                            : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop({
                      'name': name,
                      'username': username,
                      'gender': gender,
                      'phone': phone,
                      'email': email,
                    });
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: purple, width: 2),
      ),
    );
  }
}
