//For timestamps that do not have milliseconds
//This function makes sure both timestamps have the same year, same month, same day, same hour, and same minute
//Returns true if so, returns false if not
boolean compareDTG(String timestamp1, String timestamp2) {
  int year = -1; int month = -1; int day = -1; int hour = -1; int minute = -1;
  
  myDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss"); 
  myOldTime = null;
  try {  
    myOldTime = myDateFormat.parse(timestamp1);
  } catch (Exception e) { 
    println("Could not parse timestamp 1.");
  }
  if (myOldTime != null) { 
    myCalendar = GregorianCalendar.getInstance();  
    myCalendar.setTime(myOldTime); 
    year =  myCalendar.get(Calendar.YEAR);
    month = myCalendar.get(Calendar.MONTH) + 1;
    day = myCalendar.get(Calendar.DAY_OF_MONTH);
    hour = myCalendar.get(Calendar.HOUR_OF_DAY);
    minute = myCalendar.get(Calendar.MINUTE);
  }  
  
  try {  
    myOldTime = myDateFormat.parse(timestamp2);
  } catch (Exception e) { 
    println("Could not parse timestamp 2.");
  }
  if (myOldTime != null) { 
    myCalendar = GregorianCalendar.getInstance();  
    myCalendar.setTime(myOldTime); 
    if (year !=  myCalendar.get(Calendar.YEAR)) {
      return false;
    } else if (month != (myCalendar.get(Calendar.MONTH) + 1)) {
      return false;
    } else if (day != myCalendar.get(Calendar.DAY_OF_MONTH)) {
      return false;
    } else if (hour != myCalendar.get(Calendar.HOUR_OF_DAY)) {
      return false;
    } else if (minute != myCalendar.get(Calendar.MINUTE)) {
      return false;
    } 
  }
  return true; 
}

//For timestamps that have milliseconds
//This function makes sure both timestamps have the same year, same month, same day, same hour, and same minute
//Returns true if so, returns false if not
boolean compareDTG_millisecond(String timestamp1, String timestamp2) {
  int year = -1; int month = -1; int day = -1; int hour = -1; int minute = -1;
  
  myDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss:SSS"); 
  myOldTime = null;
  try {  
    myOldTime = myDateFormat.parse(timestamp1);
  } catch (Exception e) { 
    println("Could not parse timestamp 1.");
  }
  if (myOldTime != null) { 
    myCalendar = GregorianCalendar.getInstance();  
    myCalendar.setTime(myOldTime); 
    year =  myCalendar.get(Calendar.YEAR);
    month = myCalendar.get(Calendar.MONTH) + 1;
    day = myCalendar.get(Calendar.DAY_OF_MONTH);
    hour = myCalendar.get(Calendar.HOUR_OF_DAY);
    minute = myCalendar.get(Calendar.MINUTE);
  }  
  
  try {  
    myOldTime = myDateFormat.parse(timestamp2);
  } catch (Exception e) { 
    println("Could not parse timestamp 2.");
  }
  if (myOldTime != null) { 
    myCalendar = GregorianCalendar.getInstance();  
    myCalendar.setTime(myOldTime); 
    if (year !=  myCalendar.get(Calendar.YEAR)) {
      return false;
    } else if (month != (myCalendar.get(Calendar.MONTH) + 1)) {
      return false;
    } else if (day != myCalendar.get(Calendar.DAY_OF_MONTH)) {
      return false;
    } else if (hour != myCalendar.get(Calendar.HOUR_OF_DAY)) {
      return false;
    } else if (minute != myCalendar.get(Calendar.MINUTE)) {
      return false;
    } 
  }
  return true; 
}

//Changes the current datestring back to the oldest datestring
void resetToStart() { 
  myDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss"); 
  myOldTime = null;
  try {  
    myOldTime = myDateFormat.parse(oldestDateString);
  }
  catch (Exception e) { 
    println("Could not parse date.");
  }
  if (myOldTime != null) { 
    myCalendar = GregorianCalendar.getInstance();  
    myCalendar.setTime(myOldTime); 
    myOldTime = myCalendar.getTime(); 
    currentDateString = myDateFormat.format( myOldTime); 
    
    myCalendar.setTime(myOldTime); //Put the time in the calendar 
    myCalendar.add(Calendar.HOUR, -1); //myNewTime = myOldTime + millis();
    myOldTime = myCalendar.getTime(); //Get the new time back 
    backDateString = myDateFormat.format(myOldTime);
  }  
}

