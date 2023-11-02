import 'package:go_router/go_router.dart';

import '../../models/student_model.dart';
import '../../models/teacher_model.dart';
import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: LoginScreen.routeName,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/home',
    name: HomeScreen.routeName,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/register',
    name: RegisterScreen.routeName,
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: '/forgot_password',
    name: ForgotPasswordScreen.routeName,
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: '/reset_password',
    name: ResetPasswordScreen.routeName,
    builder: (context, state) {
      Teacher teacher = state.extra as Teacher;
      return ResetPasswordScreen(teacher: teacher);
    },
  ),
  GoRoute(
    path: '/users',
    name: UsersScreen.routeName,
    builder: (context, state) => const UsersScreen(),
  ),
  GoRoute(
    path: '/category_screen',
    name: CategoryScreen.routeName,
    builder: (context, state) {
      Student student = state.extra as Student;
      return CategoryScreen(student: student);
    },
  ),
  GoRoute(
      path: '/user_game_levels',
      name: StudentGamesLevesScreen.routeName,
      builder: (context, state) {
        Student student = state.extra as Student;
        return StudentGamesLevesScreen(student: student);
      }),
  GoRoute(
      path: '/picture_match',
      name: MemoryMatchScreen.routeName,
      builder: (context, state) {
        Student student = state.extra as Student;
        return MemoryMatchScreen(student: student);
      }),
  GoRoute(
    path: '/students',
    name: StudentsScreen.routeName,
    builder: (context, state) => const StudentsScreen(),
  ),
  GoRoute(
    path: '/add-student',
    name: AddStudentScreen.routeName,
    builder: (context, state) => AddStudentScreen(),
  ),
  GoRoute(
    path: '/edit-student',
    name: EditStudentScreen.routeName,
    builder: (context, state) {
      Student student = state.extra as Student;
      return EditStudentScreen(student: student);
    },
  ),
  GoRoute(
    path: '/teachers',
    name: TeachersScreen.routeName,
    builder: (context, state) => const TeachersScreen(),
  ),
  GoRoute(
    path: '/edit-teacher',
    name: EditTeacherScreen.routeName,
    builder: (context, state) {
      Teacher teacher = state.extra as Teacher;
      return EditTeacherScreen(teacher: teacher);
    },
  ),
  GoRoute(
    path: '/export',
    name: ExportScreen.routeName,
    builder: (context, state) => const ExportScreen(),
  ),
  GoRoute(
    path: '/student_info_screen',
    name: StudentInfoScreen.routeName,
    builder: (context, state) {
      Student student = state.extra as Student;
      return StudentInfoScreen(student: student);
    },
  ),
  GoRoute(
    path: '/history_game_screen',
    name: HistoryGameScreen.routeName,
    builder: (context, state) {
      Student student = state.extra as Student;
      return HistoryGameScreen(student: student);
    },
  ),
]);
