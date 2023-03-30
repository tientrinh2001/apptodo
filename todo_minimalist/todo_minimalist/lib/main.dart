import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'ui/task/task_screen.dart';
import 'ui/chat/widget/user_list.dart';
import 'ui/chat/chat_screen.dart';

import 'core/theme.dart';
import 'firebase_options.dart';
import 'provider/auth_controller.dart';
import 'service/local_notification_service.dart';
import 'ui/auth/auth_screen.dart';
import 'ui/home/home_screen.dart';
import 'ui/todo/todo_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.initialize();
  await EasyLocalization.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    EasyLocalization(
      path: 'assets/locales',
      supportedLocales: const [Locale('en', 'UK'), Locale('vi', 'VN')],
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    timeago.setLocaleMessages(
        context.locale.languageCode, timeago.ViMessages());
    final auth = ref.watch(authStateProvider);
    return MaterialApp(
      title: 'Todo minimalist',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: auth.when(
        data: ((user) {
          if (user != null) return const HomeScreen();
          return const AuthScreen();
        }),
        error: (e, trace) => const AuthScreen(),
        loading: () => const AuthScreen(),
      ),
      routes: {
        '/splash': (c) => const AuthScreen(),
        '/home': (c) => const HomeScreen(),
        '/todo': (c) => const TodoScreen(),
        '/task': (c) => const TaskScreen(),
        '/chat': (c) => const ChatScreen(),
        '/userList': (c) => const UserList(),
      },
    );
  }
}
