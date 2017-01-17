import processing.serial.*;  

PFont font;                  
Serial port;  
  


//PPG Windows
GraphWindow   PPGGraph;
HistoGram     PPGHistoGraph;
FreqWindow    PPGSpectrum;
Attractor     PPGAttractorGraph;
PolarWindow  PPGPhases;


//PPG Data
float[] PPG = new float[1024]; //20ms update -> 2048ms
float[][] PPGDFT;
float[] PPGNormalized = new float[256];
float[] PPGPeaks = new float[1024];

//IBI (Heart Rate Variability) Windows
GraphWindow   IBIGraph;
HistoGram     IBIHistoGraph;
FreqWindow    IBISpectrum;
Attractor     IBIAttractorGraph;
PolarWindow   IBIPhases;


//IBI Data
int IBI;   
float LerpIBI;
float[] SmoothIBI = new float[1024]; //25ms update -> 12.8 seconds
float[] IBINormalised = new float[256];
float[][] IBIDFT;



//MayerWave (pressure waves) Windows
GraphWindow   MayerGraph;
HistoGram     MayerHistoGraph;
FreqWindow    MayerSpectrum;
Attractor     MayerAttractorGraph;
PolarWindow  MayerPhases;


//Mayer Wave Data
float Mayer;
float[] MayerSmooth = new float[512];
float LerpMayer;
float[] MayerNormalised = new float[512];
float[][] MayerDFT;

//Graphic Positioning Stuff
relCoordsChecker coordsChecker = new relCoordsChecker();
float checkWindowX;
float checkWindowY;


//Timers
float Timer;
float UpdateTime = 25; //Update IBI and Mayer Smooth Arrays every 25ms /40hrz


void setup() {
  
  //Setup Window
  size(1600 , 960);
  surface.setResizable(true);
  frameRate(100);
  
  checkWindowX = 1600 ;
  checkWindowY = 960;
  
  //Setup Data Windows
  
  //PPG Windows
  coordsChecker.calcCoords(6,10,10,15,"left");
  PPGGraph = new GraphWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 6,6,3.413, "PPG Signal", "Seconds", "Input Signal",80);
  
  coordsChecker.calcCoords(6,10,10,4,"left");
  PPGHistoGraph = new HistoGram(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,200,800,100,64, "PPG Histogram", "IBI Milliseconds", "Occurences");
  PPGHistoGraph.autoPower = true;
  
  coordsChecker.calcCoords(6,10,10,2.3,"left");
  PPGSpectrum = new FreqWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,120,51, "PPG DFT", "Freq Hrz", "Power",10);
  //PPGSpectrum.autoPower = true;
  
  coordsChecker.calcCoords(6,4,10,1.6,"left");
  PPGAttractorGraph = new Attractor(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 6,6,"PPGAttractor", "Milliseconds", "Input Signal", 400,700);
  PPGAttractorGraph.autoPower = true;
  
  coordsChecker.calcCoords(5,5,1.3,2.7,"left");
  PPGPhases = new PolarWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 6,6,"PGPhases", "Amp", "Input Signal",-65,65);
  
  
  //IBI Windows
  coordsChecker.calcCoords(6,10,3,15,"left");
  IBIGraph = new GraphWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,6,6,2.56, "IBI Signal", "Seconds", "Input Signal",50);
  
  coordsChecker.calcCoords(6,10,3,4,"left");
  IBIHistoGraph = new HistoGram(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,500,1300,100,64, "IBI Histogram", "IBI Milliseconds", "Occurences");
  IBIHistoGraph.autoPower = true;
  
  coordsChecker.calcCoords(6,10,3,2.3,"left");
  IBISpectrum = new FreqWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,3000,64, "IBI DFT", "Freq Hrz * 0.1", "Power",10);
  IBISpectrum.autoPower = true;
  
  coordsChecker.calcCoords(6,4,3,1.6,"left");
  IBIAttractorGraph = new Attractor(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 6,6,"IBIAttractor", "Milliseconds", "Input Signal",800,1100);
  IBIAttractorGraph.autoPower = true;
  
  coordsChecker.calcCoords(5,5,1.3,15,"left");
  IBIPhases = new PolarWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 6,6,"IBIPhases", "Amp", "Input Signal",-65,65);
  
  //Mayer Windows
  coordsChecker.calcCoords(6,10,1.75,15,"left");
  MayerGraph = new GraphWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,6,6,2.56, "Mayer Signal", "Seconds", "Input Signal",50);
  
  coordsChecker.calcCoords(6,10,1.75,4,"left");
  MayerHistoGraph = new HistoGram(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,200,800,100,64, "Mayer Histogram", "Mayer Milliseconds", "Occurences");
  MayerHistoGraph.autoPower = true;
  
  coordsChecker.calcCoords(6,10,1.75,2.3,"left");
  MayerSpectrum = new FreqWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY,3000,64, "Mayer DFT", "Freq Hrz * 0.1", "Power",10);
  MayerSpectrum.autoPower = true;
  
  coordsChecker.calcCoords(6,4,1.75,1.6,"left");
  MayerAttractorGraph = new Attractor(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 6,6,"MayerAttractor", "Milliseconds", "Input Signal",520,600);
  MayerAttractorGraph.autoPower = true;
  
  coordsChecker.calcCoords(5,5,1.3,1.5,"left");
  MayerPhases = new PolarWindow(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY, 6,6,"MayerPhases", "Amp", "Input Signal",-65,65);
  
  

  //Check ComPort
  println(Serial.list());          
  port = new Serial(this, Serial.list()[0], 115200); 
  port.bufferUntil('\n');         
  port.clear();                    

}
 
void draw() {

    //Window Title
    background(125);
    
    textSize(14);
    textAlign(CENTER);
    fill(255);
    text("VIBRATIONAL WAVE SYSTEM",width/2,(height/35));
    
   println(frameRate);
  
   updateWindows();
   
    if(millis()- Timer >= UpdateTime){
    
      Timer = millis();
     
      LerpIBI = lerp(LerpIBI,(float)IBI,0.2 );
      for (int i = SmoothIBI.length-1; i > 0 ; i--){  
       SmoothIBI[i] = SmoothIBI[i-1];  
       }
       SmoothIBI[0] = lerp(SmoothIBI[0],LerpIBI,0.02); 
       
      
       LerpMayer = lerp(LerpMayer, Mayer,0.2);
       for (int i = MayerSmooth.length-1; i > 0 ; i--){  
       MayerSmooth[i] = MayerSmooth[i-1];  
       }
       MayerSmooth[0] = lerp(MayerSmooth[0],LerpMayer,0.1); 
    }
 
     //Resize window correction
     if(checkWindowX != width || checkWindowY != height){
      println("RESIZED");
      checkWindowX = width;
      checkWindowY = height;
     /*   IBIGraph.drawWindow();
    coordsChecker.calcCoords(6,6,8,8,"left");
      PPGGraph.updateSize(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY);
      
      coordsChecker.calcCoords(6,6 ,2,8,"left");
      IBIGraph.updateSize(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY);
      
      coordsChecker.calcCoords(6,6,8,1.75,"left");
      HistoGraph.updateSize(coordsChecker._posX, coordsChecker._posY, coordsChecker._sizeX, coordsChecker._sizeY);
      */
    }
  
}
 
void updateWindows(){

   //Draw Realtime Heart Signal
    PPGGraph.drawWindow();
    PPGPeaks = getPeaks(PPG,0.5,2,500);
    float[][] dataArrayPPG = new float[2][];
    dataArrayPPG[0] = PPG;
    dataArrayPPG[1] = PPGPeaks;
    PPGGraph.updateDataLine(dataArrayPPG);
    
    //Histogram of PPG for mean and standard deviation
    PPGHistoGraph.drawWindow();
    PPGHistoGraph.calcBins(PPG);
    
    // PPG Spectrum Calculate
    PPGNormalized= normaliseArray(PPG,PPGHistoGraph,256,4);
    PPGDFT = DiscreteFourier(PPGNormalized);
    PPGSpectrum.drawWindow();
    PPGSpectrum.calcBins(PPGDFT[2],75);
    
    //PPG Attractor
    PPGAttractorGraph.drawWindow();
    PPGAttractorGraph.updateDataLine( PPG,5,100);
    
     //PPGPhases
    PPGPhases.drawWindow();
    int[] bins = new int[74];
     for(int i=0; i < bins.length; i++){
     bins[i] = i+1 ;
     }
    PPGPhases.updateDataLine(PPGDFT[0], PPGDFT[1],bins);
    
    //Draw realtime Smoothed IBI
    IBIGraph.drawWindow();
    float[][] dataArrayIBI = new float[1][];
    dataArrayIBI[0] = SmoothIBI;
    IBIGraph.updateDataLine(dataArrayIBI);
    
    //Histogram of IBI for mean and standard deviation
    IBIHistoGraph.drawWindow();  
    IBIHistoGraph.calcBins(SmoothIBI);
     
    // IBI Spectrum Calculate
    IBINormalised = normaliseArray(SmoothIBI,IBIHistoGraph,256,4);
    IBIDFT = DiscreteFourier(ZeroPadding( blackmanArr(IBINormalised) , 512));
    IBISpectrum.drawWindow();
    IBISpectrum.calcBins(IBIDFT[2],48);
    
    //IBI Attractor
    IBIAttractorGraph.drawWindow();
    IBIAttractorGraph.updateDataLine( SmoothIBI,2,126);
    
    //IBIPhases
    IBIPhases.drawWindow();
     bins = new int[47];
     for(int i=0; i < bins.length; i++){
     bins[i] = i+1 ;
     }
    IBIPhases.updateDataLine(IBIDFT[0], IBIDFT[1],bins);
    
     //Draw realtime Smoothed IBI
    MayerGraph.drawWindow();
    float[][] dataArrayMayer = new float[1][];
    dataArrayMayer[0] = MayerSmooth;
    MayerGraph.updateDataLine(dataArrayMayer);
    
    //Histogram of IBI for mean and standard deviation
    MayerHistoGraph.drawWindow();  
    MayerHistoGraph.calcBins(MayerSmooth);
     
     // IBI Spectrum Calculate
    MayerNormalised = normaliseArray(MayerSmooth,MayerHistoGraph,256,2);
    MayerDFT = DiscreteFourier( blackmanArr(MayerNormalised));
    MayerSpectrum.drawWindow();
    MayerSpectrum.calcBins(MayerDFT[2],48);
    
    //IBI Attractor
    MayerAttractorGraph.drawWindow();
    MayerAttractorGraph.updateDataLine( MayerSmooth,2,126);
    
    MayerPhases.drawWindow();
    bins = new int[47];
     for(int i=0; i < bins.length; i++){
     bins[i] = i+1 ;
     }
    MayerPhases.updateDataLine(MayerDFT[0], MayerDFT[1],bins);
    
    //Mayer Data
    boolean check= false;
    for(int i=0; i< PPGPeaks.length ; i++){
         if(PPGPeaks[i] != 500 && check == false){
           check = true;
           Mayer = PPGPeaks[i];
         }
    }
    
}