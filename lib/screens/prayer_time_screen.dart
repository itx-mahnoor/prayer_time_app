import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  TextEditingController _cityController = TextEditingController();
  PrayerTime time = PrayerTime();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getPrayerTime() async {
    String cityName = _cityController.text.trim();
    if (cityName.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    http.Response response =
        await http.get(Uri.parse("https://dailyprayer.abdulrcs.repl.co/api/$cityName"));
    print(response.statusCode);
    print(response.body);

    setState(() {
      _isLoading = false;
      time = PrayerTime.fromJson(jsonDecode(response.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/bg.png"), fit: BoxFit.cover)),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            ),
            child: TextField(
              controller: _cityController,
              onChanged: (value) {
                
              },
              onSubmitted: (value) {
                getPrayerTime();
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter City Name",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${time.city}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${time.date}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    _timeCard("Fajr", "${time.today?.fajr}"),
                    _timeCard("Sunrise", "${time.today?.sunrise}"),
                    _timeCard("Dhuhr", "${time.today?.dhuhr}"),
                    _timeCard("Asr", "${time.today?.asr}"),
                    _timeCard("Maghrib", "${time.today?.maghrib}"),
                    _timeCard("Ishak", "${time.today?.ishaA}"),
                  ],
                ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Widget _timeCard(String name, String time) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.4)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 25,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ]),
    );
  }
}
