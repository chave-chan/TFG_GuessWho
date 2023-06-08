import 'package:flutter/material.dart';
import 'package:guess_who/src/persistence/application_dao.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking', style: TextStyle(fontSize: 30)),
        iconTheme: IconThemeData(size: 32),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
        child: RankingList(),
      ),
    );
  }
}

class RankingList extends StatefulWidget {
  const RankingList({super.key});

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  ApplicationDAO applicationDAO = ApplicationDAO();
  late Future<Map<ParseUser, int>> futureRanking;

  @override
  void initState() {
    super.initState();
    futureRanking = applicationDAO.getRanking();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<ParseUser, int>>(
      future: futureRanking,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading ranking'));
        } else {
          var ranking = snapshot.data!.entries
              .map((entry) => '${entry.key.get('username')}')
              .toList();
          return ListView.builder(
              itemCount: ranking.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SizedBox(
                    width: 64,
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  title: Text(
                    ranking[index],
                    style: TextStyle(fontSize: 24),
                  ),
                );
              });
        }
      },
    );
  }
}