//List of all the keyboard controls
void keyPressed() { 
  if (key == CODED) {
    if (keyCode == UP && (viewing_ratio - 19) > 0) { //increases the ratio by 10
      viewing_ratio += 10;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == UP && (viewing_ratio - 19) <= 0 && viewing_ratio >= 1) { //increases the ratio by 10
      viewing_ratio += 1;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == UP && viewing_ratio == .5) { //changes the viewing ratio up to 1
      viewing_ratio = 1;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == UP && viewing_ratio == .25) { //changes the viewing ratio to .5
      viewing_ratio = .5;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == UP && viewing_ratio == .125) { //changes the viewing ratio to .25
      viewing_ratio = .25;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == DOWN && (viewing_ratio - 20) > 0) { //decreases the ratio by 10
      viewing_ratio -= 10;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == DOWN && (viewing_ratio - 20) <= 0 && viewing_ratio > 1) { //decreases the ratio by 1
      viewing_ratio -= 1;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == DOWN && viewing_ratio == .25) { //changes the viewing ratio to .125
      viewing_ratio = .125;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == DOWN && viewing_ratio == .5) { //changes the viewing ratio to .25
      viewing_ratio = .25;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == DOWN && viewing_ratio == 1) { //changes the viewing ratio to .5
      viewing_ratio = .5;
      leftRightArrow = 0;
      marked_data_time = elapsed_data_time_sec;
      marked_viewing_time = elapsed_viewing_time_sec;
    } else if (keyCode == RIGHT) {
      leftRightArrow += 1;
    } else if (keyCode == LEFT) {
      leftRightArrow -= 1;
    } else if (keyCode == ALT) { //zoom back to the original display
      zoom_scale_factor = 1;
      bx = 0;
      by = 0;
    }
  } else if (key == ' ' && loop == 0) { //pauses the animation
    if(!paused) myPaused = millis();
    paused = true;
    loop = 1;
  } else if (key == ' ' && loop == 1) { //cpntinues the animation
    paused = false;
    myDiff += millis()-myPaused;
    loop = 0;
  } else if (key == '>') {
    leftRightArrow += 3600; //goes ahead 1 hour
  } else if (key == '<') {
    leftRightArrow -= 3600; //goes back 1 hour
  } else if (key == ENTER) {
    reset = true;
  } 
} 

//The mouse wheel is used to scale the screen during the animation
void mouseWheel(MouseEvent event) { 
  wheel_value = event.getCount();
  if (wheel_value < 0) { //images gets bigger if wheel turned up
    zoom_scale_factor *= 1.1; 
    stroke_weight /= 20;
  } else if ((scale_factor / 1.1) > 0) { //images gets smaller if wheel turned down
    zoom_scale_factor /= 1.1;
    stroke_weight *= 20;
  }
}

//The mouse drag functions allows the mouse to drag and move the map
void mousePressed() { 
  locked = true; 
  xOffset = mouseX-bx; 
  yOffset = mouseY-by; 
}

void mouseDragged() {
  if(locked) {
    bx = mouseX-xOffset; 
    by = mouseY-yOffset; 
  }
}

void mouseReleased() {
  locked = false;
}

//Stops myMillis from updating when the program is paused
//Updates myMillis when the program is active
void updateMillis() { 
  myMillis = millis()-myDiff-resetTime;
}

//Calculates the distance between two points in latitude/longitude to meters
float calc_distance_geo(float lat1, float lon1, float lat2, float lon2) {
  float dlon = lon2 - lon1;
  dlon = dlon / 360 * 2 * PI;
  float dlat = lat2 - lat1;
  dlat = dlat / 360 * 2 * PI;
  float rlat1 = lat1 / 360 * 2 * PI;
  float rlat2 = lat2 / 360 * 2 * PI;
  float a = (sin(dlat/2)) * (sin(dlat/2)) + cos(rlat1) * cos(rlat2) * (sin(dlon/2)) * (sin(dlon/2));
  float c = 2 * atan2( sqrt(a), sqrt(1-a) );  
  return 6378.1 * abs(c) * 1000; //Equilateral radius of earth is 6378.1 kilometers
}

