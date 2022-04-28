import 'package:flutter/material.dart';
import 'package:instagram/shop.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'notification.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:simple_animations/simple_animations.dart';
import 'dart:math' as math;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => Store1()),
          ChangeNotifierProvider(create: (c) => Store2()),
        ],
        child: MaterialApp(
            theme: style.theme,
            home: MyApp(),
        ),
      )
  );
}




class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  var tab = 0;
  var data = [];
  var userImage;
  var userContent;
  addMyData(){
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      data.insert(0, myData);
    });
  }
  setUserContent(a){
    setState(() {
      userContent = a;
    });
  }


  @override
  void initState() {
    super.initState();
    initNotification(context);
    getData();

  }

  addData(a){
    setState(() {
      data.add(a);
    });
  }

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
  }

  late final AnimationController controller = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.elasticOut,
  );
  // late final Animation<double> animation = Tween<double>(begin: 0, end: 300).animate(controller);

  var ani = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: RotationTransition(
        turns: animation,
        child: FloatingActionButton(onPressed: (){
          setState(() {
            if (ani){
              controller.forward();
              ani = !ani;
            } else {
              controller.reverse();
              ani = !ani;
            }
          });
        }, child: Icon(Icons.add)),
      ),

      appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null){
                  setState(() {
                    userImage = File(image.path);
                  });
                }

                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (c) => Upload(
                      userImage : userImage, setUserContent : setUserContent,
                      addMyData : addMyData,
                    ),
                  )
                );
              },
              iconSize: 30,
            )
          ]
      ),



      body: [ Home(data : data, addData : addData), Shop() ][tab],

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
        ],
      ),

    );
  }
}


class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar( actions: [
          IconButton(onPressed: (){
            addMyData();
          }, icon: Icon(Icons.send))
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage),
            Text('이미지업로드화면'),
            TextField(onChanged: (text){
              setUserContent(text);
            },),
            IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)
            ),
          ],
        )
    );
  }
}






class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.addData}) : super(key: key);
  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent){
        print('바닥');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty){
      return ListView.builder(itemCount: widget.data.length, controller: scroll, itemBuilder: (c, i){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              widget.data[i]['image'].runtimeType == String
                  ? Image.network(widget.data[i]['image'])
                  : Image.file(widget.data[i]['image']),

              GestureDetector(
                child: Text(widget.data[i]['user']),
                onTap: (){
                  Navigator.push(context,
                    PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => Profile(),
                        transitionsBuilder: (c, a1, a2, child) =>
                            FadeTransition(opacity: a1, child: child)
                    )
                  );
                },
              ),
              Text('좋아요 ${widget.data[i]['likes']}'),
              Text(widget.data[i]['date']),
              Text(widget.data[i]['content']),
            ]
        );
      });
    } else {
      return Text('로딩중임');
    }
  }
}



class Store2 extends ChangeNotifier {
  var name = 'john kim';
}

class Store1 extends ChangeNotifier {
  var follower = 0;
  var friend = false;
  var profileImage = [];

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    print(profileImage);
    notifyListeners();
  }

  addFollower(){
    if (friend == false){
      follower++;
      friend = true;
    } else {
      follower--;
      friend = false;
    }
    notifyListeners();
  }
}






class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store2>().name)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (c, i) => Container(color: Colors.grey),
                  childCount: 3,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          )
        ],
      ),

    );
  }
}





class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar( radius: 30, backgroundColor: Colors.grey),
        Text('팔로워 ${context.watch<Store1>().follower}명'),
        ElevatedButton(onPressed: (){
          context.read<Store1>().addFollower();
        }, child: Text('팔로우')),
        ElevatedButton(onPressed: (){
          context.read<Store1>().getData();
        }, child: Text('사진가져오기')),
      ],
    );
  }
}





















// getMore() async {
//   var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
//   var result2 = jsonDecode(result.body);
//   widget.addData(result2);
// }


