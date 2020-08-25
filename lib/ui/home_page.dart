import 'package:dicoding_news_app/data/api/api_service.dart';
import 'package:dicoding_news_app/data/model/articles.dart';
import 'package:dicoding_news_app/ui/detail_page.dart';
import 'package:dicoding_news_app/widget/card_article.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: ApiService().topHeadlines(),
          builder: (context, AsyncSnapshot<ArticlesResult> snapshot) {
            var state = snapshot.connectionState;
            switch (state) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data.articles.length,
                    itemBuilder: (context, index) {
                      var article = snapshot.data.articles[index];
                      return CardArticle(
                        image: article.urlToImage,
                        title: article.title,
                        desc: article.description,
                        onPressed: () => Navigator.pushNamed(
                          context,
                          DetailPage.routeName,
                          arguments: BundleData(article.source, article),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Text('');
                }
                break;
              default:
                return Text('');
            }
          },
        ),
      ),
    );
  }
}