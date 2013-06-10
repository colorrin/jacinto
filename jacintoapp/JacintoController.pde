class JacintoController{
  
  ArrayList<ITextureStrategy> _strategies;
  
  ITextureStrategy _currentStrategy;
  
  JacintoController(){
    _strategies = new ArrayList<ITextureStrategy> ();
    _strategies.add( new RayitasStrategy());
    int strPos =  floor(random(_strategies.size()));
    _currentStrategy = _strategies.get(strPos);
    _currentStrategy.intro(-1);
  }
  
  void update(){
    _currentStrategy.update();
  }
}
