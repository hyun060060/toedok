import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:collection/collection.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await MobileAds.instance.initialize();
  await initializeBackgroundService();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
        Locale('ja'),
        Locale('zh'),
        Locale('hi'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ko'),
      child: Phoenix(child: const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentLanguage = "ko";
  final Map<String, String> _uiTexts = {
    "로딩 중...": "로딩 중...",
    "튜토리얼": "튜토리얼",
    "시작하기": "시작하기",
    "TOE DOK": "TOE DOK",
    "SCREEN SHOT": "SCREEN SHOT",
    "VIP": "VIP",
    "VIP 취소": "VIP 취소",
    "Super VIP": "Super VIP",
    "언어 설정": "언어 설정",
    "테마": "테마",
    "언어를 변경하면 잠시 후 앱이 재시작됩니다.": "언어를 변경하면 잠시 후 앱이 재시작됩니다.",
    "언어 변경중": "언어 변경중",
    "대화방 목록": "대화방 목록",
    "새로운 대화방을 생성해보세요!": "새로운 대화방을 생성해보세요!",
    "대화방 생성": "대화방 생성",
    "대화방 이름을 입력하세요": "대화방 이름을 입력하세요",
    "확인": "확인",
    "대화방은 최대 10개까지 생성 가능합니다!": "대화방은 최대 10개까지 생성 가능합니다!",
    "대화방 이름을 입력해 주세요!": "대화방 이름을 입력해 주세요!",
    "이미 존재하는 대화방 이름입니다! 다른 이름을 입력해 주세요.": "이미 존재하는 대화방 이름입니다! 다른 이름을 입력해 주세요.",
    "대화방 이름 수정": "대화방 이름 수정",
    "새로운 이름을 입력하세요": "새로운 이름을 입력하세요",
    "다람쥐가 토독여준 멘트": "다람쥐가 토독여준 멘트",
    "아직 생성된 멘트가 없습니다.\n상대방의 말을 입력해 보세요!": "아직 생성된 멘트가 없습니다.\n상대방의 말을 입력해 보세요!",
    "이모티콘": "이모티콘",
    "짧게": "짧게",
    "길게": "길게",
    "기분 강도": "기분 강도",
    "상대방의 말을 입력하세요...": "상대방의 말을 입력하세요...",
    "내 말을 입력하세요...": "내 말을 입력하세요...",
    "내 기분 선택": "내 기분 선택",
    "취소": "취소",
    "소중한 글귀": "소중한 글귀",
    "아직 저장된 글귀가 없습니다.": "아직 저장된 글귀가 없습니다.",
    "닫기": "닫기",
    "상세 글귀": "상세 글귀",
    "멘트가 저장되었습니다!": "멘트가 저장되었습니다!",
    "이미 저장된 멘트입니다!": "이미 저장된 멘트입니다!",
    "현재 멘트 생성 중입니다...": "현재 멘트 생성 중입니다...",
    "상대방의 말을 입력해 주세요!": "상대방의 말을 입력해 주세요!",
    "클립보드에 복사됨!": "클립보드에 복사됨!",
    "스크린샷 방 목록": "스크린샷 방 목록",
    "스크린샷을 업로드하여 방을 생성하세요.": "스크린샷을 업로드하여 방을 생성하세요.",
    "이미지를 선택하지 않았습니다.": "이미지를 선택하지 않았습니다.",
    "JPG 또는 PNG 형식만 지원됩니다.": "JPG 또는 PNG 형식만 지원됩니다.",
    "이미지 데이터를 가져올 수 없습니다.": "이미지 데이터를 가져올 수 없습니다.",
    "메시지 형식의 스크린샷을 업로드해 주세요.": "메시지 형식의 스크린샷을 업로드해 주세요.",
    "방 이름 수정": "방 이름 수정",
    "이름을 입력해 주세요.": "이름을 입력해 주세요.",
    "대화 요약": "대화 요약",
    "대화 개선점": "대화 개선점",
    "추천 멘트": "추천 멘트",
    "기분 선택": "기분 선택",
    "대화를 분석하지 못했습니다.": "대화를 분석하지 못했습니다.",
    "분석 숨기기": "분석 숨기기",
    "더 자세히 보기": "더 자세히 보기",
    "상대방 분석": "상대방 분석",
    "이름": "이름",
    "말투": "말투",
    "호감도": "호감도",
    "잠재력": "잠재력",
    "의도": "의도",
    "희망": "희망",
    "위기": "위기",
    "MBTI": "MBTI",
    "시간에 따른 변화": "시간에 따른 변화",
    "내": "내",
    "상대방": "상대방",
    "매력": "매력",
    "화남": "화남",
    "신남": "신남",
    "궁금": "궁금",
    "진지": "진지",
    "장난": "장난",
    "슬픔": "슬픔",
    "chill가이": "chill가이",
    "시크": "시크",
    "위로": "위로",
    "분석 중": "분석 중",
    "시작": "시작",
    "초반": "초반",
    "중반": "중반",
    "최종": "최종",
    "흥미": "흥미",
    "애인": "애인",
    "썸": "썸",
    "직장 상사": "직장 상사",
    "부모님": "부모님",
    "어르신": "어르신",
    "싫어하는 사람": "싫어하는 사람",
    "모임": "모임",
    "사업": "사업",
    "일주일 / 5500원": "일주일 / 5500원",
    "마음을 전하는 길, 한 걸음 더 가까이": "마음을 전하는 길, 한 걸음 더 가까이",
    "무한 토독": "무한 토독",
    "무한 스크린샷": "무한 스크린샷",
    "광고 삭제": "광고 삭제",
    "프리미엄 기능": "프리미엄 기능",
    "구매": "구매",
    "결제가 완료되었습니다!": "결제가 완료되었습니다!",
    "이미 VIP 회원입니다!": "이미 VIP 회원입니다!",
    "이름 없음": "이름 없음",
    "대화 흐름 분석 실패.": "대화 흐름 분석 실패.",
    "대화 부족. 구체적 응답과 질문 필요.": "대화 부족. 구체적 응답과 질문 필요.",
    "알 수 없음": "알 수 없음",
    "의도 불명": "의도 불명",
    "대화 분석 실패.": "대화 분석 실패.",
    "상대방 관심 보여 대화 깊어질 가능성 높음.": "상대방 관심 보여 대화 깊어질 가능성 높음.",
    "내 느린 답변으로 대화 멈출 수 있음.": "내 느린 답변으로 대화 멈출 수 있음.",
    "분석 불가": "분석 불가",
    "대화가 부족해요. 상대방 말에 맞춰 구체적으로 답하고 질문을 던져보세요.": "대화가 부족해요. 상대방 말에 맞춰 구체적으로 답하고 질문을 던져보세요.",
    "응답을 생성하지 못했습니다.": "응답을 생성하지 못했습니다.",
    "추천 멘트 생성 중 오류가 발생했습니다:": "추천 멘트 생성 중 오류가 발생했습니다:",
    "하이라이트 이미지를 생성하지 못했습니다.": "하이라이트 이미지를 생성하지 못했습니다.",
    "분석 결과가 없어 추천 멘트를 생성할 수 없습니다.": "분석 결과가 없어 추천 멘트를 생성할 수 없습니다.",
    "필요한 권한이 없습니다. 설정에서 권한을 허용해주세요.": "필요한 권한이 없습니다. 설정에서 권한을 허용해주세요.",
    "오늘 무료 횟수를 다 사용했습니다.\n내일 다시 오세요!": "오늘 무료 횟수를 다 사용했습니다.\n내일 다시 오세요!",
    "이번 주 무료 횟수를 다 소진했습니다.\n다음 주에 다시 오세요!": "이번 주 무료 횟수를 다 소진했습니다.\n다음 주에 다시 오세요!",
    "최대 10개 방만 생성 가능합니다.": "최대 10개 방만 생성 가능합니다.",
    "VIP 전용입니다": "VIP 전용입니다",
    "최대 3개 방만 동시에 분석 가능합니다.": "최대 3개 방만 동시에 분석 가능합니다.",
    "기쁨": "기쁨",
    "불안": "불안",
    "짜증": "짜증",
    "평온": "평온",
    "친근함": "친근함",
    "연결 원함": "연결 원함"
  };
  late ValueNotifier<bool> _themeNotifier;
  late ValueNotifier<bool> _isVIPNotifier;
  late SharedPreferences prefs; // SharedPreferences 변수
  bool _isChangingLanguage = false;

  // 광고 관련 변수
  int _apiCallCount = 0; // API 호출 카운트
  InterstitialAd? _interstitialAd; // 전면 광고 객체
  static const int _adThreshold = 1; //

  Map<String, String> get translations => _uiTexts;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _loadInitialLanguage();
    _themeNotifier = ValueNotifier<bool>(false);
    _isVIPNotifier = ValueNotifier<bool>(false);
    _loadTheme();
    _loadVIPStatus();
    _translateUI();
    _loadInterstitialAd();
    _loadApiCallCount();
  }

  // SharedPreferences 초기화 메서드 추가
  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadInitialLanguage() async {
    try {
      await _initPrefs();
      String? savedLang = prefs.getString('language');
      String deviceLang = Platform.localeName.split('_')[0];
      debugPrint('디바이스 언어: $deviceLang');

      const supportedLangs = ['ko', 'en', 'ja', 'zh', 'hi'];
      String initialLang = supportedLangs.contains(deviceLang) ? deviceLang : 'en';

      if (savedLang != null && supportedLangs.contains(savedLang)) {
        _currentLanguage = savedLang;
      } else {
        _currentLanguage = initialLang;
      }

      debugPrint('적용된 언어: $_currentLanguage');

      if (mounted) {
        setState(() {});
        context.setLocale(Locale(_currentLanguage));
      }
    } catch (e) {
      debugPrint('언어 로드 오류: $e');
      if (mounted) {
        setState(() {
          _currentLanguage = 'en';
        });
        context.setLocale(Locale(_currentLanguage));
      }
    }
  }

  Future<void> _loadTheme() async {
    try {
      await _initPrefs();
      bool? savedTheme = prefs.getBool('isDarkTheme');
      if (mounted) {
        _themeNotifier.value = savedTheme ?? false;
      }
    } catch (e) {
      debugPrint('테마 로드 오류: $e');
    }
  }

  Future<void> _updateTheme(bool isDarkTheme) async {
    try {
      if (mounted) {
        _themeNotifier.value = isDarkTheme;
        await prefs.setBool('isDarkTheme', isDarkTheme);
      }
    } catch (e) {
      debugPrint('테마 업데이트 오류: $e');
    }
  }

  Future<void> _loadVIPStatus() async {
    try {
      await _initPrefs();
      bool? savedVIPStatus = prefs.getBool('isVIP');
      if (mounted) {
        _isVIPNotifier.value = savedVIPStatus ?? false;
      }
    } catch (e) {
      debugPrint('VIP 상태 로드 오류: $e');
    }
  }

  Future<void> _updateVIPStatus(bool isVIP) async {
    try {
      if (mounted) {
        _isVIPNotifier.value = isVIP;
        await prefs.setBool('isVIP', isVIP);
        if (isVIP) {
          await prefs.setInt('toedokCountToday', 0);
          await prefs.setInt('screenshotCountToday', 0);
          await prefs.setInt('rerollCountToday', 0);
        }
        setState(() {});
      }
    } catch (e) {
      debugPrint('VIP 상태 업데이트 오류: $e');
    }
  }

  Future<void> _changeLanguage(String lang) async {
    if (_isChangingLanguage || !mounted) return;

    debugPrint('언어 변경 시도: $lang');
    setState(() {
      _isChangingLanguage = true;
    });

    try {
      await prefs.setString('language', lang);
      _currentLanguage = lang;
      await context.setLocale(Locale(lang));
      if (mounted) {
        setState(() {
          _isChangingLanguage = false;
        });
        Phoenix.rebirth(context);
      }
    } catch (e) {
      debugPrint('언어 변경 중 오류: $e');
      if (mounted) {
        setState(() {
          _isChangingLanguage = false;
        });
      }
    }
  }

  Future<void> _translateUI() async {
    if (mounted) {
      setState(() {});
    }
  }

  // API 호출 카운트 로드
  Future<void> _loadApiCallCount() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString('apiCallLastResetDate');
    final today = DateTime.now();
    if (lastReset != null && !_isSameDay(DateTime.parse(lastReset), today)) {
      await prefs.setString('apiCallLastResetDate', today.toIso8601String());
      await prefs.setInt('apiCallCount', 0);
      _apiCallCount = 0;
    } else {
      _apiCallCount = prefs.getInt('apiCallCount') ?? 0;
    }
    debugPrint('API 호출 카운트 로드: $_apiCallCount');
  }

  // 날짜 비교 헬퍼 메서드
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  // 광고 로드 메서드
  void _loadInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.dispose();
      _interstitialAd = null;
    }

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // 테스트 광고 ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('전면 광고 로드 완료');
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('전면 광고 닫힘');
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('전면 광고 표시 실패: $error');
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('전면 광고 로드 실패: $error');
          _interstitialAd = null;
          Future.delayed(const Duration(seconds: 5), _loadInterstitialAd);
        },
      ),
    );
  }

  // API 호출 카운트 증가 및 광고 표시
  Future<void> incrementApiCallCount(bool isVIP) async {
    if (isVIP) {
      debugPrint('VIP 사용자: 광고 표시 및 카운트 증가 스킵');
      return;
    }

    _apiCallCount++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('apiCallCount', _apiCallCount);
    debugPrint('API 호출 카운트 증가: $_apiCallCount');

    // 광고가 이미 로드된 경우 표시
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
      debugPrint('무료 사용자: API 1회 호출마다 전면 광고 표시: 카운트=$_apiCallCount');
    } else {
      debugPrint('광고 표시 실패: 광고가 로드되지 않음, 재로드 시도');
      _loadInterstitialAd();
    }
  }

  @override
Widget build(BuildContext context) {
  return ValueListenableBuilder<bool>(
    valueListenable: _themeNotifier,
    builder: (context, isDarkTheme, child) {
      return ValueListenableBuilder<bool>(
        valueListenable: _isVIPNotifier,
        builder: (context, isVIP, child) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: isDarkTheme
                ? ThemeData(
                    scaffoldBackgroundColor: const Color(0xFF2C2C2C).withOpacity(0.95),
                    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    cardTheme: CardThemeData(
                      color: Colors.black.withOpacity(0.9),
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                    ),
                    textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
                    dialogBackgroundColor: Colors.black.withOpacity(0.95),
                    hintColor: Colors.white70,
                  )
                : ThemeData.dark().copyWith(
                    scaffoldBackgroundColor: const Color(0xFFF2F4FF).withOpacity(0.95),
                    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    cardTheme: CardThemeData(
                      color: Colors.white.withOpacity(0.9),
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                    ),
                    textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
                    dialogBackgroundColor: Colors.white.withOpacity(0.95),
                    hintColor: Colors.grey,
                  ),
            home: SplashScreen(
              onLanguageChanged: _changeLanguage,
              currentLanguage: _currentLanguage,
              translations: _uiTexts,
              isVIP: isVIP,
              onVIPStatusChanged: _updateVIPStatus,
              isDarkTheme: isDarkTheme,
              onThemeChanged: _updateTheme,
            ),
          );
        },
      );
    },
  );
}
}

class SplashScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;
  final String currentLanguage;
  final Map<String, String> translations;
  final bool isVIP;
  final Function(bool) onVIPStatusChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const SplashScreen({
    super.key,
    required this.onLanguageChanged,
    required this.currentLanguage,
    required this.translations,
    required this.isVIP,
    required this.onVIPStatusChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  late SharedPreferences prefs;
  bool _hasSeenTutorial = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/splash_video.mp4');
    _loadTutorialStatus();
    _startVideo();
  }

  Future<void> _loadTutorialStatus() async {
    prefs = await SharedPreferences.getInstance();
    bool? hasSeen = prefs.getBool('hasSeenTutorial');
    if (mounted) {
      setState(() {
        _hasSeenTutorial = hasSeen ?? false;
      });
    }
  }

  Future<void> _startVideo() async {
    try {
      await _controller.initialize().timeout(const Duration(seconds: 3));
      if (mounted) {
        setState(() => _isInitialized = true);
        _controller.play().then((_) {
          _controller.addListener(() {
            if (_controller.value.position >= _controller.value.duration && mounted) {
              _moveToNextScreen();
            }
          });
        }).catchError((e) {
          debugPrint("비디오 재생 오류: $e");
          if (mounted) _moveToNextScreen();
        });
        Timer(const Duration(seconds: 5), () {
          if (!_controller.value.isPlaying && mounted) _moveToNextScreen();
        });
      }
    } catch (e) {
      debugPrint("비디오 초기화 오류: $e");
      if (mounted) _moveToNextScreen();
    }
  }

  void _moveToNextScreen() {
    if (mounted) {
      if (!_hasSeenTutorial) {
        prefs.setBool('hasSeenTutorial', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TutorialScreen(
              onLanguageChanged: widget.onLanguageChanged,
              currentLanguage: widget.currentLanguage,
              translations: widget.translations,
              isVIP: widget.isVIP,
              onVIPStatusChanged: widget.onVIPStatusChanged,
              isDarkTheme: widget.isDarkTheme,
              onThemeChanged: widget.onThemeChanged,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(
              onLanguageChanged: widget.onLanguageChanged,
              currentLanguage: widget.currentLanguage,
              translations: widget.translations,
              isVIP: widget.isVIP,
              onVIPStatusChanged: widget.onVIPStatusChanged,
              isDarkTheme: widget.isDarkTheme,
              onThemeChanged: widget.onThemeChanged,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkTheme ? const Color(0xFF2C2C2C) : const Color(0xFFF2F4FF),
      body: Center(
        child: _isInitialized
            ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF7539BB)),
                  const SizedBox(height: 16),
                  Text(
                    "로딩 중...".tr(),
                    style: TextStyle(
                      color: widget.isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 16,
                      wordSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}

class TutorialScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;
  final String currentLanguage;
  final Map<String, String> translations;
  final bool isVIP;
  final Function(bool) onVIPStatusChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const TutorialScreen({
    super.key,
    required this.onLanguageChanged,
    required this.currentLanguage,
    required this.translations,
    required this.isVIP,
    required this.onVIPStatusChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> with TickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<double> _colorAnimation;
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;
  late PageController _pageController;
  int _currentPage = 0;

  List<Color> gradientColors = [
    const Color(0xFFC56BFF),
    const Color(0xFFA95EFF),
    const Color(0xFF8C52FF),
    const Color(0xFF6F46FF),
    const Color(0xFF5C38A0),
  ];

  List<String> get tutorialImages {
    return List.generate(5, (index) => 'assets/tutorials/${widget.currentLanguage}/tutorial${index + 1}.jpg');
  }

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    _colorAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _colorController, curve: Curves.easeInOut));
    _buttonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _buttonScale = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut));
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _colorController.dispose();
    _buttonController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < tutorialImages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(
            onLanguageChanged: widget.onLanguageChanged,
            currentLanguage: widget.currentLanguage,
            translations: widget.translations,
            isVIP: widget.isVIP,
            onVIPStatusChanged: widget.onVIPStatusChanged,
            isDarkTheme: widget.isDarkTheme,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.findAncestorStateOfType<_MyAppState>()!._isVIPNotifier,
      builder: (context, isVIP, child) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: tutorialImages.length,
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Center(
                      key: ValueKey<int>(index),
                      child: Image.asset(
                        tutorialImages[index],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 50,
                child: Center(
                  child: GestureDetector(
                    onTapDown: (_) => _buttonController.forward(),
                    onTapUp: (_) {
                      _buttonController.reverse();
                      _onNextPressed();
                    },
                    onTapCancel: () => _buttonController.reverse(),
                    child: ScaleTransition(
                      scale: _buttonScale,
                      child: AnimatedBuilder(
                        animation: _colorAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 220,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                                end: Alignment.bottomRight.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                                colors: gradientColors,
                                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              "NEXT",
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600, wordSpacing: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;
  final String currentLanguage;
  final Map<String, String> translations;
  final bool isVIP;
  final Function(bool) onVIPStatusChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const WelcomeScreen({
    super.key,
    required this.onLanguageChanged,
    required this.currentLanguage,
    required this.translations,
    required this.isVIP,
    required this.onVIPStatusChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<double> _colorAnimation;
  late AnimationController _tapController;
  late Animation<double> _tapScale;
  late AnimationController _screenshotTapController;
  late Animation<double> _screenshotTapScale;
  late AnimationController _textColorController;
  late Animation<double> _textColorAnimation;
  late AnimationController _vipColorController;
  late Animation<double> _vipColorAnimation;
  List<Color> gradientColors = [
    const Color(0xFFC56BFF),
    const Color(0xFFA95EFF),
    const Color(0xFF8C52FF),
    const Color(0xFF6F46FF),
    const Color(0xFF5C38A0),
  ];

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  bool _isPurchasing = false;
  String? _purchaseError;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    _colorAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _colorController, curve: Curves.easeInOut));
    _tapController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _tapScale = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _tapController, curve: Curves.easeInOut));
    _screenshotTapController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _screenshotTapScale = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _screenshotTapController, curve: Curves.easeInOut));
    _textColorController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    _textColorAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(parent: _textColorController, curve: Curves.easeInOut));
    _vipColorController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    _vipColorAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _vipColorController, curve: Curves.easeInOut));
    _initializeInAppPurchase();
    _restoreVipStatus(); // 기존 호출 유지
  }

  // 새 메서드 추가: VIP 상태 저장
  Future<void> _saveVipStatus(bool isVip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVIP', isVip);
    debugPrint("VIP 상태 저장: $isVip");
  }

  // 새 메서드 추가: VIP 상태 복원
  Future<void> _restoreVipStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isVip = prefs.getBool('isVIP') ?? false;
      if (isVip) {
        widget.onVIPStatusChanged(true);
        debugPrint("로컬에서 VIP 상태 복원 성공");
        return;
      }
      // Google Play 및 Apple Store에서 구매 내역 복원
      await _inAppPurchase.restorePurchases();
      debugPrint("restorePurchases 호출 완료");
    } catch (e) {
      debugPrint("구매 복원 오류: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "구매 복원 실패, 잠시 후 다시 시도해주세요.",
              style: TextStyle(fontSize: 15, wordSpacing: 1.5),
              maxLines: 2,
            ),
          ),
        );
      }
    }
  }

  // 기존 메서드들 (수정된 인앱 결제 로직 포함)
  Future<void> _initializeInAppPurchase() async {
    debugPrint("Initializing InAppPurchase...");
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!mounted) return;

    setState(() {
      _isAvailable = isAvailable;
    });

    if (!isAvailable) {
      debugPrint("InAppPurchase 사용 불가");
      if (mounted) {
        setState(() {
          _purchaseError = "결제 서비스를 사용할 수 없습니다.".tr();
        });
      }
      return;
    }

    const Set<String> _kProductIds = {'toedok_vip_subscription'};
    debugPrint("Querying product details for: $_kProductIds");
    final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kProductIds);
    if (!mounted) return;

    if (productDetailResponse.error != null) {
      debugPrint("상품 조회 오류: ${productDetailResponse.error}");
      if (mounted) {
        setState(() {
          _purchaseError = "상품 정보를 불러오는 데 실패했습니다: ${productDetailResponse.error?.message}".tr();
        });
      }
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      debugPrint("등록된 상품이 없습니다.");
      if (mounted) {
        setState(() {
          _purchaseError = "등록된 상품이 없습니다.".tr();
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _products = productDetailResponse.productDetails;
        debugPrint("상품 조회 성공: ${_products.map((p) => p.id).join(', ')}");
      });
    }

    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        debugPrint("Purchase stream closed");
        _subscription.cancel();
      },
      onError: (error) {
        debugPrint("구매 스트림 오류: $error");
        if (mounted) {
          setState(() {
            _purchaseError = "구매 처리 중 오류가 발생했습니다: $error".tr();
          });
        }
      },
      cancelOnError: false,
    );

    debugPrint("Restoring previous purchases...");
    await _inAppPurchase.restorePurchases();
  }

  Future<bool> verifyPurchase(String purchaseToken, String productId, String packageName) async {
    if (Platform.isAndroid) {
      final String verifyPurchaseApiUrl = 'https://us-central1-toedok-new.cloudfunctions.net/verifyPurchaseV2';
      final client = http.Client();
      try {
        final response = await client.post(
          Uri.parse(verifyPurchaseApiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'purchaseToken': purchaseToken,
            'productId': productId,
            'packageName': packageName,
          }),
        );
        debugPrint('Verify Purchase Request (Android): purchaseToken=$purchaseToken, productId=$productId, packageName=$packageName');
        debugPrint('Verify Purchase Response (Android): ${response.statusCode} - ${response.body}');
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['isValid'] == true;
        } else {
          debugPrint('구매 검증 실패 (Android): ${response.statusCode} - ${response.body}');
          return false;
        }
      } catch (e) {
        debugPrint('구매 검증 오류 (Android): $e');
        return false;
      } finally {
        client.close();
      }
    } else if (Platform.isIOS) {
      return await verifyApplePurchase(purchaseToken);
    }
    return false;
  }

  Future<bool> verifyApplePurchase(String receiptData) async {
    final String verifyApplePurchaseApiUrl = 'https://us-central1-toedok-new.cloudfunctions.net/verifyApplePurchase';
    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse(verifyApplePurchaseApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'receiptData': receiptData,
          'productId': 'toedok_vip_subscription',
        }),
      );
      debugPrint('Verify Apple Purchase Request: receiptData=$receiptData');
      debugPrint('Verify Apple Purchase Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isValid'] == true;
      } else {
        debugPrint('애플 구매 검증 실패: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('애플 구매 검증 오류: $e');
      return false;
    } finally {
      client.close();
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    debugPrint("Purchase updated: ${purchaseDetailsList.length} items");
    if (purchaseDetailsList.isEmpty) return;

    for (final purchaseDetails in purchaseDetailsList) {
      debugPrint("Purchase status: ${purchaseDetails.status}, ID: ${purchaseDetails.productID}");

      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint("구매 진행 중: ${purchaseDetails.productID}");
        if (mounted) {
          setState(() {
            _isPurchasing = true;
          });
        }
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint("구매 오류: ${purchaseDetails.error?.message}");
          if (mounted) {
            setState(() {
              _isPurchasing = false;
              _purchaseError = "구매 중 오류가 발생했습니다: ${purchaseDetails.error?.message}".tr();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _purchaseError!,
                  style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
                  maxLines: 1,
                ),
              ),
            );
          }
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          debugPrint("구매 성공 또는 복원: ${purchaseDetails.productID}");
          String? verificationData;
          if (Platform.isAndroid) {
            verificationData = purchaseDetails.verificationData.serverVerificationData;
          } else if (Platform.isIOS) {
            final appStorePurchaseDetails = purchaseDetails as AppStorePurchaseDetails;
            verificationData = appStorePurchaseDetails.verificationData.serverVerificationData;
          }

          if (verificationData == null || verificationData.isEmpty) {
            debugPrint('구매 검증 실패: verificationData가 없습니다.');
            if (mounted) {
              setState(() {
                _isPurchasing = false;
                _purchaseError = "구매 검증에 실패했습니다.".tr();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _purchaseError!,
                    style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
                    maxLines: 1,
                  ),
                ),
              );
            }
            continue;
          }

          bool valid;
          if (Platform.isAndroid) {
            valid = await verifyPurchase(
              verificationData,
              purchaseDetails.productID,
              'com.toedok',
            );
          } else {
            valid = await verifyApplePurchase(verificationData);
          }

          if (valid) {
            debugPrint("구매 검증 성공: ${purchaseDetails.productID}");
            widget.onVIPStatusChanged(true);
            await _saveVipStatus(true); // VIP 상태 저장
            if (!mounted) return;
            setState(() {
              _isPurchasing = false;
              _purchaseError = null;
            });

            final prefs = await SharedPreferences.getInstance();
            bool hasShownPurchaseSuccess = prefs.getBool('hasShownPurchaseSuccess') ?? false;
            if (!hasShownPurchaseSuccess && purchaseDetails.status == PurchaseStatus.purchased) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Payment Successful",
                    style: TextStyle(fontSize: 15, wordSpacing: 1.5),
                    maxLines: 1,
                  ),
                ),
              );
              await prefs.setBool('hasShownPurchaseSuccess', true);
              debugPrint("결제 성공 팝업 표시 완료, SharedPreferences에 저장");
            } else {
              debugPrint("이미 결제 성공 팝업 표시됨 또는 복원, 팝업 스킵");
            }
          } else {
            debugPrint("구매 검증 실패: ${purchaseDetails.productID}");
            await _saveVipStatus(false); // VIP 상태 해제
            if (mounted) {
              setState(() {
                _isPurchasing = false;
                _purchaseError = "구매 검증에 실패했습니다.".tr();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _purchaseError!,
                    style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
                    maxLines: 1,
                  ),
                ),
              );
            }
          }
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          debugPrint("구매 취소됨: ${purchaseDetails.productID}");
          await _saveVipStatus(false); // VIP 상태 해제
          if (mounted) {
            setState(() {
              _isPurchasing = false;
              _purchaseError = "구매가 취소되었습니다.".tr();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _purchaseError!,
                  style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
                  maxLines: 1,
                ),
              ),
            );
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          debugPrint("Completing purchase: ${purchaseDetails.productID}");
          await _inAppPurchase.completePurchase(purchaseDetails);
          debugPrint("Purchase completed: ${purchaseDetails.productID}");
        }
      }
    }
  }

  Future<void> _buyVIPSubscription() async {
    if (_isPurchasing || !_isAvailable || _products.isEmpty) {
      debugPrint("구매 불가: _isPurchasing=$_isPurchasing, _isAvailable=$_isAvailable, _products=${_products.length}");
      if (mounted) {
        setState(() {
          _purchaseError = "현재 구매를 진행할 수 없습니다.".tr();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _purchaseError!,
              style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
              maxLines: 1,
            ),
          ),
        );
      }
      return;
    }

    final ProductDetails productDetails = _products.firstWhere(
      (product) => product.id == 'toedok_vip_subscription',
      orElse: () {
        debugPrint("상품을 찾을 수 없음: toedok_vip_subscription");
        if (mounted) {
          setState(() {
            _purchaseError = "구매할 상품을 찾을 수 없습니다.".tr();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _purchaseError!,
                style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
                maxLines: 1,
              ),
            ),
          );
        }
        throw Exception("상품을 찾을 수 없습니다");
      },
    );

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: null,
    );

    setState(() {
      _isPurchasing = true;
      _purchaseError = null;
    });

    try {
      debugPrint("Starting purchase for: ${productDetails.id}");
      if (Platform.isIOS) {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
      debugPrint("Purchase initiated successfully");
    } catch (e) {
      debugPrint("구매 실패: $e");
      if (!mounted) return;
      setState(() {
        _isPurchasing = false;
        _purchaseError = "구매 중 오류가 발생했습니다: $e".tr();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _purchaseError!,
            style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
            maxLines: 1,
          ),
        ),
      );
    }
  }

  void _showVIPDialog() async {
    if (_products.isEmpty) {
      await _initializeInAppPurchase();
    }
    final isDarkTheme = context.findAncestorStateOfType<_MyAppState>()!._themeNotifier.value;
    final isVIP = context.findAncestorStateOfType<_MyAppState>()!._isVIPNotifier.value;
    showDialog(
      context: context,
      builder: (context) {
        final productDetails = _products.firstWhereOrNull((p) => p.id == 'toedok_vip_subscription');
        if (productDetails == null) {
          debugPrint("ProductDetails not found for toedok_vip_subscription");
          return const Center(child: CircularProgressIndicator(color: Color(0xFF7539BB)));
        }
        debugPrint("ProductDetails: ${productDetails.id}, Price: ${productDetails.price}, Currency: ${productDetails.currencyCode}");
        try {
          return AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return AlertDialog(
                backgroundColor: isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.all(20),
                title: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                      end: Alignment.bottomRight.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                      colors: gradientColors,
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkTheme ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: const Text(
                    'VIP',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22, wordSpacing: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeText(
                        "마음을 전하는 길, 한 걸음 더 가까이".tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: isDarkTheme ? const Color(0xFFC56BFF) : const Color(0xFF7539BB),
                          wordSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        minFontSize: 8,
                        maxFontSize: 16,
                        stepGranularity: 0.1,
                      ),
                      const SizedBox(height: 16),
                      _buildVIPOption(
                        benefits: [
                          "무한 토독".tr(),
                          "무한 스크린샷".tr(),
                          "광고 삭제".tr(),
                          "프리미엄 기능".tr(),
                        ],
                        onTap: isVIP || _isPurchasing
                            ? null
                            : () async {
                                Navigator.pop(context);
                                await _buyVIPSubscription();
                              },
                        isDarkTheme: isDarkTheme,
                        productDetails: productDetails,
                      ),
                      if (isVIP)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            "이미 VIP 회원입니다!".tr(),
                            style: TextStyle(color: isDarkTheme ? Colors.white70 : Colors.black54, fontSize: 14, wordSpacing: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "취소".tr(),
                      style: TextStyle(color: isDarkTheme ? Colors.white : Colors.red, fontSize: 16, wordSpacing: 1.5),
                    ),
                  ),
                ],
              );
            },
          );
        } catch (e, stackTrace) {
          debugPrint("Error in _showVIPDialog: $e\n$stackTrace");
          return const Center(child: Text("오류 발생, 잠시 후 다시 시도해주세요."));
        }
      },
    );
  }

  Widget _buildVIPOption({
    required List<String> benefits,
    required VoidCallback? onTap,
    required bool isDarkTheme,
    required ProductDetails productDetails,
  }) {
    String dynamicPrice = "1 Week / ${productDetails.price}";
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkTheme ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFC56BFF), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dynamicPrice,
              style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w300, wordSpacing: 1.5),
            ),
            const SizedBox(height: 12),
            ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ShaderMask(
                    shaderCallback: (bounds) => isDarkTheme
                        ? const LinearGradient(
                            colors: [Color(0xFFC56BFF), Color(0xFFC56BFF)],
                          ).createShader(bounds)
                        : LinearGradient(
                            colors: gradientColors,
                            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          ).createShader(bounds),
                    child: Text(
                      '- $benefit',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        wordSpacing: 1.5,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: onTap != null ? LinearGradient(colors: gradientColors) : null,
                  color: onTap == null ? Colors.grey : null,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkTheme ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "구매".tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, wordSpacing: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return ValueListenableBuilder<bool>(
    valueListenable: context.findAncestorStateOfType<_MyAppState>()!._themeNotifier,
    builder: (context, isDarkTheme, child) {
      return ValueListenableBuilder<bool>(
        valueListenable: context.findAncestorStateOfType<_MyAppState>()!._isVIPNotifier,
        builder: (context, isVIP, child) {
          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(isDarkTheme ? "assets/main screen2.jpg" : "assets/main screen.jpg"),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                            debugPrint('테마 이미지 로드 실패: $exception');
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 25,
                      child: GestureDetector(
                        onTap: () => Scaffold.of(context).openEndDrawer(),
                        child: Icon(
                          Icons.menu,
                          color: isDarkTheme ? Colors.white : Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewPadding.bottom + 12, // 내비게이션 바 위 12px
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTapDown: (_) => _screenshotTapController.forward(),
                              onTapUp: (_) {
                                _screenshotTapController.reverse();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreenshotScreen(
                                      onLanguageChanged: widget.onLanguageChanged,
                                      currentLanguage: widget.currentLanguage,
                                      translations: widget.translations,
                                      isVIP: isVIP,
                                      onVIPStatusChanged: widget.onVIPStatusChanged,
                                      isDarkTheme: isDarkTheme,
                                      onThemeChanged: widget.onThemeChanged,
                                      onShowVIPDialog: _showVIPDialog,
                                    ),
                                  ),
                                );
                              },
                              onTapCancel: () => _screenshotTapController.reverse(),
                              child: AnimatedBuilder(
                                animation: Listenable.merge([_colorAnimation, _screenshotTapScale]),
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _screenshotTapScale.value,
                                    child: Container(
                                      width: 236,
                                      height: 60,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                                          end: Alignment.bottomRight.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                                          colors: gradientColors,
                                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x3F000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: AutoSizeText(
                                          'SCREEN SHOT',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            height: 1,
                                            wordSpacing: 1.5,
                                          ),
                                          minFontSize: 24,
                                          maxFontSize: 48,
                                          stepGranularity: 0.1,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTapDown: (_) => _tapController.forward(),
                              onTapUp: (_) {
                                _tapController.reverse();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(
                                      onLanguageChanged: widget.onLanguageChanged,
                                      currentLanguage: widget.currentLanguage,
                                      translations: widget.translations,
                                      isVIP: isVIP,
                                      onVIPStatusChanged: widget.onVIPStatusChanged,
                                      isDarkTheme: isDarkTheme,
                                      onThemeChanged: widget.onThemeChanged,
                                      onShowVIPDialog: _showVIPDialog,
                                    ),
                                  ),
                                );
                              },
                              onTapCancel: () => _tapController.reverse(),
                              child: AnimatedBuilder(
                                animation: Listenable.merge([_colorAnimation, _tapScale]),
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _tapScale.value,
                                    child: Container(
                                      width: 236,
                                      height: 46,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                                          end: Alignment.bottomRight.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                                          colors: gradientColors,
                                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x3F000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: AutoSizeText(
                                          'TOEDOK',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            height: 1,
                                            wordSpacing: 1.5,
                                          ),
                                          minFontSize: 24,
                                          maxFontSize: 48,
                                          stepGranularity: 0.1,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            endDrawer: Drawer(
              width: 250,
              backgroundColor: isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
              elevation: 8,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AnimatedBuilder(
                          animation: _vipColorAnimation,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                begin: Alignment.topLeft.add(Alignment(_vipColorAnimation.value * 2 - 1, _vipColorAnimation.value * 2 - 1)),
                                end: Alignment.bottomRight.add(Alignment(_vipColorAnimation.value * 2 - 1, _vipColorAnimation.value * 2 - 1)),
                                colors: gradientColors,
                                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                              ).createShader(bounds),
                              child: Text(
                                isVIP ? 'VIP' : '',
                                style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, wordSpacing: 1.5),
                              ),
                            );
                          },
                        ),
                      ),
                      _buildDrawerItem(
                        text: "VIP".tr(),
                        onTap: () {
                          Navigator.pop(context);
                          _showVIPDialog();
                        },
                        isDarkTheme: isDarkTheme,
                      ),
                      _buildDrawerItem(
                        text: "튜토리얼".tr(),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TutorialScreen(
                                onLanguageChanged: widget.onLanguageChanged,
                                currentLanguage: widget.currentLanguage,
                                translations: widget.translations,
                                isVIP: isVIP,
                                onVIPStatusChanged: widget.onVIPStatusChanged,
                                isDarkTheme: isDarkTheme,
                                onThemeChanged: widget.onThemeChanged,
                              ),
                            ),
                          );
                        },
                        isDarkTheme: isDarkTheme,
                      ),
                      _buildDrawerItem(
                        text: _getLanguageButtonText(),
                        onTap: () {
                          Navigator.pop(context);
                          _showLanguageSelectionDialog(context);
                        },
                        isDarkTheme: isDarkTheme,
                      ),
                      _buildDrawerItemWithSwitch(
                        text: "테마".tr(),
                        value: isDarkTheme,
                        onChanged: (value) {
                          widget.onThemeChanged(value);
                          debugPrint("테마 변경 상태: $value");
                        },
                        isDarkTheme: isDarkTheme,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

  String _getLanguageButtonText() {
    final languages = {
      'ko': '한국어',
      'ja': '日本語',
      'en': 'English',
      'zh': '普通话',
      'hi': 'हिन्दी',
    };
    return '${"언어 설정".tr()}: ${languages[widget.currentLanguage] ?? '한국어'}';
  }

  Widget _buildDrawerItem({required String text, required VoidCallback onTap, required bool isDarkTheme}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkTheme ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkTheme ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isDarkTheme ? Colors.white : const Color(0xFF7539BB),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              wordSpacing: 1.5,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItemWithSwitch({required String text, required bool value, required ValueChanged<bool> onChanged, required bool isDarkTheme}) {
    double fontSize = text.length > 15 ? 14 : 16;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkTheme ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkTheme ? Colors.white : const Color(0xFF7539BB),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isDarkTheme ? Colors.white : const Color(0xFF7539BB),
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              wordSpacing: 1.5,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: isDarkTheme ? Colors.white : const Color(0xFF7539BB),
            inactiveTrackColor: isDarkTheme ? Colors.grey[700] : Colors.grey[400],
            activeTrackColor: isDarkTheme ? Colors.white70 : const Color(0xFFC5A9E6),
            thumbColor: WidgetStateProperty.all(isDarkTheme ? Colors.black : Colors.white),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    final languages = {
      'ko': '한국어',
      'ja': '日本語',
      'en': 'English',
      'zh': '普通话',
      'hi': 'हिन्दी',
    };

    showDialog(
      context: context,
      builder: (context) => ValueListenableBuilder<bool>(
        valueListenable: context.findAncestorStateOfType<_MyAppState>()!._themeNotifier,
        builder: (context, isDarkTheme, child) {
          return AlertDialog(
            backgroundColor: isDarkTheme ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              "언어 설정".tr(),
              style: TextStyle(
                color: isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                fontWeight: FontWeight.bold,
                wordSpacing: 1.5,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "언어를 변경하면 잠시 후 앱이 재시작됩니다.".tr(),
                    style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black87, fontSize: 14, wordSpacing: 1.5),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        final entry = languages.entries.elementAt(index);
                        return ListTile(
                          title: Text(
                            entry.value,
                            style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black87, wordSpacing: 1.5),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          onTap: () async {
                            debugPrint('언어 선택: ${entry.key}');
                            await widget.onLanguageChanged(entry.key);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  debugPrint('언어 선택 취소');
                  Navigator.pop(context);
                },
                child: Text(
                  "취소".tr(),
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                    wordSpacing: 1.5,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _colorController.dispose();
    _tapController.dispose();
    _screenshotTapController.dispose();
    _textColorController.dispose();
    _vipColorController.dispose();
    _subscription.cancel();
    super.dispose();
  }
}

class MainScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;
  final String currentLanguage;
  final Map<String, String> translations;
  final bool isVIP;
  final Function(bool) onVIPStatusChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;
  final VoidCallback onShowVIPDialog;

  const MainScreen({
    super.key,
    required this.onLanguageChanged,
    required this.currentLanguage,
    required this.translations,
    required this.isVIP,
    required this.onVIPStatusChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
    required this.onShowVIPDialog,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List<ChatScreen> chatScreens = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late AnimationController _colorController;
  late Animation<double> _colorAnimation;
  late AnimationController _fabController;
  late Animation<double> _fabScale;
  List<AnimationController> _tapControllers = [];
  List<Animation<double>> _tapScales = [];
  List<Color> gradientColors = [
    const Color(0xFFC56BFF),
    const Color(0xFFA95EFF),
    const Color(0xFF8C52FF),
    const Color(0xFF6F46FF),
    const Color(0xFF5C38A0),
  ];

  final Map<String, IconData> roleIcons = {
    '애인': Icons.favorite,
    '직장 상사': Icons.work,
    '부모님': Icons.family_restroom,
    '어르신': Icons.elderly,
    '썸': Icons.favorite_border,
    '싫어하는 사람': Icons.block,
    '모임': Icons.people,
    '사업': Icons.business,
  };

  final List<String> roles = ['애인', '직장 상사', '부모님', '어르신', '썸', '싫어하는 사람', '모임', '사업'];

  @override
  void initState() {
    super.initState();
    _loadChats();
    _colorController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    _colorAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _colorController, curve: Curves.easeInOut));
    _fabController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _fabScale = Tween<double>(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _colorController.dispose();
    _fabController.dispose();
    for (var controller in _tapControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _loadChats() async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? savedChatNames = prefs.getStringList('chatNames');
    final List<String>? savedChatRoles = prefs.getStringList('chatRoles');
    if (savedChatNames != null && savedChatRoles != null && savedChatNames.length == savedChatRoles.length && mounted) {
      setState(() {
        chatScreens = List.generate(savedChatNames.length, (index) => ChatScreen(
          key: ValueKey(savedChatNames[index]),
          name: savedChatNames[index],
          selectedRole: savedChatRoles[index],
          onLanguageChanged: widget.onLanguageChanged,
          currentLanguage: widget.currentLanguage,
          translations: widget.translations,
          isVIP: widget.isVIP,
          onVIPStatusChanged: widget.onVIPStatusChanged,
          isDarkTheme: widget.isDarkTheme,
          onThemeChanged: widget.onThemeChanged,
          onShowVIPDialog: widget.onShowVIPDialog,
        ));
                _tapControllers = List.generate(chatScreens.length, (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 100)));
        _tapScales = List.generate(chatScreens.length, (index) => Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _tapControllers[index], curve: Curves.easeInOut)));
      });
    }
  }

  void _saveChats() async {
    final SharedPreferences prefs = await _prefs;
    final chatNames = chatScreens.map((chat) => chat.name).toList();
    final chatRoles = chatScreens.map((chat) => chat.selectedRole).toList();
    await prefs.setStringList('chatNames', chatNames);
    await prefs.setStringList('chatRoles', chatRoles);
  }

  void _createNewChat() {
    if (chatScreens.length >= 10) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "대화방은 최대 10개까지 생성 가능합니다!".tr(),
              style: const TextStyle(wordSpacing: 1.5),
            ),
          ),
        );
      }
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        String selectedRole = '애인';
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(
              "대화방 생성".tr(),
              style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
            ),
            backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "대화방 이름을 입력하세요".tr(),
                    hintStyle: TextStyle(color: widget.isDarkTheme ? Colors.white70 : Colors.grey, wordSpacing: 1.5),
                  ),
                  style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedRole,
                  dropdownColor: widget.isDarkTheme ? Colors.black : Colors.white,
                  items: roles.map((role) {
                    final isLocked = !widget.isVIP && ['썸', '싫어하는 사람', '모임', '사업'].contains(role);
                    return DropdownMenuItem(
                      value: role,
                      enabled: !isLocked,
                      child: Row(
                        children: [
                          Icon(
                            roleIcons[role],
                            color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            role.tr(),
                            style: TextStyle(
                              color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                              wordSpacing: 1.5,
                            ),
                          ),
                          if (isLocked) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.lock, size: 16, color: Colors.grey),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    final isLocked = !widget.isVIP && ['썸', '싫어하는 사람', '모임', '사업'].contains(value);
                    if (isLocked) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
                          title: Text(
                            "VIP 전용입니다".tr(),
                            style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onShowVIPDialog();
                              },
                              child: Text(
                                "확인".tr(),
                                style: TextStyle(color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB), wordSpacing: 1.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      setDialogState(() => selectedRole = value);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final newName = nameController.text.trim();
                  if (newName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "대화방 이름을 입력해 주세요!".tr(),
                          style: const TextStyle(wordSpacing: 1.5),
                        ),
                      ),
                    );
                    return;
                  }
                  if (chatScreens.any((chat) => chat.name == newName)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "이미 존재하는 대화방 이름입니다! 다른 이름을 입력해 주세요.".tr(),
                          style: const TextStyle(wordSpacing: 1.5),
                        ),
                      ),
                    );
                    return;
                  }
                  if (mounted) {
                    setState(() {
                      chatScreens.add(ChatScreen(
                        key: ValueKey(newName),
                        name: newName,
                        selectedRole: selectedRole,
                        onLanguageChanged: widget.onLanguageChanged,
                        currentLanguage: widget.currentLanguage,
                        translations: widget.translations,
                        isVIP: widget.isVIP,
                        onVIPStatusChanged: widget.onVIPStatusChanged,
                        isDarkTheme: widget.isDarkTheme,
                        onThemeChanged: widget.onThemeChanged,
                        onShowVIPDialog: widget.onShowVIPDialog,
                      ));
                      _tapControllers.add(AnimationController(vsync: this, duration: const Duration(milliseconds: 100)));
                      _tapScales.add(Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _tapControllers.last, curve: Curves.easeInOut)));
                      _saveChats();
                    });
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "확인".tr(),
                    style: const TextStyle(color: Colors.white, wordSpacing: 1.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteChat(int index) async {
    final SharedPreferences prefs = await _prefs;
    final chatName = chatScreens[index].name;
    await prefs.remove('${chatName}_examples');
    await prefs.remove('${chatName}_savedQuotes');
    if (mounted) {
      setState(() {
        chatScreens.removeAt(index);
        _tapControllers[index].dispose();
        _tapControllers.removeAt(index);
        _tapScales.removeAt(index);
        _saveChats();
      });
    }
  }

  void _renameChat(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController(text: chatScreens[index].name);
        return AlertDialog(
          title: Text(
            "대화방 이름 수정".tr(),
            style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
          ),
          backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "새로운 이름을 입력하세요".tr(),
              hintStyle: TextStyle(color: widget.isDarkTheme ? Colors.white70 : Colors.grey, wordSpacing: 1.5),
            ),
            style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "대화방 이름을 입력해 주세요!".tr(),
                        style: const TextStyle(wordSpacing: 1.5),
                      ),
                    ),
                  );
                  return;
                }
                if (chatScreens.asMap().entries.any((entry) => entry.key != index && entry.value.name == newName)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "이미 존재하는 대화방 이름입니다! 다른 이름을 입력해 주세요.".tr(),
                        style: const TextStyle(wordSpacing: 1.5),
                      ),
                    ),
                  );
                  return;
                }
                if (mounted) {
                  setState(() {
                    final oldName = chatScreens[index].name;
                    chatScreens[index] = ChatScreen(
                      key: ValueKey(newName),
                      name: newName,
                      selectedRole: chatScreens[index].selectedRole,
                      onLanguageChanged: widget.onLanguageChanged,
                      currentLanguage: widget.currentLanguage,
                      translations: widget.translations,
                      isVIP: widget.isVIP,
                      onVIPStatusChanged: widget.onVIPStatusChanged,
                      isDarkTheme: widget.isDarkTheme,
                      onThemeChanged: widget.onThemeChanged,
                      onShowVIPDialog: widget.onShowVIPDialog,
                    );
                    _saveChats();
                    SharedPreferences.getInstance().then((pref) async {
                      final examples = pref.getStringList('${oldName}_examples');
                      final quotes = pref.getStringList('${oldName}_savedQuotes');
                      if (examples != null) {
                        await pref.setStringList('${newName}_examples', examples);
                        await pref.remove('${oldName}_examples');
                      }
                      if (quotes != null) {
                        await pref.setStringList('${newName}_savedQuotes', quotes);
                        await pref.remove('${oldName}_savedQuotes');
                      }
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(
                "확인".tr(),
                style: const TextStyle(color: Color(0xFF7539BB), wordSpacing: 1.5),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.findAncestorStateOfType<_MyAppState>()!._themeNotifier,
      builder: (context, isDarkTheme, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: context.findAncestorStateOfType<_MyAppState>()!._isVIPNotifier,
          builder: (context, isVIP, child) {
            return Scaffold(
              backgroundColor: isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                              end: Alignment.bottomRight.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                              colors: gradientColors,
                              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                            ),
                          ),
                          child: AppBar(
                            title: Text(
                              "대화방 목록".tr(),
                              style: const TextStyle(fontSize: 16, wordSpacing: 1.5),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Center(
                                  child: Text(
                                    isVIP ? 'VIP' : '',
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, wordSpacing: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '10/${chatScreens.length}',
                          style: TextStyle(
                            color: widget.isDarkTheme ? Colors.white70 : const Color(0xFF7539BB),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            wordSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: chatScreens.isEmpty
                        ? Center(
                            child: Text(
                              "새로운 대화방을 생성해보세요!".tr(),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: widget.isDarkTheme ? Colors.white70 : Colors.grey,
                                    fontSize: 18,
                                    wordSpacing: 1.5,
                                  ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                              softWrap: true,
                            ),
                          )
                        : ListView.builder(
                            itemCount: chatScreens.length,
                            itemBuilder: (context, index) => AnimatedBuilder(
                              animation: Listenable.merge([_colorAnimation, _tapScales[index]]),
                              builder: (context, child) {
                                return GestureDetector(
                                  onTapDown: (_) => _tapControllers[index].forward(),
                                  onTapUp: (_) {
                                    _tapControllers[index].reverse();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => chatScreens[index]),
                                    );
                                  },
                                  onTapCancel: () => _tapControllers[index].reverse(),
                                  onLongPress: () => _renameChat(index),
                                  child: Transform.scale(
                                    scale: _tapScales[index].value,
                                    child: Card(
                                      margin: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                                                end: Alignment.bottomRight.add(Alignment(_colorAnimation.value * 2 - 1, _colorAnimation.value * 2 - 1)),
                                                colors: gradientColors,
                                                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: isDarkTheme ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.3),
                                                  offset: const Offset(0, 4),
                                                  blurRadius: 10,
                                                  spreadRadius: 1,
                                                ),
                                                BoxShadow(
                                                  color: Colors.white.withValues(alpha: 0.2),
                                                  offset: const Offset(-2, -2),
                                                  blurRadius: 6,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                              border: Border.all(
                                                color: Colors.white.withValues(alpha: 0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: ListTile(
                                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                              minVerticalPadding: 0,
                                              leading: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(roleIcons[chatScreens[index].selectedRole], color: Colors.white, size: 28),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    chatScreens[index].selectedRole.tr(),
                                                    style: const TextStyle(color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                              title: Text(
                                                chatScreens[index].name,
                                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, color: Colors.white, wordSpacing: 1.5),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              trailing: GestureDetector(
                                                onTap: () => _deleteChat(index),
                                                child: const Icon(Icons.delete, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
              floatingActionButton: AnimatedBuilder(
                animation: _fabScale,
                builder: (context, child) {
                  return ScaleTransition(
                    scale: _fabScale,
                    child: GestureDetector(
                      onTap: _createNewChat,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: gradientColors,
                                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 36),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String name;
  final String selectedRole;
  final Function(String) onLanguageChanged;
  final String currentLanguage;
  final Map<String, String> translations;
  final bool isVIP;
  final Function(bool) onVIPStatusChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;
  final VoidCallback onShowVIPDialog;

  const ChatScreen({
    super.key,
    required this.name,
    required this.selectedRole,
    required this.onLanguageChanged,
    required this.currentLanguage,
    required this.translations,
    required this.isVIP,
    required this.onVIPStatusChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
    required this.onShowVIPDialog,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final String apiUrl = 'https://us-central1-toedok-new.cloudfunctions.net/analyzeTextV2';
  late TextEditingController _opponentController;
  late TextEditingController _myController;
  String selectedMood = '매력';
  bool isLoading = false;
  bool isInitialLoading = true;
  bool isShort = false;
  bool isLong = false;
  bool isEmoji = false;
  double moodIntensity = 50.0;
  List<Map<String, dynamic>> pastExamples = [];
  List<Map<String, dynamic>> currentExamples = [];
  String? lastResponse;
  List<String> savedQuotes = [];
  List<AnimationController> _animationControllers = [];
  late AnimationController _moodButtonController;
  late Animation<double> _moodButtonScale;
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonScale;
  late AnimationController _headerColorController;
  late Animation<double> _headerColorAnimation;
  late AnimationController _textColorController;
  late Animation<double> _textColorAnimation;
  int _toedokCountToday = 0;
  late DateTime _lastResetDate;

  final Map<String, IconData> roleIcons = {
    '애인': Icons.favorite,
    '직장 상사': Icons.work,
    '부모님': Icons.family_restroom,
    '어르신': Icons.elderly,
    '썸': Icons.favorite_border,
    '싫어하는 사람': Icons.block,
    '모임': Icons.people,
    '사업': Icons.business,
  };

  final Map<String, String> moodIcons = {
    '매력': 'assets/icons/attraction.png',
    '화남': 'assets/icons/angry.png',
    '신남': 'assets/icons/excited.png',
    '궁금': 'assets/icons/curious.png',
    '진지': 'assets/icons/serious.png',
    '장난': 'assets/icons/playful.png',
    '슬픔': 'assets/icons/sad.png',
    'chill가이': 'assets/icons/chill.png',
    '시크': 'assets/icons/cool.png',
    '위로': 'assets/icons/comfort.png',
  };

  final Map<String, Color> moodColors = {
    '매력': const Color(0xFFE91E63),
    '화남': const Color(0xFFF44336),
    '신남': const Color(0xFFFF9800),
    '궁금': const Color(0xFF9C27B0),
    '진지': const Color(0xFF2196F3),
    '장난': const Color(0xFF4CAF50),
    '슬픔': const Color(0xFF607D8B),
    'chill가이': const Color(0xFF00BCD4),
    '시크': Colors.black,
    '위로': const Color(0xFFBC7F5A),
  };

  final List<String> moods = ['매력', '화남', '신남', '궁금', '진지', '장난', '슬픔', 'chill가이', '시크', '위로'];

  List<Color> gradientColors = [
    const Color(0xFFC56BFF),
    const Color(0xFFA95EFF),
    const Color(0xFF8C52FF),
    const Color(0xFF6F46FF),
    const Color(0xFF5C38A0),
  ];

  @override
  void initState() {
    super.initState();
    debugPrint('ChatScreen 진입: ${widget.name}');
    _opponentController = TextEditingController();
    _myController = TextEditingController();
    selectedMood = '매력';
    isLoading = false;
    isShort = false;
    isLong = false;
    isEmoji = false;
    moodIntensity = 50.0;
    currentExamples = [];
    lastResponse = null;
    _loadInitialData();
    _moodButtonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _moodButtonScale = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _moodButtonController, curve: Curves.easeInOut));
    _sendButtonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _sendButtonScale = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _sendButtonController, curve: Curves.easeInOut));
    _headerColorController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    _headerColorAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _headerColorController, curve: Curves.easeInOut));
    _textColorController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    _textColorAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _textColorController, curve: Curves.easeInOut));
    _loadUsageCount();
  }

  Future<void> _loadUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString('toedokLastResetDate');
    _lastResetDate = lastReset != null ? DateTime.parse(lastReset) : DateTime.now();
    final today = DateTime.now();

    if (!_isSameDay(_lastResetDate, today)) {
      await prefs.setString('toedokLastResetDate', today.toIso8601String());
      await prefs.setInt('toedokCountToday', 0);
      _toedokCountToday = 0;
    } else {
      _toedokCountToday = prefs.getInt('toedokCountToday') ?? 0;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Future<void> _incrementToedokCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();

    if (!_isSameDay(_lastResetDate, today)) {
      _lastResetDate = today;
      _toedokCountToday = 0;
      await prefs.setString('toedokLastResetDate', today.toIso8601String());
    }

    _toedokCountToday++;
    await prefs.setInt('toedokCountToday', _toedokCountToday);
  }

  @override
  void dispose() {
    debugPrint('ChatScreen 종료: ${widget.name}');
    _saveChat();
    _opponentController.dispose();
    _myController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    _moodButtonController.dispose();
    _sendButtonController.dispose();
    _headerColorController.dispose();
    _textColorController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() => isInitialLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedChat = prefs.getStringList('${widget.name}_examples');
      final savedMoods = prefs.getStringList('${widget.name}_moods');
      final savedLengths = prefs.getStringList('${widget.name}_lengths');
      if (mounted) {
        setState(() {
          if (savedChat != null && savedMoods != null && savedChat.length == savedMoods.length) {
            pastExamples = List.generate(savedChat.length, (index) => {
              'text': savedChat[index],
              'isSaved': false,
              'mood': savedMoods[index],
              'isLong': savedLengths != null && savedLengths.length > index ? savedLengths[index] == 'true' : false,
            });
          } else {
            pastExamples = savedChat?.map((e) => {'text': e, 'isSaved': false, 'mood': '매력', 'isLong': false}).toList() ?? [];
          }
          final savedQuotes = prefs.getStringList('${widget.name}_savedQuotes');
          this.savedQuotes = savedQuotes ?? [];
          isInitialLoading = false;
          _animationControllers = List.generate(pastExamples.length, (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward());
        });
      }
    } catch (e) {
      debugPrint('데이터 로드 오류: $e');
      if (mounted) {
        setState(() => isInitialLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '데이터 로드 오류: $e',
              style: const TextStyle(wordSpacing: 1.5),
            ),
          ),
        );
      }
    }
  }

  Future<void> _saveChat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allExamples = [...currentExamples, ...pastExamples];
      if (allExamples.length > 8) {
        allExamples.removeRange(8, allExamples.length);
      }
      final chatToSave = allExamples.map((e) => e['text'] as String).toList();
      final moodsToSave = allExamples.map((e) => e['mood'] as String).toList();
      final lengthsToSave = allExamples.map((e) => e['isLong'].toString()).toList();
      await prefs.setStringList('${widget.name}_examples', chatToSave);
      await prefs.setStringList('${widget.name}_moods', moodsToSave);
      await prefs.setStringList('${widget.name}_lengths', lengthsToSave);
    } catch (e) {
      debugPrint('대화 저장 오류: $e');
    }
  }

  Future<void> _saveQuotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('${widget.name}_savedQuotes', savedQuotes);
    } catch (e) {
      debugPrint('글귀 저장 오류: $e');
    }
  }

  void _saveQuote(String quote) {
    if (mounted) {
      if (!savedQuotes.contains(quote)) {
        setState(() {
          if (savedQuotes.length >= 20) savedQuotes.removeAt(0);
          savedQuotes.insert(0, quote);
        });
        _saveQuotes();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "멘트가 저장되었습니다!".tr(),
                style: const TextStyle(wordSpacing: 1.5),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "이미 저장된 멘트입니다!".tr(),
              style: const TextStyle(wordSpacing: 1.5),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  String generatePrompt(String role, String mood, String opponentMessage, String userMessage) {
    final autoPolite = ['직장 상사', '부모님', '어르신', '사업', '모임'].contains(role);
    final isIntimate = ['애인', '썸'].contains(role);

    // 저장된 멘트 (최대 8개) 가져오기
    final allExamples = [...currentExamples, ...pastExamples];
    final savedResponses = allExamples.map((e) => e['text'] as String).toList();

    String lengthOption = isShort
        ? '5~10자 이내로 짧게, 단일 문장, 줄바꿈 없이'
        : isLong
            ? '50~70자, 2~3문장, 40자 이상 시 줄바꿈, 최대 세 줄, 각 줄 균형 잡힌 길이'
            : '20~30자, 단일 문장, 15자 이상 시 줄바꿈, 최대 두 줄, 각 줄 균형 잡힌 길이';

    String toneRule = autoPolite
        ? '존댓말로 자연스럽게'
        : '반말로 친근하게';

    String intimacyRule = '';
    switch (role) {
      case '애인':
        intimacyRule = '애인 관계처럼 다정하고 따뜻하게';
        break;
      case '썸':
        intimacyRule = '썸 관계처럼 호감 있으면서 가볍게';
        break;
      case '직장 상사':
        intimacyRule = '직장 상사와의 대화처럼 공손하고 전문적으로';
        break;
      case '부모님':
        intimacyRule = '부모님과의 대화처럼 따뜻하고 존중하는 톤으로';
        break;
      case '어르신':
        intimacyRule = '어르신과의 대화처럼 매우 공손하고 배려 깊게';
        break;
      case '싫어하는 사람':
        intimacyRule = '싫어하는 사람과의 대화처럼 냉소적이고 거리를 두는 톤으로';
        break;
      case '모임':
        intimacyRule = '모임에서의 대화처럼 친근하고 활기차게';
        break;
      case '사업':
        intimacyRule = '사업 관련 대화처럼 진지하고 신뢰감 있게';
        break;
      default:
        intimacyRule = '일상적인 대화처럼 자연스럽게';
    }

    String emojiRule = isEmoji
        ? '상황에 맞는 이모티콘 추가'
        : '이모지 사용 금지';

    String moodIntensityRule = '''
    기분 강도 $moodIntensity에 따라 반영:
    - 0: 중립적으로, 기분 반영 최소화
    - 50: $mood 뉘앙스를 중간 정도로 반영
    - 100: $mood 뉘앙스를 극단적으로 강하게 반영
  ''';

    String moodPrompt = '';
    switch (mood) {
      case '매력':
        moodPrompt = '매력적이고 부드러운 뉘앙스로, 다양한 감정 톤 표현';
        break;
      case '화남':
        moodPrompt = '화가 난 듯 날카롭고 직설적으로, 다양한 감정 톤 표현';
        break;
      case '신남':
        moodPrompt = '신나고 밝은 에너지가 넘치도록, 다양한 감정 톤 표현';
        break;
      case '궁금':
        moodPrompt = '궁금증을 유발하며 호기심 어린 톤으로, 다양한 감정 톤 표현';
        break;
      case '진지':
        moodPrompt = '진지하고 진중한 느낌으로, 다양한 감정 톤 표현';
        break;
      case '장난':
        moodPrompt = '장난스럽고 유쾌한 분위기로, 다양한 감정 톤 표현';
        break;
      case '슬픔':
        moodPrompt = '슬프고 감정적인 뉘앙스로, 다양한 감정 톤 표현';
        break;
      case 'chill가이':
        moodPrompt = '여유롭고 편안한 분위기로, 다양한 감정 톤 표현';
        break;
      case '시크':
        moodPrompt = '시크하고 무심한 듯한 톤으로, 다양한 감정 톤 표현';
        break;
      case '위로':
        moodPrompt = '따뜻하고 위로하는 느낌으로, 다양한 감정 톤 표현';
        break;
      default:
        moodPrompt = '기본적인 대화 톤으로, 다양한 감정 톤 표현';
    }

    String nameUsageRule = '''
    - 상대방 이름("${widget.name}")은 실제 대화처럼 자연스럽게, 가끔(30% 확률)만 문장에 포함
    - 이름 사용 시 문맥에 자연스럽게 녹아들도록, 강제로 삽입하지 않음
  ''';

    String diversityRule = '''
    - 응답 주제를 다양화, 공통 주제(예: 상대방 생각) 반복 금지
    - 이전 멘트와 다른 주제 및 감정 표현 강제, 새로운 맥락 탐구
  ''';

    String singleMentRule = '''
    - 한 번에 정확히 한 멘트만 출력, 여러 문장 절대 포함 금지
    - 단일 문장으로 완결성 유지, isLong일 경우 2~3문장으로 구성된 한 멘트 허용
    - 불필요한 줄바꿈 최소화, 지정된 길이와 줄바꿈 규칙 엄격 준수
  ''';

    return '''
[상황]
- 관계: $role (${widget.name}은 $role)
- 내 기분: $mood (단어 사용 금지, 뉘앙스만 표현)
- 기분 강도: $moodIntensity (0 중립, 50 중간, 100 극단)
- ${widget.name} 메시지: "$opponentMessage"
- 내 메시지: "${userMessage.isEmpty ? '없음' : userMessage}"
- 저장된 이전 멘트 (최대 8개): ${savedResponses.join(', ')}

[규칙]
1. $toneRule
2. $intimacyRule
3. ${widget.name} 메시지에 맞춰 내 메시지를 보완한 멘트 생성
4. 내 메시지가 있으면 그 뜻과 의미를 강하게 반영하여 보완, 내 말 그대로 사용 금지, ${widget.currentLanguage == "zh" ? "Standard Chinese (Mandarin)" : widget.currentLanguage}로 생성
5. 내 메시지가 없으면 ${widget.currentLanguage == "zh" ? "Standard Chinese (Mandarin)" : widget.currentLanguage}로 새로운 주제 생성
6. $lengthOption
7. $emojiRule
8. $moodIntensityRule
9. 출력 언어: ${widget.currentLanguage == "zh" ? "Standard Chinese (Mandarin)" : widget.currentLanguage}로만 생성, 현지 사용자가 자연스럽게 사용할 법한 표현으로 생성
10. 저장된 이전 멘트들과 동일한 문장, 유사한 문맥, 유사한 감정 톤 절대 사용 금지, 항상 새로운 문맥과 감정으로 생성
11. 자연스럽고 일상적인 대화처럼 생성
12. temperature=1.2, top_p=0.95 설정으로 창의적 응답 생성
13. 모든 응답은 서로 다른 단어로 시작, 동일한 시작 단어(예: "${widget.name}") 반복 금지
14. 멘트만 출력, 설명/의미/추천사항 절대 포함 금지
15. 기분 뉘앙스: $moodPrompt
16. $nameUsageRule
17. $diversityRule
18. $singleMentRule
''';
  }

  Future<void> fetchResponse() async {
    if (isLoading || !mounted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "현재 멘트 생성 중입니다...".tr(),
              style: const TextStyle(wordSpacing: 1.5),
            ),
          ),
        );
      }
      return;
    }

    if (!widget.isVIP) {
      final today = DateTime.now();
      if (!_isSameDay(_lastResetDate, today)) {
        _toedokCountToday = 0;
        _lastResetDate = today;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('toedokLastResetDate', today.toIso8601String());
        await prefs.setInt('toedokCountToday', 0);
      }
      if (_toedokCountToday >= 2) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: widget.isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
              title: Text(
                "오늘 무료 횟수를 다 사용했습니다.\n내일 다시 오세요!".tr(),
                style: TextStyle(
                  color: widget.isDarkTheme ? Colors.white : Colors.black,
                  wordSpacing: 1.5,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onShowVIPDialog();
                  },
                  child: Text(
                    "확인".tr(),
                    style: TextStyle(color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB), wordSpacing: 1.5),
                  ),
                ),
              ],
            ),
          );
        }
        return;
      }
    }
    if (_opponentController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "상대방의 말을 입력해 주세요!".tr(),
              style: const TextStyle(wordSpacing: 1.5),
            ),
          ),
        );
      }
      return;
    }

    debugPrint('fetchResponse 시작: ${widget.name}, 언어: ${widget.currentLanguage}');
    setState(() => isLoading = true);
    await _incrementToedokCount();
    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'conversationLog': generatePrompt(widget.selectedRole, selectedMood, _opponentController.text.trim(), _myController.text.trim()),
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final dynamic rawData = jsonDecode(utf8.decode(response.bodyBytes));
        debugPrint('Parsed Response: $rawData'); // 디버깅 로그 추가
        final Map<String, dynamic> data = rawData is Map<String, dynamic> ? rawData : {};
        final List<dynamic>? candidates = data['candidates'];
        if (candidates == null || candidates.isEmpty) {
          throw Exception('API 응답에 candidates 없음');
        }
        String responseText = candidates[0]['content']['parts'][0]['text']?.trim().replaceAll('"', '') ?? '응답 없음';

        responseText = responseText.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).join('\n');
        debugPrint('Gemini 응답: $responseText');

        if (mounted) {
          setState(() {
            currentExamples.insert(0, {
              'text': responseText.isEmpty ? '응답 없음' : responseText,
              'isSaved': false,
              'mood': selectedMood,
              'isLong': isLong,
            });
            final allExamples = [...currentExamples, ...pastExamples];
            if (allExamples.length > 8) {
              pastExamples = allExamples.sublist(0, 8);
              currentExamples.clear();
            }
            lastResponse = responseText;
            _animationControllers.insert(0, AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward());
            if (_animationControllers.length > 8) {
              _animationControllers.removeLast().dispose();
            }
          });
          await _saveChat();
        }
        final myAppState = context.findAncestorStateOfType<_MyAppState>()!;
        await myAppState.incrementApiCallCount(widget.isVIP);
      } else {
        throw Exception('API 오류: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('API 호출 오류: $e');
      if (mounted) {
        setState(() {
          currentExamples.insert(0, {
            'text': '오류: $e',
            'isSaved': false,
            'mood': selectedMood,
            'isLong': isLong,
          });
          final allExamples = [...currentExamples, ...pastExamples];
          if (allExamples.length > 8) {
            pastExamples = allExamples.sublist(0, 8);
            currentExamples.clear();
          }
          _animationControllers.insert(0, AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward());
          if (_animationControllers.length > 8) {
            _animationControllers.removeLast().dispose();
          }
        });
        await _saveChat();
      }
    } finally {
      client.close();
      if (mounted) {
        setState(() => isLoading = false);
        debugPrint('fetchResponse 완료: ${widget.name}');
      }
    }
  }

  void _showMoodSelectionDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "내 기분 선택".tr(),
          style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
        ),
        backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 4,
            radius: const Radius.circular(2),
            child: ListView.builder(
              itemCount: moods.length,
              itemBuilder: (context, index) {
                final mood = moods[index];
                final isLocked = !widget.isVIP && ['장난', '슬픔', 'chill가이', '시크', '위로'].contains(mood);
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        moodIcons[mood]!,
                        width: 36, // 24 * 1.5 (크기 키우기)
                        height: 36, // 24 * 1.5
                        color: widget.isDarkTheme && mood == '시크' ? Colors.white : moodColors[mood],
                        colorBlendMode: BlendMode.srcIn, // 검은색 PNG에 색상 강하게 적용
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.lock, size: 16, color: Colors.grey),
                      ],
                    ],
                  ),
                  title: Text(
                    mood.tr(),
                    style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
                  ),
                  onTap: () {
                    if (isLocked) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
                          title: Text(
                            "VIP 전용입니다".tr(),
                            style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onShowVIPDialog();
                              },
                              child: Text(
                                "확인".tr(),
                                style: TextStyle(color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB), wordSpacing: 1.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      if (mounted) {
                        setState(() => selectedMood = mood);
                        Navigator.pop(context);
                      }
                    }
                  },
                );
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "취소".tr(),
              style: const TextStyle(color: Color(0xFF7539BB), wordSpacing: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showSavedQuotesDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "소중한 글귀".tr(),
          style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
        ),
        backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: savedQuotes.isEmpty
              ? Center(
                  child: Text(
                    "아직 저장된 글귀가 없습니다.".tr(),
                    style: TextStyle(color: widget.isDarkTheme ? Colors.white70 : Colors.grey, wordSpacing: 1.5),
                  ),
                )
              : ListView.builder(
                  key: ValueKey('savedQuotesList_${savedQuotes.length}'),
                  cacheExtent: 1000,
                  itemCount: savedQuotes.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onLongPress: () {
                      _showFullQuoteDialog(savedQuotes[index]);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: widget.isDarkTheme ? Colors.black.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
                      child: ListTile(
                        title: Text(
                          savedQuotes[index],
                          style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                savedQuotes.removeAt(index);
                                _saveQuotes();
                              });
                              Navigator.pop(context);
                              _showSavedQuotesDialog();
                            }
                          },
                          child: const Icon(Icons.delete, color: Color(0xFF7539BB)),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "닫기".tr(),
              style: const TextStyle(color: Color(0xFF7539BB), wordSpacing: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullQuoteDialog(String quote) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AnimatedBuilder(
          animation: _headerColorAnimation,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft.add(Alignment(_headerColorAnimation.value * 2 - 1, _headerColorAnimation.value * 2 - 1)),
                end: Alignment.bottomRight.add(Alignment(_headerColorAnimation.value * 2 - 1, _headerColorAnimation.value * 2 - 1)),
                colors: gradientColors,
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ).createShader(bounds),
              child: Text(
                "상세 글귀".tr(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            );
          },
        ),
        backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
        content: SingleChildScrollView(
          child: Text(
            quote,
            style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, height: 1.5, wordSpacing: 1.5),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            maxLines: 10,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "닫기".tr(),
              style: const TextStyle(color: Color(0xFF7539BB), wordSpacing: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  
@override
Widget build(BuildContext context) {
  if (isInitialLoading) {
    return Scaffold(
      backgroundColor: widget.isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
      body: const Center(child: CircularProgressIndicator(color: Color(0xFF7539BB))),
    );
  }

  final displayExamples = [...currentExamples, ...pastExamples];

  return ValueListenableBuilder<bool>(
    valueListenable: context.findAncestorStateOfType<_MyAppState>()!._themeNotifier,
    builder: (context, isDarkTheme, child) {
      return ValueListenableBuilder<bool>(
        valueListenable: context.findAncestorStateOfType<_MyAppState>()!._isVIPNotifier,
        builder: (context, isVIP, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false, // 키보드로 화면 크기 조정 비활성화
            backgroundColor: isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AnimatedBuilder(
                animation: _headerColorAnimation,
                builder: (context, child) {
                  return ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft.add(Alignment(_headerColorAnimation.value * 2 - 1, _headerColorAnimation.value * 2 - 1)),
                            end: Alignment.bottomRight.add(Alignment(_headerColorAnimation.value * 2 - 1, _headerColorAnimation.value * 2 - 1)),
                            colors: gradientColors,
                            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          ),
                        ),
                        child: AppBar(
                          leadingWidth: 56,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(roleIcons[widget.selectedRole], color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                widget.selectedRole.tr(),
                                style: const TextStyle(color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                widget.name,
                                style: const TextStyle(color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Center(
                                child: Text(
                                  isVIP ? 'VIP' : '',
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, wordSpacing: 1.5),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: GestureDetector(
                                onTap: _showSavedQuotesDialog,
                                child: const Icon(Icons.bookmark, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_drop_down, size: 24, color: Color(0xFF7539BB)),
                      const SizedBox(width: 8),
                      AnimatedBuilder(
                        animation: _textColorAnimation,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.topLeft.add(Alignment(_textColorAnimation.value * 2 - 1, _textColorAnimation.value * 2 - 1)),
                              end: Alignment.bottomRight.add(Alignment(_textColorAnimation.value * 2 - 1, _textColorAnimation.value * 2 - 1)),
                              colors: gradientColors,
                              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                            ).createShader(bounds),
                            child: Text(
                              "다람쥐가 토독여준 멘트".tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                wordSpacing: 1.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_drop_down, size: 24, color: Color(0xFF7539BB)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    key: ValueKey('examplesList_${widget.name}_${displayExamples.length}'),
                    cacheExtent: 500,
                    padding: const EdgeInsets.all(8),
                    itemCount: displayExamples.length,
                    itemBuilder: (context, index) {
                      final example = displayExamples[index];
                      final mood = example['mood'] as String;
                      final text = example['text'].toString();
                      final wasLong = example['isLong'] as bool;
                      final textLength = text.length;
                      double containerHeight = 60;
                      int maxLines = 3;

                      if (wasLong) {
                        containerHeight = 80;
                        maxLines = 5;
                      } else if (textLength > 40) {
                        containerHeight = 80;
                        maxLines = 5;
                      }
                      if (textLength > 70) {
                        containerHeight = 100;
                        maxLines = 5;
                      }
                      if (textLength > 100) {
                        containerHeight = 120;
                        maxLines = 5;
                      }
                      if (!wasLong && textLength > 20 && textLength <= 40) {
                        containerHeight = 80;
                        maxLines = 2;
                      }

                      return ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _animationControllers[index],
                          curve: Curves.bounceOut,
                        ),
                        child: Dismissible(
                          key: Key('${example['text']}_$index'),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              if (index < currentExamples.length) {
                                currentExamples.removeAt(index);
                              } else {
                                pastExamples.removeAt(index - currentExamples.length);
                              }
                              _animationControllers.removeAt(index).dispose();
                            });
                            _saveChat();
                          },
                          background: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: gradientColors,
                                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white, size: 30),
                          ),
                          child: GestureDetector(
                            onLongPress: () {
                              if (mounted) {
                                setState(() {
                                  example['isSaved'] = !(example['isSaved'] as bool);
                                  if (example['isSaved']) _saveQuote(example['text']);
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(16),
                              height: containerHeight,
                              decoration: BoxDecoration(
                                color: widget.isDarkTheme ? Colors.black.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(8),
                                border: index == 0
                                    ? Border.all(
                                        width: 4,
                                        color: const Color(0xFFC56BFF),
                                      )
                                    : null,
                                boxShadow: index < 2
                                    ? [
                                        BoxShadow(
                                          color: widget.isDarkTheme ? Colors.white.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3),
                                          offset: const Offset(4, 4),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                        BoxShadow(
                                          color: Colors.white.withValues(alpha: 0.1),
                                          offset: const Offset(-2, -2),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          offset: const Offset(2, 2),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: widget.isDarkTheme ? Colors.white.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3),
                                          offset: const Offset(4, 4),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                        BoxShadow(
                                          color: Colors.white.withValues(alpha: 0.1),
                                          offset: const Offset(-2, -2),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 12),
                                    child: Image.asset(
                                      moodIcons[mood]!,
                                      width: 36,
                                      height: 36,
                                      color: widget.isDarkTheme && mood == '시크' ? Colors.white : moodColors[mood],
                                      colorBlendMode: BlendMode.srcIn,
                                    ),
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: widget.isDarkTheme ? Colors.white : const Color(0xFF333333),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5,
                                        wordSpacing: 1.5,
                                      ),
                                      maxLines: maxLines,
                                      minFontSize: 10,
                                      maxFontSize: 16,
                                      stepGranularity: 0.1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: example['text']));
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "클립보드에 복사됨!".tr(),
                                              style: const TextStyle(wordSpacing: 1.5),
                                            ),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Icon(Icons.content_copy, size: 18, color: Color(0xFF7539BB)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: isEmoji,
                                onChanged: isLoading ? null : (v) => mounted ? setState(() => isEmoji = v!) : null,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                checkColor: widget.isDarkTheme ? Colors.black : Colors.white,
                                activeColor: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                                side: BorderSide(color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB)),
                              ),
                              Text(
                                "이모티콘".tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 1.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: isShort,
                                onChanged: isLoading || !isVIP
                                    ? null
                                    : (v) => mounted
                                        ? setState(() {
                                            isShort = v!;
                                            if (isShort) isLong = false;
                                          })
                                        : null,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                checkColor: widget.isDarkTheme ? Colors.black : Colors.white,
                                activeColor: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                                side: BorderSide(color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB)),
                              ),
                              Text(
                                "짧게".tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 1.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (!isVIP) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.lock, size: 16, color: Colors.grey),
                              ],
                            ],
                          ),
                        ),
                        Expanded(
  child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: isLong,
                                onChanged: isLoading || !isVIP
                                    ? null
                                    : (v) => mounted
                                        ? setState(() {
                                            isLong = v!;
                                            if (isLong) isShort = false;
                                          })
                                        : null,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                checkColor: widget.isDarkTheme ? Colors.black : Colors.white,
                                activeColor: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                                side: BorderSide(color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB)),
                              ),
                              Text(
                                "길게".tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 1.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (!isVIP) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.lock, size: 16, color: Colors.grey),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              trackHeight: 1,
                              valueIndicatorColor: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                              valueIndicatorTextStyle: TextStyle(color: widget.isDarkTheme ? Colors.black : Colors.white, fontSize: 14, wordSpacing: 1.5),
                              activeTrackColor: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB),
                              inactiveTrackColor: Colors.grey[600],
                            ),
                            child: Slider(
                              value: moodIntensity,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label: '${"기분 강도".tr()}: ${moodIntensity.toInt()}',
                              onChanged: isLoading ? null : (value) => mounted ? setState(() => moodIntensity = value) : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom > 0
                            ? MediaQuery.of(context).viewInsets.bottom + 12 // 키보드 올라올 때 12px 위
                            : MediaQuery.of(context).viewPadding.bottom + 12, // 키보드 없을 때 내비게이션 바 위 12px
                        left: 12, // 양옆 12px
                        right: 12,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12), // 입력창 양옆 12px
                                decoration: BoxDecoration(
                                  color: widget.isDarkTheme ? Colors.black.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _opponentController,
                                  decoration: InputDecoration(
                                    hintText: "상대방의 말을 입력하세요...".tr(),
                                    hintStyle: TextStyle(color: widget.isDarkTheme ? Colors.white70 : Colors.grey, fontSize: 18, wordSpacing: 1.5),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, fontSize: 18, wordSpacing: 1.5),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTapDown: (_) => _moodButtonController.forward(),
                                onTapUp: (_) {
                                  _moodButtonController.reverse();
                                  _showMoodSelectionDialog();
                                },
                                onTapCancel: () => _moodButtonController.reverse(),
                                child: ScaleTransition(
                                  scale: _moodButtonScale,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 62, // 크기 유지
                                        height: 62,
                                        margin: const EdgeInsets.all(5), // 양옆/위아래 5px 패딩
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.isDarkTheme ? Colors.black.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.3),
                                              offset: const Offset(2, 2),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withValues(alpha: 0.1),
                                              offset: const Offset(-2, -2),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        moodIcons[selectedMood]!,
                                        width: 48,
                                        height: 48,
                                        color: widget.isDarkTheme && selectedMood == '시크' ? Colors.white : moodColors[selectedMood],
                                        colorBlendMode: BlendMode.srcIn,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12), // 입력창 양옆 12px
                                      decoration: BoxDecoration(
                                        color: widget.isDarkTheme ? Colors.black.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _myController,
                                              decoration: InputDecoration(
                                                hintText: "내 말을 입력하세요...".tr(),
                                                hintStyle: TextStyle(color: widget.isDarkTheme ? Colors.white70 : Colors.grey, fontSize: 18, wordSpacing: 1.5),
                                                border: InputBorder.none,
                                              ),
                                              style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, fontSize: 18, wordSpacing: 1.5),
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTapDown: (_) => _sendButtonController.forward(),
                                            onTapUp: (_) {
                                              _sendButtonController.reverse();
                                              fetchResponse();
                                            },
                                            onTapCancel: () => _sendButtonController.reverse(),
                                            child: ScaleTransition(
                                              scale: _sendButtonScale,
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: selectedMood == '시크' ? Colors.black : moodColors[selectedMood],
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withValues(alpha: 0.4),
                                                      offset: const Offset(2, 2),
                                                      blurRadius: 6,
                                                      spreadRadius: 1,
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.white.withValues(alpha: 0.1),
                                                      offset: const Offset(-2, -2),
                                                      blurRadius: 4,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: isLoading
                                                    ? Transform.scale(
                                                        scale: 0.6,
                                                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 4),
                                                      )
                                                    : const Icon(
                                                        Icons.send,
                                                        size: 24,
                                                        color: Colors.white,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
}


class Message {
  String text;
  double x;
  double X;
  double y;
  double width;
  double height;
  Color backgroundColor;
  final int id;
  bool isMine;

  Message(this.text, this.x, this.X, this.y, this.width, this.height, this.backgroundColor, {required this.id, this.isMine = false});

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'x': x,
      'X': X,
      'y': y,
      'width': width,
      'height': height,
      'backgroundColor': backgroundColor.value,
      'id': id,
      'isMine': isMine,
    };
  }

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      json['text'] as String,
      json['x'] as double,
      json['X'] as double,
      json['y'] as double,
      json['width'] as double,
      json['height'] as double,
      Color(json['backgroundColor'] as int),
      id: json['id'] as int,
      isMine: json['isMine'] as bool? ?? false,
    );
  }
}

