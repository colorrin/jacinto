int WIDTH = 800;
int HEIGHT = 600;

static int INTRO_PHASE = 1;
static int MIDDLE_PHASE = 2;
static int OUTRO_PHASE = 3;
static int FINISHED_PHASE = 4;

static RayitaConstants RAYITA_CONSTANTS;
static PuntitoConstants P_CONSTANTS;

JacintoController jacinto;

void setup(){
        size (800, 600, OPENGL);
        background (127,0,255);
        
        RAYITA_CONSTANTS = new RayitaConstants();
        P_CONSTANTS = new PuntitoConstants();
        
        jacinto = new JacintoController();
}

void draw(){
  jacinto.update();
}

color randomColor(){
  //return color(0,206,209);
  return color(floor(random(256)),floor(random(256)),floor(random(256)));
}

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
interface ITextureStrategy{
  void intro(color from);
  void update();
  color getColorFrom();
  color getColorTo();
  int getPhase();
}
class JacintoController{
  
  ArrayList<ITextureStrategy> _strategies;
  
  ITextureStrategy _currentStrategy;
  
  JacintoController(){
    _strategies = new ArrayList<ITextureStrategy> ();
    _strategies.add( new RayitasStrategy());
    _strategies.add( new PuntitosStrategy());
    _strategies.add( new PuntitosGrillaStrategy());
    _strategies.add( new RayitasZigZagStrategy());
    
    setStrategy();
  }
  
  void update(){
    if(_currentStrategy.getPhase() == FINISHED_PHASE){
      setStrategy();
    }
    _currentStrategy.update();
  }
  
  void setStrategy(){
    color from;
    if(_currentStrategy == null){
      from = color(127,0,255);  
    }else{
      from = _currentStrategy.getColorTo();  
    }
    int strPos =  floor(random(_strategies.size()));
    _currentStrategy = _strategies.get(strPos);
    _currentStrategy.intro(from);  
  }
}
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
class PuntitoConstants{
  
  public int PUNTITO_WIDTH = 10;
  public float ZOOM_SPEED = 0.5;
  public int MIDDLE_LOOPS = 150;
  public int MAX_ZOOM = WIDTH / PUNTITO_WIDTH + 100;
  public int LOCOS_AMT = 1000;  
  PuntitoConstants(){
   
  } 
}
class PuntitosGrillaStrategy implements ITextureStrategy{
  
  color _from;
  color _to;
  
  int _currentPhase;
  
  int _step;
  int _middleBaseStep;
  
  ArrayList<Puntito> _puntitos;

  Camera _camera;
  
  PuntitosGrillaStrategy(){
    
  }
  
  void intro(color from){
    _from = from;  
    
    _to = randomColor();
    _step = 0;
    
    createPuntitos();
    
    _currentPhase = INTRO_PHASE;
  
    _camera = new Camera(0, 0, P_CONSTANTS.MAX_ZOOM);
  }
  
  void update(){
    _step++;
    if(_currentPhase == INTRO_PHASE){
      introUpdate();
    }
    if(_currentPhase == MIDDLE_PHASE){
      middleUpdate();
    }
    if(_currentPhase == OUTRO_PHASE){
      outroUpdate();
    }
    
    background(_from);
    
    //translate(WIDTH /2 + _camera.getX(), HEIGHT/2 + _camera.getY(), 0);
    translate(WIDTH /2, HEIGHT/2);
    rotate(radians(_step));
    //scale(_camera.getZoom());
    
    for(int i=0; i < _puntitos.size(); i++){
      float y = (_puntitos.get(i)._y + _camera.getY()) * _camera.getZoom();
      float x = (_puntitos.get(i)._x + _camera.getX()) * _camera.getZoom();
      
      if((y > -HEIGHT && y < HEIGHT * 2) && (x > -WIDTH && x < WIDTH * 2)){
        _puntitos.get(i).draw(_camera); 
      }
    }
  }
  
  void introUpdate(){
    _camera.setZoom(_camera.getZoom()-P_CONSTANTS.ZOOM_SPEED);
    if(_camera.getZoom()<=1){
      _currentPhase = MIDDLE_PHASE;
      _camera.setZoom(1);
      _middleBaseStep = _step;
    }
  }
  
  void middleUpdate(){
    if(_step-_middleBaseStep > P_CONSTANTS.MIDDLE_LOOPS){
      _currentPhase = OUTRO_PHASE;
    }  
  }
  
  void outroUpdate(){
    if(_camera.getX() < 110){
      _camera.setX(_camera.getX()+1); 
    }
    _camera.setZoom(_camera.getZoom()+P_CONSTANTS.ZOOM_SPEED);
    
    if(_camera.getZoom() == P_CONSTANTS.MAX_ZOOM){
      _currentPhase = FINISHED_PHASE;  
    }
  }
  
  color getColorFrom(){
    return _from;  
  }
  
  color getColorTo(){
    return _to;  
  }

  int getPhase(){
    return _currentPhase;  
  }
    
  void createPuntitos(){
    _puntitos = new ArrayList<Puntito>();
    
    int rowsAmt = HEIGHT * 2 / P_CONSTANTS.PUNTITO_WIDTH;
    int puntitosAmt = WIDTH * 2 / P_CONSTANTS.PUNTITO_WIDTH;
    
    for(int h = 0; h < rowsAmt; h++){
      if(h%3 == 0){
        for(int i = 0; i < puntitosAmt; i++){
           if(i%2 == 1){
             _puntitos.add(new Puntito(i * P_CONSTANTS.PUNTITO_WIDTH - WIDTH + (h%2)*P_CONSTANTS.PUNTITO_WIDTH/2, h * P_CONSTANTS.PUNTITO_WIDTH - HEIGHT, _to)); 
             //h * P_CONSTANTS.PUNTITO_WIDTH - HEIGHT, _to));
           }
        }  
      }
    }

    //_rayitas.add(new Rayita(-10, 0, _to));
    //_rayitas.add(new Rayita(0, 0, _to));
    //_rayitas.add(new Rayita(10, 0, _to));
  }
}
class PuntitosStrategy implements ITextureStrategy{
  
  color _from;
  color _to;
  
  int _currentPhase;
  
  int _step;
  int _middleBaseStep;
  
  ArrayList<Puntito> _puntitos;

  Camera _camera;
  
  PuntitosStrategy(){
    
  }
  
  void intro(color from){
    _from = from;  
    
    _to = randomColor();
    _step = 0;
    
    createPuntitos();
    
    _currentPhase = INTRO_PHASE;
  
    _camera = new Camera(0, 0, P_CONSTANTS.MAX_ZOOM);
  }
  
  void update(){
    _step++;
    if(_currentPhase == INTRO_PHASE){
      introUpdate();
    }
    if(_currentPhase == MIDDLE_PHASE){
      middleUpdate();
    }
    if(_currentPhase == OUTRO_PHASE){
      outroUpdate();
    }
    
    background(_from);
    
    translate(WIDTH /2, HEIGHT/2);
    rotate(radians(_step));
    
    for(int i=0; i < _puntitos.size(); i++){
      _puntitos.get(i).draw(_camera); 
    }
  }
  
  void introUpdate(){
    _camera.setZoom(_camera.getZoom()-P_CONSTANTS.ZOOM_SPEED);
    if(_camera.getZoom()<=1){
      _currentPhase = MIDDLE_PHASE;
      _camera.setZoom(1);
      _middleBaseStep = _step;
    }
  }
  
  void middleUpdate(){
    if(_step-_middleBaseStep > P_CONSTANTS.MIDDLE_LOOPS){
      _currentPhase = OUTRO_PHASE;
    }  
  }
  
  void outroUpdate(){
    if(_camera.getX() < 110){
      _camera.setX(_camera.getX()+1); 
    }
    _camera.setZoom(_camera.getZoom()+P_CONSTANTS.ZOOM_SPEED);
    
    if(_camera.getZoom() == P_CONSTANTS.MAX_ZOOM){
      _currentPhase = FINISHED_PHASE;  
    }
  }
  
  color getColorFrom(){
    return _from;  
  }
  
  color getColorTo(){
    return _to;  
  }

  int getPhase(){
    return _currentPhase;  
  }
    
  void createPuntitos(){
    _puntitos = new ArrayList<Puntito>();
    
    int puntitosAmt = WIDTH * 2 / P_CONSTANTS.PUNTITO_WIDTH;
    
    for(int i = 0; i < puntitosAmt; i++){
       if(i%2 == 1){
         _puntitos.add(new Puntito(i * P_CONSTANTS.PUNTITO_WIDTH - WIDTH, 0, _to));
       }
    }  

    //_rayitas.add(new Rayita(-10, 0, _to));
    //_rayitas.add(new Rayita(0, 0, _to));
    //_rayitas.add(new Rayita(10, 0, _to));
  }
}
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
class RayitaConstants{
  
  public int RAYITA_WIDTH = 10;
  public float ZOOM_SPEED = 0.5;
  public int MIDDLE_LOOPS = 150;
  public int MAX_ZOOM = WIDTH / RAYITA_WIDTH;
  public int ZZ_MAX_ZOOM = MAX_ZOOM * 2;
  public float ZZ_ZOOM_SPEED = ZOOM_SPEED * 2;
  RayitaConstants(){
   
  } 
}
class RayitasStrategy implements ITextureStrategy{
  
  int _currentPhase;
  
  int _step;
  int _middleBaseStep;
  
  color _from;
  color _to;

  ArrayList<Rayita> _rayitas;

  Camera _camera;
  
  RayitasStrategy(){
  }
  
  void intro(color from){
    _from = from;
    _to = randomColor();
    _step = 0;
    
    createRayitas();
    
   _currentPhase = INTRO_PHASE;
  
   _camera = new Camera(0, 0, RAYITA_CONSTANTS.MAX_ZOOM); 
  }
  
  void update(){
    _step++;
    if(_currentPhase == INTRO_PHASE){
      introUpdate();
    }
    if(_currentPhase == MIDDLE_PHASE){
      middleUpdate();
    }
    if(_currentPhase == OUTRO_PHASE){
      outroUpdate();
    }
    
    background(_from);
    
    translate(WIDTH /2, HEIGHT/2);
    rotate(radians(_step));

    for(int i=0; i < _rayitas.size(); i++){
      _rayitas.get(i).draw(_camera); 
    }
  }
  
