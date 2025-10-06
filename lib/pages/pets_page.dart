import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pawgkaon/widgets/edit_pet_dialog.dart';
import '../widgets/pet_card.dart';
import '../widgets/header.dart';
import '../widgets/add_pet_button.dart';
import '../widgets/add_pet_dialog.dart';
import '../widgets/confirm_action_dialog.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  /// Creates a reference to the current user's pets collection.
  CollectionReference<Map<String, dynamic>> _petsRef(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('pets');

  Future<void> _addPet(BuildContext context, String uid) async {
    final petData = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddPetDialog(),
    );

    if (petData == null) return;

    await _petsRef(uid).add({
      'name': petData['name'],
      'petType': petData['petType'],
      'breed': petData['breed'],
      'age': petData['age'],
      'weight': petData['weight'],
      'dateAdded': FieldValue.serverTimestamp(),
      'userId': uid, // link pet to user
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pet added successfully'),
        backgroundColor: Colors.pink,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _deletePet(
    BuildContext context,
    String uid,
    String petId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => const ConfirmActionDialog(
            title: "Delete Pet",
            message:
                "Are you sure you want to delete this pet? "
                "This will also remove all its schedules and feeding history.",
            confirmText: "Delete",
            confirmColor: Colors.pink,
            icon: Icons.delete_forever,
          ),
    );

    if (confirm != true) return;

    final petRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('pets')
        .doc(petId);

    // delete schedules and feedingHistory subcollections
    final schedules = await petRef.collection('schedules').get();
    for (final s in schedules.docs) {
      await s.reference.delete();
    }
    final histories = await petRef.collection('feedingHistory').get();
    for (final h in histories.docs) {
      await h.reference.delete();
    }

    await petRef.delete();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pet deleted successfully"),
        backgroundColor: Colors.pink,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _editPet(
    BuildContext context,
    String uid,
    String docId,
    Map<String, dynamic> currentData,
  ) async {
    final updatedData = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => EditPetDialog(petData: currentData),
    );

    if (updatedData == null) return;

    await _petsRef(uid).doc(docId).update(updatedData);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pet details updated successfully'),
        backgroundColor: Colors.pink,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final petsStream = _petsRef(user.uid).snapshots();

    return SafeArea(
      child: Container(
        color: Colors.pink.shade50,
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: petsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return _buildNoPetsUI(context, user.uid);
            }
            return _buildPetsList(context, user.uid, docs);
          },
        ),
      ),
    );
  }

  Widget _buildNoPetsUI(BuildContext context, String uid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderSection(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.pets, color: Colors.pink),
                SizedBox(width: 8),
                Text(
                  "My Pets",
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            AddPetButton(onPressed: () => _addPet(context, uid)),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: Text(
              "No Pets Added",
              style: TextStyle(
                color: Colors.pink.withOpacity(0.5),
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetsList(
    BuildContext context,
    String uid,
    List<QueryDocumentSnapshot<Object?>> docs,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HeaderSection(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.pets, color: Colors.pink),
                  SizedBox(width: 8),
                  Text(
                    "My Pets",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              AddPetButton(onPressed: () => _addPet(context, uid)),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children:
                docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = data['name'] ?? '';
                  final breed = data['breed'] ?? '';
                  final age = data['age'] ?? '';
                  final weight = data['weight'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PetCard(
                      initial: name.isNotEmpty ? name[0].toUpperCase() : '?',
                      name: name,
                      breed: breed,
                      weight: '$weight kg | $age year(s) old',
                      dateAdded: 'just now',
                      onDelete: () => _deletePet(context, uid, doc.id),
                      onEdit: () => _editPet(context, uid, doc.id, data),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
