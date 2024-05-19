import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GiftEjaz extends StatefulWidget {
  const GiftEjaz({super.key});

  @override
  State<GiftEjaz> createState() => _GiftEjazState();
}

class _GiftEjazState extends State<GiftEjaz> {
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailaddressController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  String subscriptionfield = "";
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    final usableHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
        body: NestedScrollView(
            body: Stack(children: [
              FormBuilder(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: SizedBox(
                    height: usableHeight * 2,
                    child: ListView(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.you_can_gift_ejaz,
                          maxLines: 2,
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 18,
                              height: 1.2,
                              color: themeProv.isDarkTheme!
                                  ? Colors.white
                                  : ColorDark.background,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          cursorHeight: 15,
                          cursorColor: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                          cursorWidth: 2,
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: _fullnameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText:
                                AppLocalizations.of(context)!.fullname + " *",
                            hintStyle: TextStyle(
                              height: 1.5,
                                color: themeProv.isDarkTheme!
                                    ? Colors.grey
                                    : ColorDark.background,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          cursorHeight: 15,
                          cursorColor: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                          cursorWidth: 2,
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: _emailaddressController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText:
                                AppLocalizations.of(context)!.email_address +
                                    " *",
                            hintStyle: TextStyle(
                              height: 1.5,
                                color: themeProv.isDarkTheme!
                                    ? Colors.grey
                                    : ColorDark.background,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FormBuilderField(
                          autovalidateMode: AutovalidateMode.always,
                          name: 'typesubscription',
                          // validator: FormBuilderValidators.compose([
                          //   FormBuilderValidators.required(),
                          // ]),
                          builder: (FormFieldState<dynamic> field) {
                            var options = [
                              AppLocalizations.of(context)!
                                  .monthly_subscription,
                              AppLocalizations.of(context)!.yearly_subscription,
                            ];
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                        .typesubscription +
                                    " *",
                                labelStyle: TextStyle(
                                    color: themeProv.isDarkTheme!
                                        ? Colors.white
                                        : ColorDark.background,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                contentPadding:
                                    EdgeInsets.only(top: 10.0, bottom: 0.0),
                                border: InputBorder.none,
                                errorText: field.errorText,
                              ),
                              child: Container(
                                height: 100,
                                child: CupertinoPicker(
                                  itemExtent: 30,
                                  children:
                                      options.map((c) => Text(c)).toList(),
                                  onSelectedItemChanged: (index) {
                                    field.didChange(options[index]);
                                    setState(() {
                                      subscriptionfield =
                                          options[index].toString();
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          cursorHeight: 15,
                          cursorColor: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                          cursorWidth: 2,
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: _noteController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: AppLocalizations.of(context)!.note + " *",
                            hintStyle: TextStyle(
                              height: 1.5,
                                color: themeProv.isDarkTheme!
                                    ? Colors.grey
                                    : ColorDark.background,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 100),
                        MaterialButton(
                          color: ColorLight.primary,
                          minWidth: 250,
                          onPressed: ()async {
                               await PostGiftEjaz(
                                  _fullnameController.text,
                                  _emailaddressController.text,
                                  subscriptionfield,
                                  _noteController.text,
                                  localeProv.localelang!.languageCode);
                              setState(() {
                                _fullnameController.text = "";
                                _emailaddressController.text = "";
                                _noteController.text = "";
                              });
                         
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              AppLocalizations.of(context)!.submit,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                    backgroundColor: theme.colorScheme.background,
                    foregroundColor:
                        themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
                    // backgroundColor: themeProv.isDarkTheme!
                    //     ? ColorDark.background
                    //     : Colors.white,
                    pinned: true,
                    centerTitle: true,
                    automaticallyImplyLeading: true),
              ];
            }));
  }
}
