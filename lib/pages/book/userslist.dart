import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/pages/book/discussion/chat.dart';
import 'package:ejazapp/pages/book/discussion/util.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  User? _user;
  bool _error = false;
  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(
        right: 16,
      ),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void _handlePressed(types.User otherUser, BuildContext context) async {
    if (_user!.displayName != null) {
      final navigator = Navigator.of(context);
      final room = await FirebaseChatCore.instance.createRoom(otherUser);

      navigator.pop();
      await navigator.push(
        MaterialPageRoute(
          builder: (context) => ChatPage(
            room: room,
          ),
        ),
      );
    } else {
      await showDialog<dynamic>(
        context: context,
        builder: (context) {
          final themeProv = Provider.of<ThemeProvider>(context);
          final theme = Theme.of(context);
          return AlertDialog(
            backgroundColor:
                themeProv.isDarkTheme! ? ColorDark.card : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              AppLocalizations.of(context)!.are_you_sure,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            content: Text(
              // AppLocalizations.of(context)!
              //     .if_you_select_log_out_it_will_return_to_the_login_screen,
              'If you want contuine chat with users,please sign in with google ',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Get.offAllNamed<dynamic>(Routes.signin);
                  await GoogleSignIn().signOut();
                  //  await ;
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setString("token", "");
                  sharedPreferences.setString('name', '');
                  sharedPreferences.setString('phone', '');
                },
                child: Text(
                  AppLocalizations.of(context)!.yes,
                  style: theme.textTheme.headlineSmall!
                      .copyWith(color: theme.primaryColor),
                ),
              ),
              TextButton(
                onPressed: () => Get.back<dynamic>(),
                child: Text(
                  AppLocalizations.of(context)!.no,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          foregroundColor: themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
          // backgroundColor: themeProv.isDarkTheme! ? ColorDark.card : Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text(''),
          actions: [
            IconButton(
              color: themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
              icon: const Icon(Icons.close),
              tooltip: 'Close',
              onPressed: () => Get.offAllNamed<dynamic>(Routes.home),
            ),
          ],
        ),
        body: StreamBuilder<List<types.User>>(
          stream: FirebaseChatCore.instance.users(),
          initialData: const [],
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: const Text('No users'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                var date =
                    DateTime.fromMicrosecondsSinceEpoch(user.lastSeen! * 1000);
                return GestureDetector(
                  onTap: () {
                    _handlePressed(user, context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildAvatar(user),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(
                                  getUserName(user),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(top: 15.0),
                          //       child: Text(
                          //         'Last Seen : $date',
                          //         textAlign: TextAlign.end,
                          //       ),
                          //     ),
                          //     Text(''),
                          //   ],
                          // ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
