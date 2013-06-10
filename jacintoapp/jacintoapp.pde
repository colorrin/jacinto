int WIDTH = 800;
int HEIGHT = 600;

static int INTRO_PHASE = 1;
static int MIDDLE_PHASE = 2;
static int OUTRO_PHASE = 3;

static RayitaConstants RAYITA_CONSTANTS;

JacintoController jacinto;

void setup(){
        size (800,600);
        background (127,0,255);
        
        RAYITA_CONSTANTS = new RayitaConstants();
        
        jacinto = new JacintoController();
}

void draw(){
  jacinto.update();
}

color randomColor(){
  return color(0,206,209);
}

