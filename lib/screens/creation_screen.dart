import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/component_create_req.dart';
import 'package:to_do_app/providers/creation_provider.dart';
import 'package:to_do_app/providers/login_provider.dart';
import 'package:to_do_app/widgets/custom_button.dart';
import 'package:to_do_app/widgets/second_title.dart';

class CreationScreen extends StatefulWidget {
  const CreationScreen({super.key});

  @override
  State<CreationScreen> createState() => _CreationScreenState();
}

class _CreationScreenState extends State<CreationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _connectionMethodController = TextEditingController();
  final _effectiveDateController = TextEditingController();
  final SingleValueDropDownController _messageTypeController =
      SingleValueDropDownController();
  final SingleValueDropDownController _checkTokenController =
      SingleValueDropDownController();

  @override
  void initState() {
    super.initState();
    final authToken = context.read<LoginProvider>().accessToken ?? '';
    context.read<CreationProvider>().loadMessageTypes(authToken);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _connectionMethodController.dispose();
    _effectiveDateController.dispose();
    _messageTypeController.dispose();
    _checkTokenController.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _effectiveDateController.text =
            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
      });
    }
  }

  List<DropDownValueModel> _getMessageTypeDropdownList() {
    final messageTypes = context.watch<CreationProvider>().messageTypes;
    return messageTypes
        .map(
          (mt) => DropDownValueModel(name: mt.description, value: mt.msgType),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(color: Color(0xFFF6F1F1)),
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Card(
              elevation: 5,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 30,
                      children: [
                        SecondTitle(
                          title: 'Create New Component',
                          color: Color(0xFFFF7F11),
                        ),
                        TextFormField(
                          controller: _codeController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            labelText: 'Component code',
                            focusColor: Color.fromARGB(255, 211, 226, 255),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Component code is required';
                            }
                            if (value.length > 20) {
                              return 'Component code must be less or equal to 20 characters';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            labelText: 'Component name',
                            focusColor: Color.fromARGB(255, 211, 226, 255),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Component name is required';
                            }
                            if (value.length > 150) {
                              return 'Component name must be less or equal to 150 characters';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _connectionMethodController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            labelText: 'Connection method',
                            focusColor: Color.fromARGB(255, 211, 226, 255),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null && value.length > 1000) {
                              return 'Connection method must be less or equal to 1000 characters';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _effectiveDateController,
                          decoration: const InputDecoration(
                            labelText: 'Effective date',
                            focusColor: Color.fromARGB(255, 211, 226, 255),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            DateTime? date = DateTime.tryParse(value ?? '');
                            if (date != null) {
                              DateTime now = DateUtils.dateOnly(DateTime.now());
                              if (date.isBefore(now)) {
                                return 'Effective date must be in the future';
                              }
                            }
                            return null;
                          },
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: DropDownTextField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _messageTypeController,
                                enableSearch: true,
                                clearOption: true,
                                textFieldDecoration: const InputDecoration(
                                  labelText: 'Message type',
                                  focusColor: Color.fromARGB(
                                    255,
                                    211,
                                    226,
                                    255,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                dropDownList: _getMessageTypeDropdownList(),
                                validator: (value) {
                                  if (value != null && value.length > 1500) {
                                    return 'Message type must be less or equal to 1500 characters';
                                  }
                                  return null;
                                },
                                onChanged: (value) => log(
                                  '${_messageTypeController.dropDownValue}',
                                ),
                              ),
                            ),
                            Expanded(
                              child: DropDownTextField(
                                controller: _checkTokenController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                clearOption: true,
                                textFieldDecoration: const InputDecoration(
                                  labelText: 'Check token',
                                  focusColor: Color.fromARGB(
                                    255,
                                    211,
                                    226,
                                    255,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                dropDownList: const [
                                  DropDownValueModel(name: 'Yes', value: 'Y'),
                                  DropDownValueModel(name: 'No', value: 'N'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 20,
                          children: [
                            CustomButton(
                              label: 'Cancel',
                              color: Color(0xFFFF6600),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                context.go('/home');
                              },
                            ),
                            CustomButton(
                              label: 'Add',
                              color: Color(0xFF8FD14F),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final authToken =
                                      context
                                          .read<LoginProvider>()
                                          .accessToken ??
                                      '';

                                  final payload = ComponentCreateReq(
                                    componentCode: _codeController.text,
                                    componentName: _nameController.text,
                                    messageType: _messageTypeController
                                        .dropDownValue
                                        ?.value,
                                    connectionMethod:
                                        _connectionMethodController.text,
                                    checkToken: _checkTokenController
                                        .dropDownValue
                                        ?.value,
                                    effectiveDate:
                                        _effectiveDateController.text,
                                  );

                                  await context
                                      .read<CreationProvider>()
                                      .createComponent(authToken, payload);

                                  if (!context.mounted) return;

                                  if (context
                                      .read<CreationProvider>()
                                      .createSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Component created successfully',
                                        ),
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(10),
                                      ),
                                    );
                                    _formKey.currentState?.reset();
                                    context.go('/home');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to create component',
                                        ),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(10),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Form is invalid. Please check the errors.',
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(10),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (context.watch<CreationProvider>().isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
