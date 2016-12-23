import processing.serial.*;  
PFont font;                  
Serial port;  

GraphWindow PPGGraph;
GraphWindow IBIGraph;
HistoGram HistoGraph;
Attractor AttractorGraph;

relCoordsChecker coordsChecker = new relCoordsChecker();

float checkWindowX;
float checkWindowY;

//SensorData
int IBI;   
float LerpIBI;
float[] PPG;
float[] SmoothIBI;
float IBITimer;
float IBIUpdateTime = 50;

boolean pulse = false; 

void setup() {
  
  size(1280, 720);
  surface.setResizable(true);
  frameRate(60);
  
  checkWindowX = 1280;
  checkWindowY = 720;
  
  coordsChecker.calcCoords(3,3,8,8,"left");
  PPGGraph = new GraphWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 10,12,300, "PPG Signal", "Milliseconds", "Input Signal");
  
  coordsChecker.calcCoords(3,3 ,2,8,"left");
  IBIGraph = new GraphWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 10,10,1, "IBI Signal", "Milliseconds", "Input Signal");
  
  coordsChecker.calcCoords(3,3,8,1.75,"left");
  HistoGraph = new HistoGram(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,700,1200,85,64, "IBI Histogram", "IBI Milliseconds", "Occurences");
  
  coordsChecker.calcCoords(3,3,2,1.75,"left");
  AttractorGraph = new Attractor(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 12,12,"IBIAttractor", "Milliseconds", "Input Signal", 750,1000);
  
  PPG = new float[150];                
  SmoothIBI= new float[200]; 
  for (int i=0; i<150; i++){
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
    PPGGraph.updateDataLine(PPG);
    
    IBIGraph.drawWindow();
    IBIGraph.updateDataLine(SmoothIBI);
    
    HistoGraph.drawWindow();
    HistoGraph.calcBins(SmoothIBI);
    
    AttractorGraph.drawWindow();
    AttractorGraph.updateDataLine( HistoGraph._meanStorage,10,100);
    
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
    
    if(millis()- IBITimer >= IBIUpdateTime){
      IBITimer = millis();
      LerpIBI = lerp(LerpIBI,(float)IBI,0.02 );
      for (int i = 0; i < SmoothIBI.length-1; i++){  
       SmoothIBI[i] = SmoothIBI[i+1];  
       }
     
       SmoothIBI[SmoothIBI.length-1] = lerp(SmoothIBI[0],LerpIBI,0.95); 
     
    }
    
   // println(millis());
   // println(PPG[PPG.length -1]);
}
 