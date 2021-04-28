/**
*
* Place tobe to add you massive classe and test it :)
* 
*/
/**
* R_Knob
* Processing 3.5.4
* @author @stanlepunk
* @see https://github.com/StanLepunK/Rope
* v 1.4.0
* 2019-2021
*/
// package rope.gui.button;

import java.util.Arrays;

import rope.R_State.State;
import rope.gui.R_Mol;
import rope.vector.bvec2;
import rope.vector.vec2;

public class R_Knob extends R_Button {
  protected R_Mol [] molette;
  protected R_Mol guide;
  private bvec2 [] mol_limit_is;
  // angle start and end for the limit knob
  protected vec2 limit;
  protected boolean clockwise = true;
  private float threshold = 0.1f;

  private boolean init_molette_is;
  private boolean mol_used_is;

  private float previous_angle_ref;
  private float next_angle_ref;

  private boolean open_knob = true;

  private int drag_direction = CIRCULAR;
  private float drag_force = 0.1f;
  private vec2 size_limit = new vec2(-3,3);
  
  public R_Knob(vec2 pos, float size) {
    
    super("Knob", pos, new vec2(size));
    set_value(0.5f); // default > one molette > half position
    set_limit(SOUTH_WEST,SOUTH_EAST);
    init_guide();
  }
  
  public R_Knob(String type, vec2 pos, float size) {
    super(type, pos, new vec2(size));
    set_value(0.5f); // default > one molette > half position
    set_limit(SOUTH_WEST,SOUTH_EAST);
    init_guide();
  }





  // set size

  public R_Knob set_value(float pos_norm) {
    float [] arr = { pos_norm };
    set_value(arr);
    return this;
  }
  
  public R_Knob set_value(float... pos_norm) {
    set_value_calc(pos_norm);
    init_molette_is = false;
    return this;
  }

  protected void set_value_calc(float... pos_norm) {
    Arrays.sort(pos_norm);
		init_molette(pos_norm.length);
    for(int i = 0 ; i < molette.length ; i++) {
      float v = map(pos_norm[i],0,1,0,TAU);
      if(!open_knob) {
        v = constrain_value(v, this.limit);
      }
      molette[i].angle(v);
    }
  }

  protected void init_guide() {
    if(this.guide == null) {
      this.guide = new R_Mol();
      this.guide.inside_is = false;
      this.guide.size(this.size.x()/4);
      this.guide.used_is = false;
    }
  }

  protected void init_molette(int len) {
		if(molette == null || len != molette.length) {
			molette = new R_Mol[len];
      mol_limit_is = new bvec2[len];
      for(int i = 0 ; i < len ; i++) {
        this.mol_limit_is[i] = new bvec2(false);
        this.molette[i] = new R_Mol();
        this.molette[i].size(this.size.x()/4);
        this.molette[i].id = 0;
        this.molette[i].used_is = false;
        this.molette[i].inside_is = false;
      }
		}
	}


  /**
   * MOLETTE
   */

  public R_Knob set_type_mol(int molette_type) {
    for(int i = 0 ; i < molette.length ; i++) {
      this.molette[i].set_shape_type(molette_type);
    }
    return this;
  }
  
  public R_Knob set_size_mol(vec2 size) {
    return set_size_mol(size.x(),size.y());
  }

  public R_Knob set_size_mol(float size) {
    return set_size_mol(size,size);
  }

  public R_Knob set_size_mol(float w, float h) {
    for(int i = 0 ; i < molette.length ; i++) {
      this.molette[i].size(w,h);
    }
    return this;
  }

  public R_Knob set_dist_mol(float dist) {
    for(int i = 0 ; i < molette.length ; i++) {
      this.molette[i].set_dist(dist);
    }
    return this;
  }


  /**
   * GUIDE
   */

  public R_Knob set_dist_guide(float dist) {
    this.guide.set_dist(dist);
    return this;
  }

  public R_Knob set_size_guide(float size) {
    return set_size_guide(size,size);
  }

  public R_Knob set_size_guide(float w, float h) {
    this.guide.size(w,h);
    return this;
  }

  public R_Knob set_drag(int direction) {
    if(direction == VERTICAL) {
      drag_direction = VERTICAL;
    } else if(direction == CIRCULAR) {
      drag_direction = CIRCULAR;
    } else {
      drag_direction = HORIZONTAL;
    }
    return this;
  }

  public R_Knob set_drag_force(float force) {
    this.drag_force = force;
    return this;
  }




  // ASPECT MOLETTE and GUIDE

  public R_Knob set_fill_mol(int c) {
    set_fill_mol(c,c);
    return this;
  }

