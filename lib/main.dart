import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:streammoedas/model.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preço BTC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController<DataModel> _streamController = StreamController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   Timer.periodic(Duration(seconds: 15), (timer) { 

    getCrypto();
   });
  }

  Future<void> getCrypto() async {
    
    
    var url = Uri.parse("https://www.mercadobitcoin.net/api/BTC/ticker/");
    var response = await http.get(url);
    print(response.body);
    final databody = jsonDecode(response.body);


    DataModel dataModel = DataModel.fromJson(databody);
     _streamController.sink.add(dataModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: StreamBuilder<DataModel>(
        stream: _streamController.stream,
        builder: (context, snapshot){
           switch(snapshot.connectionState){
            case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
            default: if(snapshot.hasError){
              return Text("Carregando");
            }else{
              return BuidMoedas(snapshot.data!);
            }
           }
        })),
    );
  

  
  }

  Widget BuidMoedas(DataModel dataModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
              Image.asset("lib/img/mercado.png", height: 100,),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 80, right: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              
              children: [
                
                Row(
                  
                  children: [
          
                  
          
                Text("Oferta:",style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)    ),
                Text( dataModel.buy,
                 style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)  ),  
                
                ],),
          
                Row(
                  
                children: [
                Text("Volume:",style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)    ),
                Text( dataModel.volume,
                 style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)    
              
                ),
          
                ],)
                
              
          
                 
                
          
                
              ],
            ),
          ),
          
        ),
      ],
    );
  }

  

}