  void introUpdate(){
    _camera.setZoom(_camera.getZoom()-RAYITA_CONSTANTS.ZOOM_SPEED);
    if(_camera.getZoom()<=1){
      _currentPhase = MIDDLE_PHASE;
      _camera.setZoom(1);
      _middleBaseStep = _step;
    }
  }
  
  void middleUpdate(){
    if(_step-_middleBaseStep > RAYITA_CONSTANTS.MIDDLE_LOOPS){
      _currentPhase = OUTRO_PHASE;
    }  
  }
  
  void outroUpdate(){
    if(_camera.getX() < 110){
      _camera.setX(_camera.getX()+1); 
    }
    _camera.setZoom(_camera.getZoom()+RAYITA_CONSTANTS.ZOOM_SPEED);
    
    if(_camera.getZoom() >= RAYITA_CONSTANTS.MAX_ZOOM){
      _currentPhase = FINISHED_PHASE;  
    }
  }
  
  color getColorFrom(){
    return _from;  
  }
  
  color getColorTo(){
    return _to;  
  }
 
  int getPhase(){
    return _currentPhase;  
  }
  
  void createRayitas(){
    _rayitas = new ArrayList<Rayita>();
    
    int rayitasAmt = WIDTH * 2 / RAYITA_CONSTANTS.RAYITA_WIDTH;
    
    for(int i = 0; i < rayitasAmt; i++){
       if(i%2 == 1){
         _rayitas.add(new Rayita(i * RAYITA_CONSTANTS.RAYITA_WIDTH - WIDTH, 0, _to));
       }
    }  

    //_rayitas.add(new Rayita(-10, 0, _to));
    //_rayitas.add(new Rayita(0, 0, _to));
    //_rayitas.add(new Rayita(10, 0, _to));
  }
}
class RayitasZigZagStrategy implements ITextureStrategy{
  
  int _currentPhase;
  
  int _step;
  int _middleBaseStep;
  
  color _from;
  color _to;

  ArrayList<Rayita> _rayitas;

  Camera _camera;
  
  RayitasZigZagStrategy(){
  }
  
  void intro(color from){
    _from = from;
    _to = randomColor();
    _step = 0;
    
    createRayitas();
    
   _currentPhase = INTRO_PHASE;
  
   _camera = new Camera(0, 0, RAYITA_CONSTANTS.ZZ_MAX_ZOOM); 
  }
  
  void update(){
    _step++;
    if(_currentPhase == INTRO_PHASE){
      introUpdate();
    }
    if(_currentPhase == MIDDLE_PHASE){
      middleUpdate();
    }
    if(_currentPhase == OUTRO_PHASE){
      outroUpdate();
    }
    
    background(_from);
    
    translate(WIDTH /2, HEIGHT/2);
    rotate(radians(_step));

    shearX(radians(30));    
    for(int i=0; i < _rayitas.size(); i++){
      if(i%2 == 0){
        shearX(radians(30));
      }else{
        shearX(radians(-30));
      }
      _rayitas.get(i).draw(_camera); 
    }
  }
  
  void introUpdate(){
    _camera.setZoom(_camera.getZoom()-RAYITA_CONSTANTS.ZZ_ZOOM_SPEED);
    if(_camera.getZoom()<=1){
      _currentPhase = MIDDLE_PHASE;
      _camera.setZoom(1);
      _middleBaseStep = _step;
    }
  }
  
  void middleUpdate(){
    if(_step-_middleBaseStep > RAYITA_CONSTANTS.MIDDLE_LOOPS){
      _currentPhase = OUTRO_PHASE;
    }  
  }
  
  void outroUpdate(){
    if(_camera.getX() < 110){
      _camera.setX(_camera.getX()+1); 
    }
    _camera.setZoom(_camera.getZoom()+RAYITA_CONSTANTS.ZZ_ZOOM_SPEED);
    
    if(_camera.getZoom() >= RAYITA_CONSTANTS.ZZ_MAX_ZOOM){
      _currentPhase = FINISHED_PHASE;  
    }
  }
  
  color getColorFrom(){
    return _from;  
  }
  
  color getColorTo(){
    return _to;  
  }
 
  int getPhase(){
    return _currentPhase;  
  }
  
  void createRayitas(){
    _rayitas = new ArrayList<Rayita>();
    
    int rayitasAmt = WIDTH * 2 / RAYITA_CONSTANTS.RAYITA_WIDTH;
    
    for(int i = 0; i < rayitasAmt; i++){
       if(i%2 == 1){
         _rayitas.add(new Rayita(i * RAYITA_CONSTANTS.RAYITA_WIDTH - WIDTH, 0, _to));
       }
    }  

    //_rayitas.add(new Rayita(-10, 0, _to));
    //_rayitas.add(new Rayita(0, 0, _to));
    //_rayitas.add(new Rayita(10, 0, _to));
  }
}

