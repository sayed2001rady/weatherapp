import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:wheather/model/tampmodel.dart';
class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  _home_screenState createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  int temperature = 0;
  int woeid = 0;
  String weather = "heavycloud";
  String city = "City";
  String abbr="hc";
  Future<void> fetchcity(String input) async {
    var url = Uri.parse('https://www.metaweather.com/api/location/search/?query=$input');
    var response = await http.get(url,);
    var responsebody = jsonDecode(response.body)[0];
    setState(() {
      woeid=responsebody["woeid"];
      city=responsebody["title"];
    });

  }
  Future<List<tampmodel>> fetchtemp() async {
    var url = Uri.parse('https://www.metaweather.com/api/location/$woeid/');
    var response = await http.get(url,);
    var responsebody = jsonDecode(response.body)["consolidated_weather"];
    setState(() {
      temperature=responsebody[0]["the_temp"].round();
      weather=responsebody[0]["weather_state_name"].replaceAll(' ','').toLowerCase();
      abbr = responsebody[0]["weather_state_abbr"];
    });
    List<tampmodel>list=[];
    for(var i in responsebody)
    {
      tampmodel x = tampmodel(applicable_date: i["applicable_date"],max_temp: i["max_temp"],min_temp: i["min_temp"],weather_state_abbr: i["weather_state_abbr"],);
      list.add(x);
    }

return list;
  }
  Future<void> ontextfieldsupmite(String input) async {
    await fetchcity(input) ;
    await fetchtemp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/$weather.png"),fit: BoxFit.cover
          )
        ),
        padding: EdgeInsets.only(top: 10),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
          body:  Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Image.network("https://www.metaweather.com/static/img/weather/png/$abbr.png?fbclid=IwAR0c0pR-eT6G8IO7SxZuXmryj8vLK7Iv7XarPApDyXTBMg4rjHTqh31tmmU",width: 100,),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("$temperature",style: TextStyle(color: Colors.white,fontSize: 50),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30,left: 10),
                          child: Text("°C",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text("$city",style: TextStyle(color: Colors.white,fontSize: 40),),
                  ),
                  Container(
                    child: Text("$weather",style: TextStyle(color: Colors.white,fontSize: 35),),
                  ),

                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: TextField(
                      onSubmitted: (String input){
                        ontextfieldsupmite(input);
                      },
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: "search for country weather",
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                  Container(
                    height:  180,
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    child: FutureBuilder(
                      future: fetchtemp(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if(snapshot.hasData)
                        {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  height: 170,
                                  width: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.network("https://www.metaweather.com/static/img/weather/png/${snapshot.data[index].weather_state_abbr}.png?",width: 50,),
                                      Text("min: ${snapshot.data[index].min_temp.round()}",style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
                                      Text("max: ${snapshot.data[index].max_temp.round()}",style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
                                      Text("date: ${snapshot.data[index].applicable_date}",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                              );
                            },);
                        }
                        else{
                          return Text(" ");
                        }

                      },
                    ),
                  )
                ],
              )
            ],
          )
        ),

      ),
    );
  }
}
