class Textfile { //superclass
  
  String file_name;
  String[] data_file;
  String currentDateString;
  int i;
  int j;
  
  Textfile(String[] file, String dateString) {
    data_file = file;
    currentDateString = dateString;
  }
  
  Textfile(String file, String dateString) {
    file_name = file;
    currentDateString = dateString;
  }
  
}

class Acceleration extends Textfile {
  
  int[] acceleration_data;
  int acceleration_size;
  int[] xaccel, yaccel, zaccel;
  int xacc, yacc, zacc;
  int index_acc = 0;
  int index;
  int graph_index;
  float magnitude;
  
  float x = acceleration_back_view_x; //Coordinate values
  float y = acceleration_back_view_y;
  float x2 = acceleration_side_view_x; 
  float y2 = acceleration_side_view_y;
  
  Acceleration(String[] file, String dateString) {
    super(file, dateString);
  } 
  
  //Creates the back view and side view shape without the data
  void create_acceleration_shape(float x, float y) {
    beginShape();
    noFill();
    stroke(0);
    strokeWeight(2);
    vertex(x-64,y+64);
    vertex(x+64,y+64);
    vertex(x+64,y-64);
    vertex(x-64,y-64);
    vertex(x-64,y+64);
    endShape();
    
    strokeWeight(4);
    stroke(0);
    line(x-10, y, x+10, y); //place for 0-value
    line(x-10, y+128, x+10, y+128); //place for xmax
    line(x-10, y-128, x+10, y-128); //place for xmin
    line(x, y-10, x, y+10); //place for 0-value
    line(x-128, y-10, x-128, y+10); //place for ymax
    line(x+128, y-10, x+128, y+10); //place for ymin
  }

  //Displays the text for the back view and side view shapes and draws the arrows to represent the graph
  void displayText(float x, float y, float x2, float y2) {
    fill(0);
    text("Back View", x-30, y-128-60);
    text("Side View", x2-30, y2-128-60);
    text("X-min", x-20, y-128-20);
    text("X-max", x-20, y+128-20);
    text("Z-max", x2-128-20, y2-30);
    text("Z-min", x2+128-20, y2-30);
    text("X-min", x2-20, y2-128-20);
    text("X-max", x2-20, y2+128-20);
    text("Y-min", x-128-20, y-30);
    text("Y-max", x+128-20, y-30);
    strokeWeight(4);
    stroke(0);
    arrow(50, height/2+50+256, 50, height/2+50);
    arrow(30, height/2+50+128, 300, height/2+50+128);
    strokeWeight(1);
  }
  
