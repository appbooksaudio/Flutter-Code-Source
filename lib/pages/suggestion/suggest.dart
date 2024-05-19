import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SuggestEjaz extends StatefulWidget {
  const SuggestEjaz({super.key});

  @override
  State<SuggestEjaz> createState() => _SuggestEjazState();
}

class _SuggestEjazState extends State<SuggestEjaz> {
  TextEditingController _titlebookController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _isbnController = TextEditingController();
  TextEditingController _editorController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  String langugefield = "";
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: FormBuilder(
                  child: SizedBox(
                    height: usableHeight * 2,
                    child: ListView(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.the_true_sign,
                          maxLines: 2,
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                              height: 1.2,
                              color: themeProv.isDarkTheme!
                                  ? Colors.white
                                  : ColorDark.background,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        TextField(
                          cursorHeight: 15,
                          cursorOpacityAnimates: true,
                          cursorColor: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                          cursorWidth: 2,
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: _titlebookController,
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
                                AppLocalizations.of(context)!.booktitle + " *",
                            hintStyle: TextStyle(
                               height: 1.5,
                                color: themeProv.isDarkTheme!
                                    ? Colors.grey
                                    : ColorDark.background,
                                fontSize: 15),
                          ),
                        ),
                        FormBuilderField(
                          autovalidateMode: AutovalidateMode.always,
                          name: "language",
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          builder: (FormFieldState<dynamic> field) {
                            var options = [
                              AppLocalizations.of(context)!.arabic,
                              AppLocalizations.of(context)!.english,
                            ];
                            return InputDecorator(
                              decoration: InputDecoration(
                                  label: RichText(
                                text: TextSpan(
                                    text: "   " +
                                        AppLocalizations.of(context)!.language,
                                    style: TextStyle(
                                        color: themeProv.isDarkTheme!
                                            ? Colors.white
                                            : ColorDark.background,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal),
                                    children: [
                                      TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: themeProv.isDarkTheme!
                                                ? Colors.white
                                                : ColorDark.background,
                                          ))
                                    ]),
                              )),
                              child: Container(
                                height: 100,
                                child: CupertinoPicker(
                                  itemExtent: 30,
                                  children:
                                      options.map((c) => Text(c)).toList(),
                                  onSelectedItemChanged: (index) {
                                    field.didChange(options[index]);
                                    setState(() {
                                      langugefield = options[index].toString();
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
                          controller: _authorController,
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
                                AppLocalizations.of(context)!.author + " *",
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
                          controller: _isbnController,
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
                            hintText: AppLocalizations.of(context)!.isbn,
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
                          controller: _editorController,
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
                            hintText: AppLocalizations.of(context)!.editor,
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
                          maxLines: 5,
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: _commentController,
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
                            hintText: AppLocalizations.of(context)!.comments,
                            hintStyle: TextStyle(
                              height: 1.5,
                                color: themeProv.isDarkTheme!
                                    ? Colors.grey
                                    : ColorDark.background,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 60),
                        MaterialButton(
                          color: ColorLight.primary,
                          minWidth: 250,
                          onPressed: () async {
                            String title = _titlebookController.text.toString();
                            String author = _authorController.text.toString();
                            if (title == "" ||
                                author == "" ||
                                langugefield == "") {
                              Get.snackbar(
                               localeProv.localelang!.languageCode == "en" ? 'Alert' : 'تنبيه',
                               localeProv.localelang!.languageCode == "en" ? 'Please fill out all required fields':'يرجى ملء جميع الحقول المطلوبة',
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                                icon: const Icon(Icons.hourglass_disabled),
                              );
                            } else {
                              await PostSuggest(
                                  _isbnController.text,
                                  _titlebookController.text,
                                  langugefield,
                                  _authorController.text,
                                  _editorController.text,
                                  _commentController.text,
                                  localeProv.localelang!.languageCode);
                              setState(() {
                                _titlebookController.text = "";
                                _authorController.text = "";
                                _isbnController.text = "";
                                _editorController.text = "";
                                _commentController.text = "";
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(AppLocalizations.of(context)!.submit),
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
