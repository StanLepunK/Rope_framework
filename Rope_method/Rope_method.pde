/**
ROPE - Romanesco processing environment – 
* Copyleft (c) 2014-2018
* Stan le Punk
* @see https://github.com/StanLepunK
* @see http://stanlepunk.xyz/
guide to code here: 
* @see https://github.com/StanLepunK/Rope/tree/master/Guide
*/


void setup() {
  size(300,300,P3D);
  init_layer(width,height,P3D);
}


float rotate_x;
float rotate_y;
void draw() {
  begin_layer();
// background(0);
  background_rope(55,0,0);
  // noStroke();

  noStroke();
  lights();
  translate(mouseX,mouseY);
  sphere(30);

  end_layer();
  image(get_layer());
  mask(); 
}






PGraphics mask;
void mask() {
  if(mask == null) {
    mask = createGraphics(width,height,P3D);
  }
  mask.beginDraw();

  mask.fill(0);
  mask.noStroke();
  mask.rect(0,0,width/8,height);
  mask.rect(width -(width/8),0,width/8,height);

  mask.rect(0,0,width,height/8);
  mask.rect(0,height -(height/8),width,height/8);

  mask.endDraw();

  image(mask);
}


























