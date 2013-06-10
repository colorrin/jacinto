class Camera{
  int _x, _y;
  float _zoom;
  Camera(int x, int y, float zoom){
    _x = x;
    _y = y;
    _zoom = zoom;
  }

  void setX(int x){
    _x = x;
  }

  void setY(int y){
    _y = y;
  }

  void setZoom(float zoom){
    _zoom = zoom;
  }  
  
  int getX(){
    return _x; 
  }
  
  int getY(){
    return _y; 
  }
  
  float getZoom(){
    return _zoom; 
  }
}
