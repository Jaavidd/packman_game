import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:packman/ghost.dart';
import 'package:packman/path.dart';
import 'package:packman/pixel.dart';
import 'package:packman/player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow=11;
  int numberOfSquares=numberInRow*17;
  int player=numberInRow*15+1;
  int ghost=20;
  String direction="right";
  bool preGame=true;
  bool mouthClosed=false;
  int score=0;
  var rand=new Random();
  List<bool> directions=[false,false,false,false];
  static List<int> barriers=[
    0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,99,110,121,132,143,
    154,165,176,177,178,179,180,181,182,183,184,185,186,175,164,153,142,
    131,120,109,87,76,65,54,43,32,21,24,35,46,57,26,28,37,38,39,59,70,
    81,81,79,78,61,72,83,84,85,86,100,101,102,103,105,106,107,108,
    114,125,123,134,145,156,158,147,148,149,129,140,151,162,116,127,
    160,30,41,52,63,80
  ];
  List<int> food=[];
  List<int> rest=[];
  void startGame(){
    // for(int i=0;i<100;i++){
    //   barriers.add(rand.nextInt(185));
    // }

    getFood();
    preGame=false;
    Timer.periodic(Duration(milliseconds: 120), (timer) {
      if(ghost==player) ghost=-22;
      setState(() {
        mouthClosed=!mouthClosed;
      });
      if(food.contains(player)){
        food.remove(player);
        score+=1;
        rest.add(player);
      }
      switch(direction){
        case "left":
          moveLeft();
          break;
        case "up":
          moveUp();
          break;
        case "right":
          moveRight();
          break;
        case "down":
          moveDown();
          break;

      }
        moveGhost();
      });
  }
  bool stucked=false;
  void moveGhost(){
    int temp=ghost;
    if (!stucked && !directions[2] && !barriers.contains(ghost - 1)) {
      setState(() {
        ghost--;
      });
      for(int i=0;i<directions.length;i++){
        if(i==0) directions[i]=true;
        else directions[i]=false;
      }
      stucked=false;
    }

    else if ( !directions[1] && !barriers.contains(ghost + numberInRow)) {
      setState(() {
        ghost+=numberInRow;
      });

      for(int i=0;i<directions.length;i++){
        if(i==3) directions[i]=true;
        else directions[i]=false;
      }
      stucked=false;

    }
    else if ( !directions[0] && !barriers.contains(ghost + 1)) {
      setState(() {
        ghost++;
      });

      for(int i=0;i<directions.length;i++){
        if(i==2) directions[i]=true;
        else directions[i]=false;
      }
      stucked=false;

    }

    else if (!directions[3] && !barriers.contains(ghost-numberInRow)) {
      setState(() {
        ghost-=numberInRow;
      });

      for(int i=0;i<directions.length;i++){
        if(i==1) directions[i]=true;
        else directions[i]=false;
      }
      stucked=false;

    }
    if(ghost==temp){
      setState(() {
        ghost+=1;
        stucked=true;

      });
      // else ghost-=1;
    }

  }

  void getFood(){
    for(int index=0;index<numberOfSquares;index++){
        if(!barriers.contains(index)){
          food.add(index);

        }
    }
  }

  updateDirection(direction){
    switch(direction){
      case "left":
        return Transform.rotate(angle: pi,child: MyPlayer());
        break;
      case "right":
        return MyPlayer();
        break;
      case "up":
        return Transform.rotate(angle: 3*pi/2,child: MyPlayer(),);
        break;
      case "down":
        return Transform.rotate(angle: pi/2,child: MyPlayer(),);
        break;
      default: return MyPlayer();
    }
  }
  void moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }
  void moveRight() {
    if(!barriers.contains(player+1)) {
      setState(() {
        player++;
      });

  }}
  void moveUp() {
    if (!barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }
  void moveDown() {
    if (!barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 6,
              child: GestureDetector(
                onVerticalDragUpdate: (details){
                  if(details.delta.dy>0){
                        direction="down";
                  }else if(details.delta.dy<0){
                        direction="up";
                  }
                },
                onHorizontalDragUpdate: (details){
                  if(details.delta.dx>0){
                    direction="right";
                  }else if(details.delta.dx<0){
                    direction="left";
                  }
                },
                child: Container(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                      itemCount: numberOfSquares,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numberInRow),
                      itemBuilder: (BuildContext context,int index){
                    // if(mouthClosed && index==player){
                    //   return Padding(
                    //       padding: EdgeInsets.all(4),
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           color: Colors.yellow,
                    //           shape: BoxShape.circle
                    //         ),
                    //       ),);
                    // }
                        if(player==index){
                        return updateDirection(direction);
                    }else if(index==ghost){
                      return Ghost();
                    }
                    else if(barriers.contains(index)){
                            return MyPixel(innerColor: Colors.blue[800], outerColor: Colors.blue[900],
                            );
                    }else if(preGame || food.contains(index)){
                            return MyPath(innerColor: Colors.yellow, outerColor: Colors.black,);
                        }
                    else{
                      return MyPath(innerColor: Colors.black, outerColor: Colors.black,);

                    }
                      }),
                ),
              )
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Score: "+score.toString(),style: TextStyle(color: Colors.white,fontSize: 40),),
                  GestureDetector(
                      onTap: startGame,
                      child: Text("P L A Y",style: TextStyle(color: Colors.white,fontSize: 40)))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
