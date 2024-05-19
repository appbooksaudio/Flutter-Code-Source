import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/data/models/storage.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController countryCtrl = TextEditingController();
  File? _file;
  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  String? selectedValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: buildAppBar(theme),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: ((_file == null)
                          ? const CachedNetworkImageProvider(
                              'https://cdn.shopify.com/s/files/1/0747/0491/2661/files/profile.png?v=1691401880',
                            )
                          : FileImage(_file!)) as ImageProvider<Object>?,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: getImage,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: theme.primaryColor,
                        child: const Icon(
                          Feather.edit_2,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildProfileItem(
              context,
              title: AppLocalizations.of(context)!.full_name,
              trailing: TextFormField(
                controller: fullNameCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enter_your_full_name,
                  hintStyle: theme.textTheme.bodyMedium!.copyWith(
                    color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
                  ),
                  contentPadding: const EdgeInsets.only(top: 15.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            buildProfileItem(
              context,
              title: AppLocalizations.of(context)!.country,
              trailing: TextFormField(
                controller: countryCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.country,
                  hintStyle: theme.textTheme.bodyMedium!.copyWith(
                    color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
                  ),
                  contentPadding: const EdgeInsets.only(top: 15.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            buildProfileItem(
              context,
              title: AppLocalizations.of(context)!.sex,
              trailing: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                    // the menu padding when button's width is not specified.
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    'Select Your Gender',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: genderItems
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select gender.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value.toString();
                      print('selectedValue   $selectedValue');
                    });
                  },
                  onSaved: (value) {
                    selectedValue = value.toString();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            buildProfileItem(
              context,
              title: AppLocalizations.of(context)!.bio,
              trailing: TextFormField(
                // controller: _fullNameCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.bio,
                  hintStyle: theme.textTheme.bodyMedium!.copyWith(
                    color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
                  ),
                  contentPadding: const EdgeInsets.only(top: 15.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildProfileItem(
    BuildContext context, {
    required String title,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Const.margin),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Text(title, style: theme.textTheme.bodyLarge),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: trailing,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.background,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.blue,
            iconSize: 18,
            onPressed: () => Get.offNamed<dynamic>(Routes.profile),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.done),
          color: theme.primaryColor,
          onPressed: () async {
            await updateProf(fullNameCtrl.text, countryCtrl.text,
                selectedValue.toString(), 'bio');
            if (fullNameCtrl.text != "") {
              mybox!.put('name', fullNameCtrl.text);
            }
            ;
            Get.offNamed<dynamic>(Routes.profile);

            await Fluttertoast.showToast(
              webPosition: 'center',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              fontSize: 12,
              backgroundColor: ColorLight.primary,
              textColor: Colors.white,
              msg: AppLocalizations.of(context)!.successfully_changed_profile,
            );
          },
        )
      ],
    );
  }

  Future<dynamic> getImage() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _file = File(pickedImage.path);
        Uint8List bytes = _file!.readAsBytesSync();

        mybox!.put('photo', bytes);
        print('Bytes ===========$bytes');
        mybox!.put('path', pickedImage.path);
      } else {
        // print('No Image Selected');
      }
    });
    String urlPhoto =
        await StorageMethod().uploadImageToStorage("apple", _file!);
    _auth.currentUser != null
        ? _auth.currentUser!.updatePhotoURL(urlPhoto)
        : "";
    print("photo updated");
  }

  Future<DateTime?> showDate(String dateTime) async {
    DateTime? _dateTime;
    if (dateTime.isNotEmpty) {
      _dateTime = DateFormat('MM/dd/yyyy').parse(dateTime);
    } else {
      _dateTime = DateTime.now();
    }
    return await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }

  updateProf(String fullname, String country, String gender, String bio) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(fullname);
    }

    BooksApi().UpdateProfiles(fullname, country, gender, bio);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
