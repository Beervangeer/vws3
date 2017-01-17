
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
  
  float _marge;
  
  GraphWindow(float xpos, float ypos, float sizeX, float sizeY, float xUnits, float yUnits, float sampleTime, String name, String xName , String yName, float marge) {
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
   _marge = marge;
   
  }
    
  void drawWindow() {     
    fill(185);
    stroke(100);
    strokeWeight(1);
    rect(_x,_y, _sizeX, _sizeY);
    
    float _xMultiplier = _sizeX/_xUnits;
    float _yMultiplier = _sizeY/_yUnits;
    
    stroke(100);
    strokeWeight(1);
    for(int i =0; i <= _xUnits; i++){
      line( _x + (_xMultiplier *i), _y, _x + (_xMultiplier *i), _y + _sizeY + 10 );
      
      textSize(10);
      textAlign(CENTER);
      fill(255);
      text( round( i *_sampleTime ) ,_x + (_xMultiplier *i), _y + _sizeY + 25);
    
    }
    
    float yTextMulti = (_maxVal- _minVal) /  _yUnits;
    
    for(int i =0; i < _yUnits; i++){
      line( _x -10, _y + (_yMultiplier *i), _x + _sizeX, _y + (_yMultiplier *i));
      textSize(10);
      textAlign(RIGHT);
      fill(255);
      text( round( (_yUnits-i)*yTextMulti + _minVal ) ,_x -15, _y + (_yMultiplier *i) + 5 );
    }
    
    textSize(14);
    textAlign(CENTER);
    fill(255);
    text(_name,_x + (_sizeX/2), _y -10);
    
    textSize(14);
    textAlign(CENTER);
    fill(255);
    text(_xName ,_x + (_sizeX/2), _y + _sizeY + 45);
    
    pushMatrix();
    translate(_x-50,_y + (_sizeY/2));
    rotate(-HALF_PI);
    text(_yName,0,0);
    popMatrix(); 
  
  }
  
  void updateDataLine(float[][] data){
  
    for(int i=0; i < data.length; i++){
      float xCoord;
      float yCoord;
      
      float _xMultiplier = _sizeX/(data[i].length-1);
      
      if(i==0){
        stroke(250,0,0);
      }
      if(i==1){
        stroke(250,255,0);
      }
      if(i==2){
        stroke(250,0,255);
      }
      if(i==3){
        stroke(250,122,255);
      }
      if(i==4){
        stroke(122,255,255);
      }
      if(i==5){
        stroke(0,255,100);
      }
      if(i==6){
        stroke(122,122,255);
      }
      if(i==7){
        stroke(122,45,76);
      }
      if(i==8){
        stroke(33,200,134);
      }
      if(i==9){
        stroke(222,111,55);
      }
      if(i==10){
        stroke(111,55,111);
      }
      
      strokeWeight(1);
      noFill();
      beginShape();    
      
     _minVal = lerp( _minVal, minValue(data[i],data[i].length-1)-_marge , 0.05);
      _maxVal = lerp( _maxVal, maxValue(data[i],data[i].length-1)+_marge , 0.05);
     
      
      for (int j=0; j<data[i].length; j++){                  
        xCoord = ( j * _xMultiplier) + _x;
        yCoord =  map(data[i][j],_minVal,_maxVal,_sizeY,0) + _y;  
        vertex(xCoord,yCoord);    
       // print(data[i][j] + ",");
       
      } //println(" ");
      endShape();                                           
      noStroke();
    }
  }
  
  void updateSize(float xpos, float ypos, float sizeX, float sizeY){
    _x = xpos;
    _y = ypos;  
   _sizeX = sizeX;
   _sizeY = sizeY;
  }
  
} 