  public R_Knob set_fill_mol(int c_in, int c_out) {
    for(int i = 0 ; i < molette.length ; i++) {
      this.molette[i].set_fill_in(c_in);
      this.molette[i].set_fill_out(c_out);
    }
    this.guide.set_fill_in(c_in);
    this.guide.set_fill_out(c_out);
    return this;
  }
  
  public R_Knob set_stroke_mol(int c) {
    set_stroke_mol(c,c);
    return this;
  }

  public R_Knob set_stroke_mol(int c_in, int c_out) {
    for(int i = 0 ; i < molette.length ; i++) {
      this.molette[i].set_stroke_in(c_in);
      this.molette[i].set_stroke_out(c_out);
    }
    this.guide.set_stroke_in(c_in);
    this.guide.set_stroke_out(c_out);
    return this;
  }

  public R_Knob set_thickness_mol(float thickness) {
    for(int i = 0 ; i < molette.length ; i++) {
      this.molette[i].set_thickness(thickness);
    }
    this.guide.set_thickness(thickness);
    return this;
  }






  /**
   * 
   * @param open_knob
   * @return
   */
  public R_Knob limit(boolean open_knob) {
    this.open_knob = !open_knob;
    return this;
  }

  public R_Knob set_size_limit(float min, float max) {
    if(min > max) {
      this.size_limit.set(max,min);
      return this;
    }
    this.size_limit.set(min,max);
    return this;
  }


  /**
   * 
   * @param angle_a
   * @param angle_b
   * @return
   */
  public R_Knob set_limit(float angle_a, float angle_b) {
    if(angle_a > angle_b) {
      clockwise = false;
    } else {
      clockwise = true;
    }
    if(this.limit == null) {
      this.limit = new vec2(angle_a, angle_b);
      return this;
    }
    this.limit.set(angle_a, angle_b);
    return this;
  }

  @Deprecated public R_Knob set_range(float angle_a, float angle_b) {
    return set_limit(angle_a, angle_b);
  }




  // get
  /**
   * for the future when there is more molette
   */
  public float get(int index) {
    if(index >= 0 && index < molette.length)
      return this.molette[index].angle();
    return Float.NaN;
  }

  public float get() {
    return get(0);
  }

  public float [] get_all() {
    float [] value_array = new float[this.molette.length];
    for(int i = 0 ; i < value_array.length ; i++) {
			value_array[i] = get(i);
		}
    return value_array;
  }

  public R_Mol [] get_mol() {
    R_Mol [] arr_mol = new R_Mol[this.molette.length + 1];
    int index = 0;
    while(index < this.molette.length) {
      arr_mol[index] = this.molette[index];
      index++;
    }
    arr_mol[index] = this.guide;
    return arr_mol;
  }

  public R_Mol get_mol(int index) {
    R_Mol [] arr = get_mol();
    if(index > 0 && index < arr.length) {
      return arr[index];
    }
    return null;
  }



  
  // show
  public void show_limit() {
    boolean on_off_is = true;
    if(!open_knob) {
      strokeWeight(1);
      int c = 0;
      if(on_off_is) {
        if (is) {
          if (inside() && auth_rollover) {
            c = stroke_out_ON; 
          } else {
            c = stroke_in_ON;
          }
        } else {
          if (inside() && auth_rollover) {
            c = stroke_out_OFF; 
          } else {
            c = stroke_in_OFF;
          }
        }
        stroke(c);
      } else {
        stroke(c);
      }
      vec2 final_pos = pos.copy().add(size.copy().mult(0.5f));
      float radius = size.x()*0.5f;
      vec2 a_min = projection(limit.a(),radius+size_limit.min()).add(final_pos);
      vec2 b_min = projection(limit.a(),radius+size_limit.max()).add(final_pos);
      line(a_min,b_min);

      vec2 a_max = projection(limit.b(),radius+size_limit.min()).add(final_pos);
      vec2 b_max = projection(limit.b(),radius+size_limit.max()).add(final_pos);      
      line(a_max,b_max);
    }
  }


  public void show_mol() {
    for(int i = 0 ; i < molette.length ; i++) {
      if(!init_molette_is) {
       this.molette[i].pos(projection(this.molette[i].angle(), this.molette[i].get_dist()));
      }
      this.molette[i].show();
    }
    init_molette_is = true;
  }

  public void show_guide() {
    if(molette.length > 1) {
      vec2 offset = add(this.pos, this.size().copy().div(2));
      this.guide.pos(projection(this.guide.angle(), this.guide.get_dist()).add(offset));
      this.guide.show();

    }
  }

