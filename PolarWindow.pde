
class PolarWindow {
 
  float _x;
  float _y;
  float _sizeX;
  float _sizeY;
  
  float _xUnits;
  float _yUnits;
  
  String _name;
  String _xName;
  String _yName;
  
  float _minVal = 0;
  float _maxVal = 1000;
  
  float _marge;
  
  float _min;
  float _max;
  
  float _valMultiplierX;
  float _valMultiplierY;
  
  
  PolarWindow(float xpos, float ypos, float sizeX, float sizeY, float xUnits, float yUnits, String name, String xName , String yName,float min, float max) {
    _x = xpos;
    _y = ypos;  
   _sizeX = sizeX;
   _sizeY = sizeY;
   _xUnits = xUnits;
   _yUnits = yUnits;
   _name = name;
   _xName= xName;
   _yName = yName;
   _min = min;
   _max = max;
   _valMultiplierX = (_max-_min)/xUnits;
   _valMultiplierY = (_max-_min)/yUnits;
   
  }
    
   void drawWindow() {     
    fill(185);
    stroke(100);
    strokeWeight(1);
    rect(_x,_y, _sizeX, _sizeY);
    
    float _xMultiplier = _sizeX/_xUnits;
    float _yMultiplier = _sizeY/_yUnits;
    
    stroke(250,255,0);
    strokeWeight(2);
    line( _x + (_xMultiplier * _xUnits/2), _y, _x + (_xMultiplier * _xUnits/2), _y + _sizeY + 10 );
     line( _x , _y + (_yMultiplier * _yUnits/2), _x + _sizeX, _y + (_yMultiplier * _yUnits/2));
     
    stroke(100);
    strokeWeight(1);
    for(int i =0; i <= _xUnits; i++){
      line( _x + (_xMultiplier *i), _y, _x + (_xMultiplier *i), _y + _sizeY + 10 );
      
      textSize(10);
      textAlign(CENTER);
      fill(255);
      text( round( i *_valMultiplierX+ _min) ,_x + (_xMultiplier *i), _y + _sizeY + 25);
    
    }
    
    
    for(int i =0; i < _yUnits; i++){
      line( _x -10, _y + (_yMultiplier *i), _x + _sizeX, _y + (_yMultiplier *i));
      textSize(10);
      textAlign(RIGHT);
      fill(255);
      text( round( (_yUnits-i)*_valMultiplierY + _min ) ,_x -15, _y + (_yMultiplier *i) + 5 );
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
  
  
  void updateSize(float xpos, float ypos, float sizeX, float sizeY){
    _x = xpos;
    _y = ypos;  
   _sizeX = sizeX;
   _sizeY = sizeY;
  }
  
  void updateDataLine(float[] data,float[] data2, int[] bins){
  
    float xCoord;
    float yCoord;  
    
   // size(100, 100);
    float _xMultiplier = _sizeX/_xUnits;
    float _yMultiplier = _sizeY/_yUnits;
    
    float calcPhase = 0;
    
  for(int i=0 ; i < bins.length; i++){
   
      calcPhase = atan2(data2[bins[i]],data[bins[i]]) ;
     
   
      
     /* 
      strokeWeight(2);
      line( _x + (_xMultiplier * _xUnits/2) + 5, _y + (_yMultiplier * _yUnits/2), _x + (_xMultiplier * _xUnits/2) + 5,  _y + (_yMultiplier * _yUnits/2)+ (_yMultiplier *  calcPhase ));
      */
      
      stroke(250,0,0);
      strokeWeight(2);
      
       point((((data[bins[i]]-_min)/(_max-_min))*_sizeX)+_x, (((data2[bins[i]]-_min)/(_max-_min))*_sizeY)+_y);
      strokeWeight(0.5);
      noFill();
      beginShape(); 
      
      xCoord = (((0-_min)/(_max-_min))*_sizeX)+_x;
      yCoord = (((0-_min)/(_max-_min))*_sizeY)+_y;  
      vertex(xCoord,yCoord);  
      
      vertex((((data[bins[i]]-_min)/(_max-_min))*_sizeX)+_x, (((data2[bins[i]]-_min)/(_max-_min))*_sizeY)+_y);   
      
      /*for (int i=0 ;i<data.length; i++){                   // scroll through the PPG array
        xCoord = (((data[i]-_min)/(_max-_min))*_sizeX)+_x;
        yCoord = (((data2[i]-_min)/(_max-_min))*_sizeY)+_y;  
        vertex(xCoord,yCoord);                                        // set the vertex coordinates
      }*/
     
      endShape();                                           // connect the vertices
      noStroke();
    
    }
  }
} 