  //Loads all of the data and the text
  void showAcceleration() {
    index = (second_counter-8)*50;
    if (second_counter >= 8 && second_counter < 38) {
      for (i = 0 ; i < data_file.length; i++) {
        //plots acceleration data at 50 samples per second
        if (i == index && i+millisecond_counter/20 < data_file.length) {
          acceleration_data = int(split(data_file[i+millisecond_counter/20], ','));
        } else if (i > index) {
          break;
        }
      }
    }
        
    //Every time the sample number reaches a multiple of 250, the graph starts over again with new data.    
    graph_index = index;
    while (graph_index >= 250) {
      graph_index -= 250; 
    }
    
    //Loads the data for the graph
    if (second_counter >= 8 && second_counter < 38 && index < data_file.length) {
      for (i = index-graph_index; i < index+millisecond_counter/20; i++) {
        acceleration_data = int(split(data_file[i], ','));
        strokeWeight(7);
        stroke(0,0,255);
        point(graph_index+50+ i-index, height/2+50+128-acceleration_data[0]/4);
        stroke(255,0,0);
        point(graph_index+50+ i-index, height/2+50+128-acceleration_data[1]/4);
        stroke(0,255,0);
        point(graph_index+50+ i-index, height/2+50+128-acceleration_data[2]/4);
        strokeWeight(1);
        stroke(0);
      }
    }
    
    if (second_counter >= 8 && second_counter < 38) {
      //Loads the bars onto the back/side view shapes
      noStroke();
      fill(0,0,255);
      rect(x-10, y, x+10, y+acceleration_data[0]/4); //x-bar
      rect(x2-10, y2, x2+10, y2+acceleration_data[0]/4); //side view
      fill(255,0,0);
      rect(x, y-10, x+acceleration_data[1]/4, y+10); //y-bar
      fill(0,255,0,150);
      ellipse(x,y, abs(acceleration_data[2]/2), abs(acceleration_data[2])/2); //z-bar
      fill(0,255,0);
      rect(x2, y2-10, x2-acceleration_data[2]/4, y2+10); //z-bar side view
      fill(255,0,0,150);
      ellipse(x2,y2, abs(acceleration_data[1]/2), abs(acceleration_data[1])/2); //y-bar side view
      
      //Displays the statistics for the acceleration data
      fill(0,0,255);
      text("X value: " + acceleration_data[0], width-600, 10);
      fill(255,0,0);
      text("Y value: " + acceleration_data[1], width-600, 40);
      fill(0,255,0);
      text("Z value: " + acceleration_data[2], width-600, 70);
      fill(0);
      if (index + millisecond_counter/20 < data_file.length) {
        text("Sample Number: " + (index + millisecond_counter/20) + "/" + (data_file.length - 1), width-600, 100);
      } else {
        text("Sample Number: " + (data_file.length - 1) + "/" + (data_file.length - 1), width-600, 100);
      }
      magnitude = sqrt(sq(acceleration_data[0])+sq(acceleration_data[1])+sq(acceleration_data[2]));
      text("Magnitude of vector: " + (int) magnitude, width-600, 130);
      fill(0,0,255);
      text("Angle between itself and +x-axis: " + (int) degrees(acos(acceleration_data[0]/magnitude)), width-600, 160);
      fill(255,0,0);
      text("Angle between itself and +y-axis: " + (int) degrees(acos(acceleration_data[1]/magnitude)), width-600, 190);
      fill(0,255,0);
      text("Angle between itself and +z-axis: " + (int) degrees(acos(acceleration_data[2]/magnitude)), width-600, 220);
    }
  }
  
}

class Camera extends Textfile { 
  
  String[] camera_data;
  String[] nearest_neighbor;
  String[] nearest_neighbor_node;
  String[] distance_from_NN;
  boolean same_DTG = false;
  
  Camera(String[] file, String dateString) {
    super(file, dateString);
  } 

  void showCamera() {
    fill(111,55,134);
    for (i = 0 ; i < data_file.length; i++) {
      camera_data = split(data_file[i], ',');      
      same_DTG = compareDTG(camera_data[0], currentDateString); 
      //This function makes sure both timestamps have the same year, same month, same day, same hour, and same minute
      if (same_DTG) {
        if (camera_data[2].equals("O")) { //determines whether or not the camera is current recording
          fill(255);
          ellipse(width-290, 140, 20, 20);
        } else if (camera_data[2].equals("R")) {
          text("REC", width-270, 140);
          noStroke();
          fill(255,0,0,128);
          ellipse(width-290, 140, 20, 20);
          stroke(1);
        }
        fill(111,55,134);
        if (camera_data.length == 5) { //there is no nearest neighbor
          nearest_neighbor = split(camera_data[3], "n/a");
          text("No Nearest Neighbor Detected. ", width-300, 170);
          if (camera_data[2].equals("O")) { 
            text("Camera on for " + nearest_neighbor[0] + " min.", width-270, 140);
          } else if (camera_data[2].equals("R")) {
            text("Camera on for " + nearest_neighbor[0] + " min.", width-220, 140);
          }
        } else if (camera_data.length == 6 || camera_data.length == 7) { //there is a nearest neighbor
          nearest_neighbor = split(camera_data[3], "NN: ");
          if (camera_data[2].equals("O")) { 
            text("Camera on for " + nearest_neighbor[0] + " min.", width-270, 140);
          } else if (camera_data[2].equals("R")) {
            text("Camera on for " + nearest_neighbor[0] + " min.", width-220, 140);
          }
          text("Timestamp used to calculate NN: ", width-300, 170);
          text(nearest_neighbor[1], width-300, 200);
          nearest_neighbor_node = split(camera_data[4], " (");
          distance_from_NN = split(nearest_neighbor_node[1], "/");
          text("Node of NN: " + nearest_neighbor_node[0] + ". Distance from NN: " + distance_from_NN[0], width-300, 230);
          if (camera_data.length == 7) {
            if (camera_data[5].contentEquals("attempt OFF")) {
              text("Camera Will Be Turned Off", width-300, 260);
            } else if (camera_data[5].contentEquals("attempt REC")) {
              text("Camera Will Be Turned On", width-300, 260);
            } 
          }
        }
        break; 
      }
    }
  }
  
}  

