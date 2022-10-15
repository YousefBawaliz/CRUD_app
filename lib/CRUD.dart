import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
//   //create text field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

//  //access the collection created in firestore by this instance
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Products');

// //create an update method, By passing the object documentSnapshot
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['Name'];
      _priceController.text = documentSnapshot['Price'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    //save the value inputted in the name & price textfields into the controllers
                    final String name = _nameController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (price != null) {
                      //our update method (Already built in into firebase api{cloud firestore plugin})
                      await _products
                          .doc(documentSnapshot!
                              .id) //pass in the id (the previously created document object)
                          .update({"Name": name, "Price": price});
                      _nameController.text = '';
                      _priceController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

//create the create method, much like the update method, just change the built in update method to add method
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['Name'];
      _priceController.text = documentSnapshot['Price'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    //save the value inputted in the name & price textfields into the controllers
                    final String name = _nameController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (price != null) {
                      //add method from our firestore plugin
                      await _products.add({"Name": name, "Price": price});

                      _nameController.text = '';
                      _priceController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

//create delete function, passing it a productId as a parameter and using the built in method from firestore plugin "delete()"
  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(), //call the create method craeted above
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("FireStore"),
        centerTitle: true,
      ),
      //Use stream builder to get the updated data in real time immedietly
      body: StreamBuilder(
        stream: _products
            .snapshots(), //define the desired firestore collection as the target stream to get presistent data from it

        //streamsnapshot will have all the data available in our database (firestore collection)

        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return Container(
              child: ListView.builder(
                itemCount: streamSnapshot.data!.docs
                    .length, //since streamsnapshot refers to the collection, we specify the itemcount as the number of documnets we have in our firestore collection

                itemBuilder: (BuildContext context, int index) {
                  //access the data from the document (fields) and save them in a documnet object(DocumentSnaphot)
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      // access the fields using their property; which are 'name' and 'price' which we created earlier
                      title: Text(documentSnapshot['Name']),
                      subtitle: Text(documentSnapshot['Price'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _update(
                                    documentSnapshot)), //update a certain Documnet, by using the documnet object created below
                            IconButton(
                              icon: const Icon(Icons.delete),

                              onPressed: () => _delete(documentSnapshot
                                  .id), //pass the document id as the argument
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