Map<String, dynamic> kMeans(List<List<double>> features) {
  if (features.length < 2) {
    throw Exception('최소 2개의 데이터 포인트가 필요합니다.');
  }

  List<List<double>> centroids = [
    features[0],
    features[features.length - 1],
  ];
  List<int> labels = List.filled(features.length, 0);
  List<double> scores = List.filled(features.length, 0.0);

  for (int iter = 0; iter < 10; iter++) {
    for (int i = 0; i < features.length; i++) {
      double dist0 = sqrt(pow(features[i][0] - centroids[0][0], 2) + pow(features[i][1] - centroids[0][1], 2));
      double dist1 = sqrt(pow(features[i][0] - centroids[1][0], 2) + pow(features[i][1] - centroids[1][1], 2));
      labels[i] = dist0 < dist1 ? 0 : 1;

      double totalDist = dist0 + dist1;
      if (totalDist != 0) {
        scores[i] = labels[i] == 0 ? (dist1 / totalDist) : (dist0 / totalDist);
      } else {
        scores[i] = 0.5;
      }
    }

    List<List<double>> sums = [
      [0.0, 0.0],
      [0.0, 0.0],
    ];
    List<int> counts = [0, 0];
    for (int i = 0; i < features.length; i++) {
      sums[labels[i]][0] += features[i][0];
      sums[labels[i]][1] += features[i][1];
      counts[labels[i]]++;
    }

    if (counts[0] > 0) {
      centroids[0] = [sums[0][0] / counts[0], sums[0][1] / counts[0]];
    }
    if (counts[1] > 0) {
      centroids[1] = [sums[1][0] / counts[1], sums[1][1] / counts[1]];
    }
  }

  int rightCluster = centroids[0][0] > centroids[1][0] ? 0 : 1;

  return {
    'centroids': centroids,
    'labels': labels,
    'scores': scores,
    'rightCluster': rightCluster,
  };
}

List<List<int>> sampleColor(Map<String, dynamic> params) {
  final img.Image image = params['image'] as img.Image;
  final double msgX = params['msgX'] as double;
  final double msgY = params['msgY'] as double;
  final double msgXEnd = params['msgXEnd'] as double;
  final double msgYEnd = params['msgYEnd'] as double;

  List<List<int>> pixels = [];
  double centerX = (msgX + msgXEnd) / 2;
  double centerY = (msgY + msgYEnd) / 2;
  double paddingX = (msgXEnd - msgX) * 0.1;
  double paddingY = (msgYEnd - msgY) * 0.1;

  List<List<double>> offsets = [];
  for (int i = -2; i <= 2; i++) {
    for (int j = -2; j <= 2; j++) {
      offsets.add([centerX + i * paddingX, centerY + j * paddingY]);
    }
  }

  for (var offset in offsets) {
    int px = offset[0].toInt().clamp(0, image.width - 1);
    int py = offset[1].toInt().clamp(0, image.height - 1);
    final pixel = image.getPixelSafe(px, py);
    int r = pixel.r.toInt();
    int g = pixel.g.toInt();
    int b = pixel.b.toInt();
    pixels.add([r, g, b]);
  }

  return pixels;
}

Future<List<Map<String, dynamic>>> computeSampleColors(Map<String, dynamic> params) async {
  final List<Map<String, dynamic>> groups = params['groups'] as List<Map<String, dynamic>>;
  final img.Image image = params['image'] as img.Image;
  final List<double> referenceHsv = params['referenceHsv'] as List<double>;
  final double screenWidth = params['screenWidth'] as double;

  List<Future<Map<String, dynamic>>> futures = groups.map((groupData) async {
    final group = groupData['group'] as BubbleGroup;
    double groupWidth = group.maxX - group.minX;
    double groupHeight = group.maxY - group.minY;

    double colorScore = 0.0;
    if (groupWidth < 20 || groupHeight < 10) {
      debugPrint('말풍선 크기가 너무 작음 (width=$groupWidth, height=$groupHeight), 색상 샘플링 스킵');
    } else {
      List<List<int>> regionPixels = await Future.microtask(() => sampleColor({
        'image': image,
        'msgX': group.minX,
        'msgY': group.minY,
        'msgXEnd': group.maxX,
        'msgYEnd': group.maxY,
      }));

      if (regionPixels.length >= 5) {
        List<List<double>> hsvColors = [];
        for (var pixel in regionPixels) {
          double r = pixel[0].toDouble();
          double g = pixel[1].toDouble();
          double b = pixel[2].toDouble();

          r /= 255;
          g /= 255;
          b /= 255;
          double max = [r, g, b].reduce((a, b) => a > b ? a : b);
          double min = [r, g, b].reduce((a, b) => a < b ? a : b);
          double h = 0, s = 0, v = max;
          double delta = max - min;

          if (max != 0) {
            s = delta / max;
          } else {
            hsvColors.add([0.0, 0.0, 0.1]);
            continue;
          }
          if (delta != 0) {
            if (max == r) {
              h = (g - b) / delta + (g < b ? 6 : 0);
            } else if (max == g) {
              h = (b - r) / delta + 2;
            } else {
              h = (r - g) / delta + 4;
            }
            h *= 60;
          }
          hsvColors.add([h / 360, s, v]);
        }

        double sumH = 0.0, sumS = 0.0, sumV = 0.0;
        for (var hsv in hsvColors) {
          sumH += hsv[0];
          sumS += hsv[1];
          sumV += hsv[2];
        }
        List<double> avgHsv = hsvColors.isNotEmpty
            ? [sumH / hsvColors.length, sumS / hsvColors.length, sumV / hsvColors.length]
            : [0.0, 0.0, 0.0];

        if (referenceHsv != [0.0, 0.0, 0.0]) {
          double deltaH = (avgHsv[0] - referenceHsv[0]).abs();
          double deltaS = (avgHsv[1] - referenceHsv[1]).abs();
          double deltaV = (avgHsv[2] - referenceHsv[2]).abs();
          colorScore = 1.0 - (deltaH * 0.5 + deltaS * 0.3 + deltaV * 0.2);
          colorScore = colorScore.clamp(0.0, 1.0);
          debugPrint('색상 유사도: 메시지="${group.getCombinedText()}", ΔH=$deltaH, ΔS=$deltaS, ΔV=$deltaV, 점수=$colorScore');
        }
      } else {
        debugPrint('샘플 개수 부족 (샘플 수=${regionPixels.length}), 색상 샘플링 스킵');
      }
    }

    bool hasRightTail = group.maxX > screenWidth * 0.80; // 0.85 → 0.80으로 완화
bool isTailReliable = groupWidth > 70 && groupHeight > 25 && (group.maxX - group.minX) / groupWidth > 0.8; // 조건 강화
double tailScore = (isTailReliable && hasRightTail) ? 1.0 : 0.0;
    debugPrint('꼬리 감지: 메시지="${group.getCombinedText()}", hasRightTail=$hasRightTail, isTailReliable=$isTailReliable, 점수=$tailScore');

    return {
      'group': group,
      'score': colorScore,
      'isRightTail': hasRightTail,
    };
  }).toList();

  List<Map<String, dynamic>> results = await Future.wait(futures);
  return results;
}
Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStartBackgroundService,
      autoStart: false,
      isForegroundMode: true,
      initialNotificationTitle: "app_running_message".tr(),
      initialNotificationContent: "analyzing_message".tr(),
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStartBackgroundService,
      onBackground: (ServiceInstance service) {
        debugPrint('iOS 백그라운드 서비스 시작');
        return true;
      },
    ),
  );
}
FlutterBackgroundService? _backgroundService;

Future<FlutterBackgroundService> getBackgroundService() async {
  if (_backgroundService == null) {
    _backgroundService = FlutterBackgroundService();
    await initializeBackgroundService();
    debugPrint('백그라운드 서비스 초기화 완료');
  }
  return _backgroundService!;
}

@pragma('vm:entry-point')
void onStartBackgroundService(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('백그라운드 서비스 시작: Flutter 엔진 초기화 완료');

  int activeAnalyses = 0;
  final activeRoomIds = <String>{};
  final roomIdToNameMap = <String, String>{};

  // 알림 업데이트 메서드
  void updateNotification() {
    if (activeAnalyses > 0) {
      service.invoke('setAsForeground', {
        'notificationTitle': "app_running_message".tr(),
        'notificationContent': "analyzing_message".tr(),
      });
      debugPrint('알림 업데이트: 분석 중 (activeAnalyses=$activeAnalyses)');
    }
  }

  // 연결 유지 핑
  Timer.periodic(Duration(seconds: 30), (timer) {
    if (activeAnalyses == 0) {
      timer.cancel();
      debugPrint('연결 유지 핑 타이머 종료: 더 이상 분석 중인 작업 없음');
      return;
    }
    service.invoke('keepAlive', {'ping': 'keepAlive'});
    debugPrint('연결 유지 핑 전송: 현재 분석 중인 방 수: $activeAnalyses');
  });

  // roomId 등록
  service.on('registerRoom').listen((event) {
    if (event == null || event['roomId'] == null || event['roomName'] == null) return;
    final roomId = event['roomId'] as String;
    final roomName = event['roomName'] as String;
    activeRoomIds.add(roomId);
    roomIdToNameMap[roomId] = roomName;
    debugPrint('roomId 등록: $roomId, roomName=$roomName');
    // 등록 완료 알림
    service.invoke('roomRegistered', {'roomId': roomId, 'roomName': roomName});
  });

  // 방 삭제 시 작업 중지
  service.on('stopAnalysis').listen((event) {
    if (event == null || event['roomId'] == null) return;
    final roomId = event['roomId'] as String;
    final roomName = roomIdToNameMap[roomId] ?? 'Unknown';
    if (activeRoomIds.contains(roomId)) {
      activeRoomIds.remove(roomId);
      roomIdToNameMap.remove(roomId);
      activeAnalyses--;
      debugPrint('방 $roomName (roomId=$roomId) 삭제로 작업 중지, 현재 분석 중인 방 수: $activeAnalyses');
      if (activeAnalyses == 0) {
        service.stopSelf();
        debugPrint('모든 분석 완료, 백그라운드 서비스 종료');
      }
    }
  });

      service.on('analyzeScreenshot').listen((event) async {
    if (event == null) {
      debugPrint('백그라운드 서비스 이벤트가 null입니다.');
      return;
    }

    final roomId = event['roomId'] as String?;
    final roomName = event['roomName'] as String?;
    if (roomId == null || roomName == null) {
      debugPrint('방 $roomName (roomId=$roomId): roomId 또는 roomName 누락, 작업 스킵');
      return;
    }

    if (!activeRoomIds.contains(roomId)) {
      debugPrint('방 $roomName (roomId=$roomId): 삭제되었거나 유효하지 않음, 작업 스킵');
      return;
    }

    activeAnalyses++;
    debugPrint('분석 시작, 현재 분석 중인 방 수: $activeAnalyses');
    updateNotification();

    final image = event['image'] as String?;
    final filePath = event['filePath'] as String?;
    final currentLanguage = event['currentLanguage'] as String?;
    final translations = event['translations'] as Map?;
    final analysisOption = event['analysisOption'] as String?;
    final isVIP = event['isVIP'] as bool? ?? false; // isVIP 값 수신

    debugPrint('백그라운드 서비스 데이터 확인: roomName=$roomName, roomId=$roomId, image=${image?.substring(0, 50)}..., filePath=$filePath, currentLanguage=$currentLanguage, translations=$translations, analysisOption=$analysisOption, isVIP=$isVIP');

    if (image == null || currentLanguage == null || translations == null || analysisOption == null) {
      debugPrint('백그라운드 서비스 작업 오류: 필수 매개변수가 누락되었습니다.');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('${roomName}_isAnalyzing', false);
      service.invoke('analysisFailed', {
        'roomId': roomId,
        'roomName': roomName,
        'error': '필수 매개변수가 누락되었습니다.',
      });
      activeAnalyses--;
      activeRoomIds.remove(roomId);
      roomIdToNameMap.remove(roomId);
      if (activeAnalyses == 0) {
        service.stopSelf();
        debugPrint('모든 분석 완료, 백그라운드 서비스 종료');
      }
      return;
    }

    final imageBytes = base64Decode(image);
    final translationsMap = Map<String, String>.from(translations);

    final prefs = await SharedPreferences.getInstance();
    try {
      final mainScreenState = _MainScreenshotScreenState();
      final result = await mainScreenState.analyzeImageInBackground(
        roomName,
        imageBytes,
        currentLanguage,
        translationsMap,
        analysisOption,
        isVIP,
      );

      if (!activeRoomIds.contains(roomId)) {
        debugPrint('방 $roomName (roomId=$roomId): 분석 중 삭제됨, 결과 폐기');
        return;
      }

      await prefs.setString('${roomName}_analysis_data', jsonEncode(result));
      await prefs.setBool('${roomName}_isAnalyzing', false);

      service.invoke('analysisComplete', {
        'roomId': roomId,
        'roomName': roomName,
        'result': jsonEncode(result),
        'isVIP': isVIP, // 광고 표시를 위해 isVIP 전달
      });
      debugPrint('백그라운드 서비스: 분석 완료 - roomName=$roomName, roomId=$roomId');
    } catch (e) {
      debugPrint('백그라운드 서비스 작업 오류: $e');
      await prefs.setBool('${roomName}_isAnalyzing', false);
      service.invoke('analysisFailed', {
        'roomId': roomId,
        'roomName': roomName,
        'error': e.toString(),
      });
    } finally {
      activeAnalyses--;
      activeRoomIds.remove(roomId);
      roomIdToNameMap.remove(roomId);
      debugPrint('분석 종료, 현재 분석 중인 방 수: $activeAnalyses');
      if (activeAnalyses == 0) {
        service.stopSelf();
        debugPrint('모든 분석 완료, 백그라운드 서비스 종료 및 알림 제거');
      }
    }
  });
}
class MainScreenshotScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;
  final String currentLanguage;
  final Map<String, String> translations;
  final bool isVIP;
  final Function(bool) onVIPStatusChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;
  final VoidCallback onShowVIPDialog;

  const MainScreenshotScreen({
    super.key,
    required this.onLanguageChanged,
    required this.currentLanguage,
    required this.translations,
    required this.isVIP,
    required this.onVIPStatusChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
    required this.onShowVIPDialog,
  });

  @override
  _MainScreenshotScreenState createState() => _MainScreenshotScreenState();
}