class Battery extends Textfile {
  
  String[] battery_data_a;
  String[] battery_data_b;
  
  Battery(String[] file, String dateString) {
    super(file, dateString);
  }   
  
  //Goes through the text file and finds the battery's state of charge.
  void showBattery(float battery_icon_x, float battery_icon_y) {
    fill(255,141,0);
    for (i = 0 ; i < data_file.length-1; i++) {
      battery_data_a = split(data_file[i], ',');
      battery_data_b = split(data_file[i+1], ',');
      if (currentDateString.compareTo(battery_data_a[0]) >= 0 && currentDateString.compareTo(battery_data_b[0]) < 0) {
        rect(battery_icon_x, battery_icon_y, battery_icon_x+int(battery_data_a[3]), battery_icon_y+20);
        fill(0);
        textSize(20);
        text(battery_data_a[3] + "%", battery_icon_x+25, battery_icon_y+6);
        //The percent shown in the battery always corresponds to the fourth entry.
        textSize(12);
        break;
      }
    }
  }
  
  //Creates the visual battery on the screen near the key
  void create_battery_icon(float battery_icon_x, float battery_icon_y) {
    beginShape();
    noFill();
    stroke(0);
    strokeWeight(2);
    vertex(battery_icon_x, battery_icon_y);
    vertex(battery_icon_x+100, battery_icon_y);
    vertex(battery_icon_x+100, battery_icon_y+7);
    vertex(battery_icon_x+110, battery_icon_y+7);
    vertex(battery_icon_x+110, battery_icon_y+13);
    vertex(battery_icon_x+100, battery_icon_y+13);
    vertex(battery_icon_x+100, battery_icon_y+20);
    vertex(battery_icon_x, battery_icon_y+20);
    vertex(battery_icon_x, battery_icon_y);
    endShape(); 
  }
  
}

class Radio extends Textfile {
  
  String[] radio_data_a;
  String[] radio_data_b;
  String[] file_split;
  String radio_node;
  String radio_message;
  String radio_time;
  int received_messages_ping = 0;
  int received_messages_shares = 0;
  int received_messages_corrupt = 0;
  int transmitted_messages_ping = 0;
  int transmitted_messages_shares = 0;
  int timestamps_counter = 0;
  String[] array_of_timestamps = new String[20];
  boolean correct_time = false;
  boolean inside_loop = false;
  boolean show_radio = false;
  String[] radio_node_array = new String[20];
  String[] radio_message_array = new String[20];
  String[] radio_time_array = new String[20];
  String[] radio_node_transmission_array = new String[20];
  String[] radio_message_transmission_array = new String[20];
  String[] radio_time_transmission_array = new String[20];
  final String[] node_names = {"409B234F", "40A48A6A", "40A48A67", "409B234E", "40A45FB5", "40A460B2", "409B2320", "409B2352", "409B2336", "40A84EF9"};
  int radio_index;
  int node_index;
  int time_difference;
  float distance_between_nodes = 0;
  int num_arrows = 0;
  int unidirectional_arrows = 0;
  int bidirectional_arrows = 0;
  int extraneous_arrows = 0;
  int clock_differences = 0;
  int num_node_counter = 0;
  float stroke_weight_scale = 0;
  boolean isPing = false;
    
  Radio(String file, String dateString) {
    super(file, dateString);
    data_file = loadStrings(file);
    file_split = split(file, '/');
    //based on the node number, gets the node array index and radio array index
    switch (Integer.parseInt(file_split[0])) {
      case 01:
        radio_index = 0;
        node_index = 0;
        break;
      case 02:
        radio_index = 1;
        node_index = 1;
        break;  
      case 03:
        radio_index = 2;
        node_index = 2;
        break;
      case 04:
        radio_index = 3;
        node_index = 3;
        break;
      case 06:
        radio_index = 4;
        node_index = 5;
        break;  
      case 07:
        radio_index = 5;
        node_index = 6;
        break;
      case 9:
        radio_index = 6;
        node_index = 8;
        break;
      case 15:
        radio_index = 7;
        node_index = 9;
        break;  
    }
  } 

