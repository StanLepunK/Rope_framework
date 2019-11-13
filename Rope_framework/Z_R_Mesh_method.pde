/**
* R_Bloc method
* v 0.0.1
* 2019-2019
*/
R_Bloc create_bloc(vec2 [] points) {
	R_Bloc bloc = new R_Bloc();
	for(vec2 v : points) {
		bloc.build(v.x(),v.y(),true);
	}
	return bloc;
}

/**
* R_Megabloc method
* v 0.1.0
* 2019-2019
*/
boolean add_point_to_bloc_is;
boolean add_point_to_bloc_is() {
	return add_point_to_bloc_is;
}

void add_point_to_bloc_is(boolean is) {
	add_point_to_bloc_is = is;
}

void bloc_show_structure(R_Megabloc megabloc) {
	for(R_Bloc b : megabloc.get()) {
		if(b.select_is()) {
			b.show_struct();
			b.show_anchor_point();
		}
	}
}

boolean bloc_show_available_point(R_Megabloc megabloc, int x , int y) {
	boolean event_is = false;
	for(R_Bloc b : megabloc.get()) {
		if(b.select_is()) {
			if(b.show_available_point(x,y)) {
				event_is = true;
			}
		}
	}
	return event_is;
}

boolean add_new_bloc_is = true;
void check_for_new_bloc(R_Megabloc megabloc) {
	boolean check_for_new_bloc_is = false;
	// check the last current building bloc
	if(megabloc.size() > 0) {
		int last_index = megabloc.size() - 1;
		R_Bloc b = megabloc.get(last_index);
		if(b.end_is()) {
			check_for_new_bloc_is = true;
		}
	} else {
		check_for_new_bloc_is = true;
	}

	// use the result
	if(check_for_new_bloc_is) {
		add_new_bloc_is = true;
	}
}

void new_bloc(R_Megabloc megabloc) {
	R_Bloc bloc = new R_Bloc();
	int id = megabloc.size();
	bloc.set_id(id);
	bloc.set_magnetism(10);
	bloc.set_colour_build(r.CYAN);
	megabloc.add(bloc);
}

void bloc_draw(R_Megabloc megabloc, int x, int y, boolean event_is, boolean show_struc_is) {
	if(show_struc_is) {
		for(R_Bloc b : megabloc.get()) {
			if(b.select_is() || !b.end_is()) {
				if(event_is) {
					b.build(x,y,add_point_to_bloc_is());
					add_point_to_bloc_is(false);
				}
				b.show_struct();
				b.show_anchor_point();
			}	
		}
	}
}

void bloc_remove_single_select(R_Megabloc megabloc) {
	int index = -1;
	for(int i = 0 ; i < megabloc.size() ; i++) {
		R_Bloc b = megabloc.get().get(i);
		if(b.select_is()) {
			index = i;
		}
	}
	if(index > -1) {
		megabloc.remove(index);
	}
}


/**
* bloc management
*/
boolean bloc_move_event_is = false;
void bloc_move_event_is(boolean is) {
	bloc_move_event_is = is;
}

boolean bloc_move_event_is() {
	return bloc_move_event_is;
}


void bloc_show_point(float x, float y) {
	for(R_Bloc b : megabloc.get()) {
		if(b.select_is() || b.in_bloc(x,y)) {
			b.show_struct();
		}
		if(b.select_point_is()) { 
			b.show_anchor_point();
		}
	}
}

/**
* bloc move point
*/
void bloc_select_all_point(R_Megabloc megabloc, float x, float y, boolean event_is) {
	// reset
	if(event_is && !bloc_move_event_is()) {
		for(R_Bloc b : megabloc.get()) {
			if(!b.in_bloc(x,y)) {
				b.reset_all_points();
			}
		}
	}
	// select
	for(int index = megabloc.size() - 1 ; index >= 0 ; index--) {
		R_Bloc b = megabloc.get(index);
		b.update(x,y);
		if(b.in_bloc(x,y)) {
			b.show_struct();
			if(!b.select_point_is() && !bloc_move_event_is()) {
				b.select_point_is(event_is);
				if(b.select_point_is()) {
					b.select_all_points();
					bloc_move_event_is(true);
				}
			}
			break;
		}
	}
}


void bloc_select_single_point(R_Megabloc megabloc, float x, float y, boolean event_is) {
	// select
	for(int index = megabloc.size() - 1 ; index >= 0 ; index--) {
		R_Bloc b = megabloc.get(index);
		b.update(x,y);
		if(!bloc_move_event_is()) {
			b.select_point_is(false);
		}

		b.show_anchor_point();
		if(!b.select_point_is()) {
			if(event_is) {
				b.select_point(x,y);
				bloc_move_event_is(true);
			} else {
				b.reset_all_points();
			}
		}
	}
}

int bloc_point_index = -1;
boolean bloc_move_point(R_Megabloc megabloc, float x, float y, boolean event_is) {
	boolean move_is = false;
	if(bloc_point_index < 0) {
		for(int index = 0 ; index < megabloc.size() ; index++) {
			R_Bloc b = megabloc.get(index);
			boolean is = false;
			bloc_point_index = - 1;
			if(event_is && b.select_point_is()) {
				bloc_point_index = index;
				is = true;
			  move_is = true;
				break;
			}
			b.move_point(x,y,is);
		}
	} else if(bloc_point_index >= 0) {
		R_Bloc b = megabloc.get(bloc_point_index);
		b.update(x,y);
		if(event_is && b.select_point_is()) {
			move_is = true;
			b.move_point(x,y,true);
		} else {
			bloc_point_index = -1;
		}
	}
	return move_is;
}


/**
* bloc move
*/
int bloc_index = -1;
void bloc_select(R_Megabloc megabloc, float x, float y, boolean event_is) {
	for(int index = megabloc.size() - 1 ; index >= 0 ; index--) {
		R_Bloc b = megabloc.get(index);
		b.update(x,y);
		if(b.in_bloc(x,y)) {
			b.show_struct();
			if(!b.select_is() && !bloc_move_event_is()) {
				b.select_is(event_is);
			}
			break;
		}
	}
}

boolean bloc_move(R_Megabloc megabloc, float x, float y, boolean event_is) {
	boolean move_is = false;
	if(bloc_index < 0) {
		for(int index = 0 ; index < megabloc.size() ; index++) {
			R_Bloc b = megabloc.get(index);
			boolean is = false;
			bloc_index = - 1;
			if(event_is && b.select_is()) {
				bloc_index = index;
				is = true;
			  move_is = true;
				break;
			}
			b.move(x,y,is);
		}
	} else if(bloc_index >= 0) {
		R_Bloc b = megabloc.get(bloc_index);
		if(event_is && b.select_is()) {
			move_is = true;
			b.update(x,y);
			b.move(x,y,true);
		} else {
			bloc_index = -1;
		}
	}
	return move_is;
}





/**
* load save
*/
void save_megabloc(R_Megabloc megabloc, String file_name, String path) {
	String [] save = new String[1];
	// header
	String name = "bloc file name:"+file_name;
	String elem = "elements:"+ megabloc.size();
	String w = "width:" + width;
	String h = "height:" + height;
	String mag = "magnetism:" + megabloc.get_magnetism();
	save[0] =  name + "," + elem + "," + w + ","+ h + "," + mag + "\n";
	// details
	for(R_Bloc r : megabloc.get()) {
		save[0] += (r.get_data() + "\n");
	}
	saveStrings(path+file_name+".blc",save);
}

String [] load_megabloc(String path_name) {
	String [] data = loadStrings(path_name);
	for(int i = 0 ; i < data.length ; i++) {
		println(data[i]);
	}
	if(data[0].split(",")[0].contains("bloc file name")) {
		return data;
	} else {
		return null;
	}
}

R_Megabloc read_megabloc(String [] file_type_blc) {
	R_Megabloc mb = new R_Megabloc();
	boolean is = true;
	String [] header = file_type_blc[0].split(",");
	// elem
	int elem = 0;
	if(header[1].contains("elements")) {
		elem = atoi(header[1].split(":")[1]);
	} else {
		is = false;
	}
	// magnetism
	int mag = 2;
	if(header[4].contains("magnetism")) {
		mag = atoi(header[4].split(":")[1]);
	}
	// bloc
	for(int i = 1 ; i <= elem ; i++) {
		String bloc_info [] = file_type_blc[i].split(",");
		if(bloc_info[0].contains("bloc") && bloc_info[2].contains("complexity")
				&& bloc_info[3].contains("fill") && bloc_info[4].contains("stroke") && bloc_info[5].contains("thickness")) {
			R_Bloc b = new R_Bloc();
			b.set_magnetism(mag);
			b.set_fill(atoi(bloc_info[3].split(":")[1]));
			b.set_stroke(atoi(bloc_info[4].split(":")[1]));
			b.set_thickness(atof(bloc_info[5].split(":")[1]));
			int start = 5;
			for(int n = start ; n < bloc_info.length ; n++) {
				if(bloc_info[n].contains("type")) {
					String [] coord = bloc_info[n].split("<>");
					float ax = atof(coord[1].split(":")[1]);
					float ay = atof(coord[2].split(":")[1]);
					b.build(ax,ay,true);
				}
			}
			mb.add(b);
		}
	}

	if(is)
		return mb;
	else
		return null;
}















/**
* R_Plane methods
* v 0.0.1
* 2019-2019
*
*/
boolean in_plane(vec3 a, vec3 b, vec3 c, vec3 any, float range) {
	vec3 n = get_plane_normal(a, b, c);
	// Calculate nearest distance between the plane represented by the vectors
	// a,b and c, and the point any
	float d = n.x()*any.x() + n.y()*any.y() + n.z()*any.z() - n.x()*a.x() - n.y()*a.y() - n.z()*a.z();
	// A perfect result would be d == 0 but this will not hapen with realistic
	// float data so the smaller d the closer the point. 
	// Here I have decided the point is on the plane if the distance is less than 
	// range unit.
	return abs(d) < range; 
}


vec3 get_plane_normal(vec3 a, vec3 b, vec3 c) {
	return new R_Plane().get_plane_normal(a,b,c);
}








