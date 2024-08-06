// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/addPassword/addPassword.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/functions.dart';
import 'package:quirkey/utils/models.dart';
import 'package:quirkey/utils/widgets.dart';

class HomePage extends StatefulWidget {
  User? currentUser;
  HomePage({
    super.key,
    required this.currentUser,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = "All";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        showPopDialog(context, () {
          logoutAndReturnToLogin(context);
        });
      },
      child: Scaffold(
          drawer: SideBar(currentUser: widget.currentUser),
          appBar: AppBar(
            backgroundColor: kPrimaryDarkColor,
            foregroundColor: kBackgroundColor,
            centerTitle: true,
            title: const Text('All Entries'),
          ),
          body: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(color: Colors.blueGrey),
            child: Center(
                child: Column(
              children: [
                LabeledWidget(
                  label: 'Sort by',
                  widget: QStringDropDown(
                    list: const ['All', "Account", "Address", "Bank", "Notes"],
                    value: dropdownValue,
                    onchanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: defaultPadding),
                FutureBuilder(
                  future: getSortedEntries(
                    dropdownValue,
                    widget.currentUser!.uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error encountered ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          //simulate refresh duration
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {});
                        },
                        child: ListView.builder(
                          itemCount: docs.length + 1,
                          itemBuilder: (context, index) {
                            if (index == docs.length) {
                              return AddEntryCard(
                                currentUser: widget.currentUser,
                              );
                            } else {
                              final data =
                                  docs[index].data() as Map<String, dynamic>;
                              final entry = Entries.fromMap(data);
                              switch (entry.type) {
                                case 'account':
                                  return EntryCard(
                                      title: entry.title, type: entry.type);
                                case 'address':
                                  return EntryCard(
                                      title: entry.title, type: entry.type);
                                case 'bank':
                                  return EntryCard(
                                      title: entry.title, type: entry.type);
                                case 'notes':
                                  return EntryCard(
                                      title: entry.title, type: entry.type);
                                default:
                                  return const Text('Uknown entry type');
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),
          ),
          floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              foregroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AddPassword(
                        currentUser: widget.currentUser,
                      ),
                    ));
              },
              child: const Icon(Icons.add))),
    );
  }
}