  //Draws the arrows connecting the nodes, colors the ping triangles, and calculates the data for the metrics
  int createArrows(int start) {
    for (int i = start, j = 0, a = 0; i < data_file.length-1; i++) {
      radio_data_a = split(data_file[i], ',');
      if (i == start && currentDateString_millisecond.compareTo(radio_data_a[0]) < 0) {
        break;
      }
      if (compareDTG_millisecond(currentDateString_millisecond, radio_data_a[0])) { 
        if (!inside_loop) {
          start = i-1;
        }
        inside_loop = true;       
        if (currentDateString_millisecond.compareTo(radio_data_a[0]) >= 0) {
          for (int k = 0; k < node_names.length; k++) {
            if (node_names[k].equals(radio_data_a[1])) {
              radio_time_array[j] = radio_data_a[0];
              radio_node_array[j] = radio_data_a[1];
              radio_message_array[j] = radio_data_a[2];
              j++;
              break;
            } else if (radio_data_a[1].equals("FFFF")) {           
              radio_time_transmission_array[a] = radio_data_a[0];
              radio_node_transmission_array[a] = radio_data_a[1];
              radio_message_transmission_array[a] = radio_data_a[2];                            
              a++;
              break;
            }
          }                  
        }
      } else if (inside_loop && !compareDTG_millisecond(currentDateString_millisecond, radio_data_a[0])) { 
        for (; j < radio_time_array.length ; j++) {
           radio_time_array[j] = null;
           radio_node_array[j] = null;
           radio_message_array[j] = null;
        } 
        for (; a < radio_time_transmission_array.length ; a++) {
           radio_time_transmission_array[a] = null;
           radio_node_transmission_array[a] = null;
           radio_message_transmission_array[a] = null;
        }       
        break;  
      }
    }          
    
    unidirectional_arrows = 0;
    bidirectional_arrows = 0;
    num_arrows = 0;
    extraneous_arrows = 0;
    clock_differences = 0;
    for (int i = 0; i < radio_time_array.length && radio_time_array[i] != null; i++) {
      colorMode(HSB);        
      distance_between_nodes = 0;   
      if (isBidirectional(radio_node_array, i)) {
        bidirectional_arrows++;
      } else if (isUnidirectional(radio_node_array, i)) {
        unidirectional_arrows++;
      }   
      for (int z = radio_message_transmission_array.length-1; z >= 0; z--) {
        if (radio_message_transmission_array[z] != null && radio_message_transmission_array[z].compareTo("!") == 0 && (time_difference = getSeconds(currentDateString_millisecond) - getSeconds(radio_time_transmission_array[z])) <= 45) {     
          isPing = true;
          noStroke();
          fill(85, 255, 255, 255*(1-time_difference/45.0));      
          createTriangle(); 
          break;        
        } 
      }
      if (!isPing) {
        noStroke();
        fill(0,0,255);      
        createTriangle();  
      }
      for (int j = 0; j < node_names.length; j++) {        
        if (node_names[j].equals(radio_node_array[i]) && (time_difference = getSeconds(currentDateString_millisecond) - getSeconds(radio_time_array[i])) <= 45) {                      
          stroke(colorArrow(radio_message_array[i]), 255, 255, 255*(1-time_difference/45.0));        
          if (node[j].num_pts - 1 >= 0 && node[j].num_pts != node[j].num_pts_within && node[node_index].num_pts != node[node_index].num_pts_within) {                      
            num_arrows++;
            distance_between_nodes += calc_distance_geo(node[j].yval[node[j].num_pts-1]/coordinate_factor, node[j].xval[node[j].num_pts-1]/coordinate_factor, node[node_index].yval[node[node_index].num_pts-1]/coordinate_factor, node[node_index].xval[node[node_index].num_pts-1]/coordinate_factor);            
            num_node_counter = 0;
            for (int p = i-1; p >= 0; p--) {
              if (radio_node_array[i].equals(radio_node_array[p]) && !radio_message_array[i].equals(radio_message_array[p])) {
                num_node_counter++;
              }
            }
            switch (num_node_counter) {
              case 0:
                stroke_weight_scale = 2;
                break;
              case 1:
                stroke_weight_scale = .75;
                break;
              case 2:
                stroke_weight_scale = .5;
                break;
              case 3:
                stroke_weight_scale = .25;
                break;
              default:
                stroke_weight_scale = 0;
                break;
            }
            strokeWeight(stroke_weight_scale*stroke_weight);
            arrow_GPS(node[j].xval[node[j].num_pts-1], -node[j].yval[node[j].num_pts-1], node[node_index].xval[node[node_index].num_pts-1], -node[node_index].yval[node[node_index].num_pts-1]);          
            strokeWeight(stroke_weight);
          } else {
            if (isBidirectional(radio_node_array, i)) {
              bidirectional_arrows--;
              extraneous_arrows++;
            } else if (isUnidirectional(radio_node_array, i)) {
              unidirectional_arrows--;
              extraneous_arrows++;
            }  
          }
        } 
      }      
      colorMode(RGB);  
    }
    inside_loop = false; 
    return start;
  }
  
