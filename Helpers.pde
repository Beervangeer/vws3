float[] testSignal = { 1.000000, 0.616019, -0.074742, -0.867709, -1.513756, -1.814072, -1.695685, -1.238285, -0.641981, -0.148568, 0.052986, -0.099981, -0.519991, -1.004504, -1.316210, -1.277204, -0.840320, -0.109751, 0.697148, 1.332076, 1.610114, 1.479484, 1.039674, 0.500934, 0.100986, 0.011428, 0.270337, 0.767317, 1.286847, 1.593006, 1.522570, 1.050172, 0.300089, -0.500000, -1.105360, -1.347092, -1.195502, -0.769329, -0.287350, 0.018736, -0.003863, -0.368315, -0.942240, -1.498921, -1.805718, -1.715243, -1.223769, -0.474092, 0.298324, 0.855015, 1.045127, 0.861789, 0.442361, 0.012549, -0.203743, -0.073667, 0.391081, 1.037403, 1.629420, 1.939760, 1.838000, 1.341801, 0.610829, -0.114220, -0.603767, -0.726857, -0.500000, -0.078413, 0.306847, 0.441288, 0.212848, -0.342305, -1.051947, -1.673286, -1.986306, -1.878657, -1.389067, -0.692377, -0.032016, 0.373796, 0.415623, 0.133682, -0.299863, -0.650208, -0.713739, -0.399757, 0.231814, 0.991509, 1.632070, 1.942987, 1.831075, 1.355754, 0.705338, 0.123579, -0.184921, -0.133598, 0.213573, 0.668583, 0.994522, 1.000000};

//float[] testSignal = new float[100];

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

float maxValue (float arrayLink[], int leng) {
  float mxm = arrayLink[0];
  for (int i=0; i<leng; i++) {
    if (arrayLink[i]>mxm) {
      mxm = arrayLink[i];
    }
  }
  return mxm;
};

float maxValueInt (int arrayLink[], int leng) {
  float mxm = arrayLink[0];
  for (int i=0; i<leng; i++) {
    if (arrayLink[i]>mxm) {
      mxm = arrayLink[i];
    }
  }
  return mxm;
};

float minValue (float arrayLink[], int leng) {
  float mim = arrayLink[0];
  for (int i=0; i<leng; i++) {
    if (arrayLink[i]<mim) {
      mim = arrayLink[i];
    }
  }
  return mim;
};

int[][] EODecompInt(int[] dataArray){
  int[] even = new int[dataArray.length];
  int[] odd = new int[dataArray.length];
  
  for(int i =0; i < dataArray.length; i++){
    even[i] = (dataArray[i] + dataArray[dataArray.length -i] )/2;
    odd[i] = (dataArray[i] + dataArray[dataArray.length -i])/2;
  }
  
  int[][] returnData = new int[2][];
  returnData[0] = even ;
  returnData[0] = odd ;
  return returnData;
}

float[][] EODecompFlt(float[] dataArray){
  float[] even = new float[dataArray.length];
  float[] odd = new float[dataArray.length];
  
  for(int i =0; i < dataArray.length; i++){
    even[i] = (dataArray[i] + dataArray[dataArray.length-1 -i] )/2;
    odd[i] = (dataArray[i] - dataArray[dataArray.length-1 -i])/2;
  }
  
  float[][] returnData = new float[2][];
  returnData[0] = even ;
  returnData[1] = odd ;
  return returnData;
}

float[][] IntrlDecompFlt(float[] dataArray){
  float[] even = new float[dataArray.length];
  float[] odd = new float[dataArray.length];
  
  for(int i =0; i < dataArray.length; i++){
    
    if(int(dataArray[i]) % 2 == 0){
      even[i] = dataArray[i];
      odd[i]= 0;
    }else{
      even[i] = 0;
      odd[i]= dataArray[i];
    }
    
  }
  
  float[][] returnData = new float[2][];
  returnData[0] = even ;
  returnData[1] = odd ;
  return returnData;
}

float[] convultionFloatInput(float[]input, float[]impulse){
  
  float[] returnData = new float[input.length + impulse.length];
  
  for(int i=0; i<input.length; i++){
    
    for(int j=0; j < impulse.length; j++){
      returnData[i+j] = returnData[i+j] + (input[i]*impulse[j]);
    }
    
  }
  
  return returnData;
  
}

float[] convultionFloatOutput(float[]input, float[]impulse){
  
  float[] returnData = new float[input.length + impulse.length];
  
  for(int i=0; i< returnData.length; i++){
    
    for(int j=0; j < impulse.length; j++){
      if(i-j>0 && i-j<input.length ){
        returnData[i] = returnData[i] + (impulse[j]*input[i-j]);
      }
      
    }
    
  }
  
  return returnData;
  
}

