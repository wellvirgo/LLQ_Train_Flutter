import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/component.dart';
import 'package:to_do_app/models/search_component_req.dart';
import 'package:to_do_app/providers/home_provider.dart';
import 'package:to_do_app/providers/login_provider.dart';
import 'package:to_do_app/providers/update_provider.dart';
import 'package:to_do_app/widgets/cus_text_field.dart';
import 'package:to_do_app/widgets/custom_button.dart';
import 'package:to_do_app/widgets/primary_title.dart';
import 'package:to_do_app/widgets/table_header.dart';

class ComponentDatasource extends DataTableSource {
  List<Component> _components;
  int _totalElements;
  int _size;
  final Function(int id) onUpdate;
  final Function(int id) onDelete;

  ComponentDatasource(
    this._components,
    this._totalElements,
    this._size,
    this.onUpdate,
    this.onDelete,
  );

  void updateData(
    List<Component> newComponents,
    int totalElements,
    int pageSize,
  ) {
    _components = newComponents;
    _totalElements = totalElements;
    _size = pageSize;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _totalElements) return null;

    int localIndex = index % _size;

    if (localIndex >= _components.length) return null;

    final component = _components[localIndex];

    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onUpdate(component.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => onDelete(component.id),
              ),
            ],
          ),
        ),
        DataCell(Text(component.componentCode)),
        DataCell(Text(component.componentName ?? 'N/A')),
        DataCell(Text(component.messageType?.description ?? 'N/A')),
        DataCell(Text(component.connectionMethod ?? 'N/A')),
        DataCell(Text(component.checkToken ?? 'N/A')),
        DataCell(Text(component.status?.label ?? 'N/A')),
        DataCell(Text(component.effectiveDate ?? 'N/A')),
        DataCell(Text(component.endEffectiveDate ?? 'N/A')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _totalElements;

  @override
  int get selectedRowCount => 0;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PaginatorController _paginatorController = PaginatorController();
  late ComponentDatasource _dataSource;
  late final SearchComponentReq _searchPayload;
  late final String _authToken;

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final SingleValueDropDownController _statusController =
      SingleValueDropDownController();

  void handleUpdate(int id) {
    context.go('/edit/$id');
  }

  Future<void> handleDelete(int id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Do you want to delete this component?'),
          actions: [
            CustomButton(
              label: 'Cancel',
              color: Colors.redAccent,
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CustomButton(
              label: 'Delete',
              color: Colors.black,
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm ?? false) {
      if (!mounted) return;
      final success = await context.read<HomeProvider>().deleteComponent(
        _authToken,
        id,
      );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Component deleted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
          ),
        );
        context.read<HomeProvider>().loadComponents(_authToken, _searchPayload);
      }
    }
  }

  List<DropDownValueModel> _getStatusDropdownList() {
    final componentStatuses = context.watch<UpdateProvider>().componentStatuses;
    return componentStatuses
        .map((ele) => DropDownValueModel(name: ele.label, value: ele.value))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _statusController.dispose();
    _paginatorController.dispose();
  }

  @override
  void initState() {
    super.initState();
    final homeProvider = context.read<HomeProvider>();
    _dataSource = ComponentDatasource(
      [],
      homeProvider.totalElements,
      homeProvider.size,
      handleUpdate,
      handleDelete,
    );
    _searchPayload = SearchComponentReq.initialize();
    _authToken = context.read<LoginProvider>().accessToken ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeProvider.loadComponents(_authToken, _searchPayload);
      context.read<UpdateProvider>().loadComponentStatus(_authToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        decoration: const BoxDecoration(
          color: Color.fromARGB(246, 241, 241, 241),
        ),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PrimaryTitle(title: 'Management Web'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    CustomButton(
                      label: 'New Component',
                      color: const Color.fromARGB(255, 25, 167, 206),
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 241, 241, 241),
                        fontWeight: FontWeight.bold,
                      ),
                      onPressed: () {
                        context.go('/create');
                      },
                    ),
                    CustomButton(
                      label: 'Logout',
                      color: const Color.fromARGB(217, 239, 95, 29),
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 241, 241, 241),
                        fontWeight: FontWeight.bold,
                      ),
                      onPressed: () {
                        context.read<LoginProvider>().logout();
                        context.go('/login');
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              spacing: 30,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CusTextField(
                          labelText: 'Component Code',
                          controller: _codeController,
                        ),
                      ),
                      Expanded(
                        child: CusTextField(
                          labelText: 'Component Name',
                          controller: _nameController,
                        ),
                      ),
                      Expanded(
                        child: DropDownTextField(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          textFieldDecoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          controller: _statusController,
                          clearOption: true,
                          dropDownList: _getStatusDropdownList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CustomButton(
                        label: 'Search',
                        color: Colors.blue,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        onPressed: () {
                          _searchPayload.componentCode = _codeController.text;
                          _searchPayload.componentName = _nameController.text;
                          _searchPayload.status =
                              _statusController.dropDownValue?.value;
                          context.read<HomeProvider>().loadComponents(
                            _authToken,
                            _searchPayload,
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 20, color: Colors.grey[400]),
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  _dataSource.updateData(
                    provider.components,
                    provider.totalElements,
                    provider.size,
                  );
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      PaginatedDataTable2(
                        renderEmptyRowsInTheEnd: false,
                        fixedLeftColumns: 2,
                        fixedTopRows: 1,
                        minWidth: 2000,
                        controller: _paginatorController,
                        header: const Text('Components List'),
                        columns: const [
                          DataColumn2(
                            label: TableHeader(content: 'Actions'),
                            fixedWidth: 120,
                          ),
                          DataColumn2(
                            label: TableHeader(content: 'Component Code'),
                          ),
                          DataColumn2(
                            label: TableHeader(content: 'Component Name'),
                          ),
                          DataColumn2(
                            label: TableHeader(content: 'Message Type'),
                          ),
                          DataColumn2(
                            label: TableHeader(content: 'Connection Method'),
                          ),
                          DataColumn2(
                            label: TableHeader(content: 'Check Token'),
                          ),
                          DataColumn2(label: TableHeader(content: 'Status')),
                          DataColumn2(
                            label: TableHeader(content: 'Effective Date'),
                          ),
                          DataColumn2(
                            label: TableHeader(content: 'End Effective Date'),
                          ),
                        ],
                        source: _dataSource,
                        rowsPerPage: context.watch<HomeProvider>().size,
                        availableRowsPerPage: const [10, 20, 30],
                        onPageChanged: (value) {
                          final newPage = (value ~/ provider.size) + 1;
                          provider.loadComponents(
                            _authToken,
                            _searchPayload,
                            newPage: newPage,
                          );
                        },
                        onRowsPerPageChanged: (value) {
                          if (value != null) {
                            _paginatorController.goToFirstPage();
                            provider.loadComponents(
                              _authToken,
                              _searchPayload,
                              newSize: value,
                            );
                          }
                        },
                      ),
                      if (provider.isLoading)
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            color: const Color.fromARGB(63, 49, 134, 254),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
