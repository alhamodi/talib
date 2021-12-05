import 'package:bloc/bloc.dart';

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState().init());
}
