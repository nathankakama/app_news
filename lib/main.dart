import 'package:flutter/material.dart';
import 'package:flux_rss/article.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/domain/rss_feed.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: const MyHomePage(title: 'Mon Flux Rss'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> articles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final article = articles[index];
            return InkWell(
              onTap: (() => print('Tpé sur: ${article.title}')),
              child: Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Text(
                          readableDate(article.date),
                          style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                              fontSize: 13
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: (article.imageUrl == "") ? Container() : Image.network(
                        article.imageUrl,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                    ),
                    Text(
                      article.title,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      article.description,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: ((context, index) => const Divider()),
          itemCount: articles.length
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getFeed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String readableDate(DateTime dateTime) {
    DateFormat dateFormat = DateFormat.yMMMMEEEEd();
    String string = dateFormat.format(dateTime);
    return string;
  }

  getFeed() async {
    String urlString = "https://www.france24.com/fr/rss";
    final client = http.Client();
    final url = Uri.parse(urlString);
    final clientResponse = await client.get(url);
    final rssFeed = RssFeed.parse(clientResponse.body);
    final items = rssFeed.items;
    if (items != null) {
      setState(() {
        articles = items.map((item) => Article(item: item)).toList();
      });
    }
  }
}
