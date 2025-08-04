import 'package:flutter/material.dart';
import '../widgets/expandable_text.dart';
import '../widgets/user_card.dart';

//Widget that can change
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  //create the logic container
  _HomeScreenState createState() => _HomeScreenState();
}

//logic and ui container
class _HomeScreenState extends State<HomeScreen> {
  //? can be null until initialized'
  //MAP<String Key, Value>?
  // Map<String, dynamic>? _apiData;

  @override
  // void initState() {
  //   //When the app loads
  //   super.initState(); //<-REQUIRED
  //   _loadData();
  // }

  Future<void> _loadData() async {

    // final data = null;

    // cachedRequest.readDataOrCached(endpoint:'https://voteptartro.wisehub.pl/api/?action=get-program-flat',
    // method: 'GET',
    // onData: (data) {
    //   if (data != null){
    //     setState(() {
    //       _apiData = data;
    //     });
    //   }
    // }
    // );
    
    // if (data != null) {
    //   //rebuild the value to
    //   setState(() {
    //     _apiData = data;
    //   });
    // }
  }

  @override
  //BUILD THE VIEW
  Widget build(BuildContext context) {
    // if (_apiData == null) {
    //   return Center(child: CircularProgressIndicator());
    // }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/banner.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Column(
              children: [
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
                  name: "Paweł Skowronek",
                  imagePathWay: 'assets/images/paw_sko.jpeg',
                  subTitle: 'Doctor Boi',
                  onTap: (x){print("CALL BACK FROM: $x");},
                ),
                  UserCard(
                  name: "Roman Brzóska",
                  imagePathWay: 'assets/images/rom_brz.png',
                  subTitle: 'Doctor Man',
                  onTap: (x){print("CALL BACK FROM: $x");},
                ),
                  UserCard(
                  name: "Tomasz Pardała",
                  imagePathWay: 'assets/images/tom_par.jpg',
                  subTitle: 'Doctor Boi',
                  onTap: (x){print("CALL BACK FROM: $x");},
                ),
                  UserCard(
                  name: "Maciej Biały",
                  imagePathWay: 'assets/images/mac_bia.png',
                  subTitle: 'Doctor Boi',
                  onTap: (x){print("CALL BACK FROM: $x");},
                ),
              ],
            ),
          ],
        ),
      ),
    );
    // return Center(child: Text('Home Screen', style: TextStyle(fontSize: 24)));
  }
}
