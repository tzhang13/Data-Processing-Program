//Libraries used in order to increment dates and times
import java.text.SimpleDateFormat;  
import java.util.Calendar;          
import java.util.Date; 
import java.text.DateFormat;
import java.util.GregorianCalendar;

PFont myFont; //sets the font for the text on the screen
PImage elevation; //allows the program to display a contour map

//Final variables
final int num_nodes = 10; //number of nodes
final int num_radio_nodes = 8; //number of radio nodes
final int framerate = 24; //frames per second
final int coordinate_factor = 1000; //Multiply all GPS coordinates by this factor 
final int num_radio_nodes_timestamps = 20;
final String oldestDateString = "2013-11-18T14:48:03"; 
final String oldestDateString_millisecond = "2013-11-18T14:48:03:000";

//Node variables
Node[] node = new Node[num_nodes]; //create an array of Node objects
float[] color_value = new float[num_nodes]; //assigns color values to each node for display

//Acceleration variables
String[] acceleration_file_one;
String[] acceleration_file_five;
Acceleration acceleration_one;
Acceleration acceleration_five;

//Variables used to load the acceleration file
String acceleration_file_month; 
String acceleration_file_day;
String acceleration_file_hour;
String acceleration_file_minute;

//Acceleration coordinates
float acceleration_back_view_x; 
float acceleration_back_view_y;
float acceleration_side_view_x; 
float acceleration_side_view_y; 

//Battery variables
float battery_icon_x; //coordinates to display the battery icons
float battery_icon_y; //coordinates to display the battery icons
String[][] battery_file = new String[num_nodes][]; //contains data from BAT.txt files
Battery[] battery = new Battery[num_nodes]; //create an array of Battery objects

//Camera variables
String[] camera_file_five; //camera files 
String[] camera_file_fifteen;
Camera camera_five; //Camera object
Camera camera_fifteen;

//Radio variables
Radio[] radio = new Radio[num_radio_nodes]; //Radio objects
String[] radio_file = new String[num_radio_nodes]; //radio files
int[] collision_radio_counter = new int[num_radio_nodes]; //variables that help the program search through radio files
int[] arrow_radio_counter = new int[num_radio_nodes]; //variables that help the program search through radio files
int[] show_radio_counter = new int[num_radio_nodes]; //variables that help the program search through radio files
String[][] node_timestamps = new String[num_radio_nodes][num_radio_nodes_timestamps];

//Transformation variables
float xmin, ymin, xmax, ymax;
float scale_factor = 1; //used for the scale() function
float zoom_scale_factor = 1; //used for the mouseWheel function
float stroke_weight;
float wheel_value = 0; //used for the mouseWheel function

//Mouse drag variables
float bx = width; 
float by = height; 
boolean locked = false;
float xOffset = 0.0; 
float yOffset = 0.0; 

//Time variables
String currentDateString; 
String currentDateString_millisecond;
String backDateString; //currentDateString minus one hour

float elapsed_viewing_time_sec, elapsed_data_time_sec; //seconds, elapsed viewing/data time
float marked_data_time = 0, marked_viewing_time; //used to increase/decrease the viewing ratio
float viewing_ratio = 1.0; 
int leftRightArrow = 0;

//Calendar variables
DateFormat myDateFormat; 
Date myOldTime; 
Calendar myCalendar; 

//myMillis variables
float myMillis = 0; //amount of time that the playback is active //used in case the data gets paused
float myPaused = 0; //time that the playback gets paused
float myDiff = 0; //difference in time between active time and paused time
boolean paused = false; //keeps track of whether the data needs to play/pause

//Reset variables
boolean reset = false;
float resetTime = 0;

//Time counter variables
int second_counter; 
int month_counter;
int dayOfMonth_counter;
int hourOfDay_counter;
int minute_counter;
int millisecond_counter;

//Pause variable
int loop = 0; 

//Metrics that will be displayed on the screen
float total_distance = 0;
int total_arrows = 0;
int num_collisions = 0;
int received_pings = 0;
int received_shares = 0;
int received_corrupted_shares = 0;
int transmitted_pings = 0;
int transmitted_shares = 0;
int bidirectional_arrows = 0;
int unidirectional_arrows = 0;
int extraneous_arrows = 0;
int clock_differences = 0;

