PImage i1,i2;
int tailleBloc=16;
int espace=32;
int pas=24;
int blocCount=0;
int xb=0,yb=0;
int jj=29,ii=28;
int nbp=8,cnbp=0;
ArrayList<Float> l=new ArrayList<Float>();
void setup(){
  size(1920,1080);
  //size(1000,700);
  loadImages(0,1);
  i2.loadPixels();
}
void afficheDiff(Point blocSimilaire,Point blocSource){
  int[][] d=diffMatrix(blocSimilaire,blocSource);
  /////
  /*PImage out=createImage(tailleBloc,tailleBloc,RGB);
  for(int i=0;i<tailleBloc;i++){
    for(int j=0;j<tailleBloc;j++){
      int loc = i + j*out.width;
      out.pixels[loc]=color(abs(d[i][j]));
    }
  }
  out.save("out.png");
  for(int i=0;i<tailleBloc;i++){
    for(int j=0;j<tailleBloc;j++){
      int loc = i + j*out.width;
      int loc2 = (blocSource.x+i) + (blocSource.y+j)*i2.width;
      out.pixels[loc]=i2.pixels[loc2];
    }
  }
  out.save("outSource.png");
  for(int i=0;i<tailleBloc;i++){
    for(int j=0;j<tailleBloc;j++){
      int loc = i + j*out.width;
      int loc3 = (blocSimilaire.x+i) + (blocSimilaire.y+j)*i1.width;
      out.pixels[loc]=i1.pixels[loc3];
    }
  }
  out.save("outSimilaire.png");*/
  /////
  for(int i=0;i<tailleBloc;i++){
    for(int j=0;j<tailleBloc;j++){
      int loc = i+blocSource.x + (j+blocSource.y)*i2.width;
      i2.pixels[loc]=color(abs(d[i][j]));
    }
  }
}
Point[] limites(Point bloc,PImage i){
  Point[] lim=new Point[4];
  Point p1=new Point(bloc.x-espace,bloc.y-espace);Point p2=new Point(bloc.x+espace-1-tailleBloc,bloc.y-espace);
  Point p3=new Point(bloc.x-espace,bloc.y+espace-1-tailleBloc);Point p4=new Point(bloc.x+espace-1-tailleBloc,bloc.y+espace-1-tailleBloc);
  if(bloc.x-espace<0) {p1.x=0;p3.x=0;}
  if(bloc.y-espace<0) {p1.y=0;p2.y=0;}
  if(bloc.x+espace>i.width-1-tailleBloc) {p2.x=i.width-1-tailleBloc;p4.x=i.width-1-tailleBloc;}
  if(bloc.y+espace>i.height-1-tailleBloc) {p3.y=i.height-1-tailleBloc;p4.y=i.height-1-tailleBloc;}
  lim[0]=p1;lim[1]=p2;lim[2]=p3;lim[3]=p4;
  return lim;
}
void divide(){
  for (int x = 0; x< i2.width; x++ ) {
    if(x%tailleBloc==0){line(x,0,x,i2.height);}
  }
  for (int y = 0; y< i2.height; y++ ) {
    if(y%tailleBloc==0){line(0,y,i2.width,y);}
  }
}
void intensite(){
  for (int x = 0; x < i2.width; x++ ) {
    for (int y = 0; y < i2.height; y++ ) {
      int loc = x + y*i2.width;
      l.add(brightness(i2.pixels[loc]));
      //mat[x][y]=brightness(i2.pixels[loc]);
      //23 4
    }
  }
}
void loadImages(int i,int j){
  i1=loadImage("F:\\HAKIM\\MIV M1\\TP MUL\\Programmes\\TP6\\data\\image"+s(i)+".png");i1.filter(GRAY);
  i2=loadImage("F:\\HAKIM\\MIV M1\\TP MUL\\Programmes\\TP6\\data\\image"+s(j)+".png");i2.filter(GRAY);
}
boolean changed(Point bloc){
  /*for(int i=0;i<tailleBloc;i++){
    for(int j=0;j<tailleBloc;j++){
      int loc1 = (bloc.x+i) + (bloc.y+j)*i1.width;
      int loc2 = (bloc.x+i) + (bloc.y+j)*i2.width;
      if(i2.pixels[loc2]!=i1.pixels[loc1]) return true;
    }
  }*/
  double d=diff2(bloc,bloc);
  if(d<1000) return false;else return true;
  //return false;
}
int[][] diffMatrix(Point blocSimilaire,Point blocSource){
  int[][] d=new int[tailleBloc][tailleBloc];
  for(int i=0;i<tailleBloc;i++){
    for(int j=0;j<tailleBloc;j++){
      int loc1 = (blocSimilaire.x+i) + (blocSimilaire.y+j)*i1.width;
      int loc2 = (blocSource.x+i) + (blocSource.y+j)*i2.width;
      //using brightness
      d[i][j]=(int)brightness(i2.pixels[loc2])-(int)brightness(i1.pixels[loc1]);
      //using RGB
      //d[i][j]=i2.pixels[loc2]-i1.pixels[loc1];
    }
  }
  return d;
}
double diff2(Point blocSimilaire,Point blocSource){
  int[][] d=diffMatrix(blocSimilaire,blocSource);
  double mse=0;
  for(int i=0;i<tailleBloc;i++){
    for(int j=0;j<tailleBloc;j++){
      mse+=pow(d[i][j],2);
    }
  }
  return mse/(double)(tailleBloc*tailleBloc);
}
Point search(Point blocSource){
  double min=diff2(blocSource,blocSource);
  double mse=0;
  Point blocPlusSimilaire=new Point(blocSource.x,blocSource.y);
  Point blocSimilaire=new Point(blocSource.x,blocSource.y);
  //if(!changed(blocSource)){blocPlusSimilaire.x=blocSource.x;blocPlusSimilaire.y=blocSource.y;return blocPlusSimilaire;}
  Point[] lim=limites(blocSource,i1);
  for(int i=lim[0].x;i<lim[3].x;i+=pas){
    for(int j=lim[0].y;j<lim[3].y;j+=pas){
      blocSimilaire.x=i;blocSimilaire.y=j;
      mse=diff2(blocSimilaire,blocSource);
      if(mse<min){//println(mse);
        min=mse;
        blocPlusSimilaire.x=i;blocPlusSimilaire.y=j;
        //return blocPlusSimilaire;
      }
    }
  }
  return blocPlusSimilaire;
}
void draw(){
  image(i2,0,0);
  //i2.loadPixels();
  for(int i=0;i<8040;i++){
    if(yb==67) {/*saveFrame("frame"+ii+".png");*/print("<fin image "+ii+"> ");xb=0;yb=0;blocCount=0;if(cnbp==nbp)loadImages(jj,++jj);else{cnbp++;loadImages(ii,++jj);};break;}
    Point blocSource=new Point(xb*tailleBloc,yb*tailleBloc);
    Point blocSimilaire=searchDicho(blocSource);
    //noFill();
    //rect(blocSimilaire.x,blocSimilaire.y,tailleBloc,tailleBloc);
    //rect(blocSource.x,blocSource.y,tailleBloc,tailleBloc);
    //afficher la diff
    afficheDiff(blocSimilaire,blocSource);
    blocCount+=1;
    if(blocCount%120!=0)xb+=1;else{xb=0;yb+=1;}
  }
  i2.updatePixels();
  //stop();
}
Point searchDicho(Point blocSource){
  Point blocPlusSimilaire=new Point(blocSource.x,blocSource.y);
  Point blocSimilaire1=new Point(blocSource.x,blocSource.y);
  Point blocSimilaire2=new Point(blocSource.x,blocSource.y);
  Point blocSimilaire3=new Point(blocSource.x,blocSource.y);
  Point blocSimilaire4=new Point(blocSource.x,blocSource.y);
  ////
  int tt=8;
  Point blocRepere=blocSource;
  if(!changed(blocSource)){blocPlusSimilaire.x=blocSource.x;blocPlusSimilaire.y=blocSource.y;return blocPlusSimilaire;}
  while(tt>=1){
    blocPlusSimilaire=mini(blocSimilaire1,blocSimilaire2,blocSimilaire3,blocSimilaire4,blocRepere,tt);
    blocRepere=blocPlusSimilaire;
    tt=tt/2;
  }
  return blocRepere;
}
Point mini(Point blocSimilaire1,Point blocSimilaire2,Point blocSimilaire3,Point blocSimilaire4,Point blocRepere,int space){
    double d1=0,d2=0,d3=0,d4=0;
    /*blocSimilaire1.setX((blocRepere.x-tailleBloc)/2);blocSimilaire1.setY((blocRepere.y-tailleBloc)/2);
    d1=diff2(blocSimilaire1,blocRepere);
    blocSimilaire2.setX((3*blocRepere.x+tailleBloc)/2);blocSimilaire2.setY((blocRepere.y-tailleBloc)/2);
    d2=diff2(blocSimilaire2,blocRepere);
    blocSimilaire3.setX((blocRepere.x-tailleBloc)/2);blocSimilaire3.setY((3*blocRepere.y+tailleBloc)/2);
    d3=diff2(blocSimilaire3,blocRepere);
    blocSimilaire4.setX((3*blocRepere.x+tailleBloc)/2);blocSimilaire4.setY((3*blocRepere.y+tailleBloc)/2);
    d4=diff2(blocSimilaire4,blocRepere);*/
    blocSimilaire1.setX(blocRepere.x-space);blocSimilaire1.setY(blocRepere.y-space);
    d1=diff2(blocSimilaire1,blocRepere);
    blocSimilaire2.setX(blocRepere.x+space);blocSimilaire2.setY(blocRepere.y-space);
    d2=diff2(blocSimilaire2,blocRepere);
    blocSimilaire3.setX(blocRepere.x+space);blocSimilaire3.setY(blocRepere.y+space);
    d3=diff2(blocSimilaire3,blocRepere);
    blocSimilaire4.setX(blocRepere.x-space);blocSimilaire4.setY(blocRepere.y+space);
    d4=diff2(blocSimilaire4,blocRepere);
    if(d1<=d2 && d1<=d3 && d1<=d4) return blocSimilaire1;
    if(d2<=d1 && d2<=d3 && d2<=d4) return blocSimilaire2;
    if(d3<=d1 && d3<=d2 && d3<=d4) return blocSimilaire3;
    return blocSimilaire4;
}
int[][] zeros(){
  int[][] matrice=new int[tailleBloc][tailleBloc];
  for(int i=0;i<tailleBloc;i++){
    for(int j=0;j<tailleBloc;j++){
      matrice[i][j]=0;
    }
  }
  return matrice;
}
String s(int x){
  if(x<10) return "00"+x;
  if(x<100) return "0"+x;
  return x+"";
}