//Draws an arrow for the acceleration graphs
void arrow(float x1, float y1, float x2, float y2) {
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
} 

//Draws an arrow for the GPS map
void arrow_GPS(float x1, float y1, float x2, float y2) {
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -1.0/3, -1.0/3);
  line(0, 0, 1.0/3, -1.0/3);
  popMatrix();
} 

//Creates the acceleration file name 
//Composed of the month, day, hour, and minute of the current timestamp
void create_acceleration_file_name() {
  acceleration_file_month = month_counter + "";
  if (acceleration_file_month.length() == 1) {
    acceleration_file_month = "0" + acceleration_file_month;
  }
  acceleration_file_day = dayOfMonth_counter + "";
  if (acceleration_file_day.length() == 1) {
    acceleration_file_day = "0" + acceleration_file_day;
  }
  acceleration_file_hour = hourOfDay_counter + "";
  if (acceleration_file_hour.length() == 1) {
    acceleration_file_hour = "0" + acceleration_file_hour;
  }
  acceleration_file_minute = minute_counter + "";
  if (acceleration_file_minute.length() == 1) {
    acceleration_file_minute = "0" + acceleration_file_minute;
  }
}

//Fetches the current timestamp based on the run time
void getTime() {
  elapsed_viewing_time_sec = myMillis / 1000.0; //elapsed viewing time
  elapsed_data_time_sec = viewing_ratio * (elapsed_viewing_time_sec-marked_viewing_time) + marked_data_time + leftRightArrow; //elapsed time in data
  
  if(!paused) { //if active and not paused
    updateMillis();
  } 
  
  //if the enter key gets pressed, resets the data back to the oldest date string
  if (reset) {
    resetTime += myMillis;
    marked_viewing_time = 0;
    marked_data_time = 0;
    leftRightArrow = 0;
    resetToStart();
    reset = false; 
  }
  
  //Used to add to times, extract parts of time, and store the resulting times into variables
  myDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss"); //increase the time by a factor of the elapsed_viewing_time_sec
  myOldTime = null;
  try {  
    myOldTime = myDateFormat.parse(oldestDateString);
  }
  catch (Exception e) { }
  if (myOldTime != null) { // Did we succeed parsing the date string? 
    myCalendar = GregorianCalendar.getInstance();  // We need a calendar to calculate stuff 
    myCalendar.setTime( myOldTime ); //Put the time in the calendar 
    myCalendar.add(Calendar.SECOND, (int) elapsed_data_time_sec); //myNewTime = myOldTime + millis();
    myCalendar.add(Calendar.MILLISECOND, (int) floor((elapsed_data_time_sec - floor(elapsed_data_time_sec))*1000));
    myOldTime = myCalendar.getTime(); //Get the new time back 
    second_counter = myCalendar.get(Calendar.SECOND); 
    month_counter = myCalendar.get(Calendar.MONTH) + 1;
    dayOfMonth_counter = myCalendar.get(Calendar.DAY_OF_MONTH);
    hourOfDay_counter = myCalendar.get(Calendar.HOUR_OF_DAY);
    minute_counter = myCalendar.get(Calendar.MINUTE);
    millisecond_counter = myCalendar.get(Calendar.MILLISECOND);
    currentDateString = myDateFormat.format( myOldTime); //sets currentDateString to the new time
    
    myCalendar.setTime( myOldTime ); //Put the time in the calendar 
    myCalendar.add(Calendar.HOUR, -1); //myNewTime = myOldTime + millis();
    myOldTime = myCalendar.getTime(); //Get the new time back 
    backDateString = myDateFormat.format( myOldTime);
  } 
  
  myDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss:SSS"); //increase the time by a factor of the elapsed_viewing_time_sec
  myOldTime = null;
  try {  
    myOldTime = myDateFormat.parse(oldestDateString_millisecond);
  }
  catch (Exception e) { }
  if (myOldTime != null) { // Did we succeed parsing the date string? 
    myCalendar = GregorianCalendar.getInstance();  // We need a calendar to calculate stuff 
    myCalendar.setTime( myOldTime ); //Put the time in the calendar 
    myCalendar.add(Calendar.SECOND, (int) elapsed_data_time_sec); //myNewTime = myOldTime + millis();
    myCalendar.add(Calendar.MILLISECOND, (int) floor((elapsed_data_time_sec - floor(elapsed_data_time_sec))*1000));
    myOldTime = myCalendar.getTime(); //Get the new time back 
    currentDateString_millisecond = myDateFormat.format( myOldTime); //sets currentDateString to the new time
  } 
}

