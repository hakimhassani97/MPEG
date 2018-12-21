public class Point{
  int x,y;//cordonnees du bloc
  color c;
  void setX(int x){
    if(x<0) this.x=0;
    if(x>width) this.x=width;
    this.x=0;
  }
  void setY(int y){
    if(y<0) this.y=0;
    if(y>height) y=height;
    this.y=0;
  }
  Point(int x,int y){this.x=x;this.y=y;}
  Point(int x,int y,color c){this.x=x;this.y=y;this.c=c;}
}
