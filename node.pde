class Node {
  
  Table table; //loads the Excel csv file
  int size; //a counter variable that contains the total rows in table
  
  float[] xval; //contains longitude points
  float[] yval; //contains latitude points
  String[] date_arr; //contains the date time group
  String date;
  float lat;
  float lon;
  
  int i = 0;
  int j = 0;
  
  int num_pts; //number of points before currentTimeString
  int num_pts_within; //number of points before backTimeString
  
  //constructor
  Node(String file) { 
    table = loadTable(file); //loads the Excel data file
    size = table.getRowCount(); // contains the total rows in table
    xval = new float[size]; yval = new float[size]; //contains longitude and latitude points
    date_arr = new String[size]; //contains the date time group
    for (TableRow row : table.rows()) { 
      date = row.getString(0); 
      lat = row.getFloat(1); 
      lon = row.getFloat(2); 
      xval[i] = coordinate_factor*lon; 
      yval[i] = coordinate_factor*lat; 
      date_arr[i] = date; 
      i++; 
    }
  }
  
  //Plot the GPS points onto the map
  void createGPS(String currentDateString, String backDateString, float color_hue) {
    num_pts = 0; 
    num_pts_within = 0; 
    
    //compare the current time to the time of the points
    for (j = 0; j < size; j++) { 
      if (currentDateString.compareTo(date_arr[j]) > 0) { 
        num_pts++;
      } else {
        break; 
      }
    }
    
    //compare the current time shifted back an hour to the time of the points
    if (num_pts > 1) {
      for (j = 0; j < num_pts; j++) {   
        if (backDateString.compareTo(date_arr[j]) > 0) {  
          num_pts_within++;
        } else {
          break; 
        }
      }
    } 
    
    //Plotting algorithm
    colorMode(HSB);
    if (num_pts == 1) { //if there is only one point to plot in the node
      stroke(color_hue,255,255);
      point(xval[0], -yval[0]);
    } else {
      for (j = 0; j < num_pts; j++) { 
        if (j >= num_pts_within) {
          //Plots the points
          //The more recent the point, the less transparent and more visible the point
          stroke(color_hue,255,255,((float)j-(float)num_pts_within)/((float)num_pts-(float)num_pts_within)*255.0);
          point(xval[j], -yval[j]);
          
          //Dealing with the most recent point
          if (j == num_pts-1) {
            noStroke();
            fill(0,128);  
            //Indicates where the most recent point is 
            triangle(xval[j]-25/calc_distance_geo(0,0,1,0)*coordinate_factor, -yval[j]-50/calc_distance_geo(0,0,1,0)*coordinate_factor, xval[j]+25/calc_distance_geo(0,0,1,0)*coordinate_factor, -yval[j]-50/calc_distance_geo(0,0,1,0)*coordinate_factor, xval[j], -yval[j]-25/calc_distance_geo(0,0,1,0)*coordinate_factor);                
            fill(161,16,180,128);
            //10 meter radius from the most recent point
            ellipse(xval[j], -yval[j], 10/calc_distance_geo(0,0,0,1)*coordinate_factor, 10/calc_distance_geo(0,0,1,0)*coordinate_factor); 
          }
        }
      }
    }
    colorMode(RGB);
  }
  
}
