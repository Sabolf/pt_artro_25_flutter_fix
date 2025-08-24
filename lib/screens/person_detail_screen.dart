import 'package:flutter/material.dart';
import 'package:pt_25_artro_test/widgets/image_finder.dart';
import 'package:pt_25_artro_test/cached_request.dart';
import 'package:html_unescape/html_unescape.dart';
import '../l10n/app_localizations.dart' as loc;

class PersonDetailScreen extends StatefulWidget {
  final dynamic speaker;
  const PersonDetailScreen({super.key, required this.speaker});

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  String avatarUrl = "";
  List<dynamic> _speakerSessions = [];
  bool _isLoadingSessions = true;
  final unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    _findImage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSessions(context);
    });
  }

  Future<void> _findImage() async {
    final ImgPathWay = await findImagePathById(widget.speaker['id']);
    if (ImgPathWay != null) {
      setState(() {
        avatarUrl = ImgPathWay;
      });
    }
  }

  Future<void> _loadSessions(BuildContext context) async {
    final locData = loc.AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;
    
    cachedRequest.readDataOrCached(
      endpoint: 'https://voteptartro.wisehub.pl/api/?action=get-program-flat',
      method: 'GET',
      onData: (data) {
        if (data != null) {
          final List<dynamic> allSessions = [];
          data.forEach((key, value) {
            if (key.startsWith('day') && !key.contains('rooms')) {
              final dayNumber = int.parse(key.replaceAll('day', '')) + 1;

              final sessionsWithDayAndRoom = (value as List).map((session) {
                String roomName;
                if (currentLocale == 'pl') {
                  roomName = session['place_pl'] ?? '';
                } else {
                  roomName = session['place_en'] ?? '';
                }

                if (roomName.isEmpty) {
                  roomName = locData.open_stage;
                }

                return {
                  ...session,
                  'day': dayNumber.toString(),
                  'room': roomName,
                };
              }).toList();
              allSessions.addAll(sessionsWithDayAndRoom);
            }
          });

          final speakerSessions = allSessions.where((session) {
            final speakersInSession = session['speakers'] as List<dynamic>?;
            if (speakersInSession == null) {
              return false;
            }
            return speakersInSession.any(
              (speaker) => speaker['symbol'] == widget.speaker['id'],
            );
          }).toList();

          setState(() {
            _speakerSessions = speakerSessions;
            _isLoadingSessions = false;
          });
        }
      },
    );
  }

  static const backgroundColor = Color(0xFFF0F2F5);
  static const cardColor = Colors.white;
  static const accentColor = Color(0xFFE4287C);
  static const primaryTextColor = Color(0xFF1F1F1F);
  static const secondaryTextColor = Color(0xFF6B6B7C);
  static const tertiaryTextColor = Color(0xFFB0B0C0);

  Widget infoRow(IconData icon, String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: primaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locData = loc.AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;
    final isPolish = currentLocale == 'pl';
    final speaker = widget.speaker;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
        title: Text(
          locData.speaker_details,
          style: const TextStyle(color: primaryTextColor),
        ),
        iconTheme: const IconThemeData(color: primaryTextColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipOval(
                      child: avatarUrl.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : Image.asset(
                              avatarUrl,
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                              frameBuilder: (BuildContext context, Widget child,
                                  int? frame, bool wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) return child;
                                if (frame == null) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return child;
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                    child: Icon(Icons.person,
                                        size: 60, color: Colors.grey));
                              },
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "${speaker['name'] ?? ''} ".trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              if (isPolish
                  ? (speaker['titlePl'] != null && speaker['titlePl'].toString().trim().isNotEmpty)
                  : (speaker['titleEn'] != null && speaker['titleEn'].toString().trim().isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    isPolish ? speaker['titlePl'] : speaker['titleEn'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: accentColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoRow(Icons.work_outline, locData.workplace, speaker['workplace']),
                    infoRow(
                      Icons.location_on_outlined,
                      locData.location,
                      isPolish
                          ? "${speaker['city'] ?? ''}${(speaker['city'] != null && speaker['countryPl'] != null) ? ', ' : ''}${speaker['countryPl'] ?? ''}"
                          : "${speaker['city'] ?? ''}${(speaker['city'] != null && speaker['countryEn'] != null) ? ', ' : ''}${speaker['countryEn'] ?? ''}",
                    ),
                    infoRow(Icons.group_outlined, locData.member_of, speaker['member']),
                    infoRow(Icons.map_outlined, locData.zones, speaker['zones']),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (isPolish
                  ? (speaker['bioPl'] != null && (speaker['bioPl'] as String).isNotEmpty)
                  : (speaker['bioEn'] != null && (speaker['bioEn'] as String).isNotEmpty))
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locData.biography,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        unescape.convert((isPolish ? speaker['bioPl'] : speaker['bioEn'])
                            .replaceAll('[n]', '\n')),
                        style: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locData.lectures,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingSessions)
                      const Center(child: CircularProgressIndicator())
                    else if (_speakerSessions.isEmpty)
                      Text(
                        locData.not_scheduled,
                        style: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 15,
                        ),
                      )
                    else
                      ..._speakerSessions.map((session) {
                        String sessionTitle = isPolish
                            ? (session['title_pl'] ?? '')
                            : (session['title_en'] ?? '');
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: accentColor, width: 4),
                              ),
                            ),
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  unescape.convert(sessionTitle),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${locData.day} ${session['day']}: ${session['start_time']} - ${session['end_time']}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: secondaryTextColor,
                                  ),
                                ),
                                if (session['room'] != null && session['room'].isNotEmpty)
                                  Text(
                                    "${session['room']}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: secondaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}