  public void show_struc_pie() {
    aspect_impl(true);
    vec2 buf_pos = pos.copy().add(size.x() /2, size.y() / 2);
    float ang_a = this.molette[0].angle();
    if(molette.length > 1) {
      float ang_b = this.molette[molette.length -1].angle();
      if(clockwise) {
        print_out(ang_a, ang_b);
        arc(buf_pos,size,ang_a, ang_b, PIE);
        return;
      }
      // clockwise false
      arc(buf_pos,size,ang_b, ang_a, PIE);
      return;

    } 
    arc(buf_pos,size,0,ang_a,PIE);
    return; 
  }

  // public void show_struc_pie() {
  //   aspect_impl(true);
  //   vec2 buf_pos = pos.copy().add(size.x() /2, size.y() / 2);
  //   float ang_a = this.molette[0].angle();
  //   if(molette.length > 1) {
  //     float ang_b = this.molette[molette.length -1].angle();
  //     if(clockwise) {
  //       print_out("clockwise : true");
  //       if(ang_a < ang_b) {
  //         print_out("ang_a <<<<< ang_b");
  //         arc(buf_pos,size,ang_b, ang_a, PIE);
  //         return;
  //       }
  //       print_out("ang_a >>>> ang_b");
  //       arc(buf_pos,size,ang_a, ang_b, PIE);
  //       return;
  //     } else {
  //       print_out("clockwise : false");
  //       if(ang_a < ang_b) {
  //         print_out("ang_a <<<<< ang_b");
  //         arc(buf_pos,size,ang_a, ang_b, PIE);
  //         return;
  //       }
  //       print_out("ang_a >>>> ang_b");
  //       arc(buf_pos,size,ang_b, ang_a, PIE);
  //       return;
  //     }
  //   } else {
  //     arc(buf_pos,size,0,ang_a,PIE);
  //     return; 
  //   }
  // }




  // update

  /**
   * 
   */
  public void update() {
    boolean new_event = all(State.env().event.a(),State.env().event.b(), State.env().event.c());
    update(State.env().pointer.x(),State.env().pointer.y(),new_event);
  }
  
  @Deprecated public void update(float x, float y) {
    boolean new_event = all(State.env().event.a(),State.env().event.b(), State.env().event.c());
    update(x,y,new_event);
  }

  /**
   * 
   * @param x
   * @param y
   * @param event
   */
  public void update(float x, float y, boolean event) {
    cursor(x,y);
    this.event = event;
    boolean bang_is = any(State.env().bang.a(), State.env().bang.b(), State.env().bang.c());

    if(!clockwise) {
      // in this case add full clockwise tour to the max component????
      vec2 temp_limit = this.limit.copy().add_y(TAU);
      guide_update(bang_is, temp_limit);
      molette_update(bang_is, temp_limit);
    } else {
      guide_update(bang_is, this.limit);
      molette_update(bang_is, this.limit);
    }
  }




  // guide molette update
  private void guide_update(boolean bang_is, vec2 ang_limit) {
    boolean inside_is = this.guide.inside(cursor);
    boolean used_is = all(inside_is, bang_is, !mol_used_is);
    this.guide.inside_is(inside_is);
    if(this.event) {
      if(used_is) {
        this.guide.used(true);
        mol_used_is = true;
      }
    } else {
      this.guide.used(false);
    }

    if(this.guide.used_is()) {
      float angle = calc_angle_imp(this.guide.angle());
      float dif = angle - this.guide.angle();
      molette_update_from_guide(dif, ang_limit);
      render_mol(this.guide, angle);
    } else {
      guide_update_from_molette();
      mol_used_is = false;
    }
  }

  private void guide_update_from_molette() {
    float angle = 0;
    for(int i = 0 ; i < molette.length ; i++) {
      angle += this.molette[i].angle();
    }
    angle /= molette.length;
    this.guide.angle(angle);
  }

  private void molette_update_from_guide(float dif_angle, vec2 ang_limit) {
    for(int i = 0; i < molette.length ; i++) {
      float ref_angle = molette[i].angle();
      float new_angle = ref_angle + dif_angle;
      if(!this.open_knob) {
        new_angle = calc_constrain_angle(i, new_angle, ang_limit);
      }
      molette_update_position(i, ref_angle, new_angle, ang_limit);
    }
  }







