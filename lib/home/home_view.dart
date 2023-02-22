import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive/home/home_view_service.dart';
import 'package:flutter_hive/manager/user_cache_manager.dart';
import 'package:flutter_hive/model/user_model.dart';
import 'package:flutter_hive/search/search_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final IHomeService _homeService;
  late final ICacheManager<UserModel> cacheManager;
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final String _dummyUrl =
      'https://fastly.picsum.photos/id/201/200/300.jpg?grayscale&hmac=BgHJjRdLh_COHXoc1t-UQZ-iPISHfWJ_kkRqeYpti4o';
  List<UserModel>? _items;

  @override
  void initState() {
    super.initState();
    _homeService = HomeService(Dio(BaseOptions(baseUrl: _baseUrl)));
    cacheManager = UserCacheManager('userCache');
    fetchDatas();
  }

  Future<void> fetchDatas() async {
    cacheManager.init();

    _items = await _homeService.fetchUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                context.navigateToPage(SearchView(model: cacheManager));
              },
              icon: const Icon(Icons.search))
        ],
        title: const Text('Flutter Hive Demo'),
        backgroundColor: Colors.red.shade900,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        if (_items?.isNotEmpty ?? false) {
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
