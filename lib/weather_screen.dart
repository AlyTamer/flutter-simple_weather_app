import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';

import 'hourly_forecast.dart';
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

  class _WeatherScreenState extends State<WeatherScreen>{
  double temp=-99.9;

    late Future<Map<String,dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    final url = Uri.parse(
        "http://api.openweathermap.org/data/2.5/forecast?q=Cairo,eg&APPID=$apikey&units=metric"
    );

    final res = await http.get(url);


    debugPrint("HTTP ${res.statusCode} → ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("HTTP ${res.statusCode}: ${res.reasonPhrase}");
    }


    dynamic raw;
    try {
      raw = jsonDecode(res.body);
    } on FormatException catch (e) {
      throw Exception("JSON parse error: ${e.message}\nBody was: ${res.body}");
    }


    if (raw == null) {
      throw Exception("Decoded JSON was null! Body: ${res.body}");
    }


    if (raw is! Map<String, dynamic>) {
      throw Exception(
          "Expected JSON object, but got ${raw.runtimeType}:\n$raw"
      );
    }

    return raw;
  }

  @override
  void initState() {
    super.initState();
    weather=getCurrentWeather();
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text("Weather App"),
  centerTitle: true,
  actions: [
  IconButton(onPressed: (){
  setState(() {
    weather=getCurrentWeather();
  });
  }, icon: Icon(Icons.refresh)
  )
  ],
  ),
  body: FutureBuilder(
    future: weather,
    builder:(context,snapshot){
    print(snapshot);
    if(snapshot.connectionState==ConnectionState.waiting){
    return Center(child: const CircularProgressIndicator());
    }
     if(snapshot.hasError){
     return Text(snapshot.error.toString());
    }
    final data = snapshot.data!;
    final currTemp = data['list'][0]['main']['temp'];
    final currSky = data['list'][0]['weather'][0]['main'];
    final press = data['list'][0]['main']['pressure']* 0.0145037738;
    final wSpeed = data['list'][0]['wind']['speed'];
    final humidity = data['list'][0]['main']['humidity'];

    

    return
      Padding(
      padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    //main card
    SizedBox(
    width: double.infinity,
    child: Card(
    elevation: 30,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: ClipRRect(
    borderRadius: BorderRadiusGeometry.circular(24),
    child: BackdropFilter(
    filter:ImageFilter.blur(sigmaX: 10,sigmaY: 10) ,
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    Text("${currTemp} C ",
    style: TextStyle(fontSize: 32,fontWeight:FontWeight.bold),),
    const SizedBox(height: 16,),
    Icon(
      currSky == 'Clouds' || currSky == 'Rain'?Icons.cloud: Icons.sunny,size: 60,),
    const SizedBox(height:16), Text("$currSky",style: TextStyle(fontSize: 24),),
    ],
    ),
    ),
    ),
    ),
    )
    ),
    const SizedBox(height: 30),
    //weather cards
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
    alignment: Alignment.centerLeft,
    child: const Text(
    "Hourly Forecast:",
    style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
    ),
    ),
    ),
    const SizedBox(height: 8),
     SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
    children: [
      for(int i=1;i<31;i++)
        HourlyForecast(
          time: DateFormat.j().format(DateTime.parse( data['list'][i]['dt_txt'])),
          icon: data['list'][i]['weather'][0]['main']== 'Clouds' || data['list'][i]['weather'][0]['main']=='Rain'? Icons.cloud:Icons.sunny,
          temp: "${data['list'][i]['main']['temp'].toString()} C",
    ),

    ],
    ),
    ),
    const SizedBox(height: 20),
    const Text(
    "Additional Information",
    style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
    children: [
    const Icon(Icons.water_drop,size: 32,),
    const SizedBox(height:8),
    const Text("Humidity"),
    const SizedBox(height:8),
    Text("$humidity%",
    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)

    ],
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
    children: [
    const Icon(Icons.air,size: 32,),
    const SizedBox(height:8),
    const Text("Wind Speed"),
    const SizedBox(height:8),
    Text("$wSpeed KM/H",
    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)

    ],
    ),
    ),
    ],
    )
    ],
    ),
    );
    },
    ),
  );
  }

}



