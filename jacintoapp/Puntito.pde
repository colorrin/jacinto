class Puntito{
  
 int _x, _y;
 color _color;
  
 Puntito(int x, int y, color foreColor){
   _x = x;
   _y = y;
   _color = foreColor;
   
   println(_x);
 }
 
 void draw(Camera cam){
   ellipseMode(CENTER);
   fill(_color);
   noStroke();
   float x = (_x + cam.getX()) * cam.getZoom();
   float y = (_y + cam.getY()) * cam.getZoom();
   float w = (P_CONSTANTS.PUNTITO_WIDTH) * cam.getZoom();
   ellipse(x, y, w, w);
 }
  
}
