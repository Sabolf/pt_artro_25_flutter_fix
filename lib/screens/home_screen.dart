import 'package:flutter/material.dart';
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
          "Dr n. med. Tomasz Parda\u0142a \u2013 specjalista ortopeda w Polsce i Wielkiej Brytanii, doktor nauk medycznych, kierownik Kliniki Ortopedii Wydzia\u0142u Lekarskiego i Nauk o Zdrowiu w Krakowskiej Akademii im. Andrzeja Frycza Modrzewskiego, z siedzib\u0105 w Szpitalu \u015aw. Rafa\u0142a w Krakowie. [n] Specjalizuje si\u0119 w leczeniu du\u017cych staw\u00f3w: barku, biodra i kolana, gdzie wykonuje USG oraz pe\u0142ny zakres operacji. W szczeg\u00f3lno\u015bci operacje artroskopowe, operacje ratuj\u0105ce przed wszczepieniem protez staw\u00f3w, jak r\u00f3wnie\u017c operacje wszczepiania tych protez. [n] Absolwent Uniwersytetu Jagiello\u0144skiego, gdzie obroni\u0142 prac\u0119 doktorsk\u0105. Do\u015bwiadczenie zawodowe zdobywa\u0142 w Polsce i za granic\u0105 (Anglia, Szkocja). Sekretarz Zarz\u0105du Polskiego Towarzystwa Artroskopowego kadencji\u00a02019-2021.",
      "bioEn":
          "Orthopedic specialist in Poland and Great Britain, doctor of medical sciences, head of the Orthopedic Clinic of the Faculty of Medicine and Health Sciences at the Krakow Academy by Andrzej Frycz Modrzewski, based at the St. Hospital. Rafa\u0142 in Krakow. [n] He specializes in the treatment of large joints: shoulder, hip and knee, where he performs ultrasound and a full range of surgeries. In particular, arthroscopic surgeries, saving surgeries before the implantation of joint prostheses, as well as surgeries implanting these prostheses. [n] A graduate of the Jagiellonian University, where he defended his doctoral thesis. He gained professional experience in Poland and abroad (England, Scotland). Secretary of the Management Board of the Polish Arthroscopic Society of the 2019-2021 term.",
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
      "bioPl":
          "Fizjoterapeuta, adiunkt w Katedrze Nauk Biomedycznych i Medycyny Fizykalnej na Wydziale Fizjoterapii Akademii Wychowania Fizycznego im. Jerzego Kukuczki w Katowicach, opiekun Knee Research Group - ko\u0142a naukowego przy Laboratorium Analizy Ruchu na tej samej uczelni. Fizjoterapeuta podczas Pucharu \u015awiata w siatk\u00f3wce pla\u017cowej - SWATCH FIVB World Tour 2009. W latach 2009-13 fizjoterapeuta Reprezentacji Polski w koszyk\u00f3wce na w\u00f3zkach, w 2012 roku powo\u0142any do sztabu misji medycznej Reprezentacji Polski na Paraolimpiad\u0119 w Londynie. Kierownik naukowy Pracowni Diagnostyki Funkcjonalnej w \u017corskiej Sport-Klinice, na co dzie\u0144 zajmuje si\u0119 prac\u0105 z pacjentami ortopedycznymi w Shoulder and Knee Clinic w Katowicach. Amator d\u0142ugodystansowych bieg\u00f3w g\u00f3rskich.",
      "bioEn":
          "Physiotherapist and an adjunct in the Department of Biomedical Sciences and Physical Medicine of the Academy of Physical Education in Katowice (Faculty of Rehabilitation), supervisor of the Knee Research Group - a scientific group of the Laboratory of Movement Analysis operating at the same university. Physiotherapist during the 2009 SWATCH FIVB Beach Volleyball World Championship. Physiotherapist in 2009-2013 of the Polish National Wheelchair Basketball Team, in 2012 appointed to the staff of the medical mission of the Polish National Team for the Paralympic Games in London. Research director of the Functional Diagnostic Laboratory of the Sport-Clinic in Zory working on a daily basis with orthopedic patients at the Shoulder and Knee Clinic in Katowice. Enthusiast of long-distance mountain running.",
    },
    // add more entries here if needed
  ];

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
                    builder: (context) => PersonDetailScreen(speaker: congressChairmen[0]),
                  ),
                );
              },
            ),
            UserCard(
              wholeObject: congressChairmen[1],
              onTap: (x) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetailScreen(speaker: congressChairmen[1]),
                  ),
                );
              },
            ),
            UserCard(
              wholeObject: congressChairmen[2],
              onTap: (x) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetailScreen(speaker: congressChairmen[2]),
                  ),
                );
              },
            ),
            UserCard(
              wholeObject: congressChairmen[3],
              onTap: (x) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetailScreen(speaker: congressChairmen[3]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