void setup() {
  size(1300,650); 
  background(255); 
  frameRate(framerate);   
  rectMode(CORNERS);
  
  //Set up font characteristics
  myFont = createFont("Georgia", 12); 
  textFont(myFont); 
  textAlign(LEFT, CENTER); 
  
  //Set up the color values of each node    
  for (int i = 0; i < num_nodes; i++) {
    color_value[i] = i*255/num_nodes;
  }
  
  //Multiplies each reference point coordinate by the coordinate_factor
  for (int i = 0; i < reference_points_lat.length && i < reference_points_lon.length; i++) {
    reference_points_lat[i] *= coordinate_factor;
    reference_points_lon[i] *= coordinate_factor;
  }  
  
  battery_icon_x = width-175;
  battery_icon_y = 320;
  
  //Sets up Node and Battery objects
  for (int i = 0; i < node.length; i++) {
    if (i == 9) {
      node[i] = new Node("15/GPS.csv");
      battery_file[i] = loadStrings("15/BAT.TXT");
    } else {
      node[i] = new Node("0" + Integer.toString(i+1) + "/GPS.csv");
      battery_file[i] = loadStrings("0" + Integer.toString(i+1) + "/BAT.TXT");
    }
  }
   
  //Acceleration coordinates
  acceleration_back_view_x = 12*width/100; 
  acceleration_back_view_y = 30*height/100;
  acceleration_side_view_x = 2*width/5; 
  acceleration_side_view_y = 30*height/100; 
   
  //Load camera files 
  camera_file_five = loadStrings("05/CAM.TXT");
  camera_file_fifteen = loadStrings("15/CAM.TXT");
    
  //Set up radio files   
  radio_file[0] = "01/RADIO.TXT";
  radio_file[1] = "02/RADIO.TXT";
  radio_file[2] = "03/RADIO.TXT";
  radio_file[3] = "04/RADIO.TXT";
  radio_file[4] = "06/RADIO.TXT";
  radio_file[5] = "07/RADIO.TXT";
  radio_file[6] = "09/RADIO.TXT";
  radio_file[7] = "15/RADIO.TXT";
  
  for (int i = 0; i < collision_radio_counter.length; i++) {
    collision_radio_counter[i] = 0;
    arrow_radio_counter[i] = 0;
    show_radio_counter[i] = 0;
  }
  
  //Load contour map
  elevation = loadImage("elevation.bmp");
}


