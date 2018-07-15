/*
  péndulo doble / Rick
*/

final float GRAVITY = 1;

float r1 = 200,
      r2 = 200,
      m1 = 20,
      m2 = 20,
      a1 = PI/2,
      a2 = PI/2,
      a1_v = 0,
      a2_v = 0,
      px2 = -1,
      py2 = -1,
      cx, cy;

PGraphics root_window;

void setup() 
{
  size(900, 700);
  cx = width/2;
  cy = 250;
  root_window = createGraphics(width, height);
  root_window.beginDraw();
  root_window.background(255);
  root_window.endDraw();
}

void draw() 
{
  imageMode(CORNER);
  image(root_window, 0, 0, width, height);

  float[] acels= getAcel();
  
  float a1_a = acels[0],
        a2_a = acels[1];

  translate(cx, cy);
  stroke(0);
  strokeWeight(2);

  float x1 = r1 * sin(a1),
        y1 = r1 * cos(a1),
        x2 = x1 + r2 * sin(a2),
        y2 = y1 + r2 * cos(a2);

  drawMass(0, 0, x1, y1,m1);
  drawMass(x1, y1, x2, y2,m2);

  a1_v += a1_a;
  a2_v += a2_a;
  a1 += a1_v;
  a2 += a2_v;

  root_window.beginDraw();
  root_window.translate(cx, cy);
  root_window.stroke(0);
  if (frameCount > 1) 
  {
    root_window.stroke(180);
    root_window.line(px2, py2, x2, y2);
  }
  root_window.endDraw();

  px2 = x2;
  py2 = y2;
}

float[] getAcel()
{
  float[] results = new float[2];
  
  float num1 = -GRAVITY * (2 * m1 + m2) * sin(a1),
        num2 = -m2 * GRAVITY * sin(a1-2*a2),
        num3 = -2*sin(a1-a2)*m2,
        num4 = a2_v*a2_v*r2+a1_v*a1_v*r1*cos(a1-a2),
        den = r1 * (2*m1+m2-m2*cos(2*a1-2*a2));
  
  // acel 1
  results[0] = (num1 + num2 + num3*num4) / den;
  
  num1 = 2 * sin(a1-a2);
  num2 = (a1_v*a1_v*r1*(m1+m2));
  num3 = GRAVITY * (m1 + m2) * cos(a1);
  num4 = a2_v*a2_v*r2*m2*cos(a1-a2);
  den = r2 * (2*m1+m2-m2*cos(2*a1-2*a2));
 
  // acel 2
  results[1] = (num1*(num2+num3+num4)) / den;
  
  return results;
}

void drawMass(float inix, float iniy, float endx, float endy, float mass)
{
  line(inix, iniy, endx, endy);
  fill(0);
  ellipse(endx, endy, mass, mass);
}