class relCoordsChecker {
  
  float _sizeX;
  float _sizeY;
  float _posX;
  float _posY;
  
  void calcCoords(float sizeX, float sizeY, float posX, float posY, String align){
  
    _sizeX = width/sizeX;
    _sizeY = height/sizeY;
    
    if(align == "left"){
       _posX = width/posX;
       _posY = height/posY;
    }
    
    if(align == "center"){
    
       _posX = (width/posX) - (_sizeX/2);
       _posY = (height/posY) - (_sizeY/2);
       
    }
    
  }
  
}

int maxValue (int arrayLink[], int leng) {
  int mxm = arrayLink[0];
  for (int i=0; i<leng; i++) {
    if (arrayLink[i]>mxm) {
      mxm = arrayLink[i];
    }
  }
  return mxm;
};

int minValue (int arrayLink[], int leng) {
  int mim = arrayLink[0];
  for (int i=0; i<leng; i++) {
    if (arrayLink[i]<mim) {
      mim = arrayLink[i];
    }
  }
  return mim;
};