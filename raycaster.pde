int[][] worldMap =
{
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
  {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1},
  {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
};

int displayWidth = 1280;
int displayHeight = 720;
int redVal, greenVal, blueVal;
int frameTime = 60;
double moveSpeed = .3;
float rotSpeed = .1;
double posX = 22, posY = 12; //position of the player on the worldMap
double dirX = -1, dirY = 0; //direction vector
double planeX = 0, planeY = .22; //camera plane or FOV

void setup() {
  size(displayWidth, displayHeight);
  frameRate(frameTime);
  loop();
}

void draw() {
  background(0, 0, 0);
  for(int x = 0; x < displayWidth; x++){ // calculating the ray position and direction
      double cameraX = 2 * x / displayWidth - 1; //represents the vertical segment that the camera shows
      double rayDirX = dirX + planeX * cameraX; //direction the ray is going in the X direction
      double rayDirY = dirY + planeY * cameraX; //direction the ray is going in the Y direction

      int mapX = (int) (posX);
      int mapY = (int) (posY); //position on the map

      double sideDistX;
      double sideDistY; //distance from current position to next x/y box on map

      double deltaDistX = abs((float) (1 / rayDirX));
      double deltaDistY = abs((float) (1 / rayDirY)); //distance from one x/y box to next x/y box on map
      double perpWallDist;

      int stepX;
      int stepY; //used to determine if the ray will go in the positive or negative X/Y direction

      int hit = 0; //tests for wall hit
      int side = 0; //X or Y wall?

      if (rayDirX < 0){ //calculating step and sideDist
        stepX = -1;
        sideDistX = (posX - mapX) * deltaDistX;
      }
      else{
        stepX = 1;
        sideDistX = (mapX + 1.0 - posX) * deltaDistX;
      }
      if (rayDirY < 0){
        stepY = -1;
        sideDistY = (posY - mapY) * deltaDistY;
      }
      else{
        stepY = 1;
        sideDistY = (mapY + 1.0 - posY) * deltaDistY;
      }

      while (hit == 0){ // wall hit detection
        if (sideDistX < sideDistY){ //choosing whether to move in the x or y direction then moving there
          sideDistX += deltaDistX;
          mapX += stepX;
          side = 0;
        }
        else{
          sideDistY += deltaDistY;
          mapY += stepY;
          side = 1;
        }

        if (worldMap[mapX][mapY] > 0) {hit = 1;} //seeing if that box is a wall
      }

      if (side == 0){ //seeing if it is an X wall or Y wall then calculating the distance from that wall to the the camera directional plane
        perpWallDist = (mapX - posX + (1 - stepX) / 2) / rayDirX; 
      }
      else{
        perpWallDist = (mapY - posY + (1 - stepY) / 2) / rayDirY;
      }

      int lineHeight = (int) (displayHeight / perpWallDist);

      int drawStart = (-lineHeight / 2) + (displayHeight / 2); //lowest pixel to draw
      if (drawStart < 0) {drawStart = 0;}
      int drawEnd = (lineHeight / 2) + (displayHeight / 2); //highest pixel to draw
      if (drawEnd >= displayHeight) {drawEnd = displayHeight - 1;}

      print(worldMap[mapX][mapY]);
      if (side == 1){ //different colors for X or Y walls
        switch (worldMap[mapX][mapY]){
          case 1: 
            redVal = 0;
            greenVal = 204;
            blueVal = 153;
          case 2:
            redVal = 51;
            greenVal = 102;
            blueVal = 204;
          case 3:
            redVal = 255;
            greenVal = 80;
            blueVal = 80;
          case 4:
            redVal = 153;
            greenVal = 51;
            blueVal = 153;
          default:
            redVal = 153;
            greenVal = 102;
            blueVal = 51;
        }
      } 
      else{
        switch (worldMap[mapX][mapY]){
          case 1: 
            redVal = 0;
            greenVal = 179;
            blueVal = 134;
          case 2:
            redVal = 46;
            greenVal = 92;
            blueVal = 184;
          case 3:
            redVal = 255;
            greenVal = 51;
            blueVal = 51;
          case 4:
            redVal = 134;
            greenVal = 45;
            blueVal = 134;
          default:
            redVal = 134;
            greenVal = 89;
            blueVal = 45;
        }
      }
      
      
      //stroke(redVal, greenVal, blueVal);//giving the lines their color
      //line(x, drawStart, x, drawEnd); //printing each line
      noStroke();
      fill(redVal, greenVal, blueVal);
      rect(x, drawStart, 1, drawEnd-drawStart);
      
    }
}

void keyPressed() { //setting up movement and rotation
  
  if (keyCode == UP){
    if(worldMap[(int) (posX + dirX * moveSpeed)][(int) (posY)] == 0) {posX += dirX * moveSpeed;}
    if(worldMap[(int) (posX)][(int) (posY + dirY * moveSpeed)] == 0) {posY += dirY * moveSpeed;}
  }

  if (keyCode == DOWN){
    if(worldMap[(int) (posX - dirX * moveSpeed)][(int) (posY)] == 0) {posX -= dirX * moveSpeed;}
    if(worldMap[(int) (posX)][(int) (posY - dirY * moveSpeed)] == 0) {posY -= dirY * moveSpeed;}
  }
  if (keyCode == LEFT){
    double oldDirX = dirX;
    dirX = (dirX * cos(rotSpeed)) - (dirY * sin(rotSpeed));
    dirY = (oldDirX * sin(rotSpeed)) + (dirY * cos(rotSpeed));
    double oldPlaneX = planeX;
    planeX = (planeX * cos(rotSpeed)) - (planeY * sin(rotSpeed));
    planeY = (oldPlaneX * sin(rotSpeed)) + (planeY * cos(rotSpeed));
  }
  if (keyCode == RIGHT){
    double oldDirX = dirX;
    dirX = (dirX * cos(-rotSpeed)) - (dirY * sin(-rotSpeed));
    dirY = (oldDirX * sin(-rotSpeed)) + (dirY * cos(-rotSpeed));
    double oldPlaneX = planeX;
    planeX = (planeX * cos(-rotSpeed)) - (planeY * sin(-rotSpeed));
    planeY = (oldPlaneX * sin(-rotSpeed)) + (planeY * cos(-rotSpeed));
  }
}