class _MainScreenshotScreenState extends State<MainScreenshotScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  List<Map<String, dynamic>> screenshotRooms = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late AnimationController colorController;
  late Animation<double> colorAnimation;
  List<AnimationController> tapControllers = [];
  List<Animation<double>> tapScales = [];
  late AnimationController fabController;
  late Animation<double> fabScale;
  bool isNavigating = false;
  int _screenshotCountToday = 0;
  late DateTime _lastResetDate;
  final Map<String, StreamSubscription> _analysisSubscriptions = {};
  bool _isFirstLoad = true;

  final String deepSeekApiUrl = 'https://us-central1-toedok-new.cloudfunctions.net/analyzeTextV2';

  List<Color> gradientColors = [
    const Color(0xFFC56BFF),
    const Color(0xFFA95EFF),
    const Color(0xFF8C52FF),
    const Color(0xFF6F46FF),
    const Color(0xFF5C38A0),
  ];

     @override
  void initState() {
    super.initState();
    debugPrint('MainScreenshotScreen 초기화');
    colorController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    colorAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: colorController, curve: Curves.easeInOut));
    fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    fabScale = Tween<double>(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: fabController, curve: Curves.easeInOut));
    _loadUsageCount();
    WidgetsBinding.instance.addObserver(this);
    if (_isFirstLoad) {
      loadRooms();
      _checkPendingAnalysesForDuplicates();
      _preventGalleryScan();
      _requestNotificationPermission(); // 알림 권한 요청 추가
      _isFirstLoad = false;
    }
  }

  Future<void> _requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;
    if (sdkInt >= 33) {
      bool hasNotificationPermission = await Permission.notification.status.isGranted;
      debugPrint('알림 권한 상태 (SDK 33 이상): $hasNotificationPermission');
      if (!hasNotificationPermission) {
        hasNotificationPermission = await Permission.notification.request().isGranted;
        debugPrint('알림 권한 요청 결과: $hasNotificationPermission');
        if (!hasNotificationPermission) {
          debugPrint('알림 권한 거부됨');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.translations["알림 권한이 필요합니다. 설정에서 권한을 허용해주세요."] ?? "알림 권한이 필요합니다. 설정에서 권한을 허용해주세요.",
                  style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
                  maxLines: 2,
                ),
                action: SnackBarAction(
                  label: "설정으로 이동".tr(),
                  onPressed: () async {
                    await openAppSettings();
                  },
                ),
              ),
            );
          }
        }
      }
    }
  } else if (Platform.isIOS) {
    bool hasNotificationPermission = await Permission.notification.status.isGranted;
    debugPrint('iOS 알림 권한 상태: $hasNotificationPermission');
    if (!hasNotificationPermission) {
      hasNotificationPermission = await Permission.notification.request().isGranted;
      debugPrint('iOS 알림 권한 요청 결과: $hasNotificationPermission');
      if (!hasNotificationPermission) {
        debugPrint('iOS 알림 권한 거부됨');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.translations["알림 권한이 필요합니다. 설정에서 권한을 허용해주세요."] ?? "알림 권한이 필요합니다. 설정에서 권한을 허용해주세요.",
                style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
                maxLines: 2,
              ),
              action: SnackBarAction(
                label: "설정으로 이동".tr(),
                onPressed: () async {
                  await openAppSettings();
                },
              ),
            ),
          );
        }
      }
    }
  }
}

  Future<void> _preventGalleryScan() async {
    final cacheDir = await getTemporaryDirectory();
    final nomediaFile = File('${cacheDir.path}/.nomedia');
    if (!await nomediaFile.exists()) {
      await nomediaFile.create();
      debugPrint('갤러리 스캔 방지를 위해 .nomedia 파일 생성: ${nomediaFile.path}');
    }
    final filePickerCacheDir = Directory('${cacheDir.path}/file_picker');
    if (await filePickerCacheDir.exists()) {
      final filePickerNomediaFile = File('${filePickerCacheDir.path}/.nomedia');
      if (!await filePickerNomediaFile.exists()) {
        await filePickerNomediaFile.create();
        debugPrint('FilePicker 캐싱 디렉토리에 .nomedia 파일 생성: ${filePickerNomediaFile.path}');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFirstLoad) {
      debugPrint('화면 전환 감지: 데이터 유지');
      loadRooms();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('AppLifecycleState 변경: $state');
    if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 돌아올 때 최신 상태 반영
      loadRooms().then((_) {
        _checkPendingAnalysesForDuplicates();
        if (mounted) {
          setState(() {});
        }
      });
    } else if (state == AppLifecycleState.paused) {
      final analyzingRooms = screenshotRooms.where((room) => room['isAnalyzing'] == true).toList();
      if (analyzingRooms.isNotEmpty) {
        debugPrint('앱이 백그라운드로 전환됨, 백그라운드에서 분석 계속 진행 중: ${analyzingRooms.map((r) => r['roomName']).join(', ')}');
      } else {
        debugPrint('앱이 백그라운드로 전환됨, 분석 중인 방 없음');
      }
      saveRooms();
    }
  }

  Future<void> _loadUsageCount() async {
  final prefs = await SharedPreferences.getInstance();
  final lastReset = prefs.getString('screenshotLastResetDate');
  _lastResetDate = lastReset != null ? DateTime.parse(lastReset) : DateTime.now();

  final today = DateTime.now();
  if (!_isSameWeek(_lastResetDate, today)) {
    await prefs.setString('screenshotLastResetDate', today.toIso8601String());
    await prefs.setInt('screenshotCountWeek', 0);
    _screenshotCountToday = 0;
  } else {
    _screenshotCountToday = prefs.getInt('screenshotCountWeek') ?? 0;
  }
}

Future<void> _incrementScreenshotCount() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now();

  if (!_isSameWeek(_lastResetDate, today)) {
    _lastResetDate = today;
    _screenshotCountToday = 0;
    await prefs.setString('screenshotLastResetDate', today.toIso8601String());
  }

  _screenshotCountToday++;
  await prefs.setInt('screenshotCountWeek', _screenshotCountToday);
}

bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

bool _isSameWeek(DateTime date1, DateTime date2) {
  // 주의 시작을 월요일로 설정
  final weekStart1 = date1.subtract(Duration(days: date1.weekday - 1));
  final weekStart2 = date2.subtract(Duration(days: date2.weekday - 1));
  return weekStart1.year == weekStart2.year &&
         weekStart1.month == weekStart2.month &&
         weekStart1.day == weekStart2.day;
}

  @override
  void dispose() {
    debugPrint('MainScreenshotScreen 해제');
    colorController.dispose();
    fabController.dispose();
    for (var controller in tapControllers) {
      controller.dispose();
    }
    _analysisSubscriptions.forEach((roomName, subscription) {
      subscription.cancel();
    });
    _analysisSubscriptions.clear();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> loadRooms() async {
  final SharedPreferences prefs = await _prefs;
  await prefs.reload(); // Ensure cache is up-to-date
  final String? roomsJson = prefs.getString('rooms');
  if (roomsJson != null) {
    try {
      List<dynamic> roomsList = jsonDecode(roomsJson);
      List<Map<String, dynamic>> tempRooms = roomsList.map((json) {
        Map<String, dynamic> room = Map<String, dynamic>.from(json);
        if (room['image'] is String) {
          room['image'] = base64Decode(room['image'] as String);
        }
        room['key'] = ValueKey(room['roomName']);
        return room;
      }).toList();

      // 모든 방에 대해 분석 상태와 결과 확인
      for (var room in tempRooms) {
        final roomName = room['roomName'] as String;
        final isAnalyzing = prefs.getBool('${roomName}_isAnalyzing') ?? false;
        final analysisData = prefs.getString('${roomName}_analysis_data');
        final hasAnalysisResult = analysisData != null && analysisData.isNotEmpty;

        // 분석 완료된 경우 isAnalyzing 플래그를 강제로 false로 설정
        if (hasAnalysisResult && isAnalyzing) {
          await prefs.setBool('${roomName}_isAnalyzing', false);
          room['isAnalyzing'] = false;
          if (analysisData != null) {
            try {
              room['analysisResult'] = jsonDecode(analysisData);
            } catch (e) {
              debugPrint('분석 데이터 파싱 오류: $e');
            }
          }
          debugPrint('방 $roomName: 분석 완료 상태로 강제 업데이트');
        } else {
          room['isAnalyzing'] = isAnalyzing;
          if (hasAnalysisResult) {
            try {
              room['analysisResult'] = jsonDecode(analysisData!);
            } catch (e) {
              debugPrint('분석 데이터 파싱 오류: $e');
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          screenshotRooms = tempRooms;
          while (tapControllers.length > screenshotRooms.length) {
            tapControllers.last.dispose();
            tapControllers.removeLast();
            tapScales.removeLast();
          }
          while (tapControllers.length < screenshotRooms.length) {
            tapControllers.add(AnimationController(vsync: this, duration: const Duration(milliseconds: 100)));
            tapScales.add(Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: tapControllers.last, curve: Curves.easeInOut)));
          }
        });
      }

      debugPrint('방 목록 로드 완료: ${screenshotRooms.length}개 방');
    } catch (e) {
      debugPrint('SharedPreferences에서 데이터 로드 실패: $e');
    }
  } else {
    debugPrint('SharedPreferences에서 데이터 로드 실패, 방 목록 유지');
  }
}

Future<void> saveRooms() async {
  final SharedPreferences prefs = await _prefs;
  final roomsJson = jsonEncode(screenshotRooms.map((room) {
    return {
      'key': room['key'].value.toString(),
      'roomName': room['roomName'],
      'displayName': room['displayName'],
      'image': base64Encode(room['image'] as Uint8List),
      'isAnalyzing': room['isAnalyzing'],
      'analysisResult': room['analysisResult'],
      'analysisOption': room['analysisOption'],
    };
  }).toList());

  await Future.wait([
    prefs.setString('rooms', roomsJson),
    Future.wait(screenshotRooms.map((room) async {
      final roomName = room['roomName'] as String;
      final isAnalyzing = room['isAnalyzing'] as bool;
      await prefs.setBool('${roomName}_isAnalyzing', isAnalyzing);
    }).toList()),
    Future.wait(screenshotRooms.map((room) async {
      if (room['analysisResult'] != null) {
        final roomName = room['roomName'] as String;
        await prefs.setString('${roomName}_analysis_data', jsonEncode(room['analysisResult']));
        await prefs.setBool('${roomName}_hasAnalysisResult', true); // Ensure hasAnalysisResult is set
      }
    }).toList()),
  ]);

  debugPrint('방 목록 저장 완료: ${screenshotRooms.length}개 방');
}

void _startAnalysis(String roomName, Uint8List bytes, String? filePath, String analysisOption) async {
  final SharedPreferences prefs = await _prefs;
  final isAnalyzing = prefs.getBool('${roomName}_isAnalyzing') ?? false;
  final analysisData = prefs.getString('${roomName}_analysis_data');
  bool hasAnalysisResult = prefs.getBool('${roomName}_hasAnalysisResult') ?? (analysisData != null && analysisData.isNotEmpty);

  if (analysisData == null || analysisData.isEmpty) {
    hasAnalysisResult = false;
    await prefs.setBool('${roomName}_hasAnalysisResult', false);
  }

  if (hasAnalysisResult) {
    debugPrint('방 $roomName: 이미 분석 완료됨, 재분석 스킵');
    if (isAnalyzing) {
      await prefs.setBool('${roomName}_isAnalyzing', false);
      debugPrint('분석 완료 상태에서 isAnalyzing 플래그 강제로 false로 설정: $roomName');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          final roomIndex = screenshotRooms.indexWhere((room) => room['roomName'] == roomName);
          if (roomIndex != -1) {
            screenshotRooms[roomIndex]['isAnalyzing'] = false;
            screenshotRooms[roomIndex]['displayName'] = screenshotRooms[roomIndex]['roomName'] as String;
            if (analysisData != null) {
              try {
                screenshotRooms[roomIndex]['analysisResult'] = jsonDecode(analysisData);
              } catch (e) {
                debugPrint('분석 데이터 파싱 오류: $e');
                screenshotRooms[roomIndex]['displayName'] = 'Room${roomIndex + 1} (Error)';
              }
            } else {
              screenshotRooms[roomIndex]['displayName'] = 'Room${roomIndex + 1} (Error)';
            }
          }
        });
        debugPrint('UI 업데이트: $roomName, 이미 완료된 방 반영');
        saveRooms();
      }
    });
    return;
  }

  if (isAnalyzing && _analysisSubscriptions.containsKey(roomName)) {
    debugPrint('방 $roomName: 이미 분석 중, 중복 요청 무시');
    return;
  }

  // 고유 ID 생성 (타임스탬프 기반)
  final roomId = '${roomName}_${DateTime.now().millisecondsSinceEpoch}';
  await prefs.setString('${roomName}_roomId', roomId);
  await prefs.setBool('${roomName}_isAnalyzing', true);
  await prefs.setBool('${roomName}_hasAnalysisResult', false);
  await prefs.remove('${roomName}_analysis_data');
  debugPrint('분석 시작: $roomName, roomId=$roomId, SharedPreferences 초기화 및 isAnalyzing 플래그 설정 완료');

  final service = await getBackgroundService();
  bool isServiceRunning = await service.isRunning();
  if (!isServiceRunning) {
    debugPrint('백그라운드 서비스 시작: $roomName');
    await service.startService();
  } else {
    debugPrint('백그라운드 서비스 이미 실행 중, 재사용: $roomName');
  }

  // roomId 등록 완료를 기다림
  final completer = Completer<void>();
  final registerSubscription = service.on('roomRegistered').listen((event) {
    if (event != null && event['roomId'] == roomId) {
      completer.complete();
    }
  });

  // roomId 등록 요청
  service.invoke('registerRoom', {'roomId': roomId, 'roomName': roomName});
  
  // 등록 완료 대기 (최대 5초)
  await completer.future.timeout(Duration(seconds: 5), onTimeout: () {
    debugPrint('roomId 등록 타임아웃: $roomId');
    registerSubscription.cancel();
    throw Exception('roomId 등록 실패');
  });

  registerSubscription.cancel();

    service.invoke('analyzeScreenshot', {
    'roomId': roomId,
    'roomName': roomName,
    'image': base64Encode(bytes),
    'filePath': filePath,
    'currentLanguage': widget.currentLanguage,
    'translations': widget.translations,
    'analysisOption': analysisOption,
    'isVIP': widget.isVIP, // isVIP 값 전달 추가
  });

    final analysisSubscription = service.on('analysisComplete').listen((event) async {
    if (event == null || event['roomId'] != roomId || event['roomName'] != roomName) {
      debugPrint('분석 완료 이벤트 무시: roomId=$roomId, roomName=$roomName, 이벤트=$event');
      return;
    }

    final result = event['result'] as String?;
    final isVIP = event['isVIP'] as bool? ?? false; // isVIP 값 수신

    if (result == null) {
      debugPrint('분석 결과가 null입니다: $roomName');
      await prefs.setBool('${roomName}_isAnalyzing', false);
      await prefs.setBool('${roomName}_hasAnalysisResult', false);
      await prefs.remove('${roomName}_analysis_data');
      service.invoke('analysisFailed', {
        'roomId': roomId,
        'roomName': roomName,
        'error': '분석 결과가 null입니다.',
      });
      return;
    }

    final roomIndex = screenshotRooms.indexWhere((room) => room['roomName'] == roomName);
    if (roomIndex == -1) {
      debugPrint('방이 삭제됨: $roomName, 분석 중지');
      await _clearRoomData(roomName);
      return;
    }

    try {
      final decodedResult = jsonDecode(result);
      debugPrint('분석 완료: $roomName, UI 업데이트 시작');
      await prefs.setString('${roomName}_analysis_data', jsonEncode(decodedResult));
      await prefs.setBool('${roomName}_isAnalyzing', false);
      await prefs.setBool('${roomName}_hasAnalysisResult', true);
      debugPrint('분석 완료 후 isAnalyzing 플래그 false로 설정: $roomName');

      // 광고 표시 로직 추가
      if (!isVIP) {
        final myAppState = context.findAncestorStateOfType<_MyAppState>();
        if (myAppState != null) {
          await myAppState.incrementApiCallCount(isVIP);
          debugPrint('분석 완료 후 광고 표시 호출: roomName=$roomName');
        } else {
          debugPrint('광고 표시 실패: _MyAppState를 찾을 수 없음');
        }
      } else {
        debugPrint('VIP 사용자: 광고 표시 스킵');
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            screenshotRooms[roomIndex]['isAnalyzing'] = false;
            screenshotRooms[roomIndex]['analysisResult'] = decodedResult;
            screenshotRooms[roomIndex]['displayName'] = screenshotRooms[roomIndex]['roomName'] as String;
          });
          debugPrint('UI 업데이트 완료: $roomName, isAnalyzing=${screenshotRooms[roomIndex]['isAnalyzing']}');
          saveRooms().then((_) => loadRooms());
        }
      });
    } catch (e) {
      debugPrint('분석 결과 파싱 오류: $e');
      await prefs.setBool('${roomName}_isAnalyzing', false);
      await prefs.setBool('${roomName}_hasAnalysisResult', false);
      await _clearRoomData(roomName);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            screenshotRooms[roomIndex]['isAnalyzing'] = false;
            screenshotRooms[roomIndex]['displayName'] = 'Room${roomIndex + 1} (Error)';
          });
          debugPrint('UI 업데이트 완료 (오류): $roomName, isAnalyzing=${screenshotRooms[roomIndex]['isAnalyzing']}');
          saveRooms().then((_) => loadRooms());
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "이미지 처리 중 오류가 발생했습니다. 다른 스크린샷을 업로드해 주세요.",
              style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
              maxLines: 2,
            ),
          ),
        );
      }
    } finally {
      _analysisSubscriptions.remove(roomName)?.cancel();
      debugPrint('분석 완료 후 서비스 종료: $roomName');
      if (_analysisSubscriptions.isEmpty) {
        service.invoke('stopService');
        debugPrint('모든 분석 구독 종료, 백그라운드 서비스 종료');
      }
    }
  });

  service.on('analysisFailed').listen((event) async {
    if (event == null || event['roomId'] != roomId || event['roomName'] != roomName) {
      debugPrint('분석 실패 이벤트 무시: roomId=$roomId, roomName=$roomName, 이벤트=$event');
      return;
    }

    final roomIndex = screenshotRooms.indexWhere((room) => room['roomName'] == roomName);
    if (roomIndex == -1) {
      debugPrint('방이 삭제됨: $roomName, 분석 중지');
      await _clearRoomData(roomName);
      return;
    }
    await prefs.setBool('${roomName}_isAnalyzing', false);
    await prefs.setBool('${roomName}_hasAnalysisResult', false);
    await _clearRoomData(roomName);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          screenshotRooms[roomIndex]['isAnalyzing'] = false;
          screenshotRooms[roomIndex]['displayName'] = 'Room${roomIndex + 1} (Error)';
        });
        debugPrint('UI 업데이트 완료 (실패): $roomName, isAnalyzing=${screenshotRooms[roomIndex]['isAnalyzing']}');
        saveRooms().then((_) => loadRooms());
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "이미지 처리 중 오류가 발생했습니다. 다른 스크린샷을 업로드해 주세요.",
          style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
          maxLines: 2,
        ),
      ),
    );
    _analysisSubscriptions.remove(roomName)?.cancel();
    debugPrint('분석 실패 후 서비스 종료: $roomName');
    if (_analysisSubscriptions.isEmpty) {
      service.invoke('stopService');
      debugPrint('모든 분석 구독 종료, 백그라운드 서비스 종료');
    }
  });

  _analysisSubscriptions[roomName] = analysisSubscription;
}
Future<void> _checkPendingAnalysesForDuplicates() async {
  final SharedPreferences prefs = await _prefs;
  await prefs.reload(); // 캐시 강제 동기화 추가
  for (var room in List.from(screenshotRooms)) {
    final roomName = room['roomName'] as String;
    final isAnalyzing = prefs.getBool('${roomName}_isAnalyzing') ?? false;
    final analysisData = prefs.getString('${roomName}_analysis_data');
    bool hasAnalysisResult = prefs.getBool('${roomName}_hasAnalysisResult') ?? (analysisData != null && analysisData.isNotEmpty);

    // analysisData가 없으면 hasAnalysisResult를 false로 강제 설정
    if (analysisData == null || analysisData.isEmpty) {
      hasAnalysisResult = false;
      await prefs.setBool('${roomName}_hasAnalysisResult', false);
    }

    debugPrint('분석 결과 상태 - $roomName: '
        'isAnalyzing=$isAnalyzing, '
        'hasAnalysisResult=$hasAnalysisResult, '
        'analysisData=${analysisData?.substring(0, 30)}...');

    if (isAnalyzing) {
      debugPrint('방 $roomName: 분석 진행 중, UI 업데이트 스킵');
      continue; // 분석 중이면 UI 업데이트 스킵
    }

    if (hasAnalysisResult) {
      debugPrint('방 $roomName: 이미 분석 완료됨, 재분석 스킵');
      if (isAnalyzing) {
        await prefs.setBool('${roomName}_isAnalyzing', false);
        await prefs.setBool('${roomName}_hasAnalysisResult', true);
        debugPrint('분석 완료 상태에서 isAnalyzing 플래그 강제로 false로 설정: $roomName');
      }
      final roomIndex = screenshotRooms.indexWhere((r) => r['roomName'] == roomName);
      if (roomIndex != -1 && mounted) {
        setState(() {
          screenshotRooms[roomIndex]['isAnalyzing'] = false;
          screenshotRooms[roomIndex]['displayName'] = screenshotRooms[roomIndex]['roomName'] as String;
          if (analysisData != null) {
            try {
              screenshotRooms[roomIndex]['analysisResult'] = jsonDecode(analysisData);
            } catch (e) {
              debugPrint('분석 데이터 파싱 오류: $e');
              screenshotRooms[roomIndex]['displayName'] = 'Room${roomIndex + 1} (Error)';
            }
          } else {
            screenshotRooms[roomIndex]['displayName'] = 'Room${roomIndex + 1} (Error)';
          }
        });
        debugPrint('UI 업데이트: $roomName, 이미 완료된 방 반영');
        await saveRooms();
      }
      continue;
    }

    if (isAnalyzing && !hasAnalysisResult && !_analysisSubscriptions.containsKey(roomName)) {
      debugPrint('방 $roomName: 백그라운드에서 분석 계속 진행 중');
      final analysisOption = prefs.getString('${roomName}_analysis_option') ?? '기본';
      final roomIndex = screenshotRooms.indexWhere((room) => room['roomName'] == roomName);
      if (roomIndex != -1 && screenshotRooms[roomIndex]['image'] != null) {
        _startAnalysis(roomName, screenshotRooms[roomIndex]['image'] as Uint8List, null, analysisOption);
      } else {
        debugPrint('방 $roomName: 이미지 데이터 누락, 분석 스킵');
        await prefs.setBool('${roomName}_isAnalyzing', false);
        await prefs.setBool('${roomName}_hasAnalysisResult', false);
        await saveRooms();
      }
    } else if (isAnalyzing && !hasAnalysisResult && _analysisSubscriptions.containsKey(roomName)) {
      debugPrint('방 $roomName: 이미 분석 중, 중복 분석 스킵');
      continue; // 분석 중이면 UI 업데이트 스킵
    } else if (isAnalyzing && hasAnalysisResult) {
      debugPrint('방 $roomName: 분석 상태 불일치 감지, 플래그 정리');
      await prefs.setBool('${roomName}_isAnalyzing', false);
      final roomIndex = screenshotRooms.indexWhere((room) => room['roomName'] == roomName);
      if (roomIndex != -1 && mounted) {
        setState(() {
          screenshotRooms[roomIndex]['isAnalyzing'] = false;
          if (analysisData != null) {
            try {
              screenshotRooms[roomIndex]['analysisResult'] = jsonDecode(analysisData);
            } catch (e) {
              debugPrint('분석 데이터 파싱 오류: $e');
              screenshotRooms[roomIndex]['displayName'] = 'Room${roomIndex + 1} (Error)';
            }
          } else {
            screenshotRooms[roomIndex]['displayName'] = 'Room${roomIndex + 1} (Error)';
          }
        });
        await saveRooms();
      }
    }
  }
}
  Future<Map<String, bool>> checkAndRequestPermissions() async {
  bool hasStoragePermission = false;
  bool hasPhotosPermission = false;

  debugPrint('권한 확인 시작: 저장소 및 사진 권한');

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;
    debugPrint('안드로이드 SDK 버전: $sdkInt');

    if (sdkInt >= 33) {
      hasPhotosPermission = await Permission.photos.status.isGranted;
      debugPrint('사진 권한 상태 (SDK 33 이상): $hasPhotosPermission');
      if (!hasPhotosPermission) {
        hasPhotosPermission = await Permission.photos.request().isGranted;
        debugPrint('사진 권한 요청 결과: $hasPhotosPermission');
      }
      hasStoragePermission = await Permission.storage.status.isGranted;
      debugPrint('저장소 권한 상태 (SDK 33 이상): $hasStoragePermission');
      if (!hasStoragePermission) {
        hasStoragePermission = await Permission.storage.request().isGranted;
        debugPrint('저장소 권한 요청 결과: $hasStoragePermission');
      }
    } else if (sdkInt >= 30) {
      hasStoragePermission = await Permission.storage.status.isGranted;
      debugPrint('저장소 권한 상태 (SDK 30 이상): $hasStoragePermission');
      if (!hasStoragePermission) {
        hasStoragePermission = await Permission.storage.request().isGranted;
        debugPrint('저장소 권한 요청 결과: $hasStoragePermission');
      }
      hasPhotosPermission = await Permission.photos.status.isGranted;
      debugPrint('사진 권한 상태 (SDK 30 이상): $hasPhotosPermission');
      if (!hasPhotosPermission) {
        hasPhotosPermission = await Permission.photos.request().isGranted;
        debugPrint('사진 권한 요청 결과: $hasPhotosPermission');
      }
    } else {
      hasStoragePermission = await Permission.storage.status.isGranted;
      debugPrint('저장소 권한 상태 (SDK 30 미만): $hasStoragePermission');
      if (!hasStoragePermission) {
        hasStoragePermission = await Permission.storage.request().isGranted;
        debugPrint('저장소 권한 요청 결과: $hasStoragePermission');
      }
    }
  } else if (Platform.isIOS) {
    hasPhotosPermission = await Permission.photos.status.isGranted;
    debugPrint('iOS 사진 권한 상태: $hasPhotosPermission');
    if (!hasPhotosPermission) {
      hasPhotosPermission = await Permission.photos.request().isGranted;
      debugPrint('iOS 사진 권한 요청 결과: $hasPhotosPermission');
      if (!hasPhotosPermission) {
        debugPrint('iOS 사진 권한 거부됨');
      }
    }
    // iOS에서는 저장소 권한 불필요
    hasStoragePermission = true;
  }

  debugPrint('최종 권한 상태: hasStoragePermission=$hasStoragePermission, hasPhotosPermission=$hasPhotosPermission');
  return {
    'hasStoragePermission': hasStoragePermission,
    'hasPhotosPermission': hasPhotosPermission,
  };
}

  void createNewRoom() async {
    if (screenshotRooms.length >= 10) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AlertDialog(
                backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
                elevation: 8,
                surfaceTintColor: Colors.transparent,
                title: Text(
                  widget.translations["최대 10개 방만 생성 가능합니다."] ?? "최대 10개 방만 생성 가능합니다.",
                  style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, fontSize: 18, wordSpacing: 1.5),
                  maxLines: 2,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      widget.translations["확인"] ?? "확인",
                      style: const TextStyle(color: Color(0xFF7539BB), fontSize: 15, wordSpacing: 1.5),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }
      return;
    }

    int analyzingRoomsCount = screenshotRooms.where((room) => room['isAnalyzing'] == true).length;
    if (analyzingRoomsCount >= 3) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.translations["최대 3개 방만 동시에 분석 가능합니다."] ?? "최대 3개 방만 동시에 분석 가능합니다.",
              style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
              maxLines: 2,
            ),
          ),
        );
      }
      return;
    }

    if (!widget.isVIP) {
  final today = DateTime.now();
  if (!_isSameWeek(_lastResetDate, today)) {
    _screenshotCountToday = 0;
    _lastResetDate = today;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('screenshotLastResetDate', today.toIso8601String());
    await prefs.setInt('screenshotCountWeek', 0);
  }
  if (_screenshotCountToday >= 3) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AlertDialog(
              backgroundColor: widget.isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
              elevation: 8,
              surfaceTintColor: Colors.transparent,
              title: Text(
                "이번 주 무료 횟수를 다 소진했습니다.\n다음 주에 다시 오세요!".tr(),
                style: TextStyle(
                  color: widget.isDarkTheme ? Colors.white : Colors.black,
                  fontSize: 18,
                  wordSpacing: 1.5,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onShowVIPDialog();
                  },
                  child: Text(
                    widget.translations["확인"] ?? "확인",
                    style: const TextStyle(color: Color(0xFF7539BB), fontSize: 15, wordSpacing: 1.5),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }
    return;
  }
}

    debugPrint('권한 요청 시작');
    final permissions = await checkAndRequestPermissions();
    debugPrint('권한 요청 결과: $permissions');

    if (!permissions['hasStoragePermission']! && !permissions['hasPhotosPermission']!) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.translations["필요한 권한이 없습니다. 설정에서 권한을 허용해주세요."] ?? "필요한 권한이 없습니다. 설정에서 권한을 허용해주세요.",
              style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
              maxLines: 2,
            ),
            action: SnackBarAction(
              label: "설정으로 이동".tr(),
              onPressed: () async {
                await openAppSettings();
              },
            ),
          ),
        );
      }
      return;
    }

    final analysisOptions = [
      {
        "display": "기본".tr(),
        "value": "기본",
        "icon": Icons.analytics,
        "color": Colors.blue,
        "description": "대화의 전반적인 흐름과\n상태를 균형 있게 분석하여\n개선점을 제안합니다.".tr()
      },
      {
        "display": "연인으로\n발전할 수 있을까요?".tr(),
        "value": "연인으로 발전",
        "icon": Icons.favorite,
        "color": Colors.pink.shade200,
        "description": "연인 관계로 발전할 가능성과\n호감 신호를\n심층적으로 분석합니다.".tr()
      },
      {
        "display": "이 관계,\n더 가까워지고 싶어요".tr(),
        "value": "더 가까워지고 싶어요",
        "icon": Icons.favorite_border,
        "color": Colors.yellow,
        "description": "상대방과의 친밀도를 높일 수 있는\n감정 흐름과 기회를\n분석합니다.".tr()
      },
      {
        "display": "이제는\n끝내고 싶어요".tr(),
        "value": "끝내고 싶어요",
        "icon": Icons.block,
        "color": Colors.grey.shade400, // 밝은 회색으로 변경
        "description": "관계 단절 신호를 탐지하고\n정리하는 방향으로\n대화를 분석합니다.".tr()
      },
      {
        "display": "오해를\n풀고 싶어요".tr(),
        "value": "오해 풀기",
        "icon": Icons.handshake,
        "color": Colors.brown,
        "description": "대화에서 오해가 발생한\n맥락을 분석하고\n해소 방안을 제안합니다.".tr()
      },
      {
        "display": "지금 상태가\n그냥 궁금해요".tr(),
        "value": "현재 상태",
        "icon": Icons.question_mark,
        "color": Colors.green,
        "description": "현재 대화의 흐름과\n분위기를 중립적으로 분석하여\n상태를 파악합니다.".tr()
      },
    ];
    debugPrint('분석 선택 다이얼로그 표시 시작');
    PageController pageController = PageController(viewportFraction: 0.55, initialPage: 0);
    String? selectedOption = await showDialog<String>(
      context: context,
      builder: (context) {
        debugPrint('Dialog 빌더 호출');
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  clipBehavior: Clip.none,
                  controller: pageController,
                  itemCount: analysisOptions.length,
                  itemBuilder: (context, index) {
                    final option = analysisOptions[index];
                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        bool isCenter = false;
                        if (pageController.position.haveDimensions) {
                          value = (pageController.page! - index).abs();
                          value = (1 - (value * 0.3)).clamp(0.0, 1.0);
                          isCenter = value > 0.9;
                        } else {
                          value = index == 0 ? 1.0 : 0.7;
                          isCenter = index == 0;
                        }
                        double iconSize = isCenter ? 48 : 40;
                        double titleFontSize = isCenter ? 18 : 16;
                        double descriptionFontSize = isCenter ? 14 : 12;
                        return Center(
                          child: SizedBox(
                            height: isCenter ? Curves.easeOut.transform(value) * 280 : Curves.easeOut.transform(value) * 250,
                            width: isCenter ? Curves.easeOut.transform(value) * 220 : Curves.easeOut.transform(value) * 200,
                            child: child,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: colorController,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 0.05,
                                    color: Colors.transparent,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                    end: Alignment.bottomRight.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                    colors: gradientColors,
                                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                  ),
                                ),
                                child: Card(
                                  color: widget.isDarkTheme ? Colors.black : Colors.white,
                                  elevation: widget.isDarkTheme ? 0 : 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      debugPrint('Option selected: ${option['value']}');
                                      Navigator.pop(context, option['value'] as String);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: ValueListenableBuilder<bool>(
                                        valueListenable: pageController.hasClients && pageController.position.haveDimensions
                                            ? ValueNotifier((pageController.page! - index).abs() <= 0.1)
                                            : ValueNotifier(index == 0),
                                        builder: (context, isCenter, _) {
                                          double iconSize = isCenter ? 48 : 40;
                                          double titleFontSize = isCenter ? 18 : 16;
                                          double descriptionFontSize = isCenter ? 14 : 12;
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                option['icon'] as IconData,
                                                color: option['color'] as Color,
                                                size: iconSize,
                                              ),
                                              const SizedBox(height: 8),
                                              widget.isDarkTheme
                                                  ? AutoSizeText(
                                                      option['display'] as String,
                                                      style: const TextStyle(
                                                        color: Color(0xFFC56BFF),
                                                        fontWeight: FontWeight.bold,
                                                        wordSpacing: 1.5,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                      minFontSize: 12,
                                                      maxFontSize: titleFontSize,
                                                      stepGranularity: 0.1,
                                                    )
                                                  : AnimatedBuilder(
                                                      animation: colorController,
                                                      builder: (context, child) {
                                                        return ShaderMask(
                                                          shaderCallback: (bounds) => LinearGradient(
                                                            begin: Alignment.topLeft.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                                            end: Alignment.bottomRight.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                                            colors: gradientColors,
                                                            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                                          ).createShader(bounds),
                                                          child: AutoSizeText(
                                                            option['display'] as String,
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              wordSpacing: 1.5,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                            maxLines: 2,
                                                            minFontSize: 12,
                                                            maxFontSize: titleFontSize,
                                                            stepGranularity: 0.1,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                              const SizedBox(height: 8),
                                              AutoSizeText(
                                                option['description'] as String,
                                                style: TextStyle(
                                                  color: widget.isDarkTheme ? Colors.white : const Color(0xFF9575CD),
                                                  wordSpacing: 1.5,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                minFontSize: 8,
                                                maxFontSize: descriptionFontSize,
                                                stepGranularity: 0.1,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () {
                                debugPrint('분석 선택 다이얼로그 닫기');
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.isDarkTheme ? Colors.white70 : Colors.grey.shade300,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: widget.isDarkTheme ? Colors.black : Colors.black87,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    debugPrint('분석 선택 다이얼로그 닫힘, 선택된 옵션: $selectedOption');

    if (selectedOption == null) {
      debugPrint('분석 선택 취소');
      return;
    }

    debugPrint('FilePicker 호출 시작');
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
  debugPrint('FilePicker 결과: ${result != null ? "파일 선택됨" : "파일 선택 안됨"}');

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.first;
    Uint8List? bytes;
    String? filePath = file.path;

    // iOS 또는 안드로이드에서 bytes가 null이면 파일 경로에서 읽기 시도
    if (file.bytes != null) {
      bytes = file.bytes!;
    } else if (filePath != null) {
      try {
        bytes = await File(filePath).readAsBytes();
      } catch (e) {
        debugPrint('파일 읽기 오류: $e');
      }
    }

    if (bytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.translations["이미지 데이터를 가져올 수 없습니다."] ?? "이미지 데이터를 가져올 수 없습니다.",
              style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
              maxLines: 2,
            ),
          ),
        );
      }
      return;
    }

    final extension = file.extension?.toLowerCase();
    if (!['jpg', 'jpeg', 'png'].contains(extension)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.translations["JPG 또는 PNG 형식만 지원됩니다."] ?? "JPG 또는 PNG 형식만 지원됩니다.",
              style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
              maxLines: 2,
            ),
          ),
        );
      }
      return;
    }

    if (mounted) {
      await _incrementScreenshotCount();

      // 캐시 디렉토리 처리 (iOS에서도 동일하게 적용)
      final cacheDir = await getTemporaryDirectory();
      final filePickerCacheDir = Directory('${cacheDir.path}/file_picker');
      if (await filePickerCacheDir.exists()) {
        final nomediaFile = File('${filePickerCacheDir.path}/.nomedia');
        if (!await nomediaFile.exists()) {
          await nomediaFile.create();
          debugPrint('FilePicker 캐싱 디렉토리에 .nomedia 파일 생성: ${nomediaFile.path}');
        }
      }

      setState(() {
        int roomNumber = screenshotRooms.length + 1;
        String roomName = 'Room$roomNumber';
        while (screenshotRooms.any((room) => room['roomName'] == roomName)) {
          roomNumber++;
          roomName = 'Room$roomNumber';
        }
        screenshotRooms.add({
          'key': ValueKey(roomName),
          'roomName': roomName,
          'displayName': widget.translations["분석 중"] ?? "분석 중",
          'image': bytes,
          'isAnalyzing': true,
          'analysisResult': null,
          'analysisOption': selectedOption,
        });
        debugPrint('새 방 추가: $roomName, screenshotRooms 길이: ${screenshotRooms.length}');
        tapControllers.add(AnimationController(vsync: this, duration: const Duration(milliseconds: 100)));
        tapScales.add(Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: tapControllers.last, curve: Curves.easeInOut)));
        debugPrint('tapControllers 길이: ${tapControllers.length}, tapScales 길이: ${tapScales.length}');
      });

      await saveRooms();
      final roomName = screenshotRooms.last['roomName'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${roomName}_analysis_option', selectedOption);
      _startAnalysis(roomName, bytes, filePath, selectedOption);
    }
  } else {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.translations["이미지를 선택하지 않았습니다."] ?? "이미지를 선택하지 않았습니다.",
            style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
            maxLines: 2,
          ),
        ),
      );
    }
  }
}

  Widget buildBookmark(String analysisOption) {
    Color optionColor;
    Color darkerOptionColor;

    switch (analysisOption) {
      case '기본':
        optionColor = Colors.blue;
        darkerOptionColor = _getDarkerColor(optionColor);
        break;
      case '더 가까워지고 싶어요':
        optionColor = Colors.yellow;
        darkerOptionColor = _getDarkerColor(optionColor);
        break;
      case '끝내고 싶어요':
        optionColor = Colors.grey.shade400; // 밝은 회색
        darkerOptionColor = Colors.black; // 검정색으로 그라데이션
        break;
      case '연인으로 발전':
        optionColor = Colors.pink.shade200;
        darkerOptionColor = const Color(0xFFD1C4E9);
        break;
      case '오해 풀기':
        optionColor = Colors.brown;
        darkerOptionColor = _getDarkerColor(optionColor);
        break;
      case '현재 상태':
        optionColor = Colors.green;
        darkerOptionColor = _getDarkerColor(optionColor);
        break;
      default:
        optionColor = Colors.blue;
        darkerOptionColor = _getDarkerColor(optionColor);
    }

    return AnimatedBuilder(
      animation: colorAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
            end: Alignment.bottomRight.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
            colors: [
              optionColor,
              darkerOptionColor,
              optionColor,
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: const Icon(
            Icons.bookmark,
            color: Colors.white,
            size: 28,
          ),
        );
      },
    );
  }

  Future<void> _clearRoomData(String roomName) async {
  final SharedPreferences prefs = await _prefs;
  final roomId = prefs.getString('${roomName}_roomId');
  await prefs.remove('${roomName}_analysis_data');
  await prefs.remove('${roomName}_isAnalyzing');
  await prefs.remove('${roomName}_hasAnalysisResult');
  await prefs.remove('${roomName}_analysis_option');
  await prefs.remove('${roomName}_roomId');
  debugPrint('방 데이터 영구 삭제 완료: $roomName, 키: ${roomName}_analysis_data');

  // 백그라운드 서비스 작업 중지
  final service = await getBackgroundService();
  if (roomId != null) {
    service.invoke('stopAnalysis', {'roomId': roomId, 'roomName': roomName});
  }
  _analysisSubscriptions.remove(roomName)?.cancel();
}

  Future<Map<String, dynamic>> extractTextWithPosition(Uint8List bytes, String? filePath, String currentLanguage, Map<String, String> translations) async {
  TextRecognizer? textRecognizer;
  String? tempPath;
  try {
    TextRecognitionScript script;
    switch (currentLanguage) {
      case 'ja':
        script = TextRecognitionScript.japanese;
        break;
      case 'ko':
        script = TextRecognitionScript.korean;
        break;
      case 'zh':
        script = TextRecognitionScript.chinese;
        break;
      default:
        script = TextRecognitionScript.latin;
    }
    textRecognizer = TextRecognizer(script: script);

    // iOS와 안드로이드 모두에서 filePath가 제공되지 않을 경우 대비
    if (filePath == null) {
      final tempDir = await getTemporaryDirectory();
      final nomediaFile = File('${tempDir.path}/.nomedia');
      if (!await nomediaFile.exists()) {
        await nomediaFile.create();
        debugPrint('갤러리 스캔 방지를 위해 .nomedia 파일 생성: ${nomediaFile.path}');
      }

      tempPath = '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(bytes);
      debugPrint('임시 파일 생성: $tempPath');
      filePath = tempPath;
    }

    final inputImage = InputImage.fromFilePath(filePath);
    final recognizedText = await textRecognizer.processImage(inputImage);

    String fullText = recognizedText.text.trim();
    List<Message> messages = [];

    final decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) {
      throw Exception('이미지 디코딩 실패');
    }
    double imageWidth = decodedImage.width.toDouble();
    double imageHeight = decodedImage.height.toDouble();
    debugPrint('동적 이미지 크기: width=$imageWidth, height=$imageHeight');

    double topBarThreshold = imageHeight * 0.05;
    double inputBarThreshold = imageHeight * 0.85;

    RegExp systemTextPattern = RegExp(
      r'^(?:[월화수목금토일]요일\s*)?(?:\d{1,2}[:;]\d{2}(?::\d{2})?\s*(?:AM|PM|오전|오후)?|오후\s*\d{1,2}[:;]\d{2}|오전\s*\d{1,2}[:;]\d{2})$|' // 시간
      r'^\d{4}년\s*\d{1,2}(?:월|철)\s*\d{1,2}일\s*(?:[월화수목금토일효릴]요일\s*)?(?:>)?$|' // 날짜
      r'^(?:olleh|SKT|KT|Verizon|AT&T|T-Mobile|[0-9]{3}olleh\s*LTE|Chat|Send|Message)$|' // 통신사 및 UI 요소
      r'^(?:#|\+|\|)$', // 기호
      caseSensitive: false,
    );

    int messageId = 0;
    for (var block in recognizedText.blocks) {
      final boundingBox = block.boundingBox;
      if (boundingBox != null) {
        final x = boundingBox.left.toDouble();
        final X = boundingBox.right.toDouble();
        final y = boundingBox.top.toDouble();
        final width = X - x;
        final height = (boundingBox.bottom - boundingBox.top).toDouble();
        String text = block.text.trim();

        bool isInTopBarOrInputBar = y < topBarThreshold || y > inputBarThreshold;
        bool isSystemText = systemTextPattern.hasMatch(text);

        if (isInTopBarOrInputBar && isSystemText) {
          debugPrint('상단바/입력창 제외 (시스템 텍스트): "$text" (y=$y, x=$x)');
          continue;
        }

        if (isInTopBarOrInputBar && !isSystemText) {
          debugPrint('상단바/입력창 위치지만 대화 텍스트로 유지: "$text" (y=$y, x=$x)');
        }

        final backgroundColor = Colors.transparent;
        messages.add(Message(text, x, X, y, width, height, backgroundColor, id: messageId++));
      }
    }

    if (messages.isNotEmpty) {
      imageWidth = messages.map((m) => m.x + m.width).reduce((a, b) => a > b ? a : b);
    }

    debugPrint('추출된 텍스트: $fullText');
    return {
      'text': fullText,
      'messages': messages,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
    };
  } catch (e) {
    debugPrint('ML Kit 텍스트 인식 오류: $e');
    throw Exception('ML Kit 텍스트 인식 오류: $e');
  } finally {
    if (tempPath != null) {
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
        debugPrint('임시 파일 삭제: $tempPath');
      }
    }
    await textRecognizer?.close();
  }
}
  int _levenshteinDistance(String s1, String s2) {
    final m = s1.length;
    final n = s2.length;
    List<List<int>> dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (int j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + [
            dp[i - 1][j],
            dp[i][j - 1],
            dp[i - 1][j - 1],
          ].reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[m][n];
  }

  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    final distance = _levenshteinDistance(s1, s2);
    final maxLength = s1.length > s2.length ? s1.length : s2.length;
    return (1 - distance / maxLength) * 100;
  }

  
