import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // You can initialize other services here before the app runs
  // e.g., await Get.putAsync(() => SomeService.init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mock Team Directory',
      debugShowCheckedModeBanner: false,
      // darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}

class Endpoints {
  static const String baseUrl = "https://api.github.com/users/";
}

class AppPages {
  static const initial = '/home';

  static final routes = [
    GetPage(name: initial, page: () => const HomeScreen()),
    // Add other routes here
  ];
}

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String gravatarId;
  String url;
  String htmlUrl;
  String followersUrl;
  String followingUrl;
  String gistsUrl;
  String starredUrl;
  String subscriptionsUrl;
  String organizationsUrl;
  String reposUrl;
  String eventsUrl;
  String receivedEventsUrl;
  String type;
  String userViewType;
  bool siteAdmin;
  String name;
  dynamic company;
  String blog;
  String location;
  dynamic email;
  dynamic hireable;
  dynamic bio;
  dynamic twitterUsername;
  int publicRepos;
  int publicGists;
  int followers;
  int following;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.gravatarId,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    required this.gistsUrl,
    required this.starredUrl,
    required this.subscriptionsUrl,
    required this.organizationsUrl,
    required this.reposUrl,
    required this.eventsUrl,
    required this.receivedEventsUrl,
    required this.type,
    required this.userViewType,
    required this.siteAdmin,
    required this.name,
    required this.company,
    required this.blog,
    required this.location,
    required this.email,
    required this.hireable,
    required this.bio,
    required this.twitterUsername,
    required this.publicRepos,
    required this.publicGists,
    required this.followers,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    login: json["login"] ?? 'N/A',
    id: json["id"],
    nodeId: json["node_id"],
    avatarUrl: json["avatar_url"],
    gravatarId: json["gravatar_id"],
    url: json["url"],
    htmlUrl: json["html_url"],
    followersUrl: json["followers_url"],
    followingUrl: json["following_url"],
    gistsUrl: json["gists_url"],
    starredUrl: json["starred_url"],
    subscriptionsUrl: json["subscriptions_url"],
    organizationsUrl: json["organizations_url"],
    reposUrl: json["repos_url"],
    eventsUrl: json["events_url"],
    receivedEventsUrl: json["received_events_url"],
    type: json["type"],
    userViewType: json["user_view_type"],
    siteAdmin: json["site_admin"],
    name: json["name"] ?? 'N/A',
    company: json["company"],
    blog: json["blog"],
    location: json["location"] ?? 'N/A',
    email: json["email"],
    hireable: json["hireable"],
    bio: json["bio"],
    twitterUsername: json["twitter_username"],
    publicRepos: json["public_repos"],
    publicGists: json["public_gists"],
    followers: json["followers"],
    following: json["following"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "login": login,
    "id": id,
    "node_id": nodeId,
    "avatar_url": avatarUrl,
    "gravatar_id": gravatarId,
    "url": url,
    "html_url": htmlUrl,
    "followers_url": followersUrl,
    "following_url": followingUrl,
    "gists_url": gistsUrl,
    "starred_url": starredUrl,
    "subscriptions_url": subscriptionsUrl,
    "organizations_url": organizationsUrl,
    "repos_url": reposUrl,
    "events_url": eventsUrl,
    "received_events_url": receivedEventsUrl,
    "type": type,
    "user_view_type": userViewType,
    "site_admin": siteAdmin,
    "name": name,
    "company": company,
    "blog": blog,
    "location": location,
    "email": email,
    "hireable": hireable,
    "bio": bio,
    "twitter_username": twitterUsername,
    "public_repos": publicRepos,
    "public_gists": publicGists,
    "followers": followers,
    "following": following,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class MainController extends GetxController {
  TextEditingController userNameController = TextEditingController();

  final dio = Dio();
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  void getHttp() async {
    try {
      final response = await dio.get(
        '${Endpoints.baseUrl}${userNameController.text.trim()}',
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        userData.value = response.data;
        print(user);
        print('User found: ${user.login}');
        Get.to(() => DetialsScreen());
      } else {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text('User not found')));
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text("User not found")));
      print('An error occurred: $e');
    }
  }

  // Add your controller logic here
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: controller.userNameController,
                decoration: InputDecoration(
                  labelText: 'Enter GitHub Username',
                  border: OutlineInputBorder(),
                ),
                // validator: (value) => value == null || value.isEmpty
                //     ? 'Please enter a username'
                //     : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.userNameController.text.isEmpty
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a username')),
                        )
                      : controller.userNameController.text.trim().isNotEmpty
                      ? controller.getHttp()
                      : null;
                },
                child: Text('Search User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetialsScreen extends StatelessWidget {
  const DetialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    return Scaffold(
      appBar: AppBar(title: Text(controller.userData['login'] ?? 'Details')),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                controller.userData['avatar_url'] ?? '',
              ),
            ),
            SizedBox(height: 20),
            Text('Name: ${controller.userData['name'] ?? 'N/A'}'),
            Text('Bio: ${controller.userData['bio'] ?? 'N/A'}'),
            Text(
              'Public Repos: ${controller.userData['public_repos'] ?? 'N/A'}',
            ),
            Text('Followers: ${controller.userData['followers'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
