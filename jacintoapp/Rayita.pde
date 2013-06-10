class Rayita{
  
 int _x, _y;
 color _color;
  
 Rayita(int x, int y, color foreColor){
   _x = x;
   _y = y;
   _color = foreColor;
   
   println(_x);
 }
 
 void draw(Camera cam){
   if(cam == null){
     cam = new Camera(WIDTH/2, HEIGHT/2, 1);  
   }
   rectMode(CENTER);
   fill(_color);
   noStroke();
   float x = (_x + cam.getX()) * cam.getZoom();
   float y = (_y + cam.getY()) * cam.getZoom();
   float w = (RAYITA_CONSTANTS.RAYITA_WIDTH) * cam.getZoom();
   rect(x, y, w, HEIGHT * 2);
 }
  
}
