import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/expandable_text.dart';
import '../widgets/user_card.dart';
import 'person_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Example hardcoded data:
  final List<Map<String, dynamic>> congressChairmen = [
    {
      "id": "paw_sko",
      "prefixPl": "dr n. med.",
      "prefixEn": "MD, Ph.D.",
      "name": "Paweł Skowronek",
      "lname": "Skowronek",
      "city": "Kraków",
      "countryPl": "Polska",
      "countryEn": "Poland",
      "workplace":
          "Oddział Chirurgii Ortopedyczno Urazowej Szp. im. S. Żeromskiego / SPORTOKLINIK",
      "titlePl": "Specjalista ortopeda traumatolog",
      "titleEn": "Orthopaedic and traumatology specialist",
      "zones": "PR;KN;",
      "member": "PTArtro, ESSKA, EKA, AGA, EFORT, PTOiTr",
      "bioPl":
          "Sekretarz Zarządu ESSKA-EKA [n]Członek Zarządu Oświaty Polskiego Towarzystwa Artroskopowego[n]Szef SPORTOKLINIKA[n]Centrum Ortopedii i Medycyny Sportowej[n]Zastępca Kierownika Oddziału Ortopedii i Urazów[n]Szpital Specjalistyczny Żeromskiego, Kraków.",
      "bioEn":
          "Secretary of the ESSKA-EKA Board[n]Polish Arthroscopic Society Education Board Member[n]Head of SPORTOKLINIK[n]Orthopaedics and Sports Medicine Center[n]Deputy Head of Orthopaedic and Trauma Department Żeromski Specialist Hospital.",
    },
    {
      "id": "rom_brz",
      "prefixPl": "dr n. med.",
      "prefixEn": "MD, Ph.D.",
      "name": "Roman Brz\u00f3ska",
      "lname": "Brzoska",
      "city": "Bielsko-Bia\u0142a",
      "countryPl": "Polska",
      "countryEn": "Poland",
      "workplace": "Szpital \u015bw. \u0141ukasza Bielsko-Bia\u0142a",
      "titlePl": "Lekarz ",
      "titleEn": "Doctor ",
      "zones": "PR;",
      "member": "ESSKA, SECEC-ESSSE, ASI, PTOiTr, PTBi\u0141, PTArtro, PTChR",
      "bioPl":
          "Specjalizuje si\u0119 w chirurgii artroskopowej barku, w tym w leczeniu uraz\u00f3w sportowych. [n] Prezydent sekcji barkowej Europejskiego Stowarzyszenia Ortopedii Sportowej, Chirurgii Kolana i Artroskopii (ESA-ESSKA) 2016-2018. Organizator i wsp\u00f3\u0142organizator specjalistycznych kurs\u00f3w dla chirurg\u00f3w w dziedzinie leczenia uszkodze\u0144 stawu barkowego, artroskopii stawu ramiennego. Kierownik naukowy Bielskich Sympozj\u00f3w Naukowych w zakresie chirurgii\u00a0barku.",
      "bioEn":
          "He specializes in arthroscopic shoulder surgery, including the treatment of sports injuries. [n] He specializes in arthroscopic shoulder surgery, including the treatment of sports injuries. [n] President of the shoulder section of the European Association of Sports Orthopedics, Knee Surgery and Arthroscopy (ESA-ESSKA) 2016-2018. Organizer and co-organizer of specialized courses for surgeons in the field of treatment of shoulder joint injuries and shoulder\u00a0arthroscopy.",
    },
    {
      "id": "tom_par",
      "prefixPl": "dr n. med.",
      "prefixEn": "MD, Ph.D.",
      "name": "Tomasz Parda\u0142a",
      "lname": "Pardala",
      "city": "Krak\u00f3w",
      "countryPl": "Polska",
      "countryEn": "Poland",
      "workplace":
          "Klinika Ortopedii Wydzia\u0142u Lekarskiego i Nauk o Zdrowiu w Krakowskiej Akademii im. Andrzeja Frycza Modrzewskiego, z siedzib\u0105 w Szpitalu \u015aw. Rafa\u0142a w Krakowie",
      "titlePl": "Kierownik Kliniki",
      "titleEn": "Clinic manager",
      "zones": "PR;",
      "member": "",
      "bioPl":
          "Dr n. med. Tomasz Parda\u0142a \u2013 specjalista ortopeda w Polsce i Wielkiej Brytanii...",
      "bioEn":
          "Orthopedic specialist in Poland and Great Britain, doctor of medical sciences...",
    },
    {
      "id": "mac_bia",
      "prefixPl": "dr n. kult. fiz. ",
      "prefixEn": "Ph.D. in physical culture studies",
      "name": "Maciej Bia\u0142y",
      "lname": "Bialy",
      "city": "Bielsko-Bia\u0142a",
      "countryPl": "Polska",
      "countryEn": "Poland",
      "workplace": "Sport-Klinika",
      "titlePl": "Kierownik naukowy Pracowni Diagnostyki Funkcjonalnej ",
      "titleEn": "Scientific director of Functional Diagnostics Laboratory",
      "zones": "PR;KF;",
      "member": "PTArtro, PTU, ESSKA",
      "bioPl": "Fizjoterapeuta, adiunkt w Katedrze Nauk Biomedycznych...",
      "bioEn":
          "Physiotherapist and an adjunct in the Department of Biomedical Sciences...",
    },
  ];

  // FAVORITES LIST
  List<Map<String, dynamic>> favoriteSpeakers = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favListString = prefs.getString('favoriteSpeakers') ?? '[]';

    try {
      final List<dynamic> favListDecoded = jsonDecode(favListString);
      setState(() {
        favoriteSpeakers = favListDecoded.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print("Error decoding favorites: $e");
      setState(() {
        favoriteSpeakers = [];
      });
    }
  }

  bool isFavorite(String speakerId) {
    return favoriteSpeakers.any((s) => s['id'].toString() == speakerId);
  }

  Future<void> toggleStar(String speakerId) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      final existingIndex = favoriteSpeakers.indexWhere(
        (s) => s['id'].toString() == speakerId,
      );

      if (existingIndex >= 0) {
        favoriteSpeakers.removeAt(existingIndex);
      } else {
        final speakerToAdd = congressChairmen.firstWhere(
          (sp) => sp['id'].toString() == speakerId,
          orElse: () => {},
        );
        if (speakerToAdd.isNotEmpty) {
          favoriteSpeakers.add(Map<String, dynamic>.from(speakerToAdd));
        }
      }
    });

    await prefs.setString('favoriteSpeakers', jsonEncode(favoriteSpeakers));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/banner.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomExpandableText(
                leadPart:
                    "We are delighted to invite you to the 6th Polish Arthroscopy Society Congress, which will be held from October 15th to 17th, 2025, in the culturally rich city of Kraków. This event promises to be a perfect blend of modern science and history, set against the backdrop of our national heritage – A Historic Center for Modern Arthroscopic Excellence.",
                extendedPart:
                    "\n\nThe Congress provides an exceptional opportunity to explore the latest advances in arthroscopy and joint preservation surgery. Our program includes plenary lectures, scientific sessions, workshops, and presentations by leading experts from around the world. This time, we are honored to have the Romanian Arthroscopic Society as our guest society. We look forward to three enriching days of scientific discovery, professional exchange, and friendship. The Congress will serve as a valuable platform for international experts, including surgeons, physiotherapists, nurses, and medical trainers, to share their experiences From Research to Practice – basic science, through surgery to rehabilitation. The venue is the modern ICE Kraków Congress Center, located in the heart of the city, just across the Vistula River from Wawel Castle and the Old Town. Kraków is the home of the oldest university in Poland, where nearly 6,000 students currently acquire knowledge.",
              ),
            ),
            UserCard(
              wholeObject: congressChairmen[0],
              onTap: (x) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonDetailScreen(speaker: congressChairmen[0]),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(
                  isFavorite(congressChairmen[0]['id'])
                      ? Icons.star
                      : Icons.star_border,
                  color: isFavorite(congressChairmen[0]['id'])
                      ? Colors.amber
                      : Colors.grey,
                ),
                onPressed: () => toggleStar(congressChairmen[0]['id']),
              ),
            ),
            UserCard(
              wholeObject: congressChairmen[1],
              onTap: (x) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonDetailScreen(speaker: congressChairmen[1]),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(
                  isFavorite(congressChairmen[1]['id'])
                      ? Icons.star
                      : Icons.star_border,
                  color: isFavorite(congressChairmen[1]['id'])
                      ? Colors.amber
                      : Colors.grey,
                ),
                onPressed: () => toggleStar(congressChairmen[1]['id']),
              ),
            ),
            UserCard(
              wholeObject: congressChairmen[2],
              onTap: (x) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonDetailScreen(speaker: congressChairmen[2]),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(
                  isFavorite(congressChairmen[2]['id'])
                      ? Icons.star
                      : Icons.star_border,
                  color: isFavorite(congressChairmen[2]['id'])
                      ? Colors.amber
                      : Colors.grey,
                ),
                onPressed: () => toggleStar(congressChairmen[2]['id']),
              ),
            ),
            UserCard(
              wholeObject: congressChairmen[3],
              onTap: (x) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonDetailScreen(speaker: congressChairmen[3]),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(
                  isFavorite(congressChairmen[3]['id'])
                      ? Icons.star
                      : Icons.star_border,
                  color: isFavorite(congressChairmen[3]['id'])
                      ? Colors.amber
                      : Colors.grey,
                ),
                onPressed: () => toggleStar(congressChairmen[3]['id']),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: InkWell(
                onTap: () async {
                  final Uri url = Uri.parse('https://zjazd.ptartro.pl');
                  if (await canLaunchUrl(url)){
                    await launchUrl(url);
                  }
                  else{
                    throw 'can not launch $url';
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ), // Use a specific radius
                    side: const BorderSide(
                      color: Color(0xFFE4287C), // Your specified color
                      width: 2.0, // Set the border width here
                    ),
                  ),
                  child: SizedBox(
                    width: 250,
                    child: Center(child: Text("Visit Website")),
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
