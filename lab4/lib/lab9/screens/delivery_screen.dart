import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/location/location_cubit.dart';
import '../blocs/location/location_state.dart';
import '../blocs/settings/settings_cubit.dart';
import '../blocs/settings/settings_state.dart';
import '../services/location_service.dart';
import '../widgets/hardware_feedback.dart';
import '../widgets/location_panel.dart';

/// Курьерская доставка: точка доставки по GPS.
class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(context.read<LocationService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Курьерская доставка')),
        body: BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state is LocationFailure) {
              showLocationProblem(
                context,
                context.read<LocationService>(),
                state.problem,
              );
            }
          },
          builder: (context, state) {
            final current = state is LocationSuccess ? state.fix : null;
            final isLoading = state is LocationLoading;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const _SectionTitle('Адрес доставки'),
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settings) => Text(
                    settings.deliveryPoint == null
                        ? 'Ещё не выбран'
                        : '${settings.deliveryPoint!.shortText} '
                              '(± ${settings.deliveryPoint!.accuracy.toStringAsFixed(0)} м)',
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionTitle('Моё местоположение'),
                LocationPanel(fix: current, isLoading: isLoading),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: isLoading
                      ? null
                      : context.read<LocationCubit>().fetch,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Fetch Current GPS Location'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: current == null
                      ? null
                      : () {
                          context.read<SettingsCubit>().updateDeliveryPoint(
                            current,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Точка доставки сохранена'),
                            ),
                          );
                        },
                  icon: const Icon(Icons.local_shipping_outlined),
                  label: const Text('Доставить сюда'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}
