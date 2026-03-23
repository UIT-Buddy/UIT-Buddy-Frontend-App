import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/weather_entity.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/weather_bloc.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/weather_event.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/weather_state.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Returns a Material icon that matches the OpenWeatherMap icon code.
/// Day: 01d→sun, 02d→partly cloudy, 03/04d→cloudy, 09/10d→rain, 11d→storm, 13d→snow, 50d→fog
/// Night variants follow the same pattern.
IconData _owmIcon(String code) {
  switch (code.substring(0, 2)) {
    case '01':
      return Icons.wb_sunny_rounded;
    case '02':
      return Icons.wb_cloudy;
    case '03':
    case '04':
      return Icons.cloud;
    case '09':
    case '10':
      return Icons.grain;
    case '11':
      return Icons.thunderstorm;
    case '13':
      return Icons.ac_unit;
    case '50':
      return Icons.foggy;
    default:
      return Icons.wb_sunny_rounded;
  }
}

bool _isRainCode(String code) {
  final prefix = code.substring(0, 2);
  return prefix == '09' || prefix == '10' || prefix == '11';
}

String _formatHour(int dt) {
  final d = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
  return DateFormat('HH:mm').format(d);
}

String _formatDay(int dt) {
  final d = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
  final now = DateTime.now();
  if (d.year == now.year && d.month == now.month && d.day == now.day) {
    return 'Today';
  }
  return DateFormat('EEE').format(d);
}

// ─── Colors ───────────────────────────────────────────────────────────────────

const _gradientTop = Color(0xFF4DA8E8);
const _gradientMid = Color(0xFF2272C3);
const _gradientBot = Color(0xFF1B3A6B);
final _glass = Colors.white.withValues(alpha: 0.15);
final _glassBorder = Colors.white.withValues(alpha: 0.30);
final _glassText = Colors.white.withValues(alpha: 0.75);
final _rainBlue = const Color(0xFF64B5F6).withValues(alpha: 0.9);