  //Creates the triangle above the most recent GPS point
  void createTriangle() { 
    triangle(node[node_index].xval[node[node_index].num_pts-1]-25/calc_distance_geo(0,0,1,0)*coordinate_factor, -node[node_index].yval[node[node_index].num_pts-1]-50/calc_distance_geo(0,0,1,0)*coordinate_factor, node[node_index].xval[node[node_index].num_pts-1]+25/calc_distance_geo(0,0,1,0)*coordinate_factor, -node[node_index].yval[node[node_index].num_pts-1]-50/calc_distance_geo(0,0,1,0)*coordinate_factor, node[node_index].xval[node[node_index].num_pts-1], -node[node_index].yval[node[node_index].num_pts-1]-25/calc_distance_geo(0,0,1,0)*coordinate_factor);
  }
  
  //gets the number of seconds in a timestamp
  int getSeconds(String timestamp) {
    myDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss:SSS"); 
    Date calendar_time = null;
    int seconds_timestamp = -1;
    try {  
      calendar_time = myDateFormat.parse(timestamp);
    } catch (Exception e) { 
      println("Could not parse radio time.");
    }
    if (calendar_time != null) { 
      myCalendar = GregorianCalendar.getInstance();  
      myCalendar.setTime(calendar_time); 
      seconds_timestamp = myCalendar.get(Calendar.SECOND);
    }  
    return seconds_timestamp;
  }
  
  //gets the number of milliseconds in a timestamp
  int getMilliseconds(String timestamp) {
    myDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss:SSS"); 
    Date calendar_time = null;
    int milliseconds_timestamp = -1;
    try {  
      calendar_time = myDateFormat.parse(timestamp);
    } catch (Exception e) { 
      println("Could not parse radio time.");
    }
    if (calendar_time != null) { 
      myCalendar = GregorianCalendar.getInstance();  
      myCalendar.setTime(calendar_time); 
      milliseconds_timestamp = myCalendar.get(Calendar.MILLISECOND);
    }  
    return milliseconds_timestamp;
  }
  
  //Colors the arrow accoring to the radio message
  int colorArrow(String radio_message) {
    int color_value_arrow;
    if (radio_message.equals("!")) {
      color_value_arrow = 85;
    } else if (radio_message.equals("34")) {
      color_value_arrow = 170;
    } else if (radio_message.charAt(0) >= 48 && radio_message.charAt(0) <= 57) {
      color_value_arrow = 0;
    } else {
      color_value_arrow = 43;
    }
    return color_value_arrow;
  }  

  //Gets all of the timestamps that match the minute, hour, day, month, and year of the current datestamp
  int getTimestamps(int start) {
    int return_value = start;
    timestamps_counter = 0;
    for (i = start ; i < data_file.length; i++) {
      radio_data_a = split(data_file[i], ',');
      if (compareDTG_millisecond(currentDateString_millisecond, radio_data_a[0])) {      
        if (!correct_time) {
          return_value = i-1;
        }
        correct_time = true;
        if (timestamps_counter < array_of_timestamps.length) {
          array_of_timestamps[timestamps_counter] = radio_data_a[0];
          timestamps_counter++;
        }
      } else if (correct_time && !compareDTG_millisecond(currentDateString_millisecond, radio_data_a[0])) {
        correct_time = false;
        return return_value;
      }
    }    
    return start;    
  }

