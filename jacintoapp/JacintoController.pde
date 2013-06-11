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