// ─── Screen ───────────────────────────────────────────────────────────────────

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<WeatherBloc>()..add(const WeatherFetched()),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientTop, _gradientMid, _gradientBot],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state.status == WeatherStatus.loading ||
                    state.status == WeatherStatus.initial) {
                  return _buildLoading(context);
                }
                if (state.status == WeatherStatus.failure) {
                  return _buildError(context, state.errorMessage);
                }
                return _WeatherContent(weather: state.weather!);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(context, onRefresh: null),
        const Expanded(
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return Column(
      children: [
        _buildTopBar(
          context,
          onRefresh: () =>
              context.read<WeatherBloc>().add(const WeatherFetched()),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.white54,
                    size: 56,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message ?? 'Failed to load weather',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () =>
                        context.read<WeatherBloc>().add(const WeatherFetched()),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(
    BuildContext context, {
    required VoidCallback? onRefresh,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _GlassButton(
            onTap: () => context.goBack(RouteName.home),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const Spacer(),
          if (onRefresh != null)
            _GlassButton(
              onTap: onRefresh,
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Content (loaded state) ───────────────────────────────────────────────────

class _WeatherContent extends StatefulWidget {
  const _WeatherContent({required this.weather});
  final WeatherEntity weather;

  @override
  State<_WeatherContent> createState() => _WeatherContentState();
}

class _WeatherContentState extends State<_WeatherContent> {
  int? _selectedHourlyIndex;

  @override
  Widget build(BuildContext context) {
    final current = widget.weather.current;
    final hourly = widget.weather.hourly.take(24).toList();
    final daily = widget.weather.daily.take(7).toList();

    // Derive hero data from selected hourly or current
    final double heroTemp;
    final double heroFeelsLike;
    final List<WeatherConditionEntity> heroWeather;
    if (_selectedHourlyIndex != null) {
      final h = hourly[_selectedHourlyIndex!];
      heroTemp = h.temp;
      heroFeelsLike = h.feelsLike;
      heroWeather = h.weather;
    } else {
      heroTemp = current.temp;
      heroFeelsLike = current.feelsLike;
      heroWeather = current.weather;
    }

    final condition = heroWeather.isNotEmpty ? heroWeather.first : null;
    final icon = condition != null
        ? _owmIcon(condition.icon)
        : Icons.wb_sunny_rounded;
    final isRain = condition != null ? _isRainCode(condition.icon) : false;
    final updatedAt = DateFormat(
      'HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(current.dt * 1000));

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context, updatedAt)),
        SliverToBoxAdapter(
          child: _buildHero(heroTemp, heroFeelsLike, icon, isRain, condition),
        ),
        SliverToBoxAdapter(
          child: _buildStatsRow(
            current,
            hourly.isNotEmpty ? hourly.first.pop : 0.0,
          ),
        ),
        SliverToBoxAdapter(child: _buildHourlySection(hourly)),
        SliverToBoxAdapter(child: _buildDailySection(daily)),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String updatedAt) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _GlassButton(
            onTap: () => context.goBack(RouteName.home),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Thủ Đức", //_locationName(weather.timezone),
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTextStyle.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Updated $updatedAt',
                style: AppTextStyle.captionMedium.copyWith(color: _glassText),
              ),
            ],
          ),
          const SizedBox(width: 12),
          _GlassButton(
            onTap: () =>
                context.read<WeatherBloc>().add(const WeatherFetched()),
            child: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(
    double temp,
    double feelsLike,
    IconData icon,
    bool isRain,
    WeatherConditionEntity? condition,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _glass,
              border: Border.all(color: _glassBorder, width: 1.5),
            ),
            child: Icon(
              icon,
              color: isRain ? const Color(0xFF64B5F6) : const Color(0xFFFFD600),
              size: 64,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${temp.round()}°',
            style: AppTextStyle.heroNumber.copyWith(
              fontSize: 90,
              fontWeight: AppTextStyle.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            condition?.description ?? '',
            style: AppTextStyle.h4.copyWith(
              color: Colors.white,
              fontWeight: AppTextStyle.medium,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _glass,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _glassBorder),
            ),
            child: Text(
              'Feel like ${feelsLike.round()}°C  ·  UIT - VNU HCM',
              style: AppTextStyle.captionLarge.copyWith(color: _glassText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(CurrentWeatherEntity current, double rainPop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatCard(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '${current.humidity}%',
            iconColor: const Color(0xFF64B5F6),
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.air_rounded,
            label: 'Wind',
            value: '${current.windSpeed.toStringAsFixed(1)} m/s',
            iconColor: const Color(0xFF80DEEA),
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.cloud_outlined,
            label: 'Cloud',
            value: '${current.clouds}%',
            iconColor: const Color(0xFFB0BEC5),
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.umbrella_outlined,
            label: 'Rain',
            value: '${(rainPop * 100).round()}%',
            iconColor: const Color(0xFF64B5F6),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlySection(List<HourlyWeatherEntity> hourly) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: _GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'HOURLY FORECAST',
                  style: AppTextStyle.captionSmall.copyWith(
                    color: _glassText,
                    fontWeight: AppTextStyle.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 88,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: hourly.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (_, i) => _HourlyItem(
                  entry: hourly[i],
                  isFirst: i == 0,
                  isSelected:
                      _selectedHourlyIndex == i ||
                      (_selectedHourlyIndex == null && i == 0),
                  onTap: () => setState(
                    () => _selectedHourlyIndex = _selectedHourlyIndex == i
                        ? null
                        : i,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySection(List<DailyWeatherEntity> daily) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: _GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  '7-DAY FORECAST',
                  style: AppTextStyle.captionSmall.copyWith(
                    color: _glassText,
                    fontWeight: AppTextStyle.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...List.generate(daily.length, (i) {
              final isLast = i == daily.length - 1;
              return Column(
                children: [
                  _DailyRow(entry: daily[i]),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Glass Widgets ─────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _glass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _glassBorder, width: 1),
      ),
      child: child,
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _glass,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: _glassBorder),
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: _glass,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _glassBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyle.captionLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTextStyle.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyle.captionExtraSmall.copyWith(color: _glassText),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hourly Item ──────────────────────────────────────────────────────────────

class _HourlyItem extends StatelessWidget {
  const _HourlyItem({
    required this.entry,
    required this.isFirst,
    required this.isSelected,
    required this.onTap,
  });
  final HourlyWeatherEntity entry;
  final bool isFirst;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = entry.weather.isNotEmpty
        ? _owmIcon(entry.weather.first.icon)
        : Icons.wb_sunny_rounded;
    final isRain =
        entry.weather.isNotEmpty && _isRainCode(entry.weather.first.icon);
    final label = isFirst ? 'Now' : _formatHour(entry.dt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: Colors.white.withValues(alpha: 0.5))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              label,
              style: AppTextStyle.captionExtraSmall.copyWith(
                color: isSelected ? Colors.white : _glassText,
                fontWeight: isSelected
                    ? AppTextStyle.bold
                    : AppTextStyle.regular,
              ),
            ),
            Icon(
              icon,
              color: isRain ? _rainBlue : const Color(0xFFFFD600),
              size: 22,
            ),
            Text(
              '${entry.temp.round()}°',
              style: AppTextStyle.captionLarge.copyWith(
                color: Colors.white,
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Daily Row ────────────────────────────────────────────────────────────────

class _DailyRow extends StatelessWidget {
  const _DailyRow({required this.entry});
  final DailyWeatherEntity entry;

  @override
  Widget build(BuildContext context) {
    final condition = entry.weather.isNotEmpty ? entry.weather.first : null;
    final icon = condition != null
        ? _owmIcon(condition.icon)
        : Icons.wb_sunny_rounded;
    final isRain = condition != null && _isRainCode(condition.icon);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            child: Text(
              _formatDay(entry.dt),
              style: AppTextStyle.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ),
          Icon(
            icon,
            color: isRain ? _rainBlue : const Color(0xFFFFD600),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              condition?.description ?? '',
              style: AppTextStyle.captionLarge.copyWith(color: _glassText),
            ),
          ),
          _TempBar(high: entry.temp.max, low: entry.temp.min),
          const SizedBox(width: 10),
          SizedBox(
            width: 30,
            child: Text(
              '${entry.temp.max.round()}°',
              textAlign: TextAlign.end,
              style: AppTextStyle.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: AppTextStyle.bold,
              ),
            ),
          ),
          Text(
            ' / ',
            style: AppTextStyle.captionMedium.copyWith(color: _glassText),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${entry.temp.min.round()}°',
              style: AppTextStyle.captionLarge.copyWith(color: _glassText),
            ),
          ),
        ],
      ),
    );
  }
}

class _TempBar extends StatelessWidget {
  const _TempBar({required this.high, required this.low});
  final double high;
  final double low;

  @override
  Widget build(BuildContext context) {
    const globalMin = 22.0;
    const globalMax = 40.0;
    final start = ((low - globalMin) / (globalMax - globalMin)).clamp(0.0, 1.0);
    final end = ((high - globalMin) / (globalMax - globalMin)).clamp(0.0, 1.0);
    final fraction = (end - start).clamp(0.01, 1.0);

    return SizedBox(
      width: 56,
      height: 5,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          FractionallySizedBox(
            widthFactor: fraction,
            alignment: Alignment.centerLeft,
            child: FractionalTranslation(
              translation: Offset(start / fraction, 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFFFFD600)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