  //Counts received shares, received pings, corrupted received messages, transmitted pings, and transmitted messages
  int showRadio(int start) {
    int return_value = start;
    for (i = start ; i < data_file.length-1; i++) {
      radio_data_a = split(data_file[i], ',');
      radio_data_b = split(data_file[i+1], ',');
      if (currentDateString_millisecond.compareTo(radio_data_a[0]) >= 0 && currentDateString_millisecond.compareTo(radio_data_b[0]) < 0) {
        if (!show_radio) {
          return_value = i;
        }
        show_radio = true;
        if (!radio_data_a[0].equals("")) {
          radio_time = radio_data_a[0];
        }
        radio_node = radio_data_a[1];
        radio_message = radio_data_a[2]; 
        
        received_messages_ping = 0;
        received_messages_shares = 0;
        received_messages_corrupt = 0;
        transmitted_messages_ping = 0;
        transmitted_messages_shares = 0;
        if (compareDTG_millisecond(currentDateString_millisecond, radio_time) == true && radio_data_a[0].compareTo("") != 0) {
          for (j = i; j >= 0; j--) {
            radio_data_a = split(data_file[j], ',');
            if (compareDTG_millisecond(currentDateString_millisecond, radio_data_a[0]) == true && radio_data_a[0].compareTo("") != 0) {
              if (radio_data_a[1].compareTo("FFFF") == 0) { //transmitting a message                
                if (radio_data_a[2].compareTo("!") == 0) {
                  transmitted_messages_ping++;
                } 
                else if (radio_data_a[2].charAt(0) >= 48 && radio_data_a[2].charAt(0) <= 57) {
                  transmitted_messages_shares++;
                }
              }               
              else { //receiving a message
                if (radio_data_a[2].compareTo("!") == 0) {
                  received_messages_ping++;
                } else if (radio_data_a[2].compareTo("34") == 0) {
                  received_messages_shares++;
                } else if (radio_data_a[2].charAt(0) >= 48 && radio_data_a[2].charAt(0) <= 57) {
                  received_messages_corrupt++;
                }
              }
            } 
            else {
              break; 
            }            
          }
          for (j = i+1; j < data_file.length; j++) {
            radio_data_a = split(data_file[j], ',');
            if (compareDTG_millisecond(currentDateString_millisecond, radio_data_a[0]) == true && radio_data_a[0].compareTo("") != 0) {
              if (radio_data_a[1].compareTo("FFFF") == 0) { //transmitting a message
                if (radio_data_a[2].compareTo("!") == 0) {
                  transmitted_messages_ping++;
                } 
                if (radio_data_a[2].charAt(0) >= 48 && radio_data_a[2].charAt(0) <= 57) {
                  transmitted_messages_shares++;
                }
              }               
              else { //receiving a message
                if (radio_data_a[2].compareTo("!") == 0) {
                  received_messages_ping++;
                } else if (radio_data_a[2].compareTo("34") == 0) {
                  received_messages_shares++;
                } else if (radio_data_a[2].charAt(0) >= 48 && radio_data_a[2].charAt(0) <= 57) {
                  received_messages_corrupt++;
                }
              }
            } else {
              break; 
            }            
          }           
        }  
        break;
      }    
    }
    show_radio = false;
    return return_value;
  }
  
   //if one node’s radio file contains an entry that receives a certain message from another node 
   //and that other node’s radio file contains an entry that receives a certain message from the original node 
   //it gets counted as a bidirectional transmission
   boolean isBidirectional(String[] radio_node, int x) {
     int transmitting_radio_num = -1;
     
     //Do not count repeated nodes
     for (int i = x-1; i >= 0; i--) {
       if (radio_node[x].equals(radio_node[i])) {
         return false;
       }
     }
     
     for (int i = 0; i < node_names.length; i++) {
       if (node_names[i].equals(radio_node[x])) {
         if (i == 4 || i == 7) {
           return false; 
         } else {
           switch (i) { 
             case 0:
             case 1:
             case 2:
             case 3:
               transmitting_radio_num = i;
               break;
             case 5:
             case 6:
               transmitting_radio_num = i-1;
               break;
             case 8:
             case 9:
               transmitting_radio_num = i-2;
               break;
           }  
         }
         break;
       }
     }  
     
     for (int i = 0; i < radio[transmitting_radio_num].radio_node_array.length && transmitting_radio_num != -1; i++) {
       if (node_names[node_index].equals(radio[transmitting_radio_num].radio_node_array[i])) {
         return true;
       }
     }
                
     return false;
  }
  
