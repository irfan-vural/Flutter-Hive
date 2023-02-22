import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive/home/home_view_service.dart';
import 'package:flutter_hive/manager/user_cache_manager.dart';
import 'package:flutter_hive/model/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final IHomeService _homeService;
  late final ICacheManager cacheManager;
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final String _dummyUrl =
      'https://fastly.picsum.photos/id/201/200/300.jpg?grayscale&hmac=BgHJjRdLh_COHXoc1t-UQZ-iPISHfWJ_kkRqeYpti4o';
  List<user_model>? _items;

  @override
  void initState() {
    super.initState();
    _homeService = HomeService(Dio(BaseOptions(baseUrl: _baseUrl)));
    cacheManager = UserCacheManager('userCache');
    fetchDatas();
  }

  Future<void> fetchDatas() async {
    await Hive.initFlutter();
    cacheManager.init();
    _items = await _homeService.fetchUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Hive Demo'),
        backgroundColor: Colors.red.shade900,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        if (_items?.isEmpty ?? false) {
          await cacheManager.addItems(_items!);
        }
      }),
      body: (_items?.isNotEmpty ?? false)
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _items?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading:
                        CircleAvatar(backgroundImage: NetworkImage(_dummyUrl)),
                    title: Text('${_items?[index].name}'),
                  ),
                );
              },
            )
          : const CircularProgressIndicator(),
    );
  }
}
