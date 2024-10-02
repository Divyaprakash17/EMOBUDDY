import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SentimentTrendPage extends StatelessWidget {
  final List<Map<String, dynamic>> sentimentHistory;

  const SentimentTrendPage({Key? key, required this.sentimentHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging: Check the sentiment history length
    print("Sentiment History: $sentimentHistory");

    if (sentimentHistory.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sentiment Trend', style: TextStyle(fontFamily: 'Poppins')),
        ),
        body: const Center(
          child: Text('No data available', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    final minY = sentimentHistory
        .map((e) => e['total_sentiment'] as double)
        .reduce((a, b) => a < b ? a : b);
    final maxY = sentimentHistory
        .map((e) => e['total_sentiment'] as double)
        .reduce((a, b) => a > b ? a : b);

    // Calculate interval and ensure it's not zero
    final double calculatedInterval = (maxY - minY) / 5;
    final double safeInterval = calculatedInterval == 0 ? 1 : calculatedInterval;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentiment Trend', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Line Chart Section
              const Text(
                'Line Chart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Sentimental Value',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        axisNameSize: 30,
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: safeInterval, // Use safeInterval
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Chats',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        axisNameSize: 30,
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              'Chat ${value.toInt() + 1}', // X-axis label for each chat
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    minX: 0,
                    maxX: sentimentHistory.length.toDouble() - 1,
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          sentimentHistory.length,
                              (index) => FlSpot(
                            index.toDouble(),
                            sentimentHistory[index]['total_sentiment'],
                          ),
                        ),
                        isCurved: true,
                        barWidth: 2,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bar Chart Section
              const Text(
                'Bar Chart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Sentimental Value',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        axisNameSize: 30,
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: safeInterval, // Use safeInterval
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Chats',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        axisNameSize: 30,
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              'Chat ${value.toInt() + 1}', // X-axis label for each chat
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    minY: minY,
                    maxY: maxY,
                    barGroups: List.generate(
                      sentimentHistory.length,
                          (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: sentimentHistory[index]['total_sentiment'],
                              color: Colors.blue,
                              width: 15,
                              borderRadius: BorderRadius.zero,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
