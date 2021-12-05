import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_cubit.dart';
import 'notification_state.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NotificationCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<NotificationCubit>(context);

    return Container();
  }
}


