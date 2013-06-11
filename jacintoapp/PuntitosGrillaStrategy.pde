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
