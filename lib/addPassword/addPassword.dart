// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/functions.dart';
import 'package:quirkey/utils/widgets.dart';

class AddPassword extends StatefulWidget {
  User? currentUser;
  AddPassword({
    super.key,
    required this.currentUser,
  });

  @override
  State<AddPassword> createState() => _AddPasswordState();
}

class _AddPasswordState extends State<AddPassword> {
  List<String> types = <String>["Account", "Address", "Bank", "Notes"];
  String typesDropdownValue = "Account";
  String countryDropdownValue = countryList.first;
  String title = 'Entry title';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController stateprovinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController mmController = TextEditingController();
  final TextEditingController yyController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController securityNumController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController banknameController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        foregroundColor: kBackgroundColor,
        centerTitle: true,
        title: const Text('New Entry'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: isLoading
              ? null
              : () {
                  if (typesDropdownValue.toLowerCase() == 'account' &&
                      loginController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    addAccountEntry(
                            //add login entry
                            login: loginController.text,
                            password: passwordController.text,
                            title: title,
                            details: detailsController.text)
                        .then((value) {
                      loginController.clear();
                      passwordController.clear();
                      detailsController.clear();
                      Navigator.pop(context);
                      showToast('Added Account Entry!');
                      setState(() {});
                    });
                  } else if (typesDropdownValue.toLowerCase() == 'address' &&
                      stateprovinceController.text.isNotEmpty &&
                      cityController.text.isNotEmpty &&
                      postalCodeController.text.isNotEmpty &&
                      streetController.text.isNotEmpty) {
                    addAddress(
                            //add address entry
                            region: countryDropdownValue,
                            state: stateprovinceController.text,
                            city: cityController.text,
                            postal: postalCodeController.text,
                            street: streetController.text,
                            title: title)
                        .then((value) {
                      stateprovinceController.clear();
                      cityController.clear();
                      postalCodeController.clear();
                      streetController.clear();
                      showToast('Added Address Entry!');
                      Navigator.pop(context);
                      setState(() {});
                    });
                  } else if (typesDropdownValue.toLowerCase() == 'bank' &&
                      cardNumberController.text.isNotEmpty &&
                      mmController.text.isNotEmpty &&
                      yyController.text.isNotEmpty &&
                      securityNumController.text.isNotEmpty) {
                    addBank(
                      //add bank entry
                      cardNumber: cardNumberController.text,
                      month: mmController.text,
                      year: yyController.text,
                      security: securityNumController.text,
                      title: title,
                      cardIssuer: cardHolderController.text,
                      comment: commentController.text,
                      pin: pinController.text,
                      supportNumber: customerPhoneController.text,
                    ).then((value) {
                      cardNumberController.clear();
                      mmController.clear();
                      yyController.clear();
                      securityNumController.clear();
                      cardHolderController.clear();
                      commentController.clear();
                      pinController.clear();
                      customerPhoneController.clear();
                      showToast('Added Bank Entry!');
                      Navigator.pop(context);
                      setState(() {});
                    });
                  } else if (typesDropdownValue.toLowerCase() == 'notes' &&
                      notesController.text.isNotEmpty) {
                    addNotesEntry(
                            //add notes entry
                            notes: notesController.text,
                            title: title)
                        .then((value) {
                      notesController.clear();
                      showToast('Added Notes Entry!');
                      Navigator.pop(context);
                      setState(() {});
                    });
                  }
                },
          label: isLoading
              ? const CircularProgressIndicator()
              : const Text('Add +')),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      titleController.addListener(() {
                        setState(() {
                          title = titleController.text;
                        });
                      });
                      return AlertDialog(
                        title: const Text('Title'),
                        content: TextField(
                          maxLength: 15,
                          controller: titleController,
                          style: const TextStyle(color: kBackgroundColor),
                          decoration:
                              const InputDecoration(hintText: "Entry Title"),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Edit'))
                        ],
                      );
                    },
                  );
                },
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Text(title),
                    const SizedBox(width: defaultPadding / 3),
                    const Icon(Icons.edit_note_outlined),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding / 2),
              QStringDropDown(
                list: types,
                value: typesDropdownValue,
                onchanged: (String? value) {
                  setState(() {
                    typesDropdownValue = value!;
                  });
                },
              ),
              const SizedBox(height: defaultPadding),
              if (typesDropdownValue == "Account") ...[
                Column(
                  children: [
                    LabeledWidget(
                      label: 'Details',
                      widget: QTextField(
                          controller: detailsController,
                          hintText: "www.example.com (Optional)",
                          isPassword: false),
                    ),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                      label: 'Login',
                      widget: QTextField(
                          controller: loginController,
                          hintText: "example@email.com",
                          isPassword: false),
                    ),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                      label: 'Password',
                      widget: QTextField(
                          controller: passwordController,
                          hintText: "Password",
                          isPassword: true),
                    )
                  ],
                ),
              ] else if (typesDropdownValue == "Address") ...[
                Column(
                  children: [
                    LabeledWidget(
                      label: 'Region',
                      widget: QStringDropDown(
                        list: countryList,
                        value: countryDropdownValue,
                        onchanged: (String? value) {
                          setState(() {
                            countryDropdownValue = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                      label: 'State/Province',
                      widget: QTextField(
                          controller: stateprovinceController,
                          hintText: "State or province",
                          isPassword: false),
                    ),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                      label: 'City',
                      widget: QTextField(
                          controller: cityController,
                          hintText: "City",
                          isPassword: false),
                    ),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                      label: 'Postal code',
                      widget: QTextField(
                          textInputType:
                              const TextInputType.numberWithOptions(),
                          inputList: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: postalCodeController,
                          hintText: "Postal code",
                          isPassword: false),
                    ),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                      label: 'Street address',
                      widget: QTextField(
                          controller: streetController,
                          hintText: "Street address",
                          isPassword: false),
                    ),
                    const SizedBox(height: defaultPadding),
                    const Divider(thickness: 2, color: kPrimaryDarkColor),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                      label: 'First name',
                      widget: QTextField(
                          controller: firstNameController,
                          hintText: "First name",
                          isPassword: false),
                    ),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                      label: 'Last name',
                      widget: QTextField(
                          controller: lastNameController,
                          hintText: "Last name",
                          isPassword: false),
                    ),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                      label: 'Middle name',
                      widget: QTextField(
                          controller: middleNameController,
                          hintText: "Middle name",
                          isPassword: false),
                    ),
                  ],
                ),
              ] else if (typesDropdownValue == "Bank") ...[
                //OPTIMIZE TEXTFIELDS ACCORDING TO BANK LAYOUTS
                Column(
                  children: [
                    LabeledWidget(
                        label: 'Card Number',
                        widget: QTextField(
                            controller: cardNumberController,
                            hintText: "XXXX-XXXX-XXXX-XXXX",
                            isPassword: false)),
                    const SizedBox(height: defaultPadding),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledWidget(
                              label: 'Month',
                              widget: QTextField(
                                  controller: mmController,
                                  hintText: 'MM',
                                  isPassword: false)),
                        ),
                        const SizedBox(width: defaultPadding),
                        Expanded(
                          child: LabeledWidget(
                              label: 'Year',
                              widget: QTextField(
                                  controller: yyController,
                                  hintText: 'YYYY',
                                  isPassword: false)),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                        label: "Security",
                        widget: QTextField(
                            controller: securityNumController,
                            hintText: 'CVC2/CCV2',
                            isPassword: false)),
                    const SizedBox(height: defaultPadding),
                    const Divider(thickness: 2, color: kPrimaryDarkColor),
                    LabeledWidget(
                        label: 'PIN',
                        widget: QTextField(
                            controller: pinController,
                            hintText: "PIN",
                            isPassword: false)),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                        label: 'Card issuer',
                        widget: QTextField(
                            controller: banknameController,
                            hintText: "Enter bank name",
                            isPassword: false)),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                        label: 'Customer support number',
                        widget: QTextField(
                            controller: customerPhoneController,
                            hintText: "+1 234 567 890",
                            isPassword: false)),
                    const SizedBox(height: defaultPadding),
                    LabeledWidget(
                        label: 'Comment',
                        widget: QTextField(
                            controller: pinController,
                            hintText: "Enter comment",
                            isPassword: false)),
                  ],
                )
              ] else if (typesDropdownValue == "Notes") ...[
                Column(
                  children: [
                    LabeledWidget(
                        label: 'Notes',
                        widget: QTextField(
                            maxLines: 20,
                            controller: notesController,
                            hintText: "Enter note",
                            isPassword: false)),
                  ],
                )
              ],
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
