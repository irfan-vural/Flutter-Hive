import 'package:flutter/material.dart';
import 'package:flutter_hive/manager/user_cache_manager.dart';
import 'package:flutter_hive/model/user_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.model});
  final ICacheManager<UserModel> model;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final List<UserModel> _items = [];

  void findAndSet(String key) {
    widget.model
            .getValues()
            ?.where((element) =>
                element.name?.toLowerCase().contains(key.toLowerCase()) ??
                false)
            .toList() ??
        [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            findAndSet(value);
          },
        ),
      ),
      body: Text('${_items.map((e) => '${e.name} - ${e.company}').join(',')}'),
    );
  }
}
