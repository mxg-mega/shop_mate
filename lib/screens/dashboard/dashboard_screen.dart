import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Overview',
                // style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                //   fontWeight: FontWeight.bold,
                //),
                style: ShadTheme.of(context).textTheme.h2,
              ),
              SizedBox(height: 24.h),

              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16.w,
                childAspectRatio: 1.5,
                children: [
                  StatCard(
                    title: 'Total Revenue',
                    value: '₦2.45M',
                    percentage: 12.5,
                    isPositive: true,
                  ),
                  StatCard(
                    title: 'Total Orders',
                    value: '1,234',
                    percentage: 8.2,
                    isPositive: true,
                  ),
                  StatCard(
                    title: 'Products',
                    value: '456',
                    percentage: -2.3,
                    isPositive: false,
                  ),
                  StatCard(
                    title: 'Active Users',
                    value: '892',
                    percentage: 5.7,
                    isPositive: true,
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Sales Chart
              Container(
                height: 300.h,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Expanded(
                      child: LineChart(
                        _getSalesData(context),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Recent Orders
              _RecentOrders(),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _getSalesData(BuildContext context) {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
              if (value.toInt() < months.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(months[value.toInt()]),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 2.5),
            FlSpot(1, 2.8),
            FlSpot(2, 2.3),
            FlSpot(3, 3.2),
            FlSpot(4, 3.5),
            FlSpot(5, 3.9),
          ],
          isCurved: true,
          color: Theme.of(context).primaryColor,
          barWidth: 3,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double percentage;
  final bool isPositive;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      title: Text(title, style: ShadTheme.of(context).textTheme.p,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Perimeter(height: 1,),
          Text(
            value,
            style: ShadTheme.of(context).textTheme.h2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              SizedBox(width: 4.w),
              Text(
                '${percentage.abs()}%',
                overflow: TextOverflow.ellipsis,
                style: ShadTheme.of(context).textTheme.p.copyWith(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Orders',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _OrderItem();
            },
          ),
        ],
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #1234',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'John Doe • 2 items',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦45,670',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '2 mins ago',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}