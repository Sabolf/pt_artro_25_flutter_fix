import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// No description provided for @abstracts.
  ///
  /// In en, this message translates to:
  /// **'Abstracts'**
  String get abstracts;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask question'**
  String get askQuestion;

  /// No description provided for @askingTo.
  ///
  /// In en, this message translates to:
  /// **'You are asking a question from'**
  String get askingTo;

  /// No description provided for @accompanying_events.
  ///
  /// In en, this message translates to:
  /// **'Social Events'**
  String get accompanying_events;

  /// No description provided for @accompanying_events_title_1.
  ///
  /// In en, this message translates to:
  /// **'Thursday, 19.10.2023, 4:20PM'**
  String get accompanying_events_title_1;

  /// No description provided for @accompanying_events_desc_1.
  ///
  /// In en, this message translates to:
  /// **'Welcome cocktail'**
  String get accompanying_events_desc_1;

  /// No description provided for @accompanying_events_location_1.
  ///
  /// In en, this message translates to:
  /// **'The Fryderyk Chopin Polish Baltic Philharmonic'**
  String get accompanying_events_location_1;

  /// No description provided for @accompanying_events_title_2.
  ///
  /// In en, this message translates to:
  /// **'Friday, 20.10.2023, 20:00PM'**
  String get accompanying_events_title_2;

  /// No description provided for @accompanying_events_desc_2.
  ///
  /// In en, this message translates to:
  /// **'Social Party'**
  String get accompanying_events_desc_2;

  /// No description provided for @accompanying_events_location_2.
  ///
  /// In en, this message translates to:
  /// **'Elektryczny Żuraw is a unique event venue in the Gdańsk Shipyard, where original events and unique events are organized with a view of the port cranes. A space that combines elegance with a pleasant factory industrial style\nWelcome to the 4th floor of the factory.\n\\nElektryczny Żuraw, 80-863 Gdańsk, Elektryków 1\n\n*Paid participation additionally, entrance upon presentation of an invitation. '**
  String get accompanying_events_location_2;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @commitee_o.
  ///
  /// In en, this message translates to:
  /// **'Organizing Committee'**
  String get commitee_o;

  /// No description provided for @commitee_n.
  ///
  /// In en, this message translates to:
  /// **'Scientific Committee'**
  String get commitee_n;

  /// No description provided for @commitee_ph.
  ///
  /// In en, this message translates to:
  /// **'Physiotherapy Organizing Committee'**
  String get commitee_ph;

  /// No description provided for @commitees.
  ///
  /// In en, this message translates to:
  /// **'Committees'**
  String get commitees;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @goto_ptartro.
  ///
  /// In en, this message translates to:
  /// **'Visit PTArtro Website'**
  String get goto_ptartro;

  /// No description provided for @open_in_navigation_app.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Ice Kraków Congress Center'**
  String get open_in_navigation_app;

  /// No description provided for @open_poster.
  ///
  /// In en, this message translates to:
  /// **'Open poster'**
  String get open_poster;

  /// No description provided for @lectures.
  ///
  /// In en, this message translates to:
  /// **'Speaker activity'**
  String get lectures;

  /// No description provided for @event_details.
  ///
  /// In en, this message translates to:
  /// **'Facebook: Elektryczny Żuraw'**
  String get event_details;

  /// No description provided for @member_of.
  ///
  /// In en, this message translates to:
  /// **'Member of'**
  String get member_of;

  /// No description provided for @speakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get speakers;

  /// No description provided for @program.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program;

  /// No description provided for @prelegent.
  ///
  /// In en, this message translates to:
  /// **'Prelegent'**
  String get prelegent;

  /// No description provided for @read_abstract.
  ///
  /// In en, this message translates to:
  /// **'Read abstract'**
  String get read_abstract;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @room_0.
  ///
  /// In en, this message translates to:
  /// **'Room A: Congress'**
  String get room_0;

  /// No description provided for @room_1.
  ///
  /// In en, this message translates to:
  /// **'Room B: Green'**
  String get room_1;

  /// No description provided for @room_2.
  ///
  /// In en, this message translates to:
  /// **'Room C: White'**
  String get room_2;

  /// No description provided for @room_3.
  ///
  /// In en, this message translates to:
  /// **'Room D: Oak'**
  String get room_3;

  /// No description provided for @room_4.
  ///
  /// In en, this message translates to:
  /// **'Room E: Conference'**
  String get room_4;

  /// No description provided for @room_sn.
  ///
  /// In en, this message translates to:
  /// **'Smith&Nephew Exposition'**
  String get room_sn;

  /// No description provided for @scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scanQr;

  /// No description provided for @building_plan.
  ///
  /// In en, this message translates to:
  /// **'Building plan'**
  String get building_plan;

  /// No description provided for @building_plan_lead.
  ///
  /// In en, this message translates to:
  /// **'Zoom in to see details.'**
  String get building_plan_lead;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Browse favorites'**
  String get favorites;

  /// No description provided for @meeting_pt.
  ///
  /// In en, this message translates to:
  /// **'Congress PTArtro'**
  String get meeting_pt;

  /// No description provided for @sponsor_title.
  ///
  /// In en, this message translates to:
  /// **'Sponsors and Partners'**
  String get sponsor_title;

  /// No description provided for @sponsor_platinium.
  ///
  /// In en, this message translates to:
  /// **'Platinium Sponsor'**
  String get sponsor_platinium;

  /// No description provided for @sponsor_diamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond Sponsor'**
  String get sponsor_diamond;

  /// No description provided for @sponsor_exhibitor.
  ///
  /// In en, this message translates to:
  /// **'Exhibitors'**
  String get sponsor_exhibitor;

  /// No description provided for @sponsor_patron.
  ///
  /// In en, this message translates to:
  /// **'Patronage'**
  String get sponsor_patron;

  /// No description provided for @sponsor_partner.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get sponsor_partner;

  /// No description provided for @sponsor_patron_honorary.
  ///
  /// In en, this message translates to:
  /// **'Honorary Patronage'**
  String get sponsor_patron_honorary;

  /// No description provided for @sponsor_sponsor.
  ///
  /// In en, this message translates to:
  /// **'Silver Sponsors'**
  String get sponsor_sponsor;

  /// No description provided for @sponsors_session.
  ///
  /// In en, this message translates to:
  /// **'Educational activities'**
  String get sponsors_session;

  /// No description provided for @no_prelegent_data.
  ///
  /// In en, this message translates to:
  /// **'No detailed information about the speakers'**
  String get no_prelegent_data;

  /// No description provided for @no_messages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get no_messages;

  /// No description provided for @my_questions.
  ///
  /// In en, this message translates to:
  /// **'My questions'**
  String get my_questions;

  /// No description provided for @menu_sn.
  ///
  /// In en, this message translates to:
  /// **'About Arthrex'**
  String get menu_sn;

  /// No description provided for @fav_list_lead.
  ///
  /// In en, this message translates to:
  /// **'Mark your favorite lectures to browse your program. Select program details and mark with an asterisk.'**
  String get fav_list_lead;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @invitation_title.
  ///
  /// In en, this message translates to:
  /// **'Dear Colleagues and Friends,'**
  String get invitation_title;

  /// No description provided for @invitation_lead.
  ///
  /// In en, this message translates to:
  /// **'\nWe are delighted to invite you to the 6th Polish Arthroscopy Society Congress, which will be held from October 15th to 17th, 2025, in the culturally rich city of Kraków. This event promises to be a perfect blend of modern science and history, set against the backdrop of our national heritage – A Historic Center for Modern Arthroscopic Excellence.\n'**
  String get invitation_lead;

  /// No description provided for @invitation_body.
  ///
  /// In en, this message translates to:
  /// **'The Congress provides an exceptional opportunity to explore the latest advances in arthroscopy and joint preservation surgery. Our program includes plenary lectures, scientific sessions, workshops, and presentations by leading experts from around the world. This time, we are honored to have the Romanian Arthroscopic Society as our guest society. We look forward to three enriching days of scientific discovery, professional exchange, and friendship. The Congress will serve as a valuable platform for international experts, including surgeons, physiotherapists, nurses, and medical trainers, to share their experiences From Research to Practice – basic science, through surgery to rehabilitation. The venue is the modern ICE Kraków Congress Center, located in the heart of the city, just across the Vistula River from Wawel Castle and the Old Town. Kraków is the home of the oldest university in Poland, where nearly 6,000 students currently acquire knowledge.'**
  String get invitation_body;

  /// No description provided for @no_questions.
  ///
  /// In en, this message translates to:
  /// **'No questions.\n\nYou didn\'t send any questions. If you want to send a question, select a session in the program.'**
  String get no_questions;

  /// No description provided for @location_title.
  ///
  /// In en, this message translates to:
  /// **'Ice Kraków Congress Center'**
  String get location_title;

  /// No description provided for @location_ice.
  ///
  /// In en, this message translates to:
  /// **'International Conferences and Entertainment'**
  String get location_ice;

  /// No description provided for @location_city.
  ///
  /// In en, this message translates to:
  /// **'Kraków'**
  String get location_city;

  /// No description provided for @location_lead.
  ///
  /// In en, this message translates to:
  /// **'Krakow has been the main destination for incoming tourism for years, the most recognizable Polish city in the world. Many millions of tourists from Poland and abroad come here every year. They are attracted by countless monuments and museums, as well as festivals, hundreds of excellent restaurants, pubs and cafes, and hotels located in the most prestigious Polish scenery of the Old Town and the Wawel area. Krakow is a complete city – both modern and rich in history and heritage.'**
  String get location_lead;

  /// No description provided for @location_body.
  ///
  /// In en, this message translates to:
  /// **'For hundreds of years, the heart of the city has been the Main Market Square – the largest city square in medieval Europe, preserved unchanged since 1257 and included on the first UNESCO World Heritage List in 1978. From the tower of St. Mary’s Basilica, for 600 years, a song has been played every hour to the four corners of the world. In the middle there is the Cloth Hall – a medieval market hall – one of the most recognizable Polish monuments. Krakow has the second oldest university in Central Europe, after the University of Prague, the Jagiellonian University. Wawel inhabited since the Paleolithic times, was the residence of Polish rulers and a religious center from the mid-11th century. Currently, the Wawel Royal Castle serves as a museum. You can see monuments of Renaissance art here; the arcaded courtyard – a pearl of 16th-century architecture – arouses admiration.'**
  String get location_body;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @program_title.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program_title;

  /// No description provided for @program_lead.
  ///
  /// In en, this message translates to:
  /// **'Select a day to view the program:'**
  String get program_lead;

  /// No description provided for @program_day_1.
  ///
  /// In en, this message translates to:
  /// **'Day 1'**
  String get program_day_1;

  /// No description provided for @program_day_1_sub.
  ///
  /// In en, this message translates to:
  /// **'Thursday, October 19'**
  String get program_day_1_sub;

  /// No description provided for @program_day_2.
  ///
  /// In en, this message translates to:
  /// **'Day 2'**
  String get program_day_2;

  /// No description provided for @program_day_2_sub.
  ///
  /// In en, this message translates to:
  /// **'Friday, October 20'**
  String get program_day_2_sub;

  /// No description provided for @program_day_3.
  ///
  /// In en, this message translates to:
  /// **'Day 3'**
  String get program_day_3;

  /// No description provided for @program_day_3_sub.
  ///
  /// In en, this message translates to:
  /// **'Saturday, October 21'**
  String get program_day_3_sub;

  /// No description provided for @scan_entry.
  ///
  /// In en, this message translates to:
  /// **'Scan entry'**
  String get scan_entry;

  /// No description provided for @scan_badge_to_send_question.
  ///
  /// In en, this message translates to:
  /// **'Scan your badge to send your question'**
  String get scan_badge_to_send_question;

  /// No description provided for @send_question.
  ///
  /// In en, this message translates to:
  /// **'Send question now'**
  String get send_question;

  /// No description provided for @question_saved_ok.
  ///
  /// In en, this message translates to:
  /// **'Question saved. Your questions are available in the program in the Question List.'**
  String get question_saved_ok;

  /// No description provided for @question_saved_error.
  ///
  /// In en, this message translates to:
  /// **'Error, question not saved. Check your internet connection.'**
  String get question_saved_error;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @yourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter your question'**
  String get yourQuestion;

  /// No description provided for @day_information.
  ///
  /// In en, this message translates to:
  /// **'Day Information'**
  String get day_information;

  /// No description provided for @location_info_lead.
  ///
  /// In en, this message translates to:
  /// **'The ICE Krakow Congress Center is located in the very center of Krakow, opposite the Wawel Royal Castle, right next to one of the main transport hubs. The facility can be reached by car from Krakow Airport, the railway and bus stations, and from any other part of Krakow.'**
  String get location_info_lead;

  /// No description provided for @open_in_google.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get open_in_google;

  /// No description provided for @location_rec.
  ///
  /// In en, this message translates to:
  /// **'We recommend using public transport. The nearest stop is just 50 meters from ICE Krakow.'**
  String get location_rec;

  /// No description provided for @location_info_detail.
  ///
  /// In en, this message translates to:
  /// **'Around the Congress Center there is a special communication system including above-ground parking lots, a bus bay, bicycle parking lots and a two-level underground parking lot for 329 cars.'**
  String get location_info_detail;

  /// No description provided for @accom.
  ///
  /// In en, this message translates to:
  /// **'ACCOMMODATION BELOW, CLICK IMAGE TO SEE MORE DETAILS'**
  String get accom;

  /// No description provided for @accommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get accommodation;

  /// No description provided for @near_hotel.
  ///
  /// In en, this message translates to:
  /// **'Hotels near ICE Krawow'**
  String get near_hotel;

  /// No description provided for @price_per_night.
  ///
  /// In en, this message translates to:
  /// **'Prices per night'**
  String get price_per_night;

  /// No description provided for @double_tap.
  ///
  /// In en, this message translates to:
  /// **'Double tap or pinch to zoom'**
  String get double_tap;

  /// No description provided for @single_room.
  ///
  /// In en, this message translates to:
  /// **'Single room'**
  String get single_room;

  /// No description provided for @double_room.
  ///
  /// In en, this message translates to:
  /// **'Double room'**
  String get double_room;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'night'**
  String get night;

  /// No description provided for @away.
  ///
  /// In en, this message translates to:
  /// **'away'**
  String get away;

  /// No description provided for @decimal.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get decimal;

  /// No description provided for @show_more.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get show_more;

  /// No description provided for @show_less.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get show_less;

  /// No description provided for @load.
  ///
  /// In en, this message translates to:
  /// **'Loading Information'**
  String get load;

  /// No description provided for @favorite_sessions.
  ///
  /// In en, this message translates to:
  /// **'Favorite Sessions'**
  String get favorite_sessions;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @day_detail.
  ///
  /// In en, this message translates to:
  /// **'Day Details'**
  String get day_detail;

  /// No description provided for @presenters.
  ///
  /// In en, this message translates to:
  /// **'Presenters'**
  String get presenters;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @speaker_details.
  ///
  /// In en, this message translates to:
  /// **'Speaker Details'**
  String get speaker_details;

  /// No description provided for @open_stage.
  ///
  /// In en, this message translates to:
  /// **'Open Stage'**
  String get open_stage;

  /// No description provided for @zones.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get zones;

  /// No description provided for @workplace.
  ///
  /// In en, this message translates to:
  /// **'Workplace'**
  String get workplace;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @not_scheduled.
  ///
  /// In en, this message translates to:
  /// **'This speaker is not scheduled for any sessions.'**
  String get not_scheduled;

  /// No description provided for @unknown_speaker.
  ///
  /// In en, this message translates to:
  /// **'Unknown Speaker'**
  String get unknown_speaker;

  /// No description provided for @submit_attendance.
  ///
  /// In en, this message translates to:
  /// **'Submit Attendance'**
  String get submit_attendance;

  /// No description provided for @consent_header.
  ///
  /// In en, this message translates to:
  /// **'Consent For Attendance'**
  String get consent_header;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'I consent to have my attendance recorded for this session.'**
  String get recorded;

  /// No description provided for @enter_your_question.
  ///
  /// In en, this message translates to:
  /// **'Enter you question here...'**
  String get enter_your_question;

  /// No description provided for @sponsored_sesh.
  ///
  /// In en, this message translates to:
  /// **'Sponsored Lecture'**
  String get sponsored_sesh;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
