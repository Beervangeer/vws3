
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

float relMinMax(float[] data, float rel){

  float calcRel = minValue(data,data.length)+((maxValue(data,data.length)-minValue(data,data.length))*rel);
  
  return calcRel;
  
}

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
    returnData[i] = pow( (pow(rex[i],2) + pow(imx[i],2) ) , 2);
  }
  
  return returnData;
  
}

float[] getPhase(float[] rex, float[] imx, float[] pow, int lengthData, int marge){
  
  float[] returnData = new float[ (lengthData/2)+1];
  
  for(int i = 0; i < (lengthData/2)+1 ; i++){
    if(pow[i] < marge ){
      returnData[i] = 0;
    }else{
      returnData[i] = atan2(imx[i],rex[i]);
      returnData[i] = map( degrees(returnData[i]) + 180,0,360,0,5 );
    }

    
  }

  return returnData;
  
}

float[] ZeroPadding(float[] data, int size){
    
    float[] returnData = new float[size];
    
    for(int i=0; i<data.length;i++){
      returnData[i] = data[i];
    }
    
    for(int i = data.length; i < size; i++){
      returnData[i] = 0;
    }
    
    return returnData;
}

float hammingFunc(int n, int N){

    float returnData =0 ;
    
    returnData = 0.54 - (0.45* cos((2*PI*n)/N));
    
    return returnData;
}

float[] hammingArr(float[] data){
  
  float[] returnData = new float[data.length];
  
  for(int n=0; n< data.length; n++){
    returnData[n] =   hammingFunc(n,data.length) * data[n];
  }
  return returnData;
  
}

float blackmanFunc(int n, int N){

    float returnData =0 ;
    
    returnData = 0.42 - ( (0.5* cos((2*PI*n)/N) )+ (0.08* cos((4*PI*n)/N) ) );
    
    return returnData;
}

float[] blackmanArr(float[] data){
  
  float[] returnData = new float[data.length] ;
  
  for(int n=0; n< data.length; n++){
    returnData[n] = blackmanFunc(n,data.length) * data[n];
  }
  return returnData;
  
}

float[] getPeaks(float[] data , float tresh, int peakWidth, int base){
  
  float[] returnData = new float[data.length];
  for(int i=0; i<data.length; i++){
    returnData[i] = base;
  }
  float calcTresh = relMinMax(data,tresh);
  for(int i=peakWidth; i < data.length-peakWidth; i++){
      
     if(data[i-peakWidth] < data[i] && data[i+peakWidth] < data[i] && data[i]>calcTresh){
       
     // returnData  = append(returnData,data[i]);
     returnData[i]= data[i];
    }
   
  }
 
 return returnData;
}

float [] normaliseArray(float[] input, HistoGram HistoGraph, int trim, float multiplier){
   float[] returnArray = new float[trim]; 
   
   for(int i=0; i < trim; i++){
     if(Float.isNaN(input[round(i*multiplier)]) == false &&  input[round(i*multiplier)] !=0 && HistoGraph.mean-HistoGraph.sd!=0 && HistoGraph.mean+HistoGraph.sd != 0){
      returnArray[i] = map( input[round(i*multiplier)], HistoGraph.mean-HistoGraph.sd,HistoGraph.mean+HistoGraph.sd, -1,1);
     
    } 
   }
   return returnArray;
}