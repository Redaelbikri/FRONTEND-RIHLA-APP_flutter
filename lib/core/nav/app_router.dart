import 'package:flutter/material.dart';

import '../../features/ onboarding/onboarding_screen.dart';
import '../../features/events/events_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/shell/bottom_shell.dart';

import '../../features/events/event_details_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/notifications_screen.dart';
import '../../features/profile/settings_screen.dart';

import '../../features/booking/booking_hub_screen.dart';
import '../../features/booking/transport/transport_screen.dart';
import '../../features/booking/hotels/hotels_screen.dart';
import '../../features/booking/tickets/tickets_screen.dart';

import '../../features/trips/trips_screen.dart';
import 'transitions.dart';

class Routes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const shell = '/shell';


  static const bookingHub = '/booking';
  static const tickets = '/tickets';
  static const transport = '/booking/transport';
  static const hotels = '/booking/hotels';
  static const profile = '/ProfileScreen';

  static const trips = '/trips';
  static const events = '/events';

  static const editProfile = '/edit-profile';
  static const notifications = '/notifications';
  static const settings = '/settings';


  static const eventDetails = '/eventDetails';
  static const hotelBooking = '/hotel-booking';
  static const stripePay = '/stripe-pay';

}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return RihlaTransitions.fadeThrough(const SplashScreen());

      case Routes.onboarding:
        return RihlaTransitions.fadeThrough(const OnboardingScreen());

      case Routes.login:
        return RihlaTransitions.fadeThrough(const LoginScreen());

      case Routes.signup:
        return RihlaTransitions.fadeThrough(const SignUpScreen());

      case Routes.shell:
        return RihlaTransitions.fadeThrough(const BottomShell());


      case Routes.bookingHub:
        return RihlaTransitions.fadeThrough(const BookingHubScreen());

      case Routes.tickets:
        return RihlaTransitions.fadeThrough(const TicketsScreen());

      case Routes.transport:
        return RihlaTransitions.fadeThrough(const TransportScreen());

      case Routes.hotels:
        return RihlaTransitions.fadeThrough(const HotelsScreen());
      case Routes.profile:
        return RihlaTransitions.fadeThrough(const ProfileScreen());



      case Routes.trips:
        return RihlaTransitions.fadeThrough(const TripsScreen());

      case Routes.events:
        return RihlaTransitions.fadeThrough(const EventsScreen());


      case Routes.eventDetails:


        final args = settings.arguments;
        return RihlaTransitions.slideUp(
          EventDetailsScreen(event: args),
        );




      case Routes.editProfile:
        return RihlaTransitions.slideUp(const EditProfileScreen());

      case Routes.notifications:
        return RihlaTransitions.slideUp(const NotificationsScreen());

      case Routes.settings:
        return RihlaTransitions.slideUp(const SettingsScreen());

      default:
        return RihlaTransitions.fadeThrough(
          Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