  // molette update
  private void molette_update(boolean bang_is, vec2 ang_limit) {
    for(int i = 0 ; i < molette.length ; i++) {
      this.molette[i].set_offset(pos.copy().add(size.copy().mult(0.5f)));
      boolean inside_is = this.molette[i].inside(cursor);
      boolean used_is = all(inside_is, bang_is, !mol_used_is);

      this.molette[i].inside_is(inside_is);
      if(used_is && this.event) {
        this.molette[i].used(true);
        mol_used_is = true;
      }
      if(!this.event) {
        this.molette[i].used(false);
        previous_angle_ref = this.molette[i].angle();
        ref_angle_is = false;
      }

      if(this.molette[i].used_is()) {
        float buf_angle = calc_angle(i, this.molette[i].angle(), ang_limit);
        molette_update_position(i, this.molette[i].angle(), buf_angle, ang_limit);
      } else {
        mol_limit_is[i].set(false);
        mol_used_is = false;
      }
      // finalize
      float angle = constrain_value(molette[i].angle(), this.limit);
      molette[i].angle(angle);
    }
  }


  private boolean ref_angle_is = false;
  private void molette_update_position(int index, float ref_angle, float new_angle, vec2 ang_limit) {
    if(all(clockwise, mol_limit_is[index].x()) ) {
      new_angle = ref_angle;
    }

    if(all(!clockwise, mol_limit_is[index].y())) {
      new_angle = ref_angle;
    }
    
    float dif = abs(ref_angle - new_angle);
    if(any(mol_limit_is[index]) && dif < threshold) {
      ref_angle = new_angle;
    } else if(!all(mol_limit_is[index])) {
      ref_angle = new_angle;
    }
    render_mol(this.molette[index], ref_angle);
  }


  private float calc_angle(int index, float angle, vec2 ang_limit) {
    angle = calc_angle_imp(angle);
    if(!this.open_knob) {
      angle = calc_constrain_angle(index, angle, ang_limit);
    }
    return angle;
  }





  private float calc_angle_imp(float angle) {
    if(drag_direction == HORIZONTAL) {
      angle = cursor.x() * drag_force;
    } else if(drag_direction == CIRCULAR) {
      vec2 temp = pos.copy().add(size.copy().mult(0.5f));
      angle = temp.angle(cursor);
      if(angle < 0) {
        angle+= TAU;
      }
    } else if(drag_direction == VERTICAL) {
      angle = cursor.y() * drag_force;
    }
    return angle;
  }



  private void render_mol(R_Mol mol, float angle) {
    if(drag_direction != CIRCULAR) {
      if(!ref_angle_is) {
        next_angle_ref = angle;
        ref_angle_is = true;
      }
      float new_angle = previous_angle_ref + (angle -next_angle_ref);
      mol.angle(new_angle);
      mol.pos(projection(new_angle, mol.get_distance()));
    } else if(drag_direction == CIRCULAR) {
      mol.angle(angle);
      mol.pos(projection(angle, mol.get_distance()));
    }
  }




  /**
   * 
   * CONSTRAIN PART
   */

   private float calc_constrain_angle(int index, float angle, vec2 ang_limit ) {
    // print_out("frameCount", pa.frameCount);
    // print_out("ang_limit.a()", ang_limit.a());
    // print_out("ang_limit.b()", ang_limit.b());
    // print_out("angle", angle);
    float current_angle = molette[index].angle();

    boolean inf_a_is = angle < ang_limit.a();
    boolean sup_b_is = angle > ang_limit.b();

    boolean inf_a_b_is = all(angle < ang_limit.b()%TAU, inf_a_is);
    boolean inf_b_is = angle < ang_limit.b()%TAU;


    // special case where the angle restart just after min value on big value
    if(all(!clockwise, inf_a_is, abs(current_angle - ang_limit.b()) < threshold)) {
      mol_limit_is[index].y(true);
      return ang_limit.b();
    }

    if(inf_a_is && !inf_a_b_is) {
      mol_limit_is[index].x(true);
      return ang_limit.a();
    }

    // special case where the angle restart just after min value on big value
    if(all(clockwise, sup_b_is, abs(current_angle - ang_limit.a()) < threshold)) {
      mol_limit_is[index].x(true);
      return ang_limit.a();
    }

    if(sup_b_is) {
      mol_limit_is[index].y(true);
      return ang_limit.b();
    }
    return angle;
  }



  private float constrain_value(float angle, vec2 ang_limit) {
    angle = abs(angle)%TAU;
    if(ang_limit.a() > ang_limit.b()) {
      if(angle < ang_limit.a() && angle > ang_limit.b()) {
        return closer(angle, ang_limit.a(), ang_limit.b());
      } 
    } else {
      if(angle <= ang_limit.a()) {
        return ang_limit.a();
      }
      if(angle > ang_limit.b()) {
        return ang_limit.b();
      }
    }
    return angle;
  }

  private float closer(float val, float a, float b) {
    float diff_a = abs(val-a);
    float diff_b = abs(val-b);
    if(diff_a > diff_b) {
      return b;
    } else {
      return a;
    }
  }

}