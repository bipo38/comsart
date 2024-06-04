import 'package:comsart/artistPages/artistPaints/create_paint_page.dart';
import 'package:comsart/artistPages/artistPaints/edit_paint_page.dart';
import 'package:comsart/artistPages/artistPaints/paints_main_page.dart';
import 'package:comsart/artistPages/artistProfilePage.dart';
import 'package:comsart/artistPages/artistSection/artistOptionsPage.dart';
import 'package:comsart/artistPages/artistVerificationPage.dart';
import 'package:comsart/main.dart';
import 'package:comsart/register/emailPage.dart';
import 'package:comsart/register/passwordPage.dart';
import 'package:comsart/register/profileImagePage.dart';
import 'package:comsart/register/registerOptionPage.dart';
import 'package:comsart/register/usernamePage.dart';
import 'package:comsart/userPages/homePage.dart';
import 'package:comsart/userPages/paint_home_details_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0.75, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.linearToEaseOut)),
            ),
            child: child),
  );
}

// GoRouter configuration
final routerConfig = GoRouter(
  initialLocation: '/login',
  routes: [
    //Login
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context, state: state, child: const HomePage()),
      // redirect: (BuildContext context, GoRouterState state) async {
      //   final isLoggedIn = await Store().isLoggedIn();
      //   print('isLoggedIn: $isLoggedIn');
      //   if (isLoggedIn) {
      //     return '/home';
      //   }
      //   return null;
      // },
    ),

    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context, state: state, child: const HomePage()),
      routes: [
        GoRoute(
          path: 'email',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context, state: state, child: const EmailPage()),
          routes: [
            GoRoute(
                path: 'registerOption',
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                    context: context,
                    state: state,
                    child: const RegisterOptionScreen()),
                routes: [
                  GoRoute(
                    path: 'name',
                    pageBuilder: (context, state) =>
                        buildPageWithDefaultTransition(
                            context: context,
                            state: state,
                            child: const UsernamePage()),
                    routes: [
                      GoRoute(
                        path: 'profileImage',
                        pageBuilder: (context, state) =>
                            buildPageWithDefaultTransition(
                                context: context,
                                state: state,
                                child: const ProfileImagePage()),
                        routes: [
                          GoRoute(
                            path: 'password',
                            pageBuilder: (context, state) =>
                                buildPageWithDefaultTransition(
                                    context: context,
                                    state: state,
                                    child: const PasswordPage()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
          ],
        ),
      ],
    ),

    GoRoute(
        path: '/home',
        builder: (context, state) => const HomePageUser(),
        routes: [
          GoRoute(
              path: 'artist',
              routes: [
                GoRoute(
                    path: 'paints',
                    builder: (context, state) => const PaintsMainPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (context, state) => CreatePaintPage(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (context, state) => EditPaintPage(
                          id: state.pathParameters['id']!,
                        ),
                      ),
                    ]),
              ],
              builder: (context, state) => const ArtistOptionsPage()),
          GoRoute(
              path: 'profile',
              builder: (context, state) => const ArtistProfilePage(),
              routes: [
                GoRoute(
                  path: 'verify',
                  builder: (context, state) => const ArtistVerificationPage(),
                ),
              ]),
          GoRoute(
              path: ':id',
              builder: (context, state) =>
                  PaintHomeDetailsPage(id: state.pathParameters['id']!)),
        ]),
  ],
);
