import 'package:amc_flutter_kit/src/analytics/src/models/analytics_event.dart';

/// {@template amc_event}
/// An analytics event for amc kit.
/// {@endtemplate}
abstract class AMCEvent extends AnalyticsEvent {
  /// {@macro amc_event}
  AMCEvent({
    required String name,
    required String category,
    required String action,
    required bool nonInteraction,
    String? label,
    Object? value,
    String? hitType,
  }) : super(
          name,
          properties: <String, Object>{
            'eventCategory': category,
            'eventAction': action,
            'nonInteraction': '$nonInteraction',
            if (label != null) 'eventLabel': label,
            if (value != null) 'eventValue': value,
            if (hitType != null) 'hitType': hitType,
          },
        );
}

/// {@template login_event}
/// An analytics event for tracking user login.
/// {@endtemplate}
class LoginGAEvent extends AMCEvent {
  /// {@macro login_event}
  LoginGAEvent({required bool isTab})
      : super(
          name: 'login',
          category: isTab ? 'Tab User' : 'Mobile User',
          action: 'login',
          label: 'success',
          nonInteraction: false,
        );
}

/// {@template logout_event}
/// An analytics event for tracking user logout.
/// {@endtemplate}
class LogoutGAEvent extends AMCEvent {
  /// {@macro logout_event}
  LogoutGAEvent({required bool isTab})
      : super(
          name: 'logout',
          category: isTab ? 'Tab User' : 'Mobile User',
          action: 'logout',
          label: 'success',
          nonInteraction: false,
        );
}

/// {@template article_comment_event}
/// An analytics event for tracking article comments.
/// {@endtemplate}
class ProfileViewEvent extends AMCEvent {
  /// {@macro article_comment_event}
  ProfileViewEvent({required bool isTab})
      : super(
          name: 'profile_view',
          category: isTab ? 'Tab User' : 'Mobile User',
          action: 'screen view',
          nonInteraction: false,
        );
}

/// {@template social_share_event}
/// An analytics event for tracking social sharing.
/// {@endtemplate}
class SosAddEvent extends AMCEvent {
  /// {@macro social_share_event}
  SosAddEvent({required bool isTab})
      : super(
          name: 'sos_add',
          category: isTab ? 'Tab Add' : 'Mobile Add',
          action: 'add',
          label: 'Sos case add',
          nonInteraction: false,
        );
}

/// {@template calendar_event}
/// An analytics event for tracking social sharing.
/// {@endtemplate}
class CalendarEvent extends AMCEvent {
  /// {@macro social_share_event}
  CalendarEvent({required bool isTab})
      : super(
          name: 'calendar_view',
          category: isTab ? 'Tab Add' : 'Mobile Add',
          action: 'add',
          label: 'Sos case add',
          nonInteraction: false,
        );
}

/// {@template push_notification_subscription_event}
/// An analytics event for tracking push notification subscription.
/// {@endtemplate}
class PushNotificationSubscriptionEvent extends AMCEvent {
  /// {@macro push_notification_subscription_event}
  PushNotificationSubscriptionEvent.click({required bool isTab})
      : super(
          name: 'push_notification_click',
          category:
              isTab ? 'Tab Push Notification' : 'Mobile Push Notification',
          action: 'click',
          nonInteraction: false,
        );

  /// {@macro push_notification_view_event}
  PushNotificationSubscriptionEvent.view({required bool isTab})
      : super(
          name: 'notification_screen_view',
          category:
              isTab ? 'Tab Push Notification' : 'Mobile Push Notification',
          action: 'screen view',
          nonInteraction: false,
        );
}

/// {@template paywall_prompt_event}
/// An analytics event for tracking paywall prompt impression and click.
/// {@endtemplate}
class DashboardGAEvent extends AMCEvent {
  /// An analytics event for tracking dashboard grid click.
  DashboardGAEvent.gridClick({required String title, required bool isTab})
      : super(
          name: 'dashboard_grid_click',
          category: isTab ? 'Tab Dashboard' : 'Mobile Dashboard',
          action: 'click',
          label: title,
          nonInteraction: true,
        );

  /// An analytics event for tracking dashboard chart click.
  DashboardGAEvent.chartClick({required String title, required bool isTab})
      : super(
          name: 'dashboard_chart_click',
          category: isTab ? 'Tab Dashboard' : 'Mobile Dashboard',
          action: 'click',
          label: title,
          nonInteraction: false,
        );
}
