import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lastpractice/loginscreen.dart';

class HomePage extends StatelessWidget {
  final String userId;
  HomePage({required this.userId});

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginscreen()),
    );
  }

  void _sendMessage(String receiverId, String receiverRole, BuildContext context) {
    TextEditingController _messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Send Message"),
        content: TextField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: "Enter your message",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (_messageController.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('messages').add({
                  'senderId': userId,
                  'receiverId': receiverId,
                  'receiverRole': receiverRole,
                  'message': _messageController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(userId: 'uid')));
              }
            },
            child: Text("Send"),
          ),
        ],
      ),
    );
  }

  Widget buildList(String collection, String role, BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        return Column(
          children: snapshot.data!.docs.map((doc) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: Icon(Icons.account_circle, size: 40, color: Colors.deepOrange),
                  title: Text(doc['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(doc['bio']),
                  trailing: ElevatedButton(
                    onPressed: () =>
                        
                        _sendMessage(doc.id, role, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Approach"),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Masjid & Huffadh", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.deepOrange, Colors.orangeAccent]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.mosque, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sign Out"),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Masjid", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            buildList("masjids", "masjid", context),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Huffadh", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            buildList("huffadh", "huffadh", context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Call'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
        ],
      ),
    );
  }
}