  //Count for unidirectional arrows
  boolean isUnidirectional(String[] radio_node, int x) {
     int transmitting_radio_num = -1;
     
     //Do not count repeated nodes
     for (int i = x-1; i >= 0; i--) {
       if (radio_node[x].equals(radio_node[i])) {
         return false;
       }
     }
     for (int i = 0; i < node_names.length; i++) {
       if (node_names[i].equals(radio_node[x])) {
         if (i == 4 || i == 7) {
           return true; 
         } else {
           switch (i) {
             case 0:
             case 1:
             case 2:
             case 3:
               transmitting_radio_num = i;
               break;
             case 5:
             case 6:
               transmitting_radio_num = i-1;
               break;
             case 8:
             case 9:
               transmitting_radio_num = i-2;
               break;
           }  
         }
         break;
       }
     }  
     
     for (int i = 0; i < radio[transmitting_radio_num].radio_node_array.length && radio[transmitting_radio_num].radio_node_array[i] != null && transmitting_radio_num != -1; i++) {
       if (node_names[node_index].equals(radio[transmitting_radio_num].radio_node_array[i])) {
         return false;
       }
     }     
     return true;
  }
  
  //Clock difference is the difference between the time the receiving node gets a message from another node and the time the transmitting node transmitted the message 
  //The clock difference metric add up all differences from all nodes
  int findClockDifferences(String radio_time, String radio_node, String radio_message) {
     int difference_in_seconds = -1;
     int difference_in_milliseconds = -1;
     int transmitting_radio_num = -1;
     
     for (int i = 0; i < node_names.length; i++) {
       if (node_names[i].equals(radio_node)) {
         if (i == 4 || i == 7) {
           return -1; 
         } else {
           switch (i) {
             case 0:
             case 1:
             case 2:
             case 3:
               transmitting_radio_num = i;
               break;
             case 5:
             case 6:
               transmitting_radio_num = i-1;
               break;
             case 8:
             case 9:
               transmitting_radio_num = i-2;
               break;
           }  
         }
         break;
       }
     }  
          
     for (int i = 0; i < radio[transmitting_radio_num].radio_node_transmission_array.length && radio[transmitting_radio_num].radio_node_transmission_array[i] != null && transmitting_radio_num != -1; i++) {       
       if (radio_message.equals(radio[transmitting_radio_num].radio_message_transmission_array[i]) && radio_time.compareTo(radio[transmitting_radio_num].radio_time_transmission_array[i]) >= 0) {
         if (!(radio[transmitting_radio_num].radio_message_transmission_array[i].charAt(0) >= 48 && radio[transmitting_radio_num].radio_message_transmission_array[i].charAt(0) <= 57)) {
           difference_in_seconds = getSeconds(radio_time)-getSeconds(radio[transmitting_radio_num].radio_time_transmission_array[i]);
           difference_in_milliseconds = getMilliseconds(radio_time)-getMilliseconds(radio[transmitting_radio_num].radio_time_transmission_array[i]);
         }
       
       } else if (radio_message.equals("34") && radio_time.compareTo(radio[transmitting_radio_num].radio_time_transmission_array[i]) >= 0) {
         if ((radio[transmitting_radio_num].radio_message_transmission_array[i].charAt(0) >= 48 && radio[transmitting_radio_num].radio_message_transmission_array[i].charAt(0) <= 57)) {
           difference_in_seconds = getSeconds(radio_time)-getSeconds(radio[transmitting_radio_num].radio_time_transmission_array[i]);
           difference_in_milliseconds = getMilliseconds(radio_time)-getMilliseconds(radio[transmitting_radio_num].radio_time_transmission_array[i]);
         } 
       } else if (radio_message.charAt(0) >= 48 && radio_message.charAt(0) <= 57 && radio_time.compareTo(radio[transmitting_radio_num].radio_time_transmission_array[i]) >= 0) {
         if ((radio[transmitting_radio_num].radio_message_transmission_array[i].charAt(0) >= 48 && radio[transmitting_radio_num].radio_message_transmission_array[i].charAt(0) <= 57)) {
           difference_in_seconds = getSeconds(radio_time)-getSeconds(radio[transmitting_radio_num].radio_time_transmission_array[i]);
           difference_in_milliseconds = getMilliseconds(radio_time)-getMilliseconds(radio[transmitting_radio_num].radio_time_transmission_array[i]);
         } 
       }
     }     
     
     return (difference_in_seconds*1000 + difference_in_milliseconds);    
  }
  
}
  
