interface ITextureStrategy{
  void intro(color from);
  void update();
  color getColorFrom();
  color getColorTo();
  int getPhase();
}
