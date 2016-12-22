
class GraphWindow {
 
  float _x;
  float _y;
  float _sizeX;
  float _sizeY;
  
  float _xUnits;
  float _yUnits;
  
  float _sampleTime;
  
  String _name;
  String _xName;
  String _yName;
  
  float _minVal = 0;
  float _maxVal = 1000;
  
  GraphWindow(float xpos, float ypos, float sizeX, float sizeY, float xUnits, float yUnits, float sampleTime, String name, String xName , String yName) {
    _x = xpos;
    _y = ypos;  
   _sizeX = sizeX;
   _sizeY = sizeY;
   _xUnits = xUnits;
   _yUnits = yUnits;
   _sampleTime = sampleTime;
   _name = name;
   _xName= xName;
   _yName = yName;
  }
    
  void drawWindow() {     
    fill(185);
    stroke(100);
    rect(_x,_y, _sizeX, _sizeY);
    
    float _xMultiplier = _sizeX/_xUnits;
    float _yMultiplier = _sizeY/_yUnits;
    
    stroke(100);
    for(int i =0; i <= _xUnits; i++){
      line( _x + (_xMultiplier *i), _y, _x + (_xMultiplier *i), _y + _sizeY + 10 );
      
      textSize(10);
      textAlign(CENTER);
      fill(255);
      text( round( (_xUnits-i) *_sampleTime ) ,_x + (_xMultiplier *i), _y + _sizeY + 25);
    
    }
    
    float yTextMulti = (_maxVal- _minVal) /  _yUnits-1;
    
    for(int i =0; i < _yUnits; i++){
      line( _x -10, _y + (_yMultiplier *i), _x + _sizeX, _y + (_yMultiplier *i));
      textSize(10);
      textAlign(RIGHT);
      fill(255);
      text( round( (_yUnits-i+1)*yTextMulti + _minVal ) ,_x -15, _y + (_yMultiplier *i) + 5 );
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
  
  void updateDataLine(int[] data){
  
    float xCoord;
    float yCoord;
    
    float _xMultiplier = _sizeX/data.length;
    
    stroke(250,0,0);
    noFill();
    beginShape();    
    
    _minVal = lerp( _minVal, minValue(data,data.length-1)-100, 0.005);
    _maxVal = lerp( _maxVal, maxValue(data,data.length-1)+100, 0.005);
    
    for (int i=1; i<data.length; i++){                   // scroll through the PPG array
      xCoord = (i * _xMultiplier) + _x;
      yCoord =  map(PPG[i],_minVal,_maxVal,_sizeY,0) + _y;  
      vertex(xCoord,yCoord);                                        // set the vertex coordinates
    }
    endShape();                                           // connect the vertices
    noStroke();
  
  }
  
  void updateSize(float xpos, float ypos, float sizeX, float sizeY){
    _x = xpos;
    _y = ypos;  
   _sizeX = sizeX;
   _sizeY = sizeY;
  }
  
} 