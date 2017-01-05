class HistoGram{
  
  float _x;
  float _y;
  float _sizeX;
  float _sizeY; 
  float _sampleMin;
  float _sampleMax;
  float _sampleMultiplier;
  float _maxOccurences;
  int _bins;
  String _name;
  String _xName;
  String _yName;
  int[] _binData;
  float mean;
  float[] _meanStorage = new float[500];
  float sd; //standard deviation
  float[] _sdStorage = new float[500];
  
  HistoGram(float xpos, float ypos, float sizeX, float sizeY, float sampleMin, float sampleMax, float maxOccurences, int bins,String name, String xName , String yName){
  
    _x = xpos;
    _y = ypos;  
   _sizeX = sizeX;
   _sizeY = sizeY;
   _sampleMin = sampleMin;
   _sampleMax = sampleMax;
   _sampleMultiplier = (_sampleMax - _sampleMin) / bins;
   _bins = bins;
   _maxOccurences = maxOccurences;
    _name = name;
   _xName= xName;
   _yName = yName;
   
   _binData = new int[_bins];
   
  }
  
  void drawWindow() {     
    fill(185);
    stroke(100);
    strokeWeight(1);
    rect(_x,_y, _sizeX, _sizeY);
    
    float _xMultiplier = _sizeX/10;
    float _yMultiplier = _sizeY/10;
    float _binMultiplier = (_sampleMax - _sampleMin) / 10;
    
    stroke(100);
    strokeWeight(1);
    for(int i =0; i <= 10; i++){
      line( _x + (_xMultiplier *i), _y, _x + (_xMultiplier *i), _y + _sizeY + 10 );
      
      textSize(10);
      textAlign(CENTER);
      fill(255);
      text( round( ( i * _binMultiplier) + _sampleMin) ,_x + (_xMultiplier *i), _y + _sizeY + 25);
    
    }
    
    float yTextMulti = _maxOccurences/  10;
    
    for(int i =0; i < 10; i++){
      line( _x -10, _y + (_yMultiplier *i), _x + _sizeX, _y + (_yMultiplier *i));
      textSize(10);
      textAlign(RIGHT);
      fill(255);
      text( round( (10-i)*yTextMulti ) ,_x -15, _y + (_yMultiplier *i) + 5 );
    }
    
    textSize(14);
    textAlign(CENTER);
    fill(255);
    text(_name,_x + (_sizeX/2), _y -10);
    
    textSize(14);
    textAlign(CENTER);
    fill(255);
    text(_xName ,_x + (_sizeX/2), _y + _sizeY + 45);
    
  }
  
  void calcBins(float[] data){
    
    for(int i=0; i< _binData.length-1 ; i++){
    
      _binData[i] = 0;
      
    }
    
    for(int i=0; i < data.length; i++){
      
      for(int j =0; j < _binData.length-1; j++){
        
        float calcMinBin = (j*_sampleMultiplier) + _sampleMin;
        float calcMaxBin = ((j+1 )*_sampleMultiplier) + _sampleMin;
        
        if(data[i] >= calcMinBin && data[i] < calcMaxBin){
          _binData[j] = _binData[j]+1;
        }
        
      }
      
    }
    float _xMultiplier = _sizeX/_bins;
    stroke(255,0,0);
    strokeWeight(2);
    for(int i=0; i< _binData.length-1 ; i++){
      line( _x + (_xMultiplier *i), _y + _sizeY, _x + (_xMultiplier *i), _y + _sizeY -( (_binData[i]/_maxOccurences ) * _sizeY) );
    }
    
    //calcmean
    mean =0;
    for(int i=0; i < _binData.length; i++){
      mean = mean + (_binData[i] * ( (_sampleMultiplier*i) + _sampleMin) );
    }
    mean =  mean/data.length;
    
    for (int i = 0; i < _meanStorage.length-1; i++){  
       _meanStorage[i] = _meanStorage[i+1];  
    }
     
    _meanStorage[_meanStorage.length-1] = mean; 
       
    textSize(14);
    textAlign(LEFT);
    fill(255);
    text("μ:" + floor(mean),(((mean-_sampleMin)/ (_sampleMax-_sampleMin)) * _sizeX ) + _x,_y + 45 );
    
    stroke(0,0,200);
    strokeWeight(1);
    line( (((mean-_sampleMin)/ (_sampleMax-_sampleMin)) * _sizeX ) + _x,_y + _sizeY,(((mean-_sampleMin)/ (_sampleMax-_sampleMin)) * _sizeX ) + _x,_y + 50  );
    
    //calc standard deviation
    float variance = 0;
    for(int i=0; i < _binData.length; i++){
      variance = variance + ( _binData[i] * pow( ( (_sampleMultiplier*i) + _sampleMin)- mean, 2));
    }
    variance = variance/data.length;
    sd = sqrt(variance);
    
    for (int i = 0; i < _sdStorage.length-1; i++){  
      _sdStorage[i] = _sdStorage[i+1];  
    }
     
    _sdStorage[_sdStorage.length-1] = sd; 
    
    stroke(0,255,25);
    strokeWeight(1);
    line( ((((mean+sd)-_sampleMin)/ (_sampleMax-_sampleMin)) * _sizeX ) + _x,_y + _sizeY,((((mean+sd)-_sampleMin)/ (_sampleMax-_sampleMin)) * _sizeX ) + _x,_y + 50  );
    
    stroke(0,255,25);
    strokeWeight(1);
    line( ((((mean-sd)-_sampleMin)/ (_sampleMax-_sampleMin)) * _sizeX ) + _x,_y + _sizeY,((((mean-sd)-_sampleMin)/ (_sampleMax-_sampleMin)) * _sizeX ) + _x,_y + 50  );
    
    textSize(14);
    textAlign(RIGHT);
    fill(255);
    text("σ:" + floor(sd),((((mean-sd)-_sampleMin)/ (_sampleMax-_sampleMin)) * _sizeX ) + _x,_y + 45 );
    
    //Bellcurve test
      
   /*float[] yVal = new float[_bins];
   
   for(int i=0; i < _bins ; i++){
     
     float x = (_sampleMultiplier * i) + _sampleMin;
     float firstpart= 1/ (6*sqrt(2 * PI) );
     float secondpart = exp(0.5 * pow((x-mean)/6,2));
     float checkBell = firstpart * secondpart ;
     yVal[i] = checkBell;
   }
   
    stroke(100,50,85);
    strokeWeight(2);
    for(int i=0; i< _bins ; i++){
      line( _x + (_xMultiplier *i), _y + _sizeY, _x + (_xMultiplier *i), _y + _sizeY - ( yVal[i] *_maxOccurences));
    }
    
    for(int i=0; i < yVal.length; i++){
    print(yVal[i]);
    println("-");
    }*/
    
  }
  
  
  void updateSize(float xpos, float ypos, float sizeX, float sizeY){
    _x = xpos;
    _y = ypos;  
   _sizeX = sizeX;
   _sizeY = sizeY;
  }
  
}