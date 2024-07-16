import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import 'global.dart';
import 'model.dart';
class Home_Screen extends StatefulWidget {

  const Home_Screen({super.key});
  

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  }
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

    mq = MediaQuery.sizeOf(context);
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Ask Me",style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 3,
      ),
      body: Column(
        children: [

          SizedBox(height: 10,),
          // Row(
          //   children: [
          //     Image.asset('assets/images/logo 1.png',width: 35,),
          //     Container(
          //       constraints: BoxConstraints(
          //           maxWidth: mq.width * .6
          //       ),
          //       margin: EdgeInsets.only(
          //           bottom: mq.height * .02, left: mq.width *.02
          //       ),
          //       padding: EdgeInsets.symmetric(
          //         vertical: mq.height * .01, horizontal: mq.width *.02,
          //       ),
          //       decoration: BoxDecoration(
          //           border: Border.all(color: Colors.black),
          //           borderRadius: BorderRadius.circular(20)),
          //       child: AnimatedTextKit(
          //         animatedTexts: [
          //           TypewriterAnimatedText(
          //             'Hello, How Can I Help You',
          //             textStyle: const TextStyle(
          //               fontSize: 15.0,
          //               fontWeight: FontWeight.bold,
          //             ),
          //             speed: const Duration(milliseconds: 200),
          //           ),
          //         ],
          //
          //         totalRepeatCount: 1,
          //         pause: const Duration(milliseconds: 1000),
          //         displayFullTextOnTap: true,
          //         stopPauseOnTap: true,
          //       ),
          //
          //     ),
          //   ],
          // ),
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
                  textAlign: TextAlign.start,
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
          SizedBox(height: 20,),
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
                // AnimatedTextKit(
                //   animatedTexts: [
                //     TypewriterAnimatedText(
                //       message,
                //       textStyle: const TextStyle(
                //         fontSize: 18.0,
                //         fontWeight: FontWeight.bold,
                //       ),
                //       speed: const Duration(milliseconds: 50),
                //     ),
                //   ],
                //
                //   totalRepeatCount: 1,
                //   pause: const Duration(milliseconds: 1000),
                //   displayFullTextOnTap: true,
                //   stopPauseOnTap: true,
                // ),

                InkWell(
                  onLongPress: (){
                    FlutterClipboard.copy(message).then(( value ) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Text copied",style: TextStyle(
                        color: Colors.white,

                      ),),backgroundColor: Colors.black,
                      ),
                      );

                    });
                  },
                  child: Text(message,
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                    fontWeight:isPrompt?FontWeight.normal:FontWeight.bold,
                  fontSize:15,
                    color: isPrompt ? Colors.black:Colors.black,
                  ),
                  ),
                ),
              //   for prompt and response time
                Text(
                date,
                  style: TextStyle(

                  fontSize:13,
                  color: isPrompt ? Colors.black:Colors.black,
                ),
                ),
              ],
            ),
          );
  }
}