Future<Map<String, dynamic>> analyzeText(Map<String, dynamic> separatedMessages, String currentLanguage, Map<String, String> translations, String analysisOption) async {
  final client = http.Client();
  const maxRetries = 3;
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      List<Map<String, dynamic>> conversation = (separatedMessages['conversation'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];

      bool isFormal = false;
      int formalCount = 0;
      int totalMessages = 0;

      for (var entry in conversation) {
        String text = entry['text'].toString().trim();
        totalMessages++;
        if (currentLanguage == 'ko') {
          if (text.contains('습니다') || text.contains('요') || text.contains('세요') || text.contains('시다') || text.endsWith('다') || text.contains('니')) {
            formalCount++;
          }
        } else {
          formalCount++;
        }
      }

      if (totalMessages > 0) {
        isFormal = (formalCount / totalMessages) > 0.5;
      }
      debugPrint('대화 맥락 존댓말 여부: $isFormal (formalCount=$formalCount, totalMessages=$totalMessages)');

      String conversationLog = conversation
          .map((entry) => '${entry['speaker']}: ${entry['text']} ${entry['timestamp'].isNotEmpty ? '[${entry['timestamp']}]' : ''}')
          .join('\n');

      String analysisFocus = '';
      String analysisResultDescription = '';
      String additionalInstruction = '''
         ### 추가 분석 지침:
          사용자가 선택한 분석 옵션 "${analysisOption}"은 사용자의 분석 의도를 강하게 반영합니다. 모든 분석 결과는 "${analysisOption}"의 목표와 맥락에 최대한 부합하도록 작성해야 합니다. "${analysisOption}"의 의도와 관련된 감정, 맥락, 대화 흐름을 특히 강조하며, 결과에서 "${analysisOption}"의 목적이 두드러지게 드러나야 합니다. 예를 들어, "${analysisOption}"이 "오해 풀기"라면 오해와 관련된 부분을 심층적으로 분석하고, 오해 해소에 초점을 맞춘 결과를 제공해야 합니다.
          
          - 모든 분석 항목은 **심층적이고 고도화된 분석**을 제공해야 하며, 대화 맥락, 감정 흐름, 상대방의 반응 패턴 등을 매우 세밀히 분석하세요.
          - 분석 결과는 **풍부하고 상세한 설명**으로 채워져야 하며, 사용자가 "우와" 소리가 나올 정도로 만족할 수 있도록 구체적이고 실질적인 조언과 사례를 포함하세요.
          - 분석 결과의 텍스트 양을 조정:
            - 대화 흐름은 간단하고 짧게 50자 이내로 작성.
            - 나의 대화 제안, 희망, 위험은 500자 이내로 작성.
          - 각 항목은 선택된 옵션에 맞춰 **맞춤형 인사이트**를 제공하며, 대화에서 발견된 구체적인 사례를 기반으로 분석 결과를 뒷받침하세요.
          - **언어 설정**: 모든 분석 결과는 반드시 언어 "${currentLanguage == "zh" ? "Standard Chinese (Mandarin)" : currentLanguage}"로 작성하세요. 다른 언어(특히 한국어)가 섞이지 않도록 엄격히 제한합니다.
          - 지정된 언어로 응답이 생성되지 않으면 "Language output error, please retry in ${currentLanguage}"를 출력하세요.
          - 모든 텍스트 항목(대화 흐름, 나의 대화 제안, 희망, 위험 등)은 지정된 언어로 작성되어야 하며, 언어 혼합이 없어야 합니다.
          - 상대방 분석 값(기분, 말투, 의도 등)은 반드시 지정된 언어로 출력되어야 하며, 다른 언어 단어(예: 한국어 "친근함")가 포함되어서는 안 됩니다.
      ''';

      switch (analysisOption) {
        case '더 가까워지고 싶어요':
          analysisFocus = '''
            - 감정 흐름: 상대방의 감정 변화를 매우 세밀히 분석하여 친밀도를 높일 수 있는 포인트를 집중적으로 탐지, 긍정적 감정과 친밀감 증대에 초점
            - 상대의 관심도: 상대방의 메시지에서 관심과 호감 신호를 강하게 탐지, 긍정적 반응에 무게를 둠
            - 기회 포착 지점: 대화를 통해 더 가까워질 수 있는 타이밍과 상황을 적극적으로 분석, 친밀감 증대 기회에 초점
            - 대화 패턴: 나와 상대방의 대화 패턴에서 친밀도를 높일 수 있는 요소(예: 공감 표현, 질문 빈도, 긍정적 반응)를 심층적으로 분석
            - 분석 방향: 모든 분석(대화 흐름, 개선점, 희망, 위기, 추천 응답)은 "더 가까워지고 싶어요"라는 목표에 강하게 맞춰져야 하며, 친밀도를 높이는 데 초점을 맞춤
          ''';
          analysisResultDescription = '''
            - 대화 흐름: 친밀감을 높일 수 있는 대화 패턴과 감정 흐름을 중심으로 간단히 요약 (50자 이내)
            - 개선점: 친밀도를 높이기 위한 구체적이고 실질적인 대화 기술을 심층적으로 제안, 친근한 어조와 긍정적 표현을 강조하고, 대화 사례를 포함하여 실질적인 조언 제공 (500자 이내)
            - 희망: 관계를 더 가까이 발전시킬 가능성과 긍정적 요소를 구체적으로 강조, 대화에서 발견된 호감 신호와 친밀감 요소를 사례로 들어 설명 (500자 이내)
            - 위기: 친밀감을 저해할 수 있는 요소를 심층적으로 분석하고, 이를 극복하여 더 가까워질 수 있는 해결 방안을 구체적으로 제시, 대화 사례 기반 (500자 이내)
            - 추천 응답: 상대방과 더 가까워질 수 있는 자연스럽고 따뜻한 멘트를 제안, 대화 맥락에 맞춘 구체적이고 감성적인 응답 제공
          ''';
          break;
        case '끝내고 싶어요':
          analysisFocus = '''
            - 관계 단절 신호: 상대방의 메시지에서 관계 단절을 암시하는 신호를 강하게 탐지, 부정적 감정과 반응에 초점
            - 회복 가능성: 관계 회복 가능성을 매우 낮게 평가하며, 종료를 고려할 요소에 집중, 대화에서의 갈등 패턴 분석
            - 피로감 분석: 대화에서 나타나는 피로감, 갈등, 감정 소모를 심층적으로 분석
            - 대화 빈도 및 응답 패턴: 대화의 빈도와 응답 패턴에서 관계 유지의 어려움을 분석
            - 분석 방향: 모든 분석(대화 흐름, 개선점, 희망, 위기, 추천 응답)은 "끝내고 싶어요"라는 목표에 강하게 맞춰져야 하며, 관계 종료를 준비하는 데 초점을 맞춤
          ''';
          analysisResultDescription = '''
            - 대화 흐름: 관계 단절로 이어질 수 있는 부정적 패턴과 갈등 요소를 중심으로 간단히 요약 (50자 이내)
            - 개선점: 관계를 정리하기 위한 대화 기술을 심층적으로 제안, 갈등을 최소화하며 정리할 수 있는 방안을 구체적으로 제시, 대화 사례 포함 (500자 이내)
            - 희망: 관계 종료 후 더 나은 방향으로 나아갈 가능성을 구체적으로 강조, 새로운 시작을 위한 긍정적 전망 제시 (500자 이내)
            - 위기: 관계를 유지하는 데 있어 발생하는 주요 문제점을 심층적으로 분석, 종료를 고려해야 할 이유를 대화 사례와 함께 강조 (500자 이내)
            - 추천 응답: 관계를 자연스럽게 정리할 수 있는 차분하고 명확한 멘트를 제안, 대화 맥락에 맞춘 구체적 응답 제공
          ''';
          break;
        case '연인으로 발전':
          analysisFocus = '''
            - 썸/호감 신호: 상대방의 메시지에서 썸이나 호감 신호를 강하게 탐지, 애정 표현과 긍정적 반응에 초점
            - 감정 온도: 상대방의 감정 깊이와 친밀도를 매우 세밀히 분석, 대화에서의 감정 교류 패턴 분석
            - 긍정 표현 탐색: 상대방의 긍정적 표현과 반응을 집중적으로 분석, 로맨틱한 요소를 심층적으로 탐지
            - 대화 주제 및 상호작용: 대화 주제와 상호작용에서 연인으로 발전할 가능성을 높이는 요소를 분석
            - 분석 방향: 모든 분석(대화 흐름, 개선점, 희망, 위기, 추천 응답)은 "연인으로 발전"이라는 목표에 강하게 맞춰져야 하며, 연인 관계로 발전할 가능성을 높이는 데 초점을 맞춤
          ''';
          analysisResultDescription = '''
            - 대화 흐름: 연인으로 발전할 가능성이 있는 호감과 감정 흐름을 중심으로 간단히 요약, 구체적인 대화 사례 포함 (50자 이내)
            - 개선점: 연인으로 발전하기 위한 대화 기술을 심층적으로 제안, 로맨틱한 표현과 감정 교류를 강조하고, 대화 사례를 기반으로 실질적인 조언 제공 (500자 이내)
            - 희망: 연인 관계로 발전할 가능성과 긍정적 신호를 구체적으로 강조, 대화에서 발견된 호감 신호와 로맨틱한 요소를 사례로 들어 설명 (500자 이내)
            - 위기: 연인 관계로 발전을 방해할 수 있는 요소를 심층적으로 분석하고, 이를 극복할 방안을 구체적으로 제시, 대화 사례 기반 (500자 이내)
            - 추천 응답: 상대방의 호감을 강화하고 연인으로 발전할 수 있는 로맨틱한 멘트를 제안, 대화 맥락에 맞춘 구체적이고 감성적인 응답 제공
          ''';
          break;
        case '오해 풀기':
          analysisFocus = '''
            - 감정 충돌 지점: 대화에서 감정 충돌이 발생한 지점을 매우 세밀히 분석, 오해의 원인과 맥락 탐지
            - 오해 발생 타이밍: 오해가 발생한 시점과 맥락을 강하게 탐지, 대화에서의 감정 흐름 분석
            - 대화 패턴: 오해를 유발한 대화 패턴과 상호작용을 심층적으로 분석
            - 분석 방향: 모든 분석(대화 흐름, 개선점, 희망, 위기, 추천 응답)은 "오해 풀기"라는 목표에 강하게 맞춰져야 하며, 오해를 해소하고 관계를 회복하는 데 초점을 맞춤
          ''';
          analysisResultDescription = '''
            - 대화 흐름: 오해가 발생한 맥락과 감정 충돌 지점을 중심으로 간단히 요약, 구체적인 대화 사례 포함 (50자 이내)
            - 개선점: 오해를 풀기 위한 대화 기술을 심층적으로 제안, 진심을 전달하고 이해를 도모할 방안을 구체적으로 제시, 대화 사례 기반 (500자 이내)
            - 희망: 오해를 풀고 관계를 회복할 가능성을 구체적으로 강조, 관계 개선을 위한 긍정적 전망 제시 (500자 이내)
            - 위기: 오해로 인해 발생한 문제점을 심층적으로 분석, 추가 오해를 방지할 방안을 대화 사례와 함께 제시 (500자 이내)
            - 추천 응답: 오해를 풀기 위한 진솔하고 부드러운 멘트를 제안, 대화 맥락에 맞춘 구체적 응답 제공
          ''';
          break;
        case '현재 상태':
          analysisFocus = '''
            - 중립적 감정 흐름: 대화의 감정 흐름을 중립적이고 객관적으로 분석
            - 대화 리듬: 대화의 속도, 응답 패턴, 상호작용 리듬을 세밀히 분석
            - 관심도 추세: 상대방의 관심도 변화 추세를 집중적으로 분석
            - 대화 주제 및 패턴: 대화의 주제와 패턴을 심층적으로 분석, 관계의 현재 상태를 객관적으로 평가
            - 분석 방향: 모든 분석(대화 흐름, 개선점, 희망, 위기, 추천 응답)은 "현재 상태"라는 목표에 강하게 맞춰져야 하며, 객관적이고 중립적인 분석에 초점을 맞춤
          ''';
          analysisResultDescription = '''
            - 대화 흐름: 현재 대화의 객관적 흐름과 분위기를 중심으로 간단히 요약, 구체적인 대화 사례 포함 (50자 이내)
            - 개선점: 현재 대화 상태를 유지하거나 개선하기 위한 중립적인 대화 기술을 심층적으로 제안, 대화 사례 기반 (500자 이내)
            - 희망: 현재 상태를 바탕으로 관계가 나아갈 수 있는 방향을 구체적으로 제시, 긍정적 가능성 강조 (500자 이내)
            - 위기: 현재 상태에서 발생할 수 있는 잠재적 문제점을 심층적으로 분석, 중립적 해결 방안을 대화 사례와 함께 제시 (500자 이내)
            - 추천 응답: 현재 대화 흐름에 맞는 자연스럽고 중립적인 멘트를 제안, 대화 맥락에 맞춘 구체적 응답 제공
          ''';
          break;
        case '기본':
        default:
          analysisFocus = '''
            - 전체 감정 흐름: 대화의 감정 흐름을 균형 있게 분석
            - 상호작용 패턴: 나와 상대방의 대화 패턴을 세밀히 분석
            - 관심도 및 참여도: 상대방의 관심도와 대화 참여도를 균형 있게 분석
            - 분석 방향: 모든 분석(대화 흐름, 개선점, 희망, 위기, 추천 응답)은 "기본"이라는 목표에 강하게 맞춰져야 하며, 균형 잡힌 분석에 초점을 맞춤
          ''';
          analysisResultDescription = '''
            - 대화 흐름: 대화의 전반적인 흐름과 상태를 균형 있게 간단히 요약 (50자 이내)
            - 개선점: 대화의 전반적인 개선을 위한 균형 잡힌 대화 기술 제안 (500자 이내)
            - 희망: 관계의 긍정적 가능성을 균형 있게 제시 (500자 이내)
            - 위기: 관계의 잠재적 문제점을 균형 있게 분석, 해결 방안 제시 (500자 이내)
            - 추천 응답: 대화 맥락에 맞는 자연스러운 멘트 제안
          ''';
          break;
      }

      final prompt = '''
### 출력 언어 지침:
- 모든 출력은 반드시 "${currentLanguage == "zh" ? "Standard Chinese (Mandarin)" : currentLanguage}"로 작성해야 합니다.
- 다른 언어는 절대 포함시키지 마세요.
- 출력 언어가 "${currentLanguage}"가 아니면 "Language output error, please retry in ${currentLanguage}"를 반환하세요.

아래는 메시지 스크린샷에서 추출한 대화 텍스트입니다. 대화는 y 좌표순으로 정렬되어 있으며, 위에서 아래로 진행됩니다. 타임스탬프는 각 메시지 옆에 [오후 11시 40분] 형식으로 표시됩니다:

          대화 흐름:
          $conversationLog

          ### 추가 지침:
          - 대화 로그는 시스템 텍스트(예: "1", "+", "#")가 제거된 상태입니다.확실히 제거가 안될수도 있으니 시스템 텍스트로 간주되는것들은 무조건 제외하세요.
          - 남아있는 텍스트만을 기반으로 분석을 진행하세요.
          - 타임스탬프는 대화 흐름에 반영하세요.
          - 대화가 존댓말인지 반말인지 판단 결과: ${isFormal ? "존댓말" : "반말"} (이 정보를 기반으로 추천 멘트를 생성 시 반영).
          - 출력은 반드시 ${currentLanguage == "zh" ? "Standard Chinese (Mandarin)" : currentLanguage} 언어로 작성하세요.
          - 추천 멘트를 포함한 대화 맥락에 따라 멘트를 생성할 때는 대화가 존댓말이면 존댓말로, 반말이면 반말로 작성하세요.
          - 추천 멘트를 제외한 모든 분석 결과는 무조건 존댓말로 작성하세요.

          $additionalInstruction

          ### 분석 옵션:
          사용자가 선택한 분석 옵션: "$analysisOption"

          분석 포커스:
          $analysisFocus

          분석 결과 설명:
          $analysisResultDescription

          이 텍스트를 심층적으로 분석하여 다음 정보를 JSON 형식으로 반환하세요:
          1. 대화 흐름: 주제와 분위기 변화를 50자 이내로 간단히 요약, 감정 흐름과 맥락 포함 (존댓말로 작성, 분석 옵션에 강하게 맞춤);
          2. 나의 대화 제안: 내 메시지의 어조, 단어 선택, 응답 패턴, 감정 흐름을 정밀히 분석하여, 대화 참여도와 관계 개선을 위한 실용적이고 구체적인 조언을 300자 이내로 제공. 사용자의 강점과 약점을 명확히 지적하고, 상대방 반응과의 상호작용을 고려한 실행 가능한 대화 기술 제안 (존댓말로 작성, 예시 멘트는 대화 맥락에 따라 존댓말/반말로, 분석 옵션에 강하게 맞춤);
          3. 상대방의 기분: 상대방 메시지만 분석, 5개 이상 기분 비율(0-1, 합계 1, 10% 이상), 메시지 내용과 어조 기반 (존댓말로 작성, 분석 옵션에 맞춰 기분 해석);
          4. 상대방의 말투: 10자 이내로 특성 설명 (예: 친근함, 직설적, 따뜻함) (존댓말로 작성, 분석 옵션에 맞춰 해석);
          5. 상대방의 호감도: 긍정적 표현, 응답 속도, 질문 빈도 분석, 0-1 (0: 부정적, 1: 매우 긍정적) (존댓말로 작성, 분석 옵션에 맞춰 해석);
          6. 관계 잠재력: 질문, 연속성, 감정 깊이, 상호작용 패턴 분석, 0-1 (0: 낮음, 1: 높음) (존댓말로 작성, 분석 옵션에 맞춰 해석);
          7. 상대방의 참여도: 응답 일관성, 시간 간격, 주도성 분석, 0-1 (0: 낮음, 1: 높음) (존댓말로 작성, 분석 옵션에 맞춰 해석);
          8. 상대방의 의도: 12자 이내 문장 (예: "친밀감 형성", "정보 교환") (존댓말로 작성, 분석 옵션에 맞춰 해석);
          9. 추천 응답: 내 말투를 강하게 반영하여 대화 흐름의 마지막 부분에 맞는 응답, 15-35자, 한 문장, 자연스러운 톤, 대화 맥락에 따라 존댓말/반말로 작성, 분석 옵션에 강하게 맞춤;
          10. 희망: 대화에서 상대방의 반응, 관심, 감정 흐름을 분석하여 관계 잠재력을 300자 이내로 상세히 설명. 구체적인 사례와 긍정적 요소 강조, 실질적인 관계 발전 가능성 제시 (존댓말로 작성, 예시 멘트는 대화 맥락에 따라 존댓말/반말로, 분석 옵션에 강하게 맞춤);
          11. 위험: 대화 패턴에서 발견된 잠재적 문제점(예: 오해, 감정적 거리, 응답 부족)을 분석하여 주의점을 300자 이내로 상세히 설명. 문제 원인과 해결 방안 포함 (존댓말로 작성, 예시 멘트는 대화 맥락에 따라 존댓말/반말로, 분석 옵션에 강하게 맞춤);
          12. 타임라인 변화: 호감도, 잠재력, 참여도 각각 4단계 배열 ([초기, 초반, 중반, 최종], 0-1) (존댓말로 작성, 분석 옵션에 맞춰 해석);
          13. 상대방의 MBTI: 상대방 메시지만 분석하여 대화 패턴 기반으로 추정, 영어로 (예: "INFP"). 메시지가 적거나 명확하지 않아도 반드시 MBTI를 추정하여 출력, 분석 옵션에 맞춰 해석;

          ### 출력 형식
          {
            "flow": "요약",
            "userSuggestion": "조언",
            "opponentMood": {"기쁨": 0.4, "불안": 0.2, "짜증": 0.1, "슬픔": 0.2, "평온": 0.1},
            "opponentTone": "친근함",
            "opponentFavorability": 0.7,
            "relationshipPotential": 0.6,
            "opponentEngagement": 0.5,
            "opponentIntent": "연결 원함",
            "recommendedResponse": "응답",
            "hope": "가능성",
            "risk": "주의",
            "favorabilityTimeline": [0.2, 0.5, 0.8, 0.3],
            "potentialTimeline": [0.1, 0.7, 0.4, 0.9],
            "engagementTimeline": [0.3, 0.9, 0.2, 0.6],
            "opponentMBTI": "INFP"
          }
      ''';

      debugPrint('Firebase 분석 입력 프롬프트:\n$prompt');

      final response = await client.post(
        Uri.parse(deepSeekApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'conversationLog': prompt,
        }),
      );

      debugPrint('Firebase 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint('Firebase 요청 실패: 상태 코드=${response.statusCode}, 본문=${response.body}');
        throw Exception('Firebase 요청 실패: 상태 코드 ${response.statusCode} - ${response.body}');
      }

      if (response.body == null) {
        debugPrint('Firebase 응답 본문이 null입니다.');
        throw Exception('Firebase 응답 본문이 null입니다.');
      }

      final rawResponseText = utf8.decode(response.bodyBytes).trim();
      debugPrint('Firebase 분석 응답 원본: "$rawResponseText"');

      if (rawResponseText.isEmpty) {
        debugPrint('Firebase 응답이 비어있습니다.');
        throw Exception('Firebase 응답이 비어있습니다.');
      }

      Map<String, dynamic>? parsedResponse;
      try {
        parsedResponse = jsonDecode(rawResponseText);
      } catch (e) {
        debugPrint('Firebase 응답 파싱 실패: $e');
        throw Exception('Firebase 응답 파싱 실패: $e');
      }

      if (parsedResponse == null) {
        debugPrint('parsedResponse가 null입니다.');
        throw Exception('Firebase 응답 파싱 결과가 null입니다.');
      }

      debugPrint('Parsed Response: $parsedResponse'); // 디버깅 로그 추가

      final List<dynamic>? candidates = parsedResponse['candidates'];
      if (candidates == null || candidates.isEmpty) {
        debugPrint('parsedResponse[\'candidates\']가 null이거나 비어있습니다.');
        throw Exception('Firebase 응답에 candidates가 없습니다.');
      }

      final String? content = candidates[0]['content']['parts'][0]['text']?.trim();
      if (content == null || content.isEmpty) {
        debugPrint('candidates[0][\'content\']가 null이거나 비어있습니다.');
        throw Exception('Firebase 응답에 content가 없습니다.');
      }

      Map<String, dynamic>? parsedContent;
      try {
        String cleanedContent = content.replaceFirst('```json\n', '').replaceFirst('```', '');
        parsedContent = jsonDecode(cleanedContent);
      } catch (e) {
        debugPrint('Firebase content 파싱 실패: $e');
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
        if (jsonMatch != null) {
          final cleanedJson = jsonMatch.group(0);
          try {
            parsedContent = jsonDecode(cleanedJson!);
          } catch (e) {
            debugPrint('Firebase 응답 파싱 실패 (cleanedJson): $e');
            throw Exception('Firebase 응답 파싱 실패 (cleanedJson): $e');
          }
        } else {
          debugPrint('Firebase 응답에서 JSON 찾기 실패: $e');
          throw Exception('Firebase 응답에서 JSON 찾기 실패: $e');
        }
      }

      if (parsedContent == null) {
        debugPrint('parsedContent가 null입니다.');
        throw Exception('Firebase 응답의 content 파싱 결과가 null입니다.');
      }

      Map<String, dynamic> result = Map<String, dynamic>.from(parsedContent);

      result['hope'] = result['hope']?.toString() ?? widget.translations["분석 불가"] ?? "분석 불가";
      result['risk'] = result['risk']?.toString() ?? widget.translations["분석 불가"] ?? "분석 불가";
      result['userSuggestion'] = result['userSuggestion']?.toString() ?? widget.translations["분석 불가"] ?? "분석 불가";
      result['flow'] = result['flow']?.toString() ?? widget.translations["대화 흐름 분석 실패."] ?? "대화 흐름 분석 실패.";
      result['recommendedResponse'] = result['recommendedResponse']?.toString() ?? widget.translations["응답을 생성하지 못했습니다."] ?? "응답을 생성하지 못했습니다.";
      result['opponentMood'] = result['opponentMood'] ?? {"기쁨": 0.2, "불안": 0.2, "짜증": 0.2, "슬픔": 0.2, "평온": 0.2};
      result['opponentTone'] = result['opponentTone']?.toString() ?? widget.translations["알 수 없음"] ?? "알 수 없음";
      result['opponentFavorability'] = result['opponentFavorability'] != null ? (double.tryParse(result['opponentFavorability'].toString()) ?? 0.5) : 0.5;
      result['relationshipPotential'] = result['relationshipPotential'] != null ? (double.tryParse(result['relationshipPotential'].toString()) ?? 0.5) : 0.5;
      result['opponentEngagement'] = result['opponentEngagement'] != null ? (double.tryParse(result['opponentEngagement'].toString()) ?? 0.5) : 0.5;
      result['opponentIntent'] = result['opponentIntent']?.toString() ?? widget.translations["의도 불명"] ?? "의도 불명";
      result['favorabilityTimeline'] = result['favorabilityTimeline'] ?? [0.5, 0.5, 0.5, 0.5];
      result['potentialTimeline'] = result['potentialTimeline'] ?? [0.5, 0.5, 0.5, 0.5];
      result['engagementTimeline'] = result['engagementTimeline'] ?? [0.5, 0.5, 0.5, 0.5];
      result['opponentMBTI'] = result['opponentMBTI']?.toString() ?? 'INFP';

      debugPrint('분석 결과: $result');
      return result;
    } catch (e) {
      debugPrint('Firebase 요청 실패 (재시도 $retryCount/$maxRetries): $e');
      retryCount++;
      if (retryCount >= maxRetries) {
        throw Exception('대화 분석 실패: $e');
      }
      await Future.delayed(Duration(seconds: 2 * retryCount));
      continue;
    }
  }
  throw Exception('대화 분석 실패: 최대 재시도 횟수 초과');
}
Future<void> _checkPendingAnalysesForDuplicatesUpdated() async {
  final SharedPreferences prefs = await _prefs;
  await prefs.reload(); // 캐시 강제 동기화 추가
  for (var room in screenshotRooms) {
    final roomName = room['roomName'] as String;
    final isAnalyzing = prefs.getBool('${roomName}_isAnalyzing') ?? false;
    final analysisData = prefs.getString('${roomName}_analysis_data');
    final hasAnalysisResult = prefs.getBool('${roomName}_hasAnalysisResult') ?? (analysisData != null && analysisData.isNotEmpty);
    debugPrint('분석 결과 상태 - $roomName: '
        'isAnalyzing=$isAnalyzing, '
        'hasAnalysisResult=$hasAnalysisResult, '
        'analysisData=${analysisData?.substring(0, 30)}...');

    if (hasAnalysisResult) {
      debugPrint('방 $roomName: 이미 분석 완료됨, 재분석 스킵');
      if (isAnalyzing) {
        await prefs.setBool('${roomName}_isAnalyzing', false);
        debugPrint('분석 완료 상태에서 isAnalyzing 플래그 강제로 false로 설정: $roomName');
      }
      final roomIndex = screenshotRooms.indexWhere((r) => r['roomName'] == roomName);
      if (roomIndex != -1 && mounted) {
        setState(() {
          screenshotRooms[roomIndex]['isAnalyzing'] = false;
          screenshotRooms[roomIndex]['displayName'] = screenshotRooms[roomIndex]['roomName'] as String;
          if (analysisData != null) {
            try {
              screenshotRooms[roomIndex]['analysisResult'] = jsonDecode(analysisData);
            } catch (e) {
              debugPrint('분석 데이터 파싱 오류: $e');
            }
          }
        });
        debugPrint('UI 업데이트: $roomName, 이미 완료된 방 반영');
        await saveRooms();
      }
      continue;
    }

    if (isAnalyzing && !hasAnalysisResult && !_analysisSubscriptions.containsKey(roomName)) {
      debugPrint('방 $roomName: 백그라운드에서 분석 계속 진행 중');
      final analysisOption = prefs.getString('${roomName}_analysis_option') ?? '기본';
      final roomIndex = screenshotRooms.indexWhere((room) => room['roomName'] == roomName);
      if (roomIndex != -1 && screenshotRooms[roomIndex]['image'] != null) {
        _startAnalysis(roomName, screenshotRooms[roomIndex]['image'] as Uint8List, null, analysisOption);
      } else {
        debugPrint('방 $roomName: 이미지 데이터 누락, 분석 스킵');
        await prefs.setBool('${roomName}_isAnalyzing', false);
        await prefs.setBool('${roomName}_hasAnalysisResult', false);
        await saveRooms();
      }
    } else if (isAnalyzing && !hasAnalysisResult && _analysisSubscriptions.containsKey(roomName)) {
      debugPrint('방 $roomName: 이미 분석 중, 중복 분석 스킵');
    } else if (isAnalyzing && hasAnalysisResult) {
      debugPrint('방 $roomName: 분석 상태 불일치 감지, 플래그 정리');
      await prefs.setBool('${roomName}_isAnalyzing', false);
      final roomIndex = screenshotRooms.indexWhere((room) => room['roomName'] == roomName);
      if (roomIndex != -1 && mounted) {
        setState(() {
          screenshotRooms[roomIndex]['isAnalyzing'] = false;
          if (analysisData != null) {
            try {
              screenshotRooms[roomIndex]['analysisResult'] = jsonDecode(analysisData);
            } catch (e) {
              debugPrint('분석 데이터 파싱 오류: $e');
            }
          }
        });
        await saveRooms();
      }
    }
  }
}

