class FreqWindow{

  float _x;
  float _y;
  float _sizeX;
  float _sizeY; 
  float _sampleMin;
  float _sampleMax;
  float _sampleMultiplier;
  float _maxPower;
  int _bins;
  String _name;
  String _xName;
  String _yName;
  float _samplingRate;
  Boolean autoPower = false;
  
  FreqWindow(float xpos, float ypos, float sizeX, float sizeY, float sampleMin, float sampleMax, float maxPower, int bins,String name, String xName , String yName, float SamplingRate){
  
    _x = xpos;
    _y = ypos;  
   _sizeX = sizeX;
   _sizeY = sizeY;
   _sampleMin = sampleMin;
   _sampleMax = sampleMax;
   _sampleMultiplier = (_sampleMax - _sampleMin) / bins;
   _bins = bins;
   _maxPower = maxPower;
    _name = name;
   _xName= xName;
   _yName = yName;
   _samplingRate = SamplingRate;
   
  }
  
  void drawWindow() {   
    
   
    fill(185);
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
      int frequency = round( (float(i)/10 ) * _samplingRate);
      text( frequency,_x + (_xMultiplier *i), _y + _sizeY + 25);
      
    }
    
    float yTextMulti = _maxPower/  10;
    
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
  
  void calcBins(float[] dataArray){
    
     if(autoPower == true){
     _maxPower = maxValue(dataArray, dataArray.length);
      _maxPower =  _maxPower + ( _maxPower*0.1);
    }
    
    _bins = dataArray.length;
    _sampleMax = dataArray.length;
    float _xMultiplier = _sizeX/_bins;
    
    for(int i =0 ; i< dataArray.length; i++){
      
    stroke(255,0,0);
    strokeWeight(3);
    
    line( _x + (_xMultiplier *i)+3, _y + _sizeY, _x + (_xMultiplier *i)+3, _y + _sizeY -( (dataArray[i] / _maxPower ) * _sizeY) );
    
    }
    
  }
  
}