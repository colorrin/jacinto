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