Future<Map<String, dynamic>> analyzeImageInBackground(String roomName, Uint8List bytes, String currentLanguage, Map<String, String> translations, String analysisOption, bool isVIP) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final roomId = prefs.getString('${roomName}_roomId');

  try {
    debugPrint('백그라운드 서비스 데이터: roomName=$roomName, roomId=$roomId, image=${base64Encode(bytes).substring(0, 50)}..., currentLanguage=$currentLanguage, analysisOption=$analysisOption');

    final textData = await extractTextWithPosition(bytes, null, currentLanguage, translations);
    debugPrint('ML Kit 텍스트 추출 결과: text=${textData['text']}, messages=${textData['messages']?.length}');

    if (textData['text'].isEmpty || !RegExp(r'[\w\s]+.*[\w\s]+').hasMatch(textData['text'])) {
      throw Exception(translations["메시지 형식의 스크린샷을 업로드해 주세요."] ?? "메시지 형식의 스크린샷을 업로드해 주세요.");
    }
    if (textData['text'].isNotEmpty) {
      final messages = textData['messages'] as List<Message>;
      final imageWidth = textData['imageWidth'] ?? 1080.0;
      final separatedMessages = await ScreenshotAnalysisScreen(
        roomName: roomName,
        initialImage: bytes,
        analysisResult: null,
        isVIP: false,
        onVIPStatusChanged: (_) {},
        onRoomNameChanged: null,
        onLanguageChanged: (_) {},
        currentLanguage: currentLanguage,
        translations: translations,
        isDarkTheme: false,
        onThemeChanged: (_) {},
        onShowVIPDialog: () {},
      ).separateMessages(messages, imageWidth, bytes);

      debugPrint('separatedMessages 결과: myMessages=${separatedMessages['myMessages']}, otherMessages=${separatedMessages['otherMessages']}, conversation=${separatedMessages['conversation']}');

      if (separatedMessages['myMessages'].isEmpty && separatedMessages['otherMessages'].isEmpty) {
        throw Exception('대화 내용을 추출하지 못했습니다.');
      }

      Map<String, dynamic>? analysis;
      const maxRetries = 3;
      int retryCount = 0;

      while (retryCount < maxRetries) {
        try {
          analysis = await analyzeText(separatedMessages, currentLanguage, translations, analysisOption);
          break;
        } catch (e) {
          retryCount++;
          debugPrint('Firebase 요청 실패 (재시도 $retryCount/$maxRetries): $e');
          if (retryCount >= maxRetries) {
            throw Exception('대화 분석 실패: 최대 재시도 횟수 초과 - $e');
          }
          await Future.delayed(Duration(seconds: 5 * retryCount));
        }
      }

      if (analysis == null) {
        debugPrint('analyzeText 결과가 null입니다.');
        throw Exception('분석 결과가 null입니다.');
      }

      final serializedMessages = messages.map((msg) => msg.toJson()).toList();

      final result = {
        'extractedText': textData['text'] ?? '',
        'analysisResult': analysis,
        'recommendedResponse': analysis['recommendedResponse']?.toString() ?? translations["응답을 생성하지 못했습니다."] ?? "응답을 생성하지 못했습니다.",
        'conversationFlow': analysis['flow']?.toString() ?? translations["대화 흐름 분석 실패."] ?? "대화 흐름 분석 실패.",
        'userSuggestion': analysis['userSuggestion']?.toString() ?? translations["분석 불가"] ?? "분석 불가",
        'messages': serializedMessages,
        'separatedMessages': separatedMessages,
      };

      // roomId 검증
      final currentRoomId = prefs.getString('${roomName}_roomId');
      if (currentRoomId != roomId) {
        debugPrint('방 $roomName: roomId 불일치 (기대: $roomId, 실제: $currentRoomId), 결과 폐기');
        throw Exception('roomId 불일치로 결과 폐기');
      }

      await prefs.setString('${roomName}_analysis_data', jsonEncode(result));
      await prefs.setBool('${roomName}_isAnalyzing', false);
      await prefs.setBool('${roomName}_hasAnalysisResult', true);
      debugPrint('분석 결과 저장: $roomName, roomId=$roomId');

      return result;
    }
    throw Exception('텍스트를 감지하지 못했습니다.');
  } catch (e) {
    debugPrint('analyzeImageInBackground 오류: $e');
    await prefs.setBool('${roomName}_isAnalyzing', false);
    await prefs.setBool('${roomName}_hasAnalysisResult', false);
    throw Exception('대화 분석 실패: $e');
  }
}
  void deleteRoom(int index) async {
    if (index < 0 || index >= screenshotRooms.length || index >= tapControllers.length || index >= tapScales.length) {
      debugPrint('deleteRoom: 유효하지 않은 인덱스 $index, screenshotRooms: ${screenshotRooms.length}, tapControllers: ${tapControllers.length}, tapScales: ${tapScales.length}');
      return;
    }
    final roomName = screenshotRooms[index]['roomName'] as String;
    await _clearRoomData(roomName);
    if (mounted) {
      setState(() {
        screenshotRooms.removeAt(index);
        tapControllers[index].dispose();
        tapControllers.removeAt(index);
        tapScales.removeAt(index);
        debugPrint('방 삭제: $roomName, screenshotRooms 길이: ${screenshotRooms.length}, tapControllers 길이: ${tapControllers.length}, tapScales 길이: ${tapScales.length}');
      });
      await saveRooms();
    }
  }

  void renameRoom(int index) {
    if (!mounted) {
      debugPrint('renameRoom: 위젯이 마운트되지 않음');
      return;
    }
    debugPrint('renameRoom 호출: index=$index');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          final TextEditingController nameController = TextEditingController(text: screenshotRooms[index]['roomName'] as String?);
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AlertDialog(
              backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
              elevation: 8,
              surfaceTintColor: Colors.transparent,
              title: AnimatedBuilder(
                animation: colorController,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topLeft.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                      end: Alignment.bottomRight.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                      colors: gradientColors,
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      widget.translations["방 이름 수정"] ?? "방 이름 수정",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                      maxLines: 1,
                    ),
                  );
                },
              ),
              content: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: widget.translations["새로운 이름을 입력하세요"] ?? "새로운 이름을 입력하세요",
                  hintStyle: TextStyle(color: widget.isDarkTheme ? Colors.white70 : Colors.grey, wordSpacing: 1.5, fontSize: 15),
                ),
                style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5, fontSize: 15),
                maxLength: 7,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final newName = nameController.text.trim();
                    if (newName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.translations["이름을 입력해 주세요."] ?? "이름을 입력해 주세요.",
                            style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
                            maxLines: 2,
                          ),
                        ),
                      );
                      return;
                    }
                    if (mounted) {
                      setState(() {
                        final oldName = screenshotRooms[index]['roomName'] as String;
                        screenshotRooms[index]['roomName'] = newName;
                        screenshotRooms[index]['displayName'] = newName;
                        SharedPreferences.getInstance().then((pref) async {
                          final data = pref.getString('${oldName}_analysis_data');
                          final isAnalyzing = pref.getBool('${oldName}_isAnalyzing');
                          if (data != null) {
                            await pref.setString('${newName}_analysis_data', data);
                            await pref.remove('${oldName}_analysis_data');
                          }
                          if (isAnalyzing != null) {
                            await pref.setBool('${newName}_isAnalyzing', isAnalyzing);
                            await pref.remove('${oldName}_isAnalyzing');
                          }
                        });
                      });
                      saveRooms().then((_) => loadRooms());
                      Navigator.pop(context);
                      debugPrint('방 이름 변경 완료: $newName');
                    }
                  },
                  child: Text(
                    widget.translations["확인"] ?? "확인",
                    style: const TextStyle(color: Color(0xFF7539BB), fontSize: 15, wordSpacing: 1.5),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ).then((_) {
        debugPrint('renameRoom: 다이얼로그 닫힘');
      });
    });
  }

  Color _getDarkerColor(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final darkerHslColor = hslColor.withLightness((hslColor.lightness - 0.2).clamp(0.0, 1.0));
    return darkerHslColor.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.findAncestorStateOfType<_MyAppState>()!._themeNotifier,
      builder: (context, isDarkTheme, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: context.findAncestorStateOfType<_MyAppState>()!._themeNotifier,
          builder: (context, isDarkTheme, child) {
            return ValueListenableBuilder<bool>(
              valueListenable: context.findAncestorStateOfType<_MyAppState>()!._isVIPNotifier,
              builder: (context, isVIP, child) {
                return Scaffold(
                  backgroundColor: isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: AnimatedBuilder(
                      animation: colorAnimation,
                      builder: (context, child) {
                        return ClipRRect(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                end: Alignment.bottomRight.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                colors: gradientColors,
                                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                              ),
                            ),
                            child: AppBar(
                              title: Text(
                                "스크린샷 방 목록".tr(),
                                style: const TextStyle(fontSize: 16, wordSpacing: 1.5),
                                maxLines: 1,
                              ),
                              leading: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Center(
                                    child: Text(
                                      isVIP ? widget.translations["VIP"] ?? "VIP" : '',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, wordSpacing: 1.5),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  body: LayoutBuilder(
                    builder: (context, constraints) {
                      double cardWidth = constraints.maxWidth / 3 - 16;
                      double cardHeight = cardWidth * 1.46;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '10/${screenshotRooms.length}',
                                      style: TextStyle(
                                        color: widget.isDarkTheme ? Colors.white70 : const Color(0xFF7539BB),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        wordSpacing: 1.5,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          Expanded(
                            child: screenshotRooms.isEmpty
                                ? Center(
                                    child: Text(
                                      "스크린샷을 업로드하여 방을 생성하세요.".tr(),
                                      style: TextStyle(
                                        color: widget.isDarkTheme ? Colors.white70 : Colors.grey,
                                        fontSize: 18,
                                        wordSpacing: 1.5,
                                      ),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12.0,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: cardWidth / cardHeight,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    itemCount: screenshotRooms.length,
                                    itemBuilder: (context, index) => AnimatedBuilder(
                                      animation: Listenable.merge([colorAnimation, tapScales[index]]),
                                      builder: (context, child) {
                                        final room = screenshotRooms[index];
                                        final isAnalyzing = room['isAnalyzing'] as bool;
                                        final displayName = (isAnalyzing
                                                ? "분석 중".tr()
                                                : (room['displayName'] as String?)) ??
                                            "알 수 없는 방".tr();
                                        final analysisOption = room['analysisOption'] as String? ?? '기본';

                                        return GestureDetector(
                                          onTapDown: isAnalyzing || isNavigating ? null : (_) => tapControllers[index].forward(),
                                          onTapUp: isAnalyzing || isNavigating
                                              ? null
                                              : (_) async {
                                                  if (mounted) {
                                                    setState(() {
                                                      isNavigating = true;
                                                    });
                                                    tapControllers[index].reverse();
                                                    debugPrint('ScreenshotAnalysisScreen으로 이동: ${room['roomName']}');
                                                    try {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ScreenshotAnalysisScreen(
                                                            roomName: room['roomName'] as String,
                                                            initialImage: room['image'] as Uint8List,
                                                            analysisResult: room['analysisResult'] as Map<String, dynamic>?,
                                                            isVIP: widget.isVIP,
                                                            onVIPStatusChanged: widget.onVIPStatusChanged,
                                                            onRoomNameChanged: (oldName, newName) {
                                                              setState(() {
                                                                screenshotRooms[index]['roomName'] = newName;
                                                                screenshotRooms[index]['displayName'] = newName;
                                                              });
                                                              saveRooms();
                                                            },
                                                            onLanguageChanged: widget.onLanguageChanged,
                                                            currentLanguage: widget.currentLanguage,
                                                            translations: widget.translations,
                                                            isDarkTheme: widget.isDarkTheme,
                                                            onThemeChanged: widget.onThemeChanged,
                                                            onShowVIPDialog: widget.onShowVIPDialog,
                                                          ),
                                                        ),
                                                      );
                                                    } finally {
                                                      if (mounted) {
                                                        setState(() {
                                                          isNavigating = false;
                                                        });
                                                      }
                                                    }
                                                  }
                                                },
                                          onLongPress: isAnalyzing || isNavigating ? null : () => renameRoom(index),
                                          onTapCancel: isAnalyzing || isNavigating ? null : () => tapControllers[index].reverse(),
                                          child: Transform.scale(
                                            scale: tapScales[index].value,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                AnimatedBuilder(
                                                  animation: colorAnimation,
                                                  builder: (context, child) {
                                                    return Container(
                                                      padding: const EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          begin: Alignment.topLeft.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                                          end: Alignment.bottomRight.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                                          colors: gradientColors,
                                                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                                        ),
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(
                                                          width: 1,
                                                          color: gradientColors[0],
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          if (isAnalyzing)
                                                            const Center(child: CircularProgressIndicator(color: Colors.white))
                                                          else
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(12),
                                                              child: Image.memory(
                                                                room['image'] as Uint8List,
                                                                width: cardWidth - 12,
                                                                height: cardHeight - 40,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          const SizedBox(height: 2),
                                                          AutoSizeText(
                                                            displayName,
                                                            style: const TextStyle(color: Colors.white, wordSpacing: 1.5),
                                                            textAlign: TextAlign.center,
                                                            maxLines: 2,
                                                            maxFontSize: 12,
                                                            stepGranularity: 0.1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  left: 6,
                                                  child: buildBookmark(analysisOption),
                                                ),
                                                Positioned(
                                                  top: 6,
                                                  right: 6,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      deleteRoom(index);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(4),
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: const Icon(Icons.close, color: Colors.black, size: 20),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                  floatingActionButton: AnimatedBuilder(
                    animation: fabScale,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: fabScale.value,
                        child: GestureDetector(
                          onTap: isNavigating ? null : createNewRoom,
                          child: Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                end: Alignment.bottomRight.add(Alignment(colorAnimation.value * 2 - 1, colorAnimation.value * 2 - 1)),
                                colors: gradientColors,
                                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                              ),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 24),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
} 

class ScreenshotAnalysisScreen extends StatefulWidget {
  final String roomName;
  final Uint8List? initialImage;
  final Map<String, dynamic>? analysisResult;
  final bool isVIP;
  final Function(bool) onVIPStatusChanged;
  final Function(String, String)? onRoomNameChanged;
  final Function(String) onLanguageChanged;
  final String currentLanguage;
  final Map<String, String> translations;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;
  final VoidCallback onShowVIPDialog;

  const ScreenshotAnalysisScreen({
    super.key,
    required this.roomName,
    this.initialImage,
    this.analysisResult,
    required this.isVIP,
    required this.onVIPStatusChanged,
    this.onRoomNameChanged,
    required this.onLanguageChanged,
    required this.currentLanguage,
    required this.translations,
    required this.isDarkTheme,
    required this.onThemeChanged,
    required this.onShowVIPDialog,
  });

  Future<Map<String, dynamic>> separateMessages(List<Message> messages, double screenWidth, Uint8List imageBytes) async {
    List<String> myMessages = [];
    List<String> otherMessages = [];
    List<String> myTimestamps = [];
    List<String> otherTimestamps = [];
    List<Map<String, dynamic>> timestampGroups = [];
    List<Map<String, dynamic>> conversation = [];

    debugPrint('=== 메시지 분리 시작 ===');
    debugPrint('초기 메시지 수: ${messages.length}');

    messages.sort((a, b) => a.y.compareTo(b.y));
    img.Image? image;
    try {
      image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('이미지 디코딩 실패');

      screenWidth = image.width.toDouble();
      double screenHeight = image.height.toDouble();
      debugPrint('스크린샷 가로 크기: $screenWidth');
      debugPrint('스크린샷 세로 크기: $screenHeight');
      double centerScreen = screenWidth * 0.5;
      debugPrint('스크린샷 중심: $centerScreen');

      double topBarThreshold = screenHeight * 0.05;
      double inputBarThreshold = screenHeight * 0.85;

      RegExp timestampPattern = RegExp(
          r'^(?:[월화수목금토일]요일\s*)?(?:\d{1,2}[:;]\d{2}(?::\d{2})?\s*(?:AM|PM|오전|오후)?|오후\s*\d{1,2}[:;]\d{2}|오전\s*\d{1,2}[:;]\d{2})$',
          caseSensitive: false);
      RegExp datePattern = RegExp(
          r'^\d{4}년\s*\d{1,2}(?:월|철)\s*\d{1,2}일\s*(?:[월화수목금토일효릴]요일\s*)?(?:>)?$',
          caseSensitive: false);
      List<Message> timestampMessages = [];
      List<Message> dateMessages = [];
      List<BubbleGroup> bubbleGroups = [];
      List<BubbleGroup> filteredBubbleGroups = [];
      List<Message> finalLeftMessages = [];
      List<Message> finalRightMessages = [];
      List<Message> middleMessages = [];
      List<double> positionScores = [];

      List<Message> preFilteredMessages = [];
      for (var msg in messages) {
        if (msg.y < topBarThreshold || msg.y > inputBarThreshold) {
          debugPrint('상단바/입력창 메시지 제외: "${msg.text}" (y=${msg.y}, x=${msg.x})');
          continue;
        }

        final timestampMatch = timestampPattern.firstMatch(msg.text.trim());
        final dateMatch = datePattern.firstMatch(msg.text.trim());
        if (timestampMatch != null) {
          String timestamp = timestampMatch.group(0)!;
          String remainingText = msg.text.replaceFirst(timestamp, '').trim();
          if (remainingText.isNotEmpty) {
            preFilteredMessages.add(Message(remainingText, msg.x, msg.X, msg.y, msg.width, msg.height, msg.backgroundColor, id: msg.id));
          }
          timestampMessages.add(Message(timestamp, msg.x, msg.X, msg.y, msg.width, msg.height, msg.backgroundColor, id: msg.id));
          timestampGroups.add({'timestamp': timestamp, 'y': msg.y, 'x': msg.x, 'messages': <Message>[]});
          debugPrint('타임스탬프 탐지: "$timestamp" (y=${msg.y}, x=${msg.x})');
          continue;
        } else if (dateMatch != null) {
          String date = dateMatch.group(0)!;
          String remainingText = msg.text.replaceFirst(date, '').trim();
          if (remainingText.isNotEmpty) {
            preFilteredMessages.add(Message(remainingText, msg.x, msg.X, msg.y, msg.width, msg.height, msg.backgroundColor, id: msg.id));
          }
          dateMessages.add(Message(date, msg.x, msg.X, msg.y, msg.width, msg.height, msg.backgroundColor, id: msg.id));
          timestampGroups.add({'timestamp': date, 'y': msg.y, 'x': msg.x, 'messages': <Message>[]});
          debugPrint('날짜 타임스탬프 탐지: "$date" (y=${msg.y}, x=${msg.x})');
          continue;
        }

        preFilteredMessages.add(Message(msg.text.trim(), msg.x, msg.X, msg.y, msg.width, msg.height, msg.backgroundColor, id: msg.id));
      }

      preFilteredMessages.sort((a, b) => a.y.compareTo(b.y));

      // 이름 정규화: 특수문자, 이모지 제거
      String normalizeName(String name) {
        return name.replaceAll(RegExp(r'[^a-zA-Z\uAC00-\uD7A3\u4E00-\u9FFF]'), '');
      }

      // 이름 감지 및 제거 로직
      // 1. 말풍선 위치 기반 필터링: 좌측 상단에 반복적으로 등장하는 텍스트를 이름 후보로 선정
      bool isPotentialName(Message msg, double imageWidth) {
        double centerX = (msg.x + msg.X) / 2;
        return centerX < imageWidth * 0.3 &&
            msg.height < 50 &&
            msg.text.trim().length >= 1 && // 중국어 1자 이름 고려
            msg.text.trim().length <= 10 &&
            RegExp(r'^[a-zA-Z\uAC00-\uD7A3\u4E00-\u9FFF]+[\W]*$').hasMatch(msg.text.trim()); // 한글, 영어, 중국어 + 특수문자 허용
      }

      // 2. 이름 후보군 추출 (빈도 >= 2, 위치 일관성, 내 말풍 제외)
      Set<String> detectNameCandidates(List<Message> messages, double imageWidth) {
        final freq = <String, int>{};
        final positions = <String, List<int>>{}; // 위치 일관성 확인용
        final normalizedToOriginal = <String, Set<String>>{}; // 정규화된 이름과 원본 이름 매핑

        for (var msg in messages) {
          // 내 말풍은 이름 후보 감지 대상에서 제외
          if (!msg.isMine && isPotentialName(msg, imageWidth)) {
            final cleaned = msg.text.trim();
            final normalized = normalizeName(cleaned);

            freq[normalized] = (freq[normalized] ?? 0) + 1;
            positions[normalized] = positions[normalized] ?? [];
            positions[normalized]!.add(msg.x.round());

            normalizedToOriginal.putIfAbsent(normalized, () => {}).add(cleaned);
          }
        }

        // 위치 분산 계산
        double calculateVariance(List<int> values) {
          if (values.isEmpty) return 0.0;
          double mean = values.reduce((a, b) => a + b) / values.length;
          double sumSquaredDiff = values.map((x) => pow(x - mean, 2).toDouble()).reduce((a, b) => a + b);
          return values.length > 1 ? sumSquaredDiff / (values.length - 1) : 0.0;
        }

        // 빈도 >= 2 이고 위치 분산 < 50 인 텍스트만 이름 후보로 선정
        Set<String> candidates = {};
        for (var entry in freq.entries) {
          final normalized = entry.key;
          final count = entry.value;

          if (count >= 2 && calculateVariance(positions[normalized]!) < 50) {
            candidates.addAll(normalizedToOriginal[normalized]!);
          }
        }

        debugPrint('감지된 이름 후보: $candidates');
        return candidates;
      }

      // 3. 이름이 단독으로 등장하는 경우에만 제거
      bool isStrictlyNameOnly(String text, String name) {
        final trimmed = text.trim();
        return name == trimmed; // 정확히 일치하는 경우만 제거
      }

      // 4. 단독 말풍선 또는 좌측 상단에 있는 경우에만 제거
      bool shouldRemoveAsName(Message msg, Set<String> nameCandidates, double imageWidth) {
        final cleaned = msg.text.trim();
        for (var name in nameCandidates) {
          if (isStrictlyNameOnly(cleaned, name) && isPotentialName(msg, imageWidth)) {
            return true;
          }
        }
        return false;
      }

      // 5. 최종 메시지 필터링
      List<Message> filterMessages(List<Message> messages, double imageWidth) {
        final nameCandidates = detectNameCandidates(messages, imageWidth);
        return messages.where((msg) {
          // 내 말투는 이름 제거 적용하지 않음
          if (msg.isMine == true) return true;
          debugPrint('isMine=${msg.isMine}, text=${msg.text}'); // isMine 디버깅 로그 추가
          return !shouldRemoveAsName(msg, nameCandidates, imageWidth);
        }).toList();
      }

      // 6. 프롬프트 전처리용 이름 제거 (내 말투 제외)
      String removeDetectedNames(String text, Set<String> names, bool isMine) {
        if (isMine) return text; // 내 말투는 제거 안 함

        for (var name in names) {
          if (text.trim() == name || text.trim().startsWith(name)) {
            debugPrint('이름 제거 (정확히 일치 또는 시작): "$name"');
            return text.replaceFirst(name, '').trim();
          }
        }
        return text;
      }

      // 이름 제거 적용
      preFilteredMessages = filterMessages(preFilteredMessages, screenWidth);
      debugPrint('이름 제거 후 남은 메시지 수: ${preFilteredMessages.length}');

      // 말풍선 그룹화 로직
      List<Message> currentGroup = [];
      double avgHeight = preFilteredMessages.isNotEmpty
          ? preFilteredMessages.map((m) => m.height).reduce((a, b) => a + b) / preFilteredMessages.length
          : 15.0;

      for (int i = 0; i < preFilteredMessages.length; i++) {
        Message msg = preFilteredMessages[i];

        if (currentGroup.isEmpty) {
          currentGroup.add(msg);
          continue;
        }

        Message lastMsg = currentGroup.last;
        double yDiff = msg.y - lastMsg.y;
        double xDiff = (msg.x - lastMsg.x).abs();

        if (yDiff <= avgHeight * 1.5 && xDiff < 50) {
          currentGroup.add(msg);
        } else {
          double minX = currentGroup.map((m) => m.x).reduce((a, b) => a < b ? a : b);
          double maxX = currentGroup.map((m) => m.X).reduce((a, b) => a > b ? a : b);
          double minY = currentGroup.map((m) => m.y).reduce((a, b) => a < b ? a : b);
          double maxY = currentGroup.map((m) => m.y + m.height).reduce((a, b) => a > b ? a : b);

          bubbleGroups.add(BubbleGroup(
            messages: List.from(currentGroup),
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
          ));
          debugPrint('그룹 생성: 메시지 수=${currentGroup.length}, minX=$minX, maxX=$maxX, minY=$minY, maxY=$maxY, 텍스트="${currentGroup.map((m) => m.text).join(' ')}"');

          currentGroup.clear();
          currentGroup.add(msg);
        }
      }

      if (currentGroup.isNotEmpty) {
        double minX = currentGroup.map((m) => m.x).reduce((a, b) => a < b ? a : b);
        double maxX = currentGroup.map((m) => m.X).reduce((a, b) => a > b ? a : b);
        double minY = currentGroup.map((m) => m.y).reduce((a, b) => a < b ? a : b);
        double maxY = currentGroup.map((m) => m.y + m.height).reduce((a, b) => a > b ? a : b);

        bubbleGroups.add(BubbleGroup(
          messages: List.from(currentGroup),
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
        ));
        debugPrint('마지막 그룹 생성: 메시지 수=${currentGroup.length}, minX=$minX, maxX=$maxX, minY=$minY, maxY=$maxY, 텍스트="${currentGroup.map((m) => m.text).join(' ')}"');
      }

      // 이름 제거 후 그룹화된 메시지 처리
      filteredBubbleGroups = bubbleGroups;
      debugPrint('이름 제거 후 남은 그룹 수: ${filteredBubbleGroups.length}');

      double dynamicBoundary = screenWidth / 2;
      if (filteredBubbleGroups.length >= 2) {
        int calibrationCount = min(3, filteredBubbleGroups.length);
        List<List<double>> calibrationFeatures = filteredBubbleGroups
            .sublist(0, calibrationCount)
            .map((group) {
              double centerX = group.getCenterX();
              double width = group.maxX - group.minX;
              return [centerX, width];
            })
            .toList();

        Map<String, dynamic> calibrationKMeansResult = await compute(kMeans, calibrationFeatures);
        List<List<double>> calibrationCentroids = calibrationKMeansResult['centroids'] as List<List<double>>;
        double leftCentroidX = calibrationCentroids[0][0];
        double rightCentroidX = calibrationCentroids[1][0];
        dynamicBoundary = (leftCentroidX + rightCentroidX) / 2;
        debugPrint('초기 캘리브레이션: centroids=$calibrationCentroids, dynamicBoundary=$dynamicBoundary');
      } else {
        debugPrint('그룹이 너무 적어 초기 캘리브레이션 스킵, 기본 경계 사용: $dynamicBoundary');
      }

      List<List<double>> positionFeatures = filteredBubbleGroups.map((group) {
        double centerX = group.getCenterX();
        double width = group.maxX - group.minX;
        return [centerX, width];
      }).toList();
      if (positionFeatures.length < 2) {
        throw Exception('그룹이 너무 적어 위치 클러스터링을 수행할 수 없습니다.');
      }

      Map<String, dynamic> kMeansResult = await compute(kMeans, positionFeatures);
      List<int> positionLabels = kMeansResult['labels'] as List<int>;
      positionScores = kMeansResult['scores'] as List<double>;
      List<List<double>> positionCentroids = kMeansResult['centroids'] as List<List<double>>;
      int rightCluster = kMeansResult['rightCluster'] as int;

      debugPrint('위치 클러스터링 결과: centroids=$positionCentroids, rightCluster=$rightCluster');

      double leftThreshold = screenWidth * 0.25;
      double rightThreshold = screenWidth * 0.75;

      finalLeftMessages.clear();
      finalRightMessages.clear();
      middleMessages.clear();

      for (int i = 0; i < filteredBubbleGroups.length; i++) {
        BubbleGroup group = filteredBubbleGroups[i];
        double centerX = group.getCenterX();
        if (centerX < leftThreshold) {
          for (var msg in group.messages) {
            msg.isMine = false; // Opponent's message
          }
          finalLeftMessages.addAll(group.messages);
          debugPrint('왼쪽 그룹 (상대방): "${group.getCombinedText()}" (centerX=$centerX, width=${group.maxX - group.minX}, positionScore=${positionScores[i]})');
        } else if (centerX > rightThreshold) {
          for (var msg in group.messages) {
            msg.isMine = true; // User's message
          }
          finalRightMessages.addAll(group.messages);
          debugPrint('오른쪽 그룹 (내 말): "${group.getCombinedText()}" (centerX=$centerX, width=${group.maxX - group.minX}, positionScore=${positionScores[i]})');
        } else {
          for (var msg in group.messages) {
            msg.isMine = false; // Temporarily set to false; will determine later
          }
          middleMessages.addAll(group.messages);
          debugPrint('가운데 그룹 (컬러로 판단): "${group.getCombinedText()}" (centerX=$centerX, width=${group.maxX - group.minX}, positionScore=${positionScores[i]})');
        }
      }

      List<BubbleGroup> rightmostGroups = finalRightMessages.isNotEmpty
    ? filteredBubbleGroups.where((group) => finalRightMessages.any((msg) => group.messages.contains(msg))).toList()
    : filteredBubbleGroups.sublist(0, max(3, (filteredBubbleGroups.length * 0.3).ceil())); // 샘플링 대상 10% → 30%로 확장
      List<List<double>> referenceHsvColors = [];
      for (var group in rightmostGroups) {
        double groupWidth = group.maxX - group.minX;
        double groupHeight = group.maxY - group.minY;
        if (groupWidth < 20 || groupHeight < 10) {
          debugPrint('말풍선 크기가 너무 작음 (width=$groupWidth, height=$groupHeight), 기준 색상 샘플링 스킵');
          continue;
        }

        List<List<int>> regionPixels = await compute(sampleColor, {
          'image': image,
          'msgX': group.minX,
          'msgY': group.minY,
          'msgXEnd': group.maxX,
          'msgYEnd': group.maxY,
        });

        if (regionPixels.length < 5) {
          debugPrint('샘플 개수 부족 (샘플 수=${regionPixels.length}), 기준 색상 샘플링 스킵');
          continue;
        }

        for (var pixel in regionPixels) {
          double r = pixel[0].toDouble();
          double g = pixel[1].toDouble();
          double b = pixel[2].toDouble();
          r /= 255;
          g /= 255;
          b /= 255;
          double max = [r, g, b].reduce((a, b) => a > b ? a : b);
          double min = [r, g, b].reduce((a, b) => a < b ? a : b);
          double h = 0, s = 0, v = max;
          double delta = max - min;

          if (max != 0) {
            s = delta / max;
          } else {
            referenceHsvColors.add([0.0, 0.0, 0.1]);
            continue;
          }
          if (delta != 0) {
            if (max == r) {
              h = (g - b) / delta + (g < b ? 6 : 0);
            } else if (max == g) {
              h = (b - r) / delta + 2;
            } else {
              h = (r - g) / delta + 4;
            }
            h *= 60;
          }
          referenceHsvColors.add([h / 360, s, v]);
        }
        debugPrint('기준 색상 샘플링: 총 샘플 수=${regionPixels.length}, 메시지="${group.getCombinedText()}"');
      }

      List<double> referenceHsv = [0.0, 0.0, 0.0];
      if (referenceHsvColors.isNotEmpty) {
        double sumH = 0.0, sumS = 0.0, sumV = 0.0;
        for (var hsv in referenceHsvColors) {
          sumH += hsv[0];
          sumS += hsv[1];
          sumV += hsv[2];
        }
        referenceHsv = [
          sumH / referenceHsvColors.length,
          sumS / referenceHsvColors.length,
          sumV / referenceHsvColors.length,
        ];
        debugPrint('기준 색상 HSV 평균: H=${referenceHsv[0]}, S=${referenceHsv[1]}, V=${referenceHsv[2]}');
      } else {
        debugPrint('기준 색상 샘플링 실패: 오른쪽 메시지 없음');
      }

      List<BubbleGroup> middleGroups = [];
      for (var msg in middleMessages) {
        for (var group in filteredBubbleGroups) {
          if (group.messages.contains(msg)) {
            middleGroups.add(group);
            break;
          }
        }
      }

      List<Map<String, dynamic>> groupsData = middleGroups.map((group) => {'group': group}).toList();
      List<Map<String, dynamic>> messageScores = await compute(computeSampleColors, {
        'groups': groupsData,
        'image': image,
        'referenceHsv': referenceHsv,
        'screenWidth': screenWidth,
      });

      List<BubbleGroup> rightGroups = filteredBubbleGroups.where((group) => finalRightMessages.any((msg) => group.messages.contains(msg))).toList();
      List<BubbleGroup> leftGroups = filteredBubbleGroups.where((group) => finalLeftMessages.any((msg) => group.messages.contains(msg))).toList();

      double positionDiff = 0.0;
      if (rightGroups.isNotEmpty && leftGroups.isNotEmpty) {
        double avgRightX = rightGroups.map((g) => (g.maxX + g.minX) / 2).reduce((a, b) => a + b) / rightGroups.length;
        double avgLeftX = leftGroups.map((g) => (g.maxX + g.minX) / 2).reduce((a, b) => a + b) / leftGroups.length;
        positionDiff = ((avgRightX - avgLeftX).abs()) / screenWidth;
      } else {
        List<double> maxXValues = filteredBubbleGroups.map((group) => group.maxX).toList();
        double maxMaxX = maxXValues.reduce((a, b) => a > b ? a : b);
        double minMaxX = maxXValues.reduce((a, b) => a < b ? a : b);
        positionDiff = (maxMaxX - minMaxX) / screenWidth;
      }
      debugPrint('위치 차이 분석: positionDiff=$positionDiff');

      List<double> colorSimilarities = [];
      for (var groupData in groupsData) {
        final group = groupData['group'] as BubbleGroup;
        double groupWidth = group.maxX - group.minX;
        double groupHeight = group.maxY - group.minY;
        if (groupWidth < 20 || groupHeight < 10) continue;

        List<List<int>> regionPixels = await compute(sampleColor, {
          'image': image,
          'msgX': group.minX,
          'msgY': group.minY,
          'msgXEnd': group.maxX,
          'msgYEnd': group.maxY,
        });

        if (regionPixels.length < 5) continue;

        List<List<double>> hsvColors = [];
        for (var pixel in regionPixels) {
          double r = pixel[0].toDouble();
          double g = pixel[1].toDouble();
          double b = pixel[2].toDouble();
          r /= 255;
          g /= 255;
          b /= 255;
          double max = [r, g, b].reduce((a, b) => a > b ? a : b);
          double min = [r, g, b].reduce((a, b) => a < b ? a : b);
          double h = 0, s = 0, v = max;
          double delta = max - min;

          if (max != 0) {
            s = delta / max;
          } else {
            hsvColors.add([0.0, 0.0, 0.1]);
            continue;
          }
          if (delta != 0) {
            if (max == r) {
              h = (g - b) / delta + (g < b ? 6 : 0);
            } else if (max == g) {
              h = (b - r) / delta + 2;
            } else {
              h = (r - g) / delta + 4;
            }
            h *= 60;
          }
          hsvColors.add([h / 360, s, v]);
        }

        double sumH = 0.0, sumS = 0.0, sumV = 0.0;
        for (var hsv in hsvColors) {
          sumH += hsv[0];
          sumS += hsv[1];
          sumV += hsv[2];
        }
        List<double> avgHsv = hsvColors.isNotEmpty
            ? [sumH / hsvColors.length, sumS / hsvColors.length, sumV / hsvColors.length]
            : [0.0, 0.0, 0.0];

        double deltaH = (avgHsv[0] - referenceHsv[0]).abs();
        double deltaS = (avgHsv[1] - referenceHsv[1]).abs();
        double deltaV = (avgHsv[2] - referenceHsv[1]).abs();
        double similarity = 1.0 - ((deltaH * 2) + (deltaS * 0.8) + (deltaV * 1.0));
        similarity = similarity.clamp(0.0, 1.0);
        colorSimilarities.add(similarity);
      }

      double colorDiff = colorSimilarities.isNotEmpty
          ? 1.0 - (colorSimilarities.reduce((a, b) => a + b) / colorSimilarities.length)
          : 1.0;
      debugPrint('색상 차이 분석: colorDiff=$colorDiff (유사도 평균=${1.0 - colorDiff})');

      double colorWeight = 0.1 + (colorDiff * 0.3);
      double positionWeight = 0.1 + ((positionDiff < 0.5 ? 1 - positionDiff : 0) * 0.2);
      debugPrint('가중치 계산: colorWeight=$colorWeight, positionWeight=$positionWeight');

      double baseThreshold = 0.5 + ((1 - colorDiff) * 0.3) + (positionDiff * 0.2);
      baseThreshold = baseThreshold.clamp(0.3, 0.85);
      debugPrint('기본 임계값: baseThreshold=$baseThreshold');

      String? previousSpeaker;
      for (int i = 0; i < messageScores.length; i++) {
        var entry = messageScores[i];
        BubbleGroup? group = entry['group'] as BubbleGroup?;
        if (group == null) {
          debugPrint('그룹 객체가 누락됨: entry=$entry');
          continue;
        }

        double colorScore = entry['score'] as double;
        bool hasRightTail = entry['isRightTail'] as bool;
        bool isTailReliable = group.maxX - group.minX > 60 && group.maxY - group.minY > 20;
        double centerX = group.getCenterX();
        String text = group.getCombinedText();
if (colorScore >= 0.9) {
  debugPrint('📂 색상 점수 높음: "${group.getCombinedText()}", colorScore=$colorScore, 나로 분류');
  for (var msg in group.messages) {
    msg.isMine = true;
  }
  finalRightMessages.addAll(group.messages);
  previousSpeaker = "나";
  continue;
}

        if (centerX < screenWidth * 0.4 && colorScore < 0.75) {
          debugPrint('📛 좌측 + 색상 애매: "${group.getCombinedText()}", 강제로 상대방 처리');
          for (var msg in group.messages) {
            msg.isMine = false;
          }
          finalLeftMessages.addAll(group.messages);
          previousSpeaker = "상대방";
          continue;
        }

                if (hasRightTail == false && isTailReliable == false && colorScore < 0.8 && centerX < screenWidth * 0.5) {
          debugPrint('📛 꼬리 없음 + 중간 이하 위치 + 색상 점수 낮음 → 상대방 처리');
          for (var msg in group.messages) {
            msg.isMine = false;
          }
          finalLeftMessages.addAll(group.messages);
          previousSpeaker = "상대방";
          continue;
        }

                double tailScore = 0.0; // tailScore 변수 선언 및 초기화
        if (hasRightTail && !isTailReliable && colorScore > 0.75 && centerX > screenWidth * 0.65) {
          tailScore = 0.4;
          debugPrint('꼬리 보정 적용: "${group.getCombinedText()}", tailScore=$tailScore');
        }

        if (hasRightTail && colorScore > 0.85 && centerX > screenWidth * 0.7) {
          isTailReliable = true;
          debugPrint('색상+위치 기반 꼬리 신뢰도 보정: "${group.getCombinedText()}"');
        }

        if (hasRightTail && colorScore > 0.85 && centerX > screenWidth * 0.65) {
          for (var msg in group.messages) {
            msg.isMine = true;
          }
          finalRightMessages.addAll(group.messages);
          debugPrint('✅ 색상+위치+꼬리 기반 확정: "${group.getCombinedText()}"');
          previousSpeaker = "나";
          continue;
        }

        if (hasRightTail && isTailReliable) {
          for (var msg in group.messages) {
            msg.isMine = true;
          }
          finalRightMessages.addAll(group.messages);
          debugPrint('가운데 → 나 (꼬리 규칙 적용): "${group.getCombinedText()}"');
          previousSpeaker = "나";
          continue;
        }

        bool isNeutralZone = (centerX > screenWidth * 0.4 && centerX < screenWidth * 0.6);
        if (isNeutralZone && colorScore < 0.75) {
          debugPrint('⚠️ 중립 구간 보수적 처리: "${group.getCombinedText()}"');
          for (var msg in group.messages) {
            msg.isMine = false;
          }
          finalLeftMessages.addAll(group.messages);
          previousSpeaker = "상대방";
          continue;
        }

        double finalScore;
        if (tailScore == 0.0) {
  finalScore = (colorScore * 0.15) + (1 - (centerX / screenWidth)) * 0.85; // 색상 가중치 0.2 → 0.15, 위치 가중치 0.8 → 0.85
  debugPrint('꼬리 없음: 색상+위치 기반 판단: "${group.getCombinedText()}", finalScore=$finalScore');
} else {
  finalScore = (colorScore * 0.25) + (tailScore * 0.75); // 색상 가중치 0.3 → 0.25, 꼬리 가중치 0.7 → 0.75
  debugPrint('꼬리 신뢰도 있음, 기존 가중치 적용: "${group.getCombinedText()}", finalScore=$finalScore');
}

        if (!isTailReliable && hasRightTail && colorScore > 0.85 && centerX > screenWidth * 0.65) {
          finalScore += 0.25;
          debugPrint('🎯 보정 적용: "${group.getCombinedText()}", finalScore=$finalScore');
        }

        if (centerX > screenWidth * 0.7 && colorScore > 0.6) {
          finalScore += 0.2;
          debugPrint('FinalScore 보정 적용 (위치 기반): "${group.getCombinedText()}", finalScore=$finalScore');
        }

        double positionPenalty = 0.0;
        if (centerX < screenWidth * 0.4) {
          positionPenalty = 0.03;
          finalScore -= positionPenalty;
          debugPrint('위치 페널티 적용 (완화됨): "${group.getCombinedText()}", positionPenalty=$positionPenalty, finalScore=$finalScore');
        }

        double groupColorDiff = 1.0 - colorScore;
        double groupPositionDiff = ((centerX - (screenWidth / 2)).abs()) / (screenWidth / 2);
        double groupThreshold = baseThreshold + (groupColorDiff * 0.1) + (0.1 * (1 - groupPositionDiff));
        groupThreshold = groupThreshold.clamp(0.4, 0.9);
        debugPrint('그룹별 임계값: "${group.getCombinedText()}", groupThreshold=$groupThreshold');

        bool isMyMessage = finalScore >= groupThreshold;

        if (previousSpeaker == "나" && text.contains("?")) {
          debugPrint('❗ 앞 말이 나 + 질문 포함 = 상대방일 확률 높음');
          isMyMessage = false;
        }

        if (isMyMessage) {
          for (var msg in group.messages) {
            msg.isMine = true;
          }
          finalRightMessages.addAll(group.messages);
          debugPrint('가운데 → 나: "${group.getCombinedText()}" (finalScore=$finalScore, 그룹 임계값=$groupThreshold)');
          previousSpeaker = "나";
        } else {
          for (var msg in group.messages) {
            msg.isMine = false;
          }
          finalLeftMessages.addAll(group.messages);
          debugPrint('가운데 → 상대방: "${group.getCombinedText()}" (finalScore=$finalScore, 그룹 임계값=$groupThreshold)');
          previousSpeaker = "상대방";
        }
      }

      List<Message> allMessages = [...finalLeftMessages, ...finalRightMessages];
      allMessages.sort((a, b) => a.y.compareTo(b.y));
      for (var msg in allMessages) {
        bool assigned = false;
        for (var tsGroup in timestampGroups) {
          double tsY = tsGroup['y'];
          double tsX = tsGroup['x'];
          if ((msg.y - tsY).abs() < 100 && (msg.x - tsX).abs() < 300) {
            (tsGroup['messages'] as List<Message>).add(msg);
            assigned = true;
            debugPrint('타임스탬프 "${tsGroup['timestamp']}"에 메시지 "${msg.text}" 매핑 (y=${msg.y}, x=${msg.x})');
            break;
          }
        }
        if (!assigned) {
          timestampGroups.add({'timestamp': '', 'y': msg.y, 'x': msg.x, 'messages': [msg]});
          debugPrint('타임스탬프 없음, 새 그룹 생성: "${msg.text}" (y=${msg.y}, x=${msg.x})');
        }
      }

      debugPrint('왼쪽 메시지 수: ${finalLeftMessages.length}');
      debugPrint('오른쪽 메시지 수: ${finalRightMessages.length}');
      debugPrint('타임스탬프 수: ${timestampGroups.length}');

      double avgHeightFinal = allMessages.isNotEmpty
          ? allMessages.map((m) => m.height).reduce((a, b) => a + b) / allMessages.length
          : 15.0;
      double avgMessageY = allMessages.isNotEmpty ? allMessages.map((m) => m.y).reduce((a, b) => a + b) / allMessages.length : 0.0;
      debugPrint('텍스트 평균 높이: $avgHeightFinal');
      debugPrint('텍스트 평균 Y값: $avgMessageY');

      for (var tsGroup in timestampGroups..sort((a, b) => a['y'].compareTo(b['y']))) {
        List<Message> tsMessages = tsGroup['messages'] as List<Message>;
        tsMessages.sort((a, b) => a.y.compareTo(b.y));
        List<Map<String, dynamic>> opponentGroups = [];
        List<Map<String, dynamic>> myGroups = [];

        for (var msg in tsMessages) {
          bool isOpponent = finalLeftMessages.contains(msg);
          bool assigned = false;

          if (isOpponent) {
            for (var group in opponentGroups) {
              double groupY = group['y'];
              if ((msg.y - groupY).abs() < 25 && msg.x >= group['minX'] - 250 && msg.x <= group['maxX'] + 250) {
                if (!(group['messages'] as List<Message>).any((m) => m.text == msg.text && m.y == msg.y)) {
                  (group['messages'] as List<Message>).add(msg);
                  group['minX'] = msg.x < group['minX'] ? msg.x : group['minX'];
                  group['maxX'] = msg.X > group['maxX'] ? msg.X : group['maxX'];
                  debugPrint('새 상대방 그룹 추가: "${msg.text}" (y=${msg.y}, height=${msg.height}, x=${msg.x})');
                }
                assigned = true;
                break;
              }
            }
            if (!assigned) {
              opponentGroups.add({
                'y': msg.y,
                'minX': msg.x,
                'maxX': msg.X,
                'messages': [msg],
                'timestamp': tsGroup['timestamp'],
              });
              debugPrint('새 상대방 그룹 생성: "${msg.text}" (y=${msg.y}, height=${msg.height}, x=${msg.x})');
            }
          } else {
            for (var group in myGroups) {
              double groupY = group['y'];
              if ((msg.y - groupY).abs() < 25 && msg.x >= group['minX'] - 250 && msg.x <= group['maxX'] + 250) {
                if (!(group['messages'] as List<Message>).any((m) => m.text == msg.text && m.y == msg.y)) {
                  (group['messages'] as List<Message>).add(msg);
                  group['minX'] = msg.x < group['minX'] ? msg.x : group['minX'];
                  group['maxX'] = msg.X > group['maxX'] ? msg.X : group['maxX'];
                  debugPrint('내 그룹 추가: "${msg.text}" (y=${msg.y}, height=${msg.height}, x=${msg.x})');
                }
                assigned = true;
                break;
              }
            }
            if (!assigned) {
              myGroups.add({
                'y': msg.y,
                'minX': msg.x,
                'maxX': msg.X,
                'messages': [msg],
                'timestamp': tsGroup['timestamp'],
              });
              debugPrint('새 내 그룹 생성: "${msg.text}" (y=${msg.y}, height=${msg.height}, x=${msg.x})');
            }
          }
        }

        for (var group in opponentGroups..sort((a, b) => a['y'].compareTo(b['y']))) {
          List<Message> groupMessages = group['messages'] as List<Message>;
          groupMessages.sort((a, b) => a.y.compareTo(b.y));
          String combinedText = groupMessages.map((m) => m.text.trim()).toSet().join(' ');
          String timestamp = group['timestamp'] != '' ? group['timestamp'] : '';
          conversation.add({
            'y': group['y'],
            'text': combinedText,
            'isOpponent': true,
            'speaker': "상대방",
            'timestamp': timestamp,
          });
        }
        for (var group in myGroups..sort((a, b) => a['y'].compareTo(b['y']))) {
          List<Message> groupMessages = group['messages'] as List<Message>;
          groupMessages.sort((a, b) => a.y.compareTo(b.y));
          String combinedText = groupMessages.map((m) => m.text.trim()).toSet().join(' ');
          String timestamp = group['timestamp'] != '' ? group['timestamp'] : '';
          conversation.add({
            'y': group['y'],
            'text': combinedText,
            'isOpponent': false,
            'speaker': "나",
            'timestamp': timestamp,
          });
        }
      }

      // 프롬프트 구성 전 대화에서 이름 제거 (내 말투 제외)
      final nameCandidates = detectNameCandidates(messages, screenWidth);
      List<Map<String, dynamic>> filteredConversation = [];
      conversation.sort((a, b) => a['y'].compareTo(b['y']));
      for (var entry in conversation) {
        String text = entry['text'].toString().trim();
        bool isMine = !entry['isOpponent']; // isOpponent가 false면 내 메시지
        String newText = removeDetectedNames(text, nameCandidates, isMine);
        debugPrint('${isMine ? "나" : "상대방"}: 원본="${text}" → 수정="${newText}"');

        newText = newText.replaceAll(RegExp(r'^(1|[+#])$'), '').trim();

        if (newText.isNotEmpty) {
          filteredConversation.add({
            'y': entry['y'],
            'text': newText,
            'isOpponent': entry['isOpponent'],
            'speaker': entry['speaker'],
            'timestamp': entry['timestamp'],
          });
        }
      }

      conversation = filteredConversation;

      for (var entry in conversation) {
        String speaker = entry['isOpponent'] ? "상대방" : "나";
        String text = entry['text'];
        String timestamp = entry['timestamp'] != '' ? '[${entry['timestamp']}]' : '';
        debugPrint('$speaker: $text $timestamp (y=${entry['y']})');
        if (entry['isOpponent']) {
          otherMessages.add(text);
          if (timestamp.isNotEmpty) otherTimestamps.add(timestamp);
        } else {
          myMessages.add(text);
          if (timestamp.isNotEmpty) myTimestamps.add(timestamp);
        }
      }

      return {
        'myMessages': myMessages,
        'otherMessages': otherMessages,
        'myTimestamps': myTimestamps,
        'otherTimestamps': otherTimestamps,
        'conversation': conversation,
      };
    } catch (e) {
      debugPrint('메시지 분리 중 오류: $e');
      throw Exception('메시지 분리 중 오류 발생: $e');
    } finally {
      image = null;
    }
  }

  int _levenshteinDistance(String s1, String s2) {
    final m = s1.length;
    final n = s2.length;
    List<List<int>> dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (int j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + [
            dp[i - 1][j],
            dp[i][j - 1],
            dp[i - 1][j - 1],
          ].reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[m][n];
  }

  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    final distance = _levenshteinDistance(s1, s2);
    final maxLength = s1.length > s2.length ? s1.length : s2.length;
    return (1 - distance / maxLength) * 100;
  }

  @override
  State<ScreenshotAnalysisScreen> createState() => _ScreenshotAnalysisScreenState();
}

class _ScreenshotAnalysisScreenState extends State<ScreenshotAnalysisScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  final String deepSeekApiUrl = 'https://us-central1-toedok-new.cloudfunctions.net/analyzeTextV2';
  bool isLoading = false;
  bool isRerollLoading = false;
  String? extractedText;
  Map<String, dynamic>? analysisResult;
  String? recommendedResponse;
  String? errorMessage;
  String? conversationFlow;
  String? userSuggestion;
  String selectedMood = '매력';
  Uint8List? uploadedImage;
  List<Message> detectedMessages = [];
  double screenWidth = 1080.0;
  String displayRoomName = '';
  Uint8List? highlightedImage = null;
  bool showDetailedAnalysis = false;
  final ScrollController scrollController = ScrollController();
  int _rerollCountToday = 0;
  late DateTime _lastResetDate;
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  bool isFastForward = false;
  String? textToSpeak;
  Map<String, dynamic>? separatedMessages;

  AnimationController? moodButtonController;
  Animation<double>? moodButtonScale;
  AnimationController? sendButtonController;
  Animation<double>? sendButtonScale;
  AnimationController? headerColorController;
  Animation<double>? headerColorAnimation;
  AnimationController? loadingController;
  AnimationController? popController;
  Animation<double>? popAnimation;

final Map<String, String> moodIcons = {
    '매력': 'assets/icons/attraction.png',
    '화남': 'assets/icons/angry.png',
    '신남': 'assets/icons/excited.png', // 제공된 고양이 이미지
    '궁금': 'assets/icons/curious.png',
    '진지': 'assets/icons/serious.png',
    '장난': 'assets/icons/playful.png',
    '슬픔': 'assets/icons/sad.png',
    'chill가이': 'assets/icons/chill.png',
    '시크': 'assets/icons/cool.png',
    '위로': 'assets/icons/comfort.png',
  };

  final Map<String, Color> moodColors = {
    '기쁨': const Color(0xFFFFD700),
    '불안': const Color(0xFF9C27B0),
    '짜증': const Color(0xFFF44336),
    '슬픔': const Color(0xFF2196F3),
    '평온': const Color(0xFF4CAF50),
    '매력': const Color(0xFFE91E63),
    '화남': const Color(0xFFFF5722),
    '신남': const Color(0xFFFF9800),
    '궁금': const Color(0xFF9E9E9E),
    '진지': const Color(0xFF607D8B),
    '장난': const Color(0xFFFFC107),
    'chill가이': const Color(0xFF00BCD4),
    '시크': Colors.black,
    '위로': const Color(0xFF8D5524),
  };

  final List<String> moods = ['매력', '화남', '신남', '궁금', '진지', '장난', '슬픔', 'chill가이', '시크', '위로'];

  List<Color> gradientColors = [
    const Color(0xFFC56BFF),
    const Color(0xFFA95EFF),
    const Color(0xFF8C52FF),
    const Color(0xFF6F46FF),
    const Color(0xFF5C38A0),
  ];

  List<Color> purpleGradientColors = [
    const Color(0xFFD1C4E9),
    const Color(0xFFB39DDB),
    const Color(0xFF9575CD),
    const Color(0xFF7E57C2),
    const Color(0xFF673AB7),
  ];

    @override
  void initState() {
    super.initState();
    debugPrint('ScreenshotAnalysisScreen 초기화: ${widget.roomName}');
    try {
      flutterTts = FlutterTts();
      Future.microtask(() async {
        await _initTts();
      });

      moodButtonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
      moodButtonScale = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: moodButtonController!, curve: Curves.easeInOut));
      sendButtonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
      sendButtonScale = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: sendButtonController!, curve: Curves.easeInOut));
      headerColorController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
      headerColorAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: headerColorController!, curve: Curves.easeInOut));
      loadingController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
      popController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))..forward();
      popAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: popController!, curve: Curves.easeOutBack));
      displayRoomName = widget.roomName;

      if (widget.initialImage != null) {
        uploadedImage = widget.initialImage;
        highlightedImage = uploadedImage;
      }

      if (widget.analysisResult != null) {
        extractedText = widget.analysisResult!['extractedText']?.toString();
        analysisResult = widget.analysisResult!['analysisResult'] as Map<String, dynamic>?;
        recommendedResponse = widget.analysisResult!['recommendedResponse']?.toString();
        conversationFlow = widget.analysisResult!['conversationFlow']?.toString();
        userSuggestion = widget.analysisResult!['userSuggestion']?.toString();
        detectedMessages = (widget.analysisResult!['messages'] as List<dynamic>?)
                ?.map((msg) => Message.fromJson(msg as Map<String, dynamic>))
                .toList() ??
            [];
        separatedMessages = widget.analysisResult!['separatedMessages'] as Map<String, dynamic>?;
        debugPrint('초기 분석 결과 로드: ${widget.roomName}');
      }

      loadRerollCount();
      WidgetsBinding.instance.addObserver(this);
    } catch (e) {
      debugPrint('초기화 오류: $e');
      if (mounted) {
        setState(() {
          errorMessage = '초기화 중 오류 발생: $e';
        });
      }
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('ScreenshotAnalysisScreen AppLifecycleState 변경: $state');
  }

            Future<void> _initTts() async {
    try {
      // 디바이스 로케일 확인
      String deviceLocale = Platform.localeName; // 예: "ko_KR", "en_US"
      debugPrint('디바이스 로케일: $deviceLocale');

      // 디바이스 언어에 따라 TTS 언어 설정
      String ttsLocale = 'en-US'; // 기본값
      String deviceLang = deviceLocale.split('_')[0]; // "ko_KR" -> "ko"
      switch (deviceLang) {
        case 'ko':
          ttsLocale = 'ko-KR';
          break;
        case 'en':
          ttsLocale = 'en-US';
          break;
        case 'ja':
          ttsLocale = 'ja-JP';
          break;
        case 'zh':
          ttsLocale = 'zh-CN';
          break;
        case 'hi':
          ttsLocale = 'hi-IN';
          break;
        default:
          ttsLocale = 'en-US';
      }
      debugPrint('설정된 TTS 언어: $ttsLocale');

      // 지원 언어 확인
      List<dynamic> languages = await flutterTts.getLanguages;
      debugPrint('TTS 지원 언어: $languages');

      // TTS 언어 설정
      await flutterTts.setLanguage(ttsLocale);
      dynamic isLanguageSetResult = await flutterTts.isLanguageAvailable(ttsLocale);
      bool isLanguageSet = (isLanguageSetResult is bool) ? isLanguageSetResult : (isLanguageSetResult == 1);
      if (!isLanguageSet) {
        debugPrint('TTS 언어 설정 실패: $ttsLocale, en-US로 대체');
        ttsLocale = 'en-US';
        await flutterTts.setLanguage(ttsLocale);
      }

      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      debugPrint('TTS 초기화 완료: 언어=$ttsLocale, 속도=0.5');

      flutterTts.setStartHandler(() {
        setState(() {
          isSpeaking = true;
        });
        debugPrint('TTS 재생 시작');
      });

      flutterTts.setCompletionHandler(() {
        setState(() {
          isSpeaking = false;
          isFastForward = false;
        });
        debugPrint('TTS 재생 완료');
      });

      flutterTts.setErrorHandler((msg) {
        setState(() {
          isSpeaking = false;
          isFastForward = false;
          errorMessage = 'TTS 오류: $msg';
        });
        debugPrint('TTS 오류: $msg');
      });
    } catch (e) {
      debugPrint('TTS 초기화 오류: $e');
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      debugPrint('TTS 초기화 완료 (오류 후 기본값): 언어=en-US, 속도=0.5');

      flutterTts.setStartHandler(() {
        setState(() {
          isSpeaking = true;
        });
        debugPrint('TTS 재생 시작');
      });

      flutterTts.setCompletionHandler(() {
        setState(() {
          isSpeaking = false;
          isFastForward = false;
        });
        debugPrint('TTS 재생 완료');
      });

      flutterTts.setErrorHandler((msg) {
        setState(() {
          isSpeaking = false;
          isFastForward = false;
          errorMessage = 'TTS 오류: $msg';
        });
        debugPrint('TTS 오류: $msg');
      });
    }
  }

     Future<void> _speakAnalysis() async {
    if (!isSpeaking) {
      if (analysisResult == null) {
        setState(() {
          errorMessage = widget.translations["분석 결과가 없습니다."] ?? "분석 결과가 없습니다.";
        });
        return;
      }

      textToSpeak = '';
      if (userSuggestion != null && userSuggestion!.isNotEmpty) {
        textToSpeak = "${"대화 개선점".tr()}: $userSuggestion\n"; // 제목을 "대화 개선점"으로 변경
      }
      if (analysisResult!['hope'] != null && analysisResult!['hope'].toString().isNotEmpty) {
        textToSpeak = textToSpeak! + "${"희망".tr()}: ${analysisResult!['hope']}\n"; // UI에 표시된 번역된 제목 사용
      }
      if (analysisResult!['risk'] != null && analysisResult!['risk'].toString().isNotEmpty) {
        textToSpeak = textToSpeak! + "${"위기".tr()}: ${analysisResult!['risk']}\n"; // UI에 표시된 번역된 제목 사용
      }

      if (textToSpeak!.isEmpty) {
        setState(() {
          errorMessage = widget.translations["읽을 분석 결과가 없습니다."] ?? "읽을 분석 결과가 없습니다.";
        });
        return;
      }

      await flutterTts.stop();
      await flutterTts.setSpeechRate(0.5);
      debugPrint('TTS 속도 설정: 0.5 (기본 속도), 디바이스 기본 언어 사용');
      await flutterTts.speak(textToSpeak!);
      setState(() {
        isSpeaking = true;
        isFastForward = false;
      });
    } else if (isSpeaking && !isFastForward) {
      await flutterTts.stop();
      await flutterTts.setSpeechRate(0.7);
      debugPrint('TTS 속도 설정: 0.7 (2배속), 디바이스 기본 언어 사용');
      await flutterTts.speak(textToSpeak!);
      setState(() {
        isFastForward = true;
      });
    } else if (isSpeaking && isFastForward) {
      await flutterTts.stop();
      debugPrint('TTS 정지');
      setState(() {
        isSpeaking = false;
        isFastForward = false;
      });
    }
  }
  Future<void> loadRerollCount() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString('rerollLastResetDate');
    _lastResetDate = lastReset != null ? DateTime.parse(lastReset) : DateTime.now();
    final today = DateTime.now();

    if (!_isSameDay(_lastResetDate, today)) {
      await prefs.setString('rerollLastResetDate', today.toIso8601String());
      await prefs.setInt('rerollCountToday', 0);
      _rerollCountToday = 0;
    } else {
      _rerollCountToday = prefs.getInt('rerollCountToday') ?? 0;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Future<void> _incrementRerollCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();

    if (!_isSameDay(_lastResetDate, today)) {
      _lastResetDate = today;
      _rerollCountToday = 0;
      await prefs.setString('rerollLastResetDate', today.toIso8601String());
    }

    _rerollCountToday++;
    await prefs.setInt('rerollCountToday', _rerollCountToday);
  }

  @override
  void dispose() {
    debugPrint('ScreenshotAnalysisScreen 해제');
    try {
      flutterTts.stop();
      moodButtonController?.dispose();
      sendButtonController?.dispose();
      headerColorController?.dispose();
      loadingController?.dispose();
      popController?.dispose();
      scrollController.dispose();
      WidgetsBinding.instance.removeObserver(this);
    } catch (e) {
      debugPrint('해제 오류: $e');
    }
    super.dispose();
  }

  void showFullScreenshot() {
    if (uploadedImage == null) return;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.memory(
            uploadedImage!,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void showMoodSelectionDialog() {
    if (!mounted) {
      debugPrint('showMoodSelectionDialog: 위젯이 마운트되지 않음');
      return;
    }
    debugPrint('showMoodSelectionDialog 호출');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AlertDialog(
            backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
            elevation: 8,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: AnimatedBuilder(
              animation: headerColorController!,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                    end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                    colors: gradientColors,
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  ).createShader(bounds),
                  child: Text(
                    "기분 선택".tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                    maxLines: 1,
                  ),
                );
              },
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 300,
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 4,
                radius: const Radius.circular(2),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: moods.asMap().entries.map((entry) {
                      final index = entry.key;
                      final mood = entry.value;
                      final isLocked = !widget.isVIP && ['장난', '슬픔', 'chill가이', '시크', '위로'].contains(mood);
                      debugPrint('기분 목록 렌더링: $mood (index: $index)');
                      return ListTile(
                        leading: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Image.asset(
      moodIcons[mood]!,
      width: 36, // 크기 키우기 (24 * 1.5)
      height: 36,
      color: widget.isDarkTheme && mood == '시크' ? Colors.white : moodColors[mood],
      colorBlendMode: BlendMode.srcIn, // 검은색 PNG에 색상 강하게 적용
    ),
    if (isLocked) ...[
      const SizedBox(width: 8),
      const Icon(Icons.lock, size: 16, color: Colors.grey),
    ],
  ],
),
                        title: Text(
                          mood.tr(),
                          style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
                          maxLines: 1,
                        ),
                        onTap: () {
                          if (isLocked) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
                                title: Text(
                                  "VIP 전용입니다".tr(),
                                  style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black, wordSpacing: 1.5),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      widget.onShowVIPDialog();
                                    },
                                    child: Text(
                                      "확인".tr(),
                                      style: TextStyle(color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB), wordSpacing: 1.5),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            debugPrint('기분 선택: $mood');
                            if (mounted) {
                              setState(() => selectedMood = mood);
                              Navigator.pop(context);
                              rerollRecommendation();
                            }
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  debugPrint('기분 선택 취소');
                  Navigator.pop(context);
                },
                child: Text(
                  "취소".tr(),
                  style: const TextStyle(color: Color(0xFF7539BB), fontSize: 15),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ).then((_) {
        debugPrint('showMoodSelectionDialog: 다이얼로그 닫힘');
      });
    });
  }

  Future<void> rerollRecommendation() async {
  if (isRerollLoading || !mounted || extractedText == null || analysisResult == null || detectedMessages.isEmpty || separatedMessages == null) {
    if (mounted) {
      setState(() {
        errorMessage = widget.translations["분석 결과가 없어 추천 멘트를 생성할 수 없습니다."] ?? "분석 결과가 없어 추천 멘트를 생성할 수 없습니다.";
      });
    }
    return;
  }

  if (!widget.isVIP) {
    final today = DateTime.now();
    if (!_isSameDay(_lastResetDate, today)) {
      _rerollCountToday = 0;
      _lastResetDate = today;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('rerollLastResetDate', today.toIso8601String());
      await prefs.setInt('rerollCountToday', 0);
    }
    if (_rerollCountToday >= 2) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AlertDialog(
                backgroundColor: widget.isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
                elevation: 8,
                surfaceTintColor: Colors.transparent,
                title: Text(
                  "오늘 무료 횟수를 다 사용했습니다.\n내일 다시 오세요!".tr(),
                  style: TextStyle(
                    color: widget.isDarkTheme ? Colors.white : Colors.black,
                    fontSize: 18,
                    wordSpacing: 1.5,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onShowVIPDialog();
                    },
                    child: Text(
                      widget.translations["확인"] ?? "확인",
                      style: const TextStyle(color: Color(0xFF7539BB), fontSize: 15, wordSpacing: 1.5),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }
      return;
    }
  }

  setState(() {
    isRerollLoading = true;
    errorMessage = null;
  });

  await _incrementRerollCount();
  final client = http.Client();
  try {
    List<Map<String, dynamic>> conversation = (separatedMessages!['conversation'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];

    bool isFormal = false;
    int formalCount = 0;
    int totalMessages = 0;

    for (var entry in conversation) {
      String text = entry['text'].toString().trim();
      totalMessages++;
      if (widget.currentLanguage == 'ko') {
        if (text.contains('습니다') || text.contains('요') || text.contains('세요') || text.contains('시다') || text.endsWith('다') || text.contains('니')) {
          formalCount++;
        }
      } else {
        formalCount++;
      }
    }

    if (totalMessages > 0) {
      isFormal = (formalCount / totalMessages) > 0.5;
    }
    debugPrint('대화 맥락 존댓말 여부 (reroll): $isFormal (formalCount=$formalCount, totalMessages=$totalMessages)');

    String conversationLog = conversation
        .map((entry) => '${entry['speaker']}: ${entry['text']} ${entry['timestamp'].isNotEmpty ? '[${entry['timestamp']}]' : ''}')
        .join('\n');

    List<String> myMessages = conversation
        .where((entry) => entry['speaker'] == "나")
        .map((entry) => entry['text'].toString())
        .toList();

    String lastMessage = conversation.isNotEmpty ? conversation.last['text'].toString() : '';
    bool isLastMessageMine = conversation.isNotEmpty && conversation.last['speaker'] == "나";

    final prompt = '''
### 출력 언어 지침:
- 모든 출력은 반드시 "${widget.currentLanguage == "zh" ? "Standard Chinese (Mandarin)" : widget.currentLanguage}"로 작성해야 합니다.
- 한국어 또는 다른 언어는 절대 포함시키지 마세요.
- 출력 언어가 "${widget.currentLanguage}"가 아니면 "Language output error, please retry in ${widget.currentLanguage}"를 반환하세요.

아래는 메시지 스크린샷에서 추출한 대화 텍스트입니다. 대화는 y 좌표순으로 정렬되어 있으며, 위에서 아래로 진행됩니다. 타임스탬프는 각 메시지 옆에 [오후 11시 40분] 형식으로 표시됩니다:
        대화 흐름:
        $conversationLog
        대화 흐름 제안: "${analysisResult!['userSuggestion'] ?? widget.translations["대화 흐름 분석 실패."] ?? "대화 흐름 분석 실패."}"

        ### 추가 정보:
        - 내 메시지 목록: $myMessages
        - 대화의 마지막 메시지: "$lastMessage" (나의 메시지: $isLastMessageMine)
        - 이전 추천 응답: "$recommendedResponse"
        - 대화가 존댓말인지 반말인지 판단 결과: ${isFormal ? "존댓말" : "반말"}
        - 선택된 기분: "$selectedMood" (이 기분을 강하게 반영)

        ### 언어 설정 (강력히 준수):
        - 출력 언어는 반드시 "${widget.currentLanguage == "zh" ? "Standard Chinese (Mandarin)" : widget.currentLanguage}"로 설정하세요.
        - 다른 언어(예: 한국어, 영어 등)가 섞이지 않도록 엄격히 제한합니다.
        - 지정된 언어로 응답이 생성되지 않으면 "Language output error, please retry in ${widget.currentLanguage}"를 출력하세요.
        - 응답 텍스트는 지정된 언어로만 작성되어야 하며, 언어 혼합은 절대 허용되지 않습니다.

        다음 조건을 만족하는 새로운 추천 응답을 생성하세요:
        - 대화 맥락: 대화 흐름의 마지막 메시지 바로 다음에 이어질 "나"의 응답으로, 대화의 주제와 감정을 반영
        - 내 기분: "$selectedMood" (기분 뉘앙스를 강하게 반영, 자연스러운 톤 조정)
        - 내 말투: 내 메시지의 스타일, 어조, 단어 선택, 문장 구조를 강하게 반영하여 동일한 말투로 작성 (내 메시지 목록을 참고하여 말투 분석 후 반영)
        - 대화가 존댓말이면 존댓말로, 반말이면 반말로 작성 (현재 대화 맥락: ${isFormal ? "존댓말" : "반말"})
        - 15-35자, 한 문장, 이모지 없이
        - 이전 추천 응답과 절대 동일하거나 유사한 문맥, 단어 사용 금지, 항상 새로운 응답 생성
        - 대화 흐름과 감정에 맞는 자연스러운 톤으로 작성
        - 응답 텍스트만 제공
        ''';

    debugPrint('Firebase 추천 응답 입력 프롬프트:\n$prompt');

    final response = await client.post(
      Uri.parse(deepSeekApiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'conversationLog': prompt
      }),
    );

    if (response.statusCode == 200) {
      final rawResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint('Parsed Response: $rawResponse'); // 디버깅 로그 추가
      final candidates = rawResponse['candidates'];
      if (candidates == null || candidates.isEmpty) throw Exception('Firebase 응답에 candidates 없음');
      var content = candidates[0]['content']['parts'][0]['text']?.trim() ?? '';
      debugPrint('Gemini 추천 응답: $content');

      if (content.isEmpty || content.contains("Language output error")) {
        content = widget.currentLanguage == 'ko'
            ? "다시 시도해 보세요."
            : widget.currentLanguage == 'en'
                ? "Please try again."
                : widget.currentLanguage == 'ja'
                    ? "もう一度試してください。"
                    : widget.currentLanguage == 'zh'
                        ? "请再试一次。"
                        : widget.currentLanguage == 'hi'
                            ? "कृपया पुनः प्रयास करें।"
                            : "Please try again.";
        debugPrint('Gemini에서 빈 응답 또는 언어 오류 반환, 기본 응답으로 대체: $content');
      }

      if (mounted) {
        setState(() {
          recommendedResponse = content;
          isRerollLoading = false;
        });
        await saveAnalysisData();

        final myAppState = context.findAncestorStateOfType<_MyAppState>()!;
        await myAppState.incrementApiCallCount(widget.isVIP);
      }
    } else {
      throw Exception('Firebase 요청 실패: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    debugPrint('rerollRecommendation 오류: $e');
    String content = widget.currentLanguage == 'ko'
        ? "다시 시도해 보세요."
        : widget.currentLanguage == 'en'
            ? "Please try again."
            : widget.currentLanguage == 'ja'
                ? "もう一度試してください。"
                : widget.currentLanguage == 'zh'
                    ? "请再试一次。"
                    : widget.currentLanguage == 'hi'
                        ? "कृपया पुनः प्रयास करें।"
                        : "Please try again.";
    if (mounted) {
      setState(() {
        recommendedResponse = content;
        isRerollLoading = false;
        errorMessage = "${widget.translations["추천 멘트 생성 중 오류가 발생했습니다:"] ?? "추천 멘트 생성 중 오류가 발생했습니다:"} $e";
      });
      await saveAnalysisData();
    }
  } finally {
    client.close();
  }
}

  Future<void> saveAnalysisData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = jsonEncode({
        'extractedText': extractedText,
        'analysisResult': analysisResult,
        'recommendedResponse': recommendedResponse,
        'conversationFlow': conversationFlow,
        'userSuggestion': userSuggestion,
        'displayRoomName': displayRoomName,
        'messages': detectedMessages.map((msg) => msg.toJson()).toList(),
        'separatedMessages': separatedMessages,
      });
      String key = '${widget.roomName}_analysis_data';
      await prefs.setString(key, data);
      final savedData = prefs.getString(key);
      if (savedData == null || savedData.isEmpty) {
        throw Exception('데이터 저장 실패: ${widget.roomName}');
      }
      debugPrint('분석 데이터 저장 완료: ${widget.roomName}, 키: $key');
    } catch (e) {
      debugPrint('데이터 저장 오류: $e');
      if (mounted) {
        setState(() {
          errorMessage = '데이터 저장 중 오류 발생: $e';
        });
      }
    }
  }

  void showFullTextDialog(String title, String content) {
    if (!mounted) {
      debugPrint('showFullTextDialog: 위젯이 마운트되지 않음');
      return;
    }
    debugPrint('showFullTextDialog 호출: title=$title, content=$content');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AlertDialog(
            backgroundColor: widget.isDarkTheme ? Colors.black : Colors.white,
            elevation: 8,
            surfaceTintColor: Colors.transparent,
            title: AnimatedBuilder(
              animation: headerColorController!,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                    end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                    colors: gradientColors,
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      wordSpacing: 1.5,
                    ),
                    maxLines: 1,
                  ),
                );
              },
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: TextStyle(
                    color: widget.isDarkTheme ? Colors.white : Colors.black87,
                    fontSize: 15,
                    height: 1.5,
                    wordSpacing: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  debugPrint('팝업 닫기 버튼 클릭');
                  Navigator.pop(context);
                },
                child: Text(
                  "닫기".tr(),
                  style: const TextStyle(color: Color(0xFF7539BB), fontSize: 15),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ).then((_) {
        debugPrint('showFullTextDialog: 다이얼로그 닫힘');
      });
    });
  }

  Widget buildErrorSection() {
    if (errorMessage == null) return const SizedBox.shrink();
    return ScaleTransition(
      scale: popAnimation!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isDarkTheme ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: gradientColors[0]),
          ),
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 15, wordSpacing: 1.5),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  Widget buildImageSection() {
    if (extractedText == null) return const SizedBox.shrink();
    return ScaleTransition(
      scale: popAnimation!,
      child: highlightedImage != null
          ? GestureDetector(
              onTap: showFullScreenshot,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 100,
                  decoration: BoxDecoration(
                    color: widget.isDarkTheme ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 2, color: gradientColors[0]),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      highlightedImage!,
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isDarkTheme ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1, color: gradientColors[0]),
                ),
                child: Text(
                  "하이라이트 이미지를 생성하지 못했습니다.".tr(),
                  style: TextStyle(color: widget.isDarkTheme ? Colors.white70 : Colors.grey, fontSize: 15, wordSpacing: 1.5),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
    );
  }

  Widget buildSummarySection() {
    if (extractedText == null) return const SizedBox.shrink();
    return ScaleTransition(
      scale: popAnimation!,
      child: GestureDetector(
        onTap: () {
          debugPrint('대화 개선점 터치');
          showFullTextDialog(
            "대화 개선점".tr(),
            userSuggestion ?? '',
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            height: showDetailedAnalysis ? MediaQuery.of(context).size.height * 0.23 : MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: widget.isDarkTheme ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: gradientColors[0]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: headerColorAnimation!,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                        end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                        colors: gradientColors,
                        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                      ).createShader(bounds),
                      child: Text(
                        "대화 요약".tr(),
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                        maxLines: 1,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    conversationFlow ?? '',
                    style: TextStyle(color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB), wordSpacing: 1.5),
                    textAlign: TextAlign.left,
                    minFontSize: 8,
                    maxFontSize: 16,
                    stepGranularity: 0.1,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedBuilder(
                  animation: headerColorAnimation!,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                        end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                        colors: gradientColors,
                        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                      ).createShader(bounds),
                      child: Text(
                        "대화 개선점".tr(),
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                        maxLines: 1,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                Flexible(
                  flex: 3,
                  child: AutoSizeText(
                    userSuggestion ?? '',
                    style: TextStyle(color: widget.isDarkTheme ? Colors.white : const Color(0xFF7539BB), wordSpacing: 1.5),
                    textAlign: TextAlign.left,
                    minFontSize: 8,
                    maxFontSize: 16,
                    stepGranularity: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOpponentAnalysis() {
    if (!showDetailedAnalysis || analysisResult == null || analysisResult!['opponentMood'] == null) return const SizedBox.shrink();

    double pieChartFontSize = 8;
    int sectionCount = (analysisResult!['opponentMood'] as Map<String, dynamic>).entries.where((e) => (e.value as num).toDouble() >= 0.1).length;
    if (sectionCount <= 5) pieChartFontSize = 10;

    double pieRadius = MediaQuery.of(context).size.width * 0.125;
    double centerSpaceRadius = pieRadius * 0.4;

    // 언어에 맞는 라벨 설정
    Map<String, String> moodLabels = {
      "기쁨": "기쁨".tr(),
      "불안": "불안".tr(),
      "짜증": "짜증".tr(),
      "슬픔": "슬픔".tr(),
      "평온": "평온".tr(),
    };

    return ScaleTransition(
      scale: popAnimation!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 12),
          height: 220,
          decoration: BoxDecoration(
            color: widget.isDarkTheme ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: gradientColors[0]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: headerColorAnimation!,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                      end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                      colors: gradientColors,
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      "상대방 분석".tr(),
                      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                      maxLines: 1,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 130,
                      child: PieChart(
                        PieChartData(
                          sections: (analysisResult!['opponentMood'] as Map<String, dynamic>)
                              .entries
                              .where((e) => (e.value as num).toDouble() >= 0.1)
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                            int idx = entry.key;
                            var e = entry.value;
                            String moodKey = e.key;
                            String translatedMood = moodLabels[moodKey] ?? moodKey;
                            return PieChartSectionData(
                              color: purpleGradientColors[idx % purpleGradientColors.length],
                              value: (e.value as num).toDouble(),
                              title: '$translatedMood\n${((e.value as num).toDouble() * 100).toInt()}%',
                              radius: pieRadius,
                              titleStyle: TextStyle(
                                fontSize: pieChartFontSize,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                wordSpacing: 1.5,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: centerSpaceRadius,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              "말투".tr(),
                              style: const TextStyle(color: Color(0xFF7539BB), fontWeight: FontWeight.w600, fontSize: 14, wordSpacing: 1.5),
                              maxLines: 1,
                            ),
                            const SizedBox(width: 16),
                            Flexible(
                              child: AutoSizeText(
                                analysisResult!['opponentTone']?.toString() ?? '',
                                style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, wordSpacing: 1.5),
                                minFontSize: 8,
                                maxFontSize: 14,
                                stepGranularity: 0.1,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              "호감도".tr(),
                              style: const TextStyle(color: Color(0xFF7539BB), fontWeight: FontWeight.w600, fontSize: 14, wordSpacing: 1.0),
                              maxLines: 1,
                            ),
                            const SizedBox(width: 16),
                            AutoSizeText(
                              '${((analysisResult!['opponentFavorability'] as double? ?? 0.5) * 100).toInt()}%',
                              style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, wordSpacing: 1.5),
                              minFontSize: 8,
                              maxFontSize: 14,
                              stepGranularity: 0.1,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              "잠재력".tr(),
                              style: const TextStyle(color: Color(0xFF7539BB), fontWeight: FontWeight.w600, fontSize: 14, wordSpacing: 1.5),
                              maxLines: 1,
                            ),
                            const SizedBox(width: 16),
                            AutoSizeText(
                              '${((analysisResult!['relationshipPotential'] as double? ?? 0.5) * 100).toInt()}%',
                              style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, wordSpacing: 1.5),
                              minFontSize: 8,
                              maxFontSize: 14,
                              stepGranularity: 0.1,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              "의도".tr(),
                              style: const TextStyle(color: Color(0xFF7539BB), fontWeight: FontWeight.w600, fontSize: 14, wordSpacing: 1.5),
                              maxLines: 1,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AutoSizeText(
                                analysisResult!['opponentIntent']?.toString() ?? '',
                                style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, wordSpacing: 1.5),
                                minFontSize: 8,
                                maxFontSize: 14,
                                stepGranularity: 0.1,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserAnalysis() {
    if (!showDetailedAnalysis || analysisResult == null || extractedText == null) return const SizedBox.shrink();

    return ScaleTransition(
      scale: popAnimation!,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    debugPrint('희망 터치');
                    showFullTextDialog(
                      "희망".tr(),
                      analysisResult!['hope']?.toString() ?? '',
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      height: 180,
                      decoration: BoxDecoration(
                        color: widget.isDarkTheme ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 1, color: gradientColors[0]),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                            animation: headerColorAnimation!,
                            builder: (context, child) {
                              return ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                                  end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                                  colors: gradientColors,
                                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                ).createShader(bounds),
                                child: Text(
                                  "희망".tr(),
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                                  maxLines: 1,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: AutoSizeText(
                              analysisResult!['hope']?.toString() ?? '',
                              style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, wordSpacing: 1.5),
                              minFontSize: 8,
                              maxFontSize: 16,
                              stepGranularity: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    debugPrint('위기 터치');
                    showFullTextDialog(
                      "위기".tr(),
                      analysisResult!['risk']?.toString() ?? '',
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      height: 180,
                      decoration: BoxDecoration(
                        color: widget.isDarkTheme ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 1, color: gradientColors[0]),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                            animation: headerColorAnimation!,
                            builder: (context, child) {
                              return ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                                  end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                                  colors: gradientColors,
                                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                ).createShader(bounds),
                                child: Text(
                                  "위기".tr(),
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                                  maxLines: 1,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: AutoSizeText(
                              analysisResult!['risk']?.toString() ?? '',
                              style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, wordSpacing: 1.5),
                              minFontSize: 8,
                              maxFontSize: 16,
                              stepGranularity: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                color: widget.isDarkTheme ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: gradientColors[0]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: headerColorAnimation!,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                          end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                          colors: gradientColors,
                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                        ).createShader(bounds),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "MBTI",
                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                            maxLines: 1,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 1),
                  Expanded(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: headerColorAnimation!,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                              end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                              colors: gradientColors,
                              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                            ).createShader(bounds),
                            child: AutoSizeText(
                              analysisResult!['opponentMBTI']?.toString() ?? "알 수 없음".tr(),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, wordSpacing: 1.5),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              minFontSize: 40,
                              maxFontSize: 120,
                              stepGranularity: 0.1,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToggleButton() {
    return GestureDetector(
      onTap: () {
        if (!mounted) return;
        setState(() {
          showDetailedAnalysis = !showDetailedAnalysis;
          if (showDetailedAnalysis) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                double recommendationSectionOffset = 0.0;
                recommendationSectionOffset += (errorMessage != null ? 60.0 : 0.0);
                recommendationSectionOffset += 12.0;
                recommendationSectionOffset += 100.0;
                recommendationSectionOffset += 12.0;
                recommendationSectionOffset += MediaQuery.of(context).size.height * 0.25;
                recommendationSectionOffset += 12.0;
                recommendationSectionOffset += 220.0;
                recommendationSectionOffset += 12.0;
                recommendationSectionOffset += 48.0;
                recommendationSectionOffset += 12.0;
                recommendationSectionOffset += 122.0;
                recommendationSectionOffset += 4.0;

                scrollController.animateTo(
                  recommendationSectionOffset,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutQuad,
                );
              }
            });
          } else {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                );
              }
            });
          }
        });
      },
      child: AnimatedBuilder(
        animation: headerColorAnimation!,
        builder: (context, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                  end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                  colors: gradientColors,
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  showDetailedAnalysis ? "분석 숨기기".tr() : "더 자세히 보기".tr(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, wordSpacing: 1.5),
                  maxLines: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRecommendationSection() {
    if (extractedText == null) return const SizedBox.shrink();
    return ScaleTransition(
      scale: popAnimation!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          height: 122,
          decoration: BoxDecoration(
            color: widget.isDarkTheme ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: gradientColors[0]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: headerColorAnimation!,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                      end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                      colors: gradientColors,
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      "추천 멘트".tr(),
                      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                      maxLines: 1,
                    ),
                  );
                },
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Row(
                  children: [
                    GestureDetector(
                                            onTapDown: (_) => moodButtonController?.forward(),
                      onTapUp: (_) {
                        moodButtonController?.reverse();
                        showMoodSelectionDialog();
                      },
                      onTapCancel: () => moodButtonController?.reverse(),
                      child: ScaleTransition(
  scale: moodButtonScale!,
  child: Container(
    width: 44,
    height: 44,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: gradientColors),
    ),
    child: Image.asset(
      moodIcons[selectedMood]!,
      width: 36,
      height: 36,
      color: Colors.white,
      colorBlendMode: BlendMode.srcIn, // 검은색 PNG에 색상 강하게 적용
    ),
  ),
),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onLongPress: () {
                          if (recommendedResponse != null && recommendedResponse!.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: recommendedResponse!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "추천 멘트가 복사되었습니다.".tr(),
                                  style: const TextStyle(fontSize: 15, wordSpacing: 1.5),
                                  maxLines: 2,
                                ),
                              ),
                            );
                          }
                        },
                                                  child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: gradientColors[0]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: isRerollLoading
                                ? Center(
                                    child: RotationTransition(
                                      turns: loadingController!,
                                      child: const Icon(Icons.refresh, color: Color(0xFF7539BB), size: 24),
                                    ),
                                  )
                                : AutoSizeText(
                                    recommendedResponse ?? '',
                                    style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, wordSpacing: 1.5),
                                    minFontSize: 8,
                                    maxFontSize: 16,
                                    stepGranularity: 0.1,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTapDown: (_) => sendButtonController?.forward(),
                        onTapUp: (_) {
                          sendButtonController?.reverse();
                          rerollRecommendation();
                        },
                        onTapCancel: () => sendButtonController?.reverse(),
                        child: ScaleTransition(
                          scale: sendButtonScale!,
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: gradientColors),
                            ),
                                                      child: const Icon(Icons.refresh, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget buildFavorabilityTimeline() {
    if (extractedText == null || analysisResult == null) return const SizedBox.shrink();
    final favorabilityTimeline = (analysisResult!['favorabilityTimeline'] as List<dynamic>?)?.cast<double>() ?? [0.2, 0.5, 0.8, 0.3];
    final potentialTimeline = (analysisResult!['potentialTimeline'] as List<dynamic>?)?.cast<double>() ?? [0.1, 0.7, 0.4, 0.9];
    final engagementTimeline = (analysisResult!['engagementTimeline'] as List<dynamic>?)?.cast<double>() ?? [0.3, 0.9, 0.2, 0.6];

    final favorabilityData = List.generate(favorabilityTimeline.length, (index) => FlSpot(index.toDouble(), favorabilityTimeline[index]));
    final potentialData = List.generate(potentialTimeline.length, (index) => FlSpot(index.toDouble(), potentialTimeline[index]));
    final engagementData = List.generate(engagementTimeline.length, (index) => FlSpot(index.toDouble(), engagementTimeline[index]));

    return ScaleTransition(
      scale: popAnimation!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 12),
          height: showDetailedAnalysis ? 208 : 220,
          decoration: BoxDecoration(
            color: widget.isDarkTheme ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: gradientColors[0]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: headerColorAnimation!,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                      end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                      colors: gradientColors,
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      "시간에 따른 변화".tr(),
                      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16, wordSpacing: 1.5),
                      maxLines: 1,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 108,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 0.5,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
                        getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 0.5,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) {
                                return AutoSizeText(
                                  '0',
                                  style: TextStyle(color: widget.isDarkTheme ? Colors.white54 : Colors.black87, wordSpacing: 1.5),
                                  minFontSize: 8,
                                  maxFontSize: 12,
                                  stepGranularity: 0.1,
                                  maxLines: 1,
                                );
                              }
                              if (value == 0.5) {
                                return AutoSizeText(
                                  '50',
                                  style: TextStyle(color: widget.isDarkTheme ? Colors.white54 : Colors.black87, wordSpacing: 1.5),
                                  minFontSize: 8,
                                  maxFontSize: 12,
                                  stepGranularity: 0.1,
                                  maxLines: 1,
                                );
                              }
                              if (value == 1.0) {
                                return AutoSizeText(
                                  '100',
                                  style: TextStyle(color: widget.isDarkTheme ? Colors.white54 : Colors.black87, wordSpacing: 1.5),
                                  minFontSize: 8,
                                  maxFontSize: 12,
                                  stepGranularity: 0.1,
                                  maxLines: 1,
                                );
                              }
                              return const SizedBox();
                            },
                            reservedSize: 30,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return AutoSizeText(
                                    "시작".tr(),
                                    style: TextStyle(color: widget.isDarkTheme ? Colors.white54 : Colors.black87, wordSpacing: 1.5),
                                    minFontSize: 8,
                                    maxFontSize: 12,
                                    stepGranularity: 0.1,
                                    maxLines: 1,
                                  );
                                case 1:
                                  return AutoSizeText(
                                    "초반".tr(),
                                    style: TextStyle(color: widget.isDarkTheme ? Colors.white54 : Colors.black87, wordSpacing: 1.5),
                                    minFontSize: 8,
                                    maxFontSize: 12,
                                    stepGranularity: 0.1,
                                    maxLines: 1,
                                  );
                                case 2:
                                  return AutoSizeText(
                                    "중반".tr(),
                                    style: TextStyle(color: widget.isDarkTheme ? Colors.white54 : Colors.black87, wordSpacing: 1.5),
                                    minFontSize: 8,
                                    maxFontSize: 12,
                                    stepGranularity: 0.1,
                                    maxLines: 1,
                                  );
                                case 3:
                                  return AutoSizeText(
                                    "최종".tr(),
                                    style: TextStyle(color: widget.isDarkTheme ? Colors.white54 : Colors.black87, wordSpacing: 1.5),
                                    minFontSize: 8,
                                    maxFontSize: 12,
                                    stepGranularity: 0.1,
                                    maxLines: 1,
                                  );
                                default:
                                  return const SizedBox();
                              }
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.5))),
                      minX: 0,
                      maxX: 3,
                      minY: 0,
                      maxY: 1,
                      lineTouchData: LineTouchData(enabled: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: favorabilityData,
                          isCurved: true,
                          color: purpleGradientColors[0], // 보라색 톤 1
                          barWidth: 2,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: potentialData,
                          isCurved: true,
                          color: purpleGradientColors[2], // 보라색 톤 2
                          barWidth: 2,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: engagementData,
                          isCurved: true,
                          color: purpleGradientColors[4], // 보라색 톤 3
                          barWidth: 2,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(width: 10, height: 2, color: purpleGradientColors[0]), // 호감도 색상
                      const SizedBox(width: 4),
                      Text(
                        "호감도".tr(),
                        style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, fontSize: 12, wordSpacing: 1.5),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Container(width: 10, height: 2, color: purpleGradientColors[2]), // 잠재력 색상
                      const SizedBox(width: 4),
                      Text(
                        "잠재력".tr(),
                        style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, fontSize: 12, wordSpacing: 1.5),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Container(width: 10, height: 2, color: purpleGradientColors[4]), // 흥미 색상
                      const SizedBox(width: 4),
                      Text(
                        "흥미".tr(),
                        style: TextStyle(color: widget.isDarkTheme ? Colors.white : Colors.black87, fontSize: 12, wordSpacing: 1.5),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: context.findAncestorStateOfType<_MyAppState>()!._themeNotifier,
      builder: (context, isDarkTheme, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: context.findAncestorStateOfType<_MyAppState>()!._isVIPNotifier,
          builder: (context, isVIP, child) {
            return Scaffold(
              backgroundColor: isDarkTheme ? const Color(0xFF2C2C2C) : Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AnimatedBuilder(
                  animation: headerColorAnimation!,
                  builder: (context, child) {
                    return ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                            end: Alignment.bottomRight.add(Alignment(headerColorAnimation!.value * 2 - 1, headerColorAnimation!.value * 2 - 1)),
                            colors: gradientColors,
                            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          ),
                        ),
                        child: AppBar(
                          title: Text(
                            displayRoomName,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, wordSpacing: 1.5),
                            maxLines: 1,
                          ),
                          centerTitle: true,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(
                                isSpeaking
                                    ? (isFastForward ? Icons.fast_forward : Icons.volume_up)
                                    : Icons.volume_up,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: _speakAnalysis,
                            ),
                            if (isVIP)
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Center(
                                  child: Text(
                                    "VIP".tr(),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, wordSpacing: 1.5),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              body: ListView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  buildErrorSection(),
                  const SizedBox(height: 12),
                  buildImageSection(),
                  const SizedBox(height: 12),
                  buildSummarySection(),
                  const SizedBox(height: 12),
                  buildFavorabilityTimeline(),
                  const SizedBox(height: 12),
                  if (showDetailedAnalysis) ...[
                    buildOpponentAnalysis(),
                    const SizedBox(height: 12),
                    buildUserAnalysis(),
                    const SizedBox(height: 12),
                  ],
                  buildToggleButton(),
                  const SizedBox(height: 12),
                  buildRecommendationSection(),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class BubbleGroup {
  final List<Message> messages;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  BubbleGroup({
    required this.messages,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  double getCenterX() => (minX + maxX) / 2;
  double getWidth() => maxX - minX;
  double getHeight() => maxY - minY;
  String getCombinedText() => messages.map((m) => m.text.trim()).join(' ');
  bool isRightAligned(double screenWidth) => maxX > screenWidth * 0.7;
}  