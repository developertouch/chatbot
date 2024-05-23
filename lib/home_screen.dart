import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import 'model.dart';
class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  TextEditingController promptController = TextEditingController();
  static const apiKey='AIzaSyBG-nSXx31H7Of1JzXgWSBxCmY6TAX2qo0';
  final model= GenerativeModel(model: "gemini-pro", apiKey: apiKey);

  final List<ModelMessage> prompt=[];


  Future<void> SendMessage() async{
    final message = promptController.text;
    // for prompt
    setState(() {
      promptController.clear();
      prompt.add(ModelMessage(isPrompt: true, message: message, time: DateTime.now(),
      ),
      );
    });
  //   for response
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      prompt.add(ModelMessage(isPrompt: false, message: response.text ??"", time: DateTime.now(),
      ),
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ChatBot"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 3,
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
              itemCount:prompt.length ,
              itemBuilder: (context,index){
                final message=prompt[index];
            return UserPrompt(isPrompt: message.isPrompt, message: message.message, date: DateFormat('hh:mm a').format(message.time));
          }
          ),),
          Padding(padding:EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  flex: 20,
                  child: TextField(
                    controller: promptController,
                  textAlign: TextAlign.center,
                  onTapOutside: (e) => FocusScope.of(context).unfocus(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),

                    ),
                    hintText: "Ask me anything you want... ",
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    SendMessage();
                  },
                  child: CircleAvatar(
                    radius: 29,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.send,color: Colors.white,size: 32,),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container UserPrompt({required final bool isPrompt, required String message, required String date}) {
    return Container(

      decoration: BoxDecoration(
        color: isPrompt ? Colors.white : Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isPrompt ? Radius.circular(20):Radius.zero,
           bottomRight: isPrompt ? Radius.zero:Radius.circular(20),
        ),
      ),
            width: double.infinity,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 15).copyWith(left: isPrompt ?80:15,right: isPrompt ?15:80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // for prompt and response
                Text(message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontWeight:isPrompt?FontWeight.normal:FontWeight.bold,
                fontSize:18,
                  color: isPrompt ? Colors.black:Colors.black,
                ),
                ),
              //   for prompt and response time
                Text(
                date,
                  style: TextStyle(

                  fontSize:15,
                  color: isPrompt ? Colors.black:Colors.black,
                ),
                ),
              ],
            ),
          );
  }
}