float[][] DiscreteFourier(float[] dataArray){
  float[] RE = new float[(dataArray.length/2) +1];
  float[] IM = new float[(dataArray.length/2) +1];
  float[] PS = new float[(dataArray.length/2) +1];
  
  for(int k =0; k < (dataArray.length/2) +1; k++){
    
    for(int i =0; i<dataArray.length; i++){
      RE[k] = RE[k] + (dataArray[i] * cos( (2*PI*k*i)/dataArray.length) );
      IM[k] = IM[k] + (dataArray[i] * -sin( (2*PI*k*i)/dataArray.length) );
      PS[k] = pow( pow(RE[k],2) + pow(IM[k],2) , 0.5) ;
    }
    
  }
  //println(" _____");
  float[][] returnData = new float[3][];
  returnData[0] = RE;
  returnData[1] = IM;
  returnData[2] = PS;
  return returnData;
}

float[][] CosDFT(float[] signal, int bin){

  float[][] returnData = new float[2][];
  
  returnData[0] = new float[signal.length];
  returnData[1] = new float[signal.length];
  for(int i =0; i<signal.length; i++){
     returnData[0][i] = cos( (2*PI*bin*i)/signal.length);
     returnData[1][i] = signal[i] * cos( (2*PI*bin*i)/signal.length);
    }
  
  return returnData;
}

float[][] SinDFT(float[] signal, int bin){

  float[][] returnData = new float[2][];
  returnData[0] = new float[signal.length];
  returnData[1] = new float[signal.length];
  for(int i =0; i<signal.length; i++){
     returnData[0][i] = -sin( (2*PI*bin*i)/signal.length);
     returnData[1][i] = signal[i] * -sin( (2*PI*bin*i)/signal.length); 
    }
  
  return returnData;
}

float[] invertDFT(float[] rex, float[] imx, int lengthData){

  float[] returnData = new float[ lengthData];
 
  for(int i =0; i< rex.length; i++){
    
    for(int j=0; j < lengthData; j++){
      returnData[j] = returnData[j] + ((rex[i] * cos( (2*PI*i*j)/lengthData))/rex.length);
      returnData[j] = returnData[j] + ((imx[i] * sin( (2*PI*i*j)/lengthData))/rex.length);
    }
    
  }
  
  return reverse(returnData);
}

float[] invertDFTBin(float[] rex, float[] imx, int lengthData, int[] bin){

  float[] returnData = new float[ lengthData];
 
  for(int i =0; i< rex.length; i++){
    
    for(int j=0; j < lengthData; j++){
      for(int b=0; b < bin.length; b++){
      if(i == bin[b]){
        returnData[j] = returnData[j] + ((rex[i] * cos( (2*PI*i*j)/lengthData))/rex.length);
        returnData[j] = returnData[j] + ((imx[i] * sin( (2*PI*i*j)/lengthData))/rex.length);
      }
      }
    }
    
  }
  
  return reverse(returnData);
}

float[] invertDFTBinCos(float[] rex, float[] imx, int lengthData, int[] bin){

  float[] returnData = new float[ lengthData];
 
  for(int i =0; i< rex.length; i++){
    
    for(int j=0; j < lengthData; j++){
      for(int b=0; b < bin.length; b++){
      if(i == bin[b]){
        returnData[j] = returnData[j] + ((rex[i] * cos( (2*PI*i*j)/lengthData))/rex.length);
       // returnData[j] = returnData[j] + ((imx[i] * sin( (2*PI*i*j)/lengthData))/rex.length);
      }
      }
    }
    
  }
  
  return reverse(returnData);
}
float[] invertDFTBinSin(float[] rex, float[] imx, int lengthData, int[] bin){

  float[] returnData = new float[ lengthData];
 
  for(int i =0; i< rex.length; i++){
    
    for(int j=0; j < lengthData; j++){
      for(int b=0; b < bin.length; b++){
      if(i == bin[b]){
       // returnData[j] = returnData[j] + ((rex[i] * cos( (2*PI*i*j)/lengthData))/rex.length);
        returnData[j] = returnData[j] + ((imx[i] * sin( (2*PI*i*j)/lengthData))/rex.length);
      }
      }
    }
    
  }
  
  return reverse(returnData);
}
float[] getMagnitude(float[] rex, float[] imx, int lengthData){
  float[] returnData = new float[ lengthData];
  
  for(int i=0; i < lengthData; i++){
    returnData[i] = pow( (pow(rex[i],2) + pow(imx[i],2) ) , 0.5);
  }
  
  return returnData;
  
}