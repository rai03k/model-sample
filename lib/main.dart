import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(0xFFffffff),
        brightness: Brightness.light,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(36),
              child: TextField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: "メールアドレス",
                    prefixIcon: Icon(Icons.mail)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(36),
              child: TextField(
                obscureText: _isObscure,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: "パスワード",
                  prefixIcon: Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 36, right: 36, left: 36, bottom: 20),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                        (_) => false);
                  },
                  child: Text(
                    "ログイン",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 36, left: 36),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('既にアカウントをお持ちですか？'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthPage()),
                      );
                    },
                    child: Text("新規登録"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 28),
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('ログイン画面へ戻る')),
            ),
            Padding(
              padding: EdgeInsets.all(36),
              child: TextField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: "メールアドレス",
                    prefixIcon: Icon(Icons.mail)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(36),
              child: TextField(
                obscureText: _isObscure,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: "パスワード",
                  prefixIcon: Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(36),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "新規登録",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => SearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  void _submission() {
    setState(() {
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: 8),
        child: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: CircleAvatar(
            backgroundImage:
                NetworkImage('https://twitter.com/RaiAppDev/photo'),
            backgroundColor: Colors.red, // 背景色
            radius: 16, // 表示したいサイズの半径を指定
          ),
        ),
      ),
      title: SizedBox(
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFffffff),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Container(
              width: 340,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: _controller,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '検索',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _submission();
                    },
                    padding: EdgeInsets.zero,
                    highlightColor: Colors.transparent,
                  ),
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  isCollapsed: true,
                ),
                onSubmitted: (text) => _submission(),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.lightbulb_outline),
          onPressed: () => {},
        )
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(),
      drawer: Drawer(),
      body: Container(
        margin: const EdgeInsets.all(12),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          gradient: LinearGradient(
            colors: [
              Color(0xFFE32212),
              Color(0xFFBD271A),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class MyMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(0, 70, 0, 0),
          items: [
            PopupMenuItem(
              child: Text('Menu Item 1'),
              value: 'item1',
            ),
            PopupMenuItem(
              child: Text('Menu Item 2'),
              value: 'item2',
            ),
            PopupMenuItem(
              child: Text('Menu Item 3'),
              value: 'item3',
            ),
          ],
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.menu),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  // ここにアイコン画像の設定
                  backgroundImage: AssetImage('assets/profile_image.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  'Your Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('プロフィールを編集'),
            onTap: () {
              // プロフィール編集がタップされたときの処理
              Navigator.pop(context); // ドロワーを閉じる
              // 他の処理を追加
            },
          ),
          ListTile(
            title: Text('設定'),
            onTap: () {
              // 設定がタップされたときの処理
              Navigator.pop(context); // ドロワーを閉じる
              // 他の処理を追加
            },
          ),
          ListTile(
            title: Text('ログアウト'),
            onTap: () {
              // ログアウトがタップされたときの処理
              Navigator.pop(context); // ドロワーを閉じる
              // 他の処理を追加
            },
          ),
          ListTile(
            title: Text('アカウントを削除'),
            onTap: () {
              // アカウント削除がタップされたときの処理
              Navigator.pop(context); // ドロワーを閉じる
              // 他の処理を追加
            },
          ),
        ],
      ),
    );
  }
}
