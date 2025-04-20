import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lastpractice/loginscreen.dart';




class UserDashboard extends StatelessWidget {
  final String userId;

  UserDashboard({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Dashboard")),
      drawer: _buildDrawer(context),
      body: _buildMessageList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu, color: Colors.red), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.phone, color: Colors.red), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera, color: Colors.red), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, color: Colors.red), label: ''),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text("User Menu")),
          ListTile(
            title: Text("Sign Out"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginscreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('messages').where('recipientId', isEqualTo: userId).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(doc['message']),
                subtitle: doc['reply'] != null ? Text("Reply: " + doc['reply']) : null,
                trailing: ElevatedButton(
                  onPressed: () {
                    _replyToMessage(context, doc.id);
                  },
                  child: Text("Reply"),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _replyToMessage(BuildContext context, String messageId) {
    TextEditingController replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Reply to Message"),
          content: TextField(controller: replyController, decoration: InputDecoration(hintText: "Type your reply")),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('messages').doc(messageId).update({'reply': replyController.text});
                Navigator.pop(context);
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }
}
