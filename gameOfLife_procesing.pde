// 2D Array of objects
System sys;

// Number of columns and cols in the grid
// cols need to > 35 to support the gun test
int cols = 50;
int pixelOfWindow = 400;

void setup() {
  size(pixelOfWindow,pixelOfWindow);
  sys = new System(cols, pixelOfWindow / cols);
  sys.gliderTest();
  sys.gliderGunTest();
}

void draw() {
  background(0);
  sys.display();
  sys.simulate();
  delay(50);
}

// A Cell object
class Cell {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  float x,y;   // x,y location
  float w,h;   // width and height
  float angle; // angle for oscillating brightness
  int alive;

  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, int tempAlive) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    alive = tempAlive;

  }

  void display() {
    stroke(255);
    // Color calculated using sine wave
    if (alive == 1)
      fill(0);
    else
      fill(255);
    rect(x,y,w,h); 
  }
}

class System {
  Cell[][] grid;
  int cols;
  
  System(int tempCols, int size) {
    cols = tempCols;
    grid = new Cell[cols][cols];
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < cols; j++) {
        // Initialize each object
        grid[i][j] = new Cell(i*size,j*size,size,size,int(random(0, 2)));
      }
    }
  }
  
  // test for glider:)
  void gliderTest() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < cols; j++) {
        // Initialize each object
        grid[i][j].alive = 0;
      }
    }
    grid[0][1].alive = 1;
    grid[1][2].alive = 1;
    grid[2][0].alive = 1;
    grid[2][1].alive = 1;
    grid[2][2].alive = 1;
  }
  
  void gliderGunTest() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < cols; j++) {
        // Initialize each object
        grid[i][j].alive = 0;
      }
    }
    
    grid[1][5].alive = 1;
    grid[1][6].alive = 1;
    grid[2][5].alive = 1;
    grid[2][6].alive = 1;
    
    grid[35][3].alive = 1;
    grid[35][4].alive = 1;
    grid[36][3].alive = 1;
    grid[36][4].alive = 1;
    
    grid[11][5].alive = 1;
    grid[11][6].alive = 1;
    grid[11][7].alive = 1;
    grid[12][4].alive = 1;
    grid[12][8].alive = 1;
    grid[13][3].alive = 1;
    grid[13][9].alive = 1;
    grid[14][3].alive = 1;
    grid[14][9].alive = 1;
    grid[15][6].alive = 1;
    grid[16][4].alive = 1;
    grid[16][8].alive = 1;
    grid[17][5].alive = 1;
    grid[17][6].alive = 1;
    grid[17][7].alive = 1;
    grid[18][6].alive = 1;
    
    grid[21][3].alive = 1;
    grid[21][4].alive = 1;
    grid[21][5].alive = 1;
    grid[22][3].alive = 1;
    grid[22][4].alive = 1;
    grid[22][5].alive = 1;
    grid[23][2].alive = 1;
    grid[23][6].alive = 1;
    grid[25][1].alive = 1;
    grid[25][2].alive = 1;
    grid[25][6].alive = 1;
    grid[25][7].alive = 1;
  }
  
  // set the alive
  void setlive(int i, int j, int tempAlive) {
    grid[i][j].alive = tempAlive;
  }
  
  // simulate the procedure
  // no need to reed this, ugly:(
  void simulate() {
    int[][] near = new int[cols][cols];
    for (int i = 0; i < cols; i++)
      for (int j = 0; j < cols; j++)
      {
        if (i == 0 && j == 0)
          near[i][j] = grid[1][0].alive + grid[0][1].alive + grid[1][1].alive;
        else if (i == 0 && j == cols - 1)
          near[i][j] = grid[0][cols - 2].alive + grid[1][cols - 2].alive + grid[1][cols - 1].alive;
        else if (i == cols - 1 && j == 0)
          near[i][j] = grid[cols - 2][0].alive + grid[cols - 2][1].alive + grid[cols - 1][1].alive;
        else if (i == cols - 1 && j == cols - 1)
          near[i][j] = grid[cols - 2][cols - 1].alive + grid[cols - 2][cols - 2].alive + grid[cols - 1][cols - 2].alive;
        else if (i == 0)
          near[i][j] = grid[i][j - 1].alive + grid[i][j + 1].alive + grid[i + 1][j - 1].alive + grid[i + 1][j].alive + grid[i + 1][j + 1].alive;
        else if (i == cols - 1)
          near[i][j] = grid[i][j - 1].alive + grid[i][j - 1].alive + grid[i - 1][j - 1].alive + grid[i - 1][j].alive + grid[i - 1][j + 1].alive;
        else if (j == 0)
          near[i][j] = grid[i - 1][j].alive + grid[i + 1][j].alive + grid[i - 1][j + 1].alive + grid[i][j + 1].alive + grid[i + 1][j + 1].alive;
        else if (j == cols - 1)
          near[i][j] = grid[i - 1][j].alive + grid[i + 1][j].alive + grid[i - 1][j - 1].alive + grid[i][j - 1].alive + grid[i + 1][j - 1].alive;
        else
        {
          for (int tempi = i - 1; tempi <= i + 1; tempi++)
            for (int tempj = j - 1; tempj <= j + 1; tempj++)
            {
              if (tempi == i && tempj == j)
                continue;
              near[i][j] += grid[tempi][tempj].alive;
            }
        }
      }
    for (int i = 0; i < cols; i++)
      for (int j = 0; j < cols; j++)
      {
        if (grid[i][j].alive == 0 && near[i][j] == 3)
          grid[i][j].alive = 1;
        else if (grid[i][j].alive ==1 && near[i][j] <= 3 && near[i][j] >= 2)
          grid[i][j].alive = 1;
        else
          grid[i][j].alive = 0;
      }
  }
  
  void display() {
    // The counter variables i and j are also the column and row numbers and 
    // are used as arguments to the constructor for each object in the grid.  
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < cols; j++) {
        grid[i][j].display();
      }
    }
  }
}
