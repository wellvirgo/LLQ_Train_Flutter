import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/component_update_req.dart';
import 'package:to_do_app/models/detail_component.dart';
import 'package:to_do_app/providers/creation_provider.dart';
import 'package:to_do_app/providers/login_provider.dart';
import 'package:to_do_app/providers/update_provider.dart';
import 'package:to_do_app/widgets/custom_button.dart';
import 'package:to_do_app/widgets/second_title.dart';

class UpdateScreen extends StatefulWidget {
  final int componentId;
  const UpdateScreen({super.key, required this.componentId});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _connectionMethodController =
      TextEditingController();
  final SingleValueDropDownController _messageTypeController =
      SingleValueDropDownController();
  final TextEditingController _effectiveDateController =
      TextEditingController();
  final TextEditingController _endEffectiveDateController =
      TextEditingController();
  final SingleValueDropDownController _checkTokenController =
      SingleValueDropDownController();
  final SingleValueDropDownController _statusController =
      SingleValueDropDownController();
  late bool _isDisplay;
  late bool _isActive;

  bool _isDataInitialized = false;
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  List<DropDownValueModel> _getMessageTypeDropdownList() {
    final messageTypes = context.watch<CreationProvider>().messageTypes;
    return messageTypes
        .map(
          (mt) => DropDownValueModel(name: mt.description, value: mt.msgType),
        )
        .toList();
  }

