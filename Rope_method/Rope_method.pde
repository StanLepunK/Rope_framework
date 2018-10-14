/**
ROPE - Romanesco processing environment – 
* Copyleft (c) 2014-2017
* Stan le Punk
* https://github.com/StanLepunK
* http://stanlepunk.xyz/
*/


void setup() {
  size (300,300,P3D);
  init_layer();

}


void draw() {
  background(0);
  begin_layer();
  work_widthout_layer();
  /*

    background_rope(255,0,255);
    translate(width/2,height/2,width/3);
    pushMatrix();
    
    rotateX(rotate_x);
    rotateY(rotate_y);
    box(100);
        popMatrix();
        */

  end_layer();
  g.image(get_layer(),0,0);

}

float rotate_x,rotate_y;
void work_widthout_layer() {
    rotate_x += .01;
    rotate_y += .02;
  background_rope(255,0,255);
  fill(255);
  stroke(255);
  strokeWeight(1);
  pushMatrix();
  
  translate(width/2,height/2,width/3);
  rotateX(rotate_x);
  rotateZ(rotate_y);

  box(100);
  popMatrix();

}