//Displays the current time and the viewing ratio on the upper-right hand corner
void showTime() {
  if (viewing_ratio >= 1) {
    text("Viewing Ratio: " + (int) viewing_ratio + "X", width-300, 20); //println(elapsed_viewing_time_sec, marked_viewing_time, marked_data_time, leftRightArrow);
  } else {
    text("Viewing Ratio: " + viewing_ratio + "X", width-300, 20);
  }  
  text("Timestamp: " + currentDateString_millisecond, width-300, 40);  
}

//Creates the key for the node colors and the reference point color
void create_legend(float[] color_value) {
  colorMode(HSB);
  noStroke();
  textSize(20);
  int w = 300;
  text("Key ", width-300, w);
  text("Node 01", width-270, w+30);
  fill(color_value[0],255,255);
  ellipse(width-290, w+30, 20, 20);
  fill(0);
  text("Node 02", width-270, w+60);
  fill(color_value[1],255,255);
  ellipse(width-290, w+60, 20, 20);
  fill(0);
  text("Node 03", width-270, w+90);
  fill(color_value[2],255,255);
  ellipse(width-290, w+90, 20, 20);
  fill(0);
  text("Node 04", width-270, w+120);
  fill(color_value[3],255,255);
  ellipse(width-290, w+120, 20, 20);
  fill(0);
  text("Node 05", width-270, w+150);
  fill(color_value[4],255,255);
  ellipse(width-290, w+150, 20, 20);
  fill(0);
  text("Node 06", width-270, w+180);
  fill(color_value[5],255,255);
  ellipse(width-290, w+180, 20, 20);
  fill(0);
  text("Node 07", width-270, w+210);
  fill(color_value[6],255,255);
  ellipse(width-290, w+210, 20, 20);
  fill(0);
  text("Node 08", width-270, w+240);
  fill(color_value[7],255,255);
  ellipse(width-290, w+240, 20, 20);
  fill(0);
  text("Node 09", width-270, w+270);
  fill(color_value[8],255,255);
  ellipse(width-290, w+270, 20, 20);
  fill(0);
  text("Node 15", width-270, w+300);
  fill(color_value[9],255,255);
  ellipse(width-290, w+300, 20, 20);
  fill(0);
  colorMode(RGB);
  text("Reference Points", width-270, w+330);
  fill(0,0,0,160);
  ellipse(width-290, w+330, 20, 20);
  stroke(1);
  textSize(12);
}

//Detects whether there is a collision 
//A collision occurs when two different timestamps from different nodes come within 50 milliseconds of each other
boolean isCollision(String timestamp_one, String timestamp_two) {
  String timestamp_upperbound = null;
  String timestamp_lowerbound = null;
  myDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss:SSS");
  try {  
    myOldTime = myDateFormat.parse(timestamp_one);
  } catch (Exception e) { 
    println("Could not read timestamp_one.");
  }
  if (myOldTime != null) { // Did we succeed parsing the date string? 
    myCalendar = GregorianCalendar.getInstance();  // We need a calendar to calculate stuff 
    myCalendar.setTime(myOldTime); //Put the time in the calendar 
    myCalendar.add(Calendar.MILLISECOND, 50);
    myOldTime = myCalendar.getTime(); //Get the new time back 
    timestamp_upperbound = myDateFormat.format(myOldTime);
    myCalendar.setTime(myOldTime);
    myCalendar.add(Calendar.MILLISECOND, -100);
    myOldTime = myCalendar.getTime();
    timestamp_lowerbound = myDateFormat.format(myOldTime);
  }
  if (timestamp_two != null && timestamp_two.compareTo(timestamp_lowerbound) >= 0 && timestamp_two.compareTo(timestamp_upperbound) <= 0) {
    return true;
  }
  
  return false; 
}