  List<DropDownValueModel> _getStatusDropdownList() {
    final componentStatuses = context.watch<UpdateProvider>().componentStatuses;
    return componentStatuses
        .map((ele) => DropDownValueModel(name: ele.label, value: ele.value))
        .toList();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void setInitialData(DetailComponent detailComponent) {
    _codeController.text = detailComponent.componentCode;
    _nameController.text = detailComponent.componentName ?? '';

    _checkTokenController.setDropDown(switch (detailComponent.checkToken) {
      'Y' => DropDownValueModel(name: 'Yes', value: 'Y'),
      'N' => DropDownValueModel(name: 'No', value: 'N'),
      _ => DropDownValueModel(name: '', value: ''),
    });
    _connectionMethodController.text = detailComponent.connectionMethod ?? '';
    _messageTypeController.setDropDown(
      DropDownValueModel(
        name: detailComponent.messageType?.description ?? '',
        value: detailComponent.messageType?.msgType ?? '',
      ),
    );
    _statusController.setDropDown(
      DropDownValueModel(
        name: detailComponent.status?.label ?? '',
        value: detailComponent.status?.value ?? '',
      ),
    );

    _effectiveDateController.text = detailComponent.effectiveDate ?? '';
    _endEffectiveDateController.text = detailComponent.endEffectiveDate ?? '';

    setState(() {
      _isDisplay = detailComponent.isDisplay == 1;
      _isActive = detailComponent.isActive == 1;
      _autovalidateMode = AutovalidateMode.disabled;
    });
  }

  void enableAutoValidate() {
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  ComponentUpdateReq buildPayLoad() {
    String messageType = _messageTypeController.dropDownValue!.value;
    String checkToken = _checkTokenController.dropDownValue!.value;
    return ComponentUpdateReq(
      componentCode: _codeController.text.trim(),
      componentName: _nameController.text.trim(),
      connectionMethod: _connectionMethodController.text.trim(),
      messageType: messageType == '' ? null : messageType,
      effectiveDate: _effectiveDateController.text.trim(),
      endEffectiveDate: _endEffectiveDateController.text.trim(),
      checkToken: checkToken == '' ? null : checkToken,
      status: _statusController.dropDownValue!.value,
      isDisplay: _isDisplay ? 1 : 0,
      isActive: _isActive ? 1 : 0,
    );
  }

  String? validateDate(String? value) {
    final date = DateTime.tryParse(value ?? '');
    if (date != null) {
      if (date.isBefore(DateUtils.dateOnly(DateTime.now()))) {
        return 'Date must not be in the past';
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _connectionMethodController.dispose();
    _messageTypeController.dispose();
    _effectiveDateController.dispose();
    _endEffectiveDateController.dispose();
    _checkTokenController.dispose();
    _statusController.dispose();
  }

  @override
  void initState() {
    super.initState();
    final authToken = context.read<LoginProvider>().accessToken ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<CreationProvider>().loadMessageTypes(authToken);
      context.read<UpdateProvider>().loadComponentStatus(authToken);

      final updateProvider = context.read<UpdateProvider>();
      await updateProvider.loadComponent(authToken, widget.componentId);
      final detailComponent = updateProvider.detailComponent;
      if (detailComponent != null) {
        setInitialData(detailComponent);
        setState(() {
          _isDataInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(color: Color(0xFFF6F1F1)),
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 5),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isDataInitialized)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.go('/home'),
                    icon: Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SecondTitle(
                                  title: 'Update Component',
                                  color: Colors.cyan,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: Text('Display'),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: _isDisplay,
                                        onChanged: (value) {
                                          setState(() {
                                            _isDisplay = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: Text('Active'),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: _isActive,
                                        onChanged: (value) {
                                          setState(() {
                                            _isActive = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  autovalidateMode: _autovalidateMode,
                                  controller: _codeController,
                                  decoration: InputDecoration(
                                    labelText: 'Component Code',
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
                                  onChanged: (_) => enableAutoValidate(),
                                ),
                                TextFormField(
                                  autovalidateMode: _autovalidateMode,
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Component Name',
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
                                  onChanged: (_) => enableAutoValidate(),
                                ),
                                TextFormField(
                                  autovalidateMode: _autovalidateMode,
                                  controller: _connectionMethodController,
                                  decoration: InputDecoration(
                                    labelText: 'Connection Method',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.length > 1000) {
                                      return 'Connection method must be less or equal to 1000 characters';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => enableAutoValidate(),
                                ),
                                DropDownTextField(
                                  autovalidateMode: _autovalidateMode,
                                  enableSearch: true,
                                  clearOption: true,
                                  controller: _messageTypeController,
                                  textFieldDecoration: const InputDecoration(
                                    labelText: 'Message Type',
                                    border: OutlineInputBorder(),
                                  ),
                                  dropDownList: _getMessageTypeDropdownList(),
                                  validator: (value) {
                                    if (value != null && value.length > 1500) {
                                      return 'Message type must be less or equal to 1500 characters';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => enableAutoValidate(),
                                ),
                                Row(
                                  spacing: 20,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        autovalidateMode: _autovalidateMode,
                                        controller: _effectiveDateController,
                                        decoration: InputDecoration(
                                          labelText: 'Effective Date',
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () {
                                          _selectDate(
                                            context,
                                            _effectiveDateController,
                                          );
                                          enableAutoValidate();
                                        },
                                        validator: (value) =>
                                            validateDate(value),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        autovalidateMode: _autovalidateMode,
                                        controller: _endEffectiveDateController,
                                        decoration: InputDecoration(
                                          labelText: 'End Effective Date',
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () {
                                          _selectDate(
                                            context,
                                            _endEffectiveDateController,
                                          );
                                          enableAutoValidate();
                                        },
                                        validator: (value) {
                                          String? pastDateError = validateDate(
                                            value,
                                          );
                                          if (pastDateError != null) {
                                            return pastDateError;
                                          }

                                          final endEffectiveDate =
                                              DateTime.tryParse(value ?? '')!;

                                          final effectiveDate =
                                              DateTime.tryParse(
                                                _effectiveDateController.text,
                                              );

                                          if (effectiveDate != null &&
                                              endEffectiveDate.isBefore(
                                                effectiveDate,
                                              )) {
                                            return 'End Effective Date must be after Effective Date';
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 20,
                                  children: [
                                    Expanded(
                                      child: DropDownTextField(
                                        clearOption: true,
                                        controller: _checkTokenController,
                                        dropDownList: [
                                          DropDownValueModel(
                                            name: 'Yes',
                                            value: 'Y',
                                          ),
                                          DropDownValueModel(
                                            name: 'No',
                                            value: 'N',
                                          ),
                                        ],
                                        textFieldDecoration:
                                            const InputDecoration(
                                              labelText: 'Check Token',
                                              border: OutlineInputBorder(),
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: DropDownTextField(
                                        clearOption: true,
                                        enableSearch: true,
                                        controller: _statusController,
                                        dropDownList: _getStatusDropdownList(),
                                        textFieldDecoration:
                                            const InputDecoration(
                                              labelText: 'Status',
                                              border: OutlineInputBorder(),
                                            ),
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onPressed: () {
                                        _formKey.currentState!.reset();
                                        setInitialData(
                                          context
                                              .read<UpdateProvider>()
                                              .detailComponent!,
                                        );
                                        _formKey.currentState!.save();
                                      },
                                    ),
                                    CustomButton(
                                      label: 'Update',
                                      color: Colors.blue,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          final updateProvider = context
                                              .read<UpdateProvider>();
                                          final authToken =
                                              context
                                                  .read<LoginProvider>()
                                                  .accessToken ??
                                              '';
                                          final payload = buildPayLoad();
                                          updateProvider
                                              .updateComponent(
                                                authToken,
                                                widget.componentId,
                                                payload,
                                              )
                                              .then((isSuccess) async {
                                                if (isSuccess &&
                                                    context.mounted) {
                                                  _formKey.currentState
                                                      ?.reset();
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Component updated successfully',
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      margin: EdgeInsets.all(
                                                        10,
                                                      ),
                                                    ),
                                                  );
                                                  await updateProvider
                                                      .loadComponent(
                                                        authToken,
                                                        widget.componentId,
                                                      );
                                                  setInitialData(
                                                    updateProvider
                                                        .detailComponent!,
                                                  );
                                                } else {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Failed to update component',
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        margin: EdgeInsets.all(
                                                          10,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              });
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Form is invalid. Please check the errors.',
                                              ),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
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
                  ),
                ],
              ),

            if (context.watch<UpdateProvider>().isLoading)
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(63, 49, 134, 254),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
