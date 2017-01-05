import processing.serial.*;  
PFont font;                  
Serial port;  

GraphWindow PPGGraph;
GraphWindow IBIGraph;
HistoGram HistoGraph;
Attractor AttractorGraph;
GraphWindow TestSignalGraph;
FreqWindow DFTGraph;

relCoordsChecker coordsChecker = new relCoordsChecker();

float checkWindowX;
float checkWindowY;

//SensorData
int IBI;   
float LerpIBI;
int[] IBIStorage = new int[10];
float[] PPG;
float[] SmoothIBI;
float IBITimer;
float IBIUpdateTime = 25;

boolean pulse = false; 

void setup() {
  
  size(1280, 720);
  surface.setResizable(true);
  frameRate(60);
  
  checkWindowX = 1280;
  checkWindowY = 720;
  
  coordsChecker.calcCoords(4,3,8,8,"left");
  PPGGraph = new GraphWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 10,12,300, "PPG Signal", "Milliseconds", "Input Signal",100);
  
  coordsChecker.calcCoords(4,3 ,2.3,8,"left");
  IBIGraph = new GraphWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 10,10,1, "IBI Signal", "Milliseconds", "Input Signal",100);
  
  coordsChecker.calcCoords(4,3,8,1.75,"left");
  HistoGraph = new HistoGram(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,500,1200,100,64, "IBI Histogram", "IBI Milliseconds", "Occurences");
  
  coordsChecker.calcCoords(4,3,2.3,1.75,"left");
  AttractorGraph = new Attractor(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 12,12,"IBIAttractor", "Milliseconds", "Input Signal", 600,1200);
  
  coordsChecker.calcCoords(4,3 ,1.35,8,"left");
  TestSignalGraph = new GraphWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 10,4,10, "TestSignal", "Samples", "Input Signal",2);
  
  coordsChecker.calcCoords(4,3 ,1.35,1.75,"left");
  DFTGraph = new FreqWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,0,50,3000,50, "Test DFT", "Frequencies", "Power", 50);
  
  PPG = new float[500];                
  SmoothIBI= new float[1000]; 
  for (int i=0; i<500; i++){
    PPG[i] = 0;            
  }

  println(Serial.list());          
  port = new Serial(this, Serial.list()[0], 115200); 
  port.bufferUntil('\n');         
  port.clear();                    

}
 
void draw() {

    background(125);
    
    textSize(18);
    textAlign(CENTER);
    fill(255);
    text("VIBRATIONAL WAVES SYSTEM",width/2,(height/8)-(height/16)+15);
    
    textSize(12);
    textAlign(CENTER);
    fill(255);
    text("IBI:" + IBI,width/2,(height/8)-(height/16)+35);
    
    PPGGraph.drawWindow();
    float[][] dataArrayPPG = new float[1][];
    dataArrayPPG[0] = PPG;
    PPGGraph.updateDataLine(dataArrayPPG);
    
    IBIGraph.drawWindow();
    float[][] dataArrayIBI = new float[1][];
    dataArrayIBI[0] = SmoothIBI;
    IBIGraph.updateDataLine(dataArrayIBI);
    
    HistoGraph.drawWindow();
    float[] shortenArr = SmoothIBI;
    for(int i=0; i<5; i++){
      shortenArr = shorten(shortenArr);
    }
    HistoGraph.calcBins(shortenArr);
    
    TestSignalGraph.drawWindow();
    float[][] dataArraySignal = new float[12][];
    dataArraySignal[0] = testSignal; 
    //println(testSignal.length + "-" + (testSignal.length/2+1));
   dataArraySignal[1] = invertDFT(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100); 
   dataArraySignal[2] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,7);
   dataArraySignal[3] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,8);
   dataArraySignal[4] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,9);
   dataArraySignal[5] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,10);
   dataArraySignal[6] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,11);
   dataArraySignal[7] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,12);
   dataArraySignal[8] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,13);
   dataArraySignal[9] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,14);
   dataArraySignal[10] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,15);
   dataArraySignal[11] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[1],100,16);
   //dataArraySignal[3] = invertDFTBin(DiscreteFourier(testSignal)[0],DiscreteFourier(testSignal)[2],100,1);
    /*dataArraySignal[1] = CosDFT(testSignal,4)[0];
    dataArraySignal[2] = SinDFT(testSignal,4)[0];
    dataArraySignal[3] = CosDFT(testSignal,4)[1];
    dataArraySignal[4] = SinDFT(testSignal,4)[1];*/
    TestSignalGraph.updateDataLine(dataArraySignal);
     
    AttractorGraph.drawWindow();
    AttractorGraph.updateDataLine( HistoGraph._meanStorage,10,490);
    
    DFTGraph.drawWindow();
    
   // float powerSpectrum = testSignal.length/2;
    
     DFTGraph.calcBins(DiscreteFourier(testSignal)[2]);
    
    if(checkWindowX != width || checkWindowY != height){
      println("RESIZED");
      checkWindowX = width;
      checkWindowY = height;
      coordsChecker.calcCoords(3,3,8,8,"left");
      PPGGraph.updateSize(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY);
      
      coordsChecker.calcCoords(3,3 ,2,8,"left");
      IBIGraph.updateSize(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY);
      
      coordsChecker.calcCoords(3,3,8,1.75,"left");
      HistoGraph.updateSize(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY);
      
    }
    float time = float(millis())/1000;
 
    /*for(float i=0; i < 100; i++){
      testSignal[int(i)] = sin((2*PI)*1*((i*0.01)+time) ) + sin((2*PI)*6*((i*0.01)+time) );
    }*/
   
    for(int i=0; i < 100; i++){
      float test = (SmoothIBI[i*10] - HistoGraph.mean);
      float mapper = (test+HistoGraph.sd)/(HistoGraph.sd*2);
     // testSignal[i] = map( (SmoothIBI[i*5] - HistoGraph.mean), 0-HistoGraph.sd,HistoGraph.sd, -2,2);
     testSignal[i] = test/20;
     // print(map((SmoothIBI[i*5] - HistoGraph.mean), 0-HistoGraph.sdmoothIBI),HistoGraph.sd, -2,2));
    }
    //testSignal = IntrlDecompFlt(testSignal)[1];
   // println();
    
    if(millis()- IBITimer >= IBIUpdateTime){
      IBITimer = millis();
      LerpIBI = lerp(LerpIBI,(float)IBI,0.2 );
      for (int i = SmoothIBI.length-1; i > 0 ; i--){  
       SmoothIBI[i] = SmoothIBI[i-1];  
       }
     
       SmoothIBI[0] = lerp(SmoothIBI[0],LerpIBI,0.02); 
     
    }
    
   // println(millis());
   // println(PPG[PPG.length -1]);
}
 