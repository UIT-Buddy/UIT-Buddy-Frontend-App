import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

// ─── Mock data ────────────────────────────────────────────────────────────────

class _HourlyEntry {
  const _HourlyEntry(this.time, this.icon, this.temp, this.isRain);
  final String time;
  final IconData icon;
  final int temp;
  final bool isRain;
}

class _DailyEntry {
  const _DailyEntry(this.day, this.icon, this.condition, this.high, this.low);
  final String day;
  final IconData icon;
  final String condition;
  final int high;
  final int low;
}

const _hourly = [
  _HourlyEntry('Now', Icons.wb_sunny_rounded, 35, false),
  _HourlyEntry('11:00', Icons.wb_sunny_rounded, 36, false),
  _HourlyEntry('12:00', Icons.wb_sunny_rounded, 37, false),
  _HourlyEntry('13:00', Icons.wb_cloudy, 37, false),
  _HourlyEntry('14:00', Icons.cloud, 36, false),
  _HourlyEntry('15:00', Icons.grain, 34, true),
  _HourlyEntry('16:00', Icons.grain, 32, true),
  _HourlyEntry('17:00', Icons.wb_cloudy, 31, false),
];

const _daily = [
  _DailyEntry('Today', Icons.wb_sunny_rounded, 'Sunny', 35, 27),
  _DailyEntry('Thu', Icons.wb_cloudy, 'Partly Cloudy', 33, 26),
  _DailyEntry('Fri', Icons.grain, 'Rainy', 31, 25),
  _DailyEntry('Sat', Icons.wb_cloudy, 'Partly Cloudy', 32, 25),
  _DailyEntry('Sun', Icons.wb_sunny_rounded, 'Sunny', 34, 26),
  _DailyEntry('Mon', Icons.wb_sunny_rounded, 'Sunny', 35, 27),
  _DailyEntry('Tue', Icons.wb_sunny_rounded, 'Sunny', 36, 28),
];

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientTop, _gradientMid, _gradientBot],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(child: _buildHero()),
              SliverToBoxAdapter(child: _buildStatsRow()),
              SliverToBoxAdapter(child: _buildHourlySection()),
              SliverToBoxAdapter(child: _buildDailySection()),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                    'Ho Chi Minh City',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTextStyle.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Updated 10:30 AM',
                style: AppTextStyle.captionMedium.copyWith(color: _glassText),
              ),
            ],
          ),
          const SizedBox(width: 12),
          _GlassButton(
            onTap: () {},
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

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          // Weather icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _glass,
              border: Border.all(color: _glassBorder, width: 1.5),
            ),
            child: const Icon(
              Icons.wb_sunny_rounded,
              color: Color(0xFFFFD600),
              size: 64,
            ),
          ),
          const SizedBox(height: 20),
          // Temperature
          Text(
            '35°',
            style: AppTextStyle.heroNumber.copyWith(
              fontSize: 90,
              fontWeight: AppTextStyle.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          // Condition
          Text(
            'Partly Cloudy',
            style: AppTextStyle.h4.copyWith(
              color: Colors.white,
              fontWeight: AppTextStyle.medium,
            ),
          ),
          const SizedBox(height: 8),
          // Feels like
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _glass,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _glassBorder),
            ),
            child: Text(
              'Feels like 39°  ·  Thu Duc, UIT',
              style: AppTextStyle.captionLarge.copyWith(color: _glassText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatCard(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '78%',
            iconColor: const Color(0xFF64B5F6),
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.air_rounded,
            label: 'Wind',
            value: '12 km/h',
            iconColor: const Color(0xFF80DEEA),
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.wb_sunny_outlined,
            label: 'UV Index',
            value: '8 High',
            iconColor: const Color(0xFFFFD600),
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.visibility_outlined,
            label: 'Visibility',
            value: '10 km',
            iconColor: const Color(0xFFA5D6A7),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlySection() {
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
                itemCount: _hourly.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (_, i) => _HourlyItem(entry: _hourly[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySection() {
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
            ...List.generate(_daily.length, (i) {
              final isLast = i == _daily.length - 1;
              return Column(
                children: [
                  _DailyRow(entry: _daily[i]),
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
  const _HourlyItem({required this.entry});
  final _HourlyEntry entry;

  @override
  Widget build(BuildContext context) {
    final highlight = entry.time == 'Now';
    return Container(
      width: 58,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.white.withValues(alpha: 0.25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: highlight
            ? Border.all(color: Colors.white.withValues(alpha: 0.5))
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            entry.time,
            style: AppTextStyle.captionExtraSmall.copyWith(
              color: highlight ? Colors.white : _glassText,
              fontWeight: highlight ? AppTextStyle.bold : AppTextStyle.regular,
            ),
          ),
          Icon(
            entry.icon,
            color: entry.isRain ? _rainBlue : const Color(0xFFFFD600),
            size: 22,
          ),
          Text(
            '${entry.temp}°',
            style: AppTextStyle.captionLarge.copyWith(
              color: Colors.white,
              fontWeight: AppTextStyle.medium,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Daily Row ────────────────────────────────────────────────────────────────

class _DailyRow extends StatelessWidget {
  const _DailyRow({required this.entry});
  final _DailyEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            child: Text(
              entry.day,
              style: AppTextStyle.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ),
          Icon(
            entry.icon,
            color: entry.icon == Icons.grain
                ? _rainBlue
                : const Color(0xFFFFD600),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              entry.condition,
              style: AppTextStyle.captionLarge.copyWith(color: _glassText),
            ),
          ),
          // Temp bar
          _TempBar(high: entry.high, low: entry.low),
          const SizedBox(width: 10),
          SizedBox(
            width: 30,
            child: Text(
              '${entry.high}°',
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
              '${entry.low}°',
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
  final int high;
  final int low;

  @override
  Widget build(BuildContext context) {
    const globalMin = 25.0;
    const globalMax = 37.0;
    final start = (low - globalMin) / (globalMax - globalMin);
    final end = (high - globalMin) / (globalMax - globalMin);

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
            widthFactor: end - start,
            alignment: Alignment.centerLeft,
            child: FractionalTranslation(
              translation: Offset(start / (end - start), 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF64B5F6), const Color(0xFFFFD600)],
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
