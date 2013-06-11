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

