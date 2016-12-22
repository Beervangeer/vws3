import processing.serial.*;  // Serial library makes it possible to talk to Arduino
PFont font;                  // we will use text in this sketch
Serial port;  

GraphWindow PPGGraph;
GraphWindow IBIGraph;
relCoordsChecker coordsChecker = new relCoordsChecker();

float checkWindowX;
float checkWindowY;

//SensorData

int IBI;                 
int[] PPG;
int[] SmoothIBI;
float IBITimer;
float IBIUpdateTime = 42;

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
  IBIGraph = new GraphWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 10,12,300, "IBI Signal", "Milliseconds", "Input Signal");
  
  PPG = new int[150];                
  SmoothIBI= new int[50]; 
  for (int i=0; i<150; i++){
    PPG[i] = 0;             // initialize PPG widow with dataline at midpoint
  }

  // FIND AND ESTABLISH CONTACT WITH THE SERIAL PORT
  println(Serial.list());          // print a list of available serial ports
  port = new Serial(this, Serial.list()[0], 115200); // choose the right COM port and baud rate
  port.bufferUntil('\n');          // arduino will end each data packet with a carriage return 
  port.clear();                    // flush the Serial buffer

}
 
void draw() {
 
    background(125);
    
    textSize(18);
    textAlign(CENTER);
    fill(255);
    text("VIBRATIONAL WAVES SYSTEM",width/2,(height/8)-(height/16)+15);
    
    PPGGraph.drawWindow();
    PPGGraph.updateDataLine(PPG);
    
    IBIGraph.drawWindow();
    IBIGraph.updateDataLine(SmoothIBI);
    
    if(checkWindowX != width || checkWindowY != height){
      println("RESIZED");
      checkWindowX = width;
      checkWindowY = height;
      coordsChecker.calcCoords(4,4,8,8,"left");
      PPGGraph.updateSize(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY);
    }
    
    if(millis()- IBITimer >= IBIUpdateTime){
      IBITimer = millis();
      
      for (int i = 0; i < SmoothIBI.length-1; i++){  
       SmoothIBI[i] = SmoothIBI[i+1];  
       }
     
       SmoothIBI[SmoothIBI.length-1] = (int)lerp(SmoothIBI[0],(float)IBI,0.2);;  
     
    }
    
   // println(millis());
   // println(PPG[PPG.length -1]);
}
 