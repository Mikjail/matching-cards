import 'package:flutter/material.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class Competition {
  final String id;
  final String name;
  final String logo;
  final String alt;

  Competition({
    required this.id,
    required this.name,
    required this.logo,
    required this.alt,
  });
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _currentPage = 0;
  final List<Competition> _competitions = [
    Competition(
        id: "12",
        name: "FIFA World Cup",
        logo:
            "https://images.onefootball.com/icons/leagueColoredCompetition/128/12.png",
        alt: "Icon: FIFA World Cup"),
    Competition(
        id: "5",
        name: "UEFA Champions League",
        logo:
            "https://images.onefootball.com/icons/leagueColoredCompetition/128/5.png",
        alt: "Icon: UEFA Champions League"),
    Competition(
        id: "4",
        name: "Serie A",
        logo:
            "https://images.onefootball.com/icons/leagueColoredCompetition/128/4.png",
        alt: "Icon: Serie A"),
    Competition(
        id: "1",
        name: "Bundesliga",
        logo:
            "https://images.onefootball.com/icons/leagueColoredCompetition/128/1.png",
        alt: "Icon: Bundesliga"),
    Competition(
        id: "10",
        name: "LaLiga",
        logo:
            "https://images.onefootball.com/icons/leagueColoredCompetition/128/10.png",
        alt: "Icon: LaLiga")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Text(_competitions[_currentPage].name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CustomTheme.white,
              )),
          SizedBox(
            height: 500,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: _competitions.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Image.network(
                        _competitions[_currentPage].logo,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _currentPage =
                            (_currentPage - 1) % _competitions.length;
                      });
                    },
                    icon: Icon(Icons.arrow_left),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _currentPage =
                            (_currentPage + 1) % _competitions.length;
                      });
                    },
                    icon: Icon(Icons.arrow_right),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchingCards(
                            competitionId: _competitions[_currentPage].id,
                            version: 'v1',
                          ),
                        ),
                      );
                    },
                    child: const Text('Start Game with Text'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchingCards(
                            competitionId: _competitions[_currentPage].id,
                            version: 'v2',
                          ),
                        ),
                      );
                    },
                    child: const Text('Start Game with images'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