void draw() {
  fill(255); noStroke(); rect(0, 0, width, height); //white rectangle clears the screen every iteration
  fill(0); //allows text to be drawn
    
  if (key == '<' || keyCode == LEFT) {
    for (int i = 0; i < collision_radio_counter.length; i++) {
      collision_radio_counter[i] = 0;
      arrow_radio_counter[i] = 0;
      show_radio_counter[i] = 0;
    }
  }    
  
  pushMatrix(); //Transformations to the screen  
    
  xmin = min(reference_points_lon);
  ymin = min(reference_points_lat);
  xmax = max(reference_points_lon);
  ymax = max(reference_points_lat);
  
  if (wheel_value == 0) { //Calculates the scale factor
    if ((xmax - xmin) > (ymax - ymin)) { 
      scale_factor = 500 / (xmax - xmin);
    } else {
      scale_factor = 500 / (ymax - ymin);
    }
  } 
        
  translate(-reference_points_lon[0]*scale_factor*zoom_scale_factor+width/4, reference_points_lat[0]*scale_factor*zoom_scale_factor+height); 
  translate(bx, by); //used for the mouse drag feature
  if (wheel_value != 0) {
    scale(zoom_scale_factor);
  }
  scale(scale_factor);
  stroke_weight = 6 / scale_factor / zoom_scale_factor; //calculated so that each point has area 6
  strokeWeight(stroke_weight);
  
  //Loads contour map
  image(elevation, -78.1584*coordinate_factor, -38.903*coordinate_factor, .5*width/29, height/34);
  tint(128, 200);    
  
  //Assigns the currentDateString
  getTime();
  
  //Radio code
  for (int i = 0; i < radio.length; i++) {
    radio[i] = new Radio(radio_file[i], currentDateString); 
    show_radio_counter[i] = radio[i].showRadio(show_radio_counter[i]);
  }
    
  //Node code
  for (int i = 0; i < node.length; i++) {
    node[i].createGPS(currentDateString, backDateString, color_value[i]);
  } 
  
  //Creates the radio arrows
  for (int i = 0; i < radio.length; i++) {
    arrow_radio_counter[i] = radio[i].createArrows(arrow_radio_counter[i]);
  } 
  
  //Plots the reference points
  stroke(0, 128); strokeWeight(2*stroke_weight); fill(0);
  for (int i = 1; i < reference_points_lat.length && i < reference_points_lon.length; i++) {
    point(reference_points_lon[i], -reference_points_lat[i]);     
  }
  
  popMatrix();
  
  //Protects the right-hand side of the screen from the map
  fill(255);
  noStroke();
  rect(width-300, 0, width, height); 
  
  textSize(12);
  strokeWeight(stroke_weight); stroke(0); fill(0);  
  
  showTime(); //Displays the time on the upper-left hand screen
  create_legend(color_value); //create the legend for the GPS data (nodes and reference points)
  
  create_acceleration_file_name(); //loading the acceleration file name 
  
  //Acceleration code 
  try { 
    acceleration_file_five = loadStrings("05/" + acceleration_file_month + "" + acceleration_file_day + "" + acceleration_file_hour + "" + acceleration_file_minute + ".BIN" + ".txt"); 
  } catch (Exception f) { 
    println("Acceleration not working."); 
  } 
  if (acceleration_file_five != null) {
    acceleration_five = new Acceleration(acceleration_file_five, currentDateString);
    acceleration_five.create_acceleration_shape(acceleration_back_view_x, acceleration_back_view_y); //back view
    acceleration_five.create_acceleration_shape(acceleration_side_view_x, acceleration_side_view_y); //side view
    acceleration_five.displayText(acceleration_back_view_x, acceleration_back_view_y, acceleration_side_view_x, acceleration_side_view_y);
    acceleration_five.showAcceleration();
  }
  
  //Camera code
  //camera_five = new Camera(camera_file_five, currentDateString);
  //camera_five.showCamera();
  
  //Battery code 
  for (int i = 0; i < battery.length; i++) {
    battery[i] = new Battery(battery_file[i], currentDateString);
    battery[i].create_battery_icon(battery_icon_x, battery_icon_y+30*i);
    battery[i].showBattery(battery_icon_x, battery_icon_y+30*i);
  }
  
  //Collisions code   
  //A collision occurs when two different timestamps from different nodes come within 50 milliseconds of each other
  for (int i = 0; i < node_timestamps.length; i++) {
    for (int j = 0; j < node_timestamps[i].length; j++) {
      node_timestamps[i][j] = null;
    } 
  }
 
  for (int i = 0; i < radio.length; i++) {      
    if ((i < 4 && node[i].num_pts - 1 >= 0 && node[i].num_pts != node[i].num_pts_within) || (i >= 4 && i <= 5 && node[i+1].num_pts - 1 >= 0 && node[i+1].num_pts != node[i+1].num_pts_within) || (i == 6 && node[i+2].num_pts - 1 >= 0 && node[i+2].num_pts != node[i+2].num_pts_within) || (i == 7 && node[9].num_pts - 1 >= 0 && node[9].num_pts != node[9].num_pts_within)) {
      collision_radio_counter[i] = radio[i].getTimestamps(collision_radio_counter[i]);      
      for (int j = 0; j < radio[i].array_of_timestamps.length; j++) {
        if (radio[i].array_of_timestamps[j] != null) {
          node_timestamps[i][j] = radio[i].array_of_timestamps[j];
        } else {
          break;  
        }
      }
    }
  }

  num_collisions = 0;  
  for (int x = 0; x < node_timestamps.length; x++) {
    for (int y = 0; node_timestamps[x][y] != null && y < node_timestamps[x].length; y++) {
      for (int i = x+1; i < node_timestamps.length; i++) {
        for (int j = 0; node_timestamps[i][j] != null && j < node_timestamps[i].length; j++) {
          if (isCollision(node_timestamps[x][y], node_timestamps[i][j])) {
            num_collisions++;
          }
        }
      }
    }
  } 
    
  //Metrics code  
  received_pings = 0;
  received_shares = 0;
  received_corrupted_shares = 0;
  transmitted_pings = 0;
  transmitted_shares = 0;
  total_distance = 0;
  total_arrows = 0;
  bidirectional_arrows = 0;
  unidirectional_arrows = 0;
  extraneous_arrows = 0;
  clock_differences = 0;
  
  //Adding metrics from all radio nodes
  for (int i = 0; i < radio.length; i++) {
    received_corrupted_shares += radio[i].received_messages_corrupt;
    received_shares += radio[i].received_messages_shares;
    received_pings += radio[i].received_messages_ping;
    transmitted_shares += radio[i].transmitted_messages_shares;
    transmitted_pings += radio[i].transmitted_messages_ping;
    total_arrows += radio[i].num_arrows;
    total_distance += radio[i].distance_between_nodes;
    bidirectional_arrows += radio[i].bidirectional_arrows;
    unidirectional_arrows +=  radio[i].unidirectional_arrows;
    extraneous_arrows += radio[i].extraneous_arrows;
    for (int j = 0; j < radio[i].radio_time_array.length && radio[i].radio_time_array[j] != null; j++) {
      if (radio[i].findClockDifferences(radio[i].radio_time_array[j], radio[i].radio_node_array[j], radio[i].radio_message_array[j]) >= 0) {
        clock_differences += radio[i].findClockDifferences(radio[i].radio_time_array[j], radio[i].radio_node_array[j], radio[i].radio_message_array[j]);
      }
    }    
  }
  
  fill(0);
  text("Total Number of Received Shares: " + received_shares , width-300, 80);
  text("Total Number of Received Pings: " + received_pings , width-300, 95);
  text("Total Number of Corrupt Received Messages: " + received_corrupted_shares , width-300, 110);
  text("Total Number of Transmitted Shares: " + transmitted_shares, width-300, 125);  
  text("Total Number of Transmitted Pings: " + transmitted_pings, width-300, 140);    
  text("Number of Potential Collisions: " + num_collisions, width-300, 155);
  text("Total Number of Meters Traveled: " + (int) total_distance, width-300, 170);  
  text("Average Number of Meters Traveled per Arrow: " + (int) (total_distance/total_arrows), width-300, 185); 
  text("Number of Bidirectional Arrows: " + bidirectional_arrows, width-300, 200); 
  text("Number of Unidirectional Arrows: " + (unidirectional_arrows-bidirectional_arrows), width-300, 215);   
  text("Number of Extraneous Arrows: " + extraneous_arrows, width-300, 230);  
  text("Clock Differences(in seconds): " + clock_differences/1000.0, width-300, 245);        
}

