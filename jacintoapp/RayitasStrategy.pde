class RayitasStrategy implements ITextureStrategy{
  
  int _currentPhase;
  
  int _step;
  
  color _from;
  color _to;

  ArrayList<Rayita> _rayitas;

  Camera _camera;
  
  RayitasStrategy(){
  }
  
  void intro(color from){
    if(from == -1){
        _from = color(127,0,255);
    }
    _to = randomColor();
    _step = 0;
    
    createRayitas();
    
   _currentPhase = INTRO_PHASE;
  
   _camera = new Camera(0, 0, WIDTH / RAYITA_CONSTANTS.RAYITA_WIDTH); 
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
   
    for(int i=0; i < _rayitas.size(); i++){
      _rayitas.get(i).draw(_camera); 
    }
  }
  
  void introUpdate(){
    _camera.setZoom(_camera.getZoom()-1);
    if(_camera.getZoom()<=1){
      _currentPhase = MIDDLE_PHASE;
      _camera.setZoom(1);
      _step = 0;  
    }
  }
  
  void middleUpdate(){
    if(_step > 30){
      _currentPhase = OUTRO_PHASE;
    }  
  }
  
  void outroUpdate(){
    if(_camera.getX() < 110){
      _camera.setX(_camera.getX()+1); 
    }
    _camera.setZoom(_camera.getZoom()+1);
  }
  
  color getColorFrom(){
    return _from;  
  }
  
  color getColorTo(){
    return _to;  
  }
  
  void createRayitas(){
    _rayitas = new ArrayList<Rayita>();
    
    int rayitasAmt = WIDTH / RAYITA_CONSTANTS.RAYITA_WIDTH;
    
    for(int i = 0; i < rayitasAmt; i++){
       if(i%2 == 1){
         _rayitas.add(new Rayita(i * RAYITA_CONSTANTS.RAYITA_WIDTH - WIDTH/2, 0, _to));
       }
    }  

    //_rayitas.add(new Rayita(-10, 0, _to));
    //_rayitas.add(new Rayita(0, 0, _to));
    //_rayitas.add(new Rayita(10, 0, _to));
  }
}
