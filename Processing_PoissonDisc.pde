
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// Poisson Disc
// Processing implementation by Nicholas Felton
// Based example by Mike Bostock
// http://bost.ocks.org/mike/algorithms/
// Borrows the containsPoint() function from Toxiclibs by Karsten Schmidt
// http://toxiclibs.org
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

// FEATURES
// Fill polygon with a Poisson Disc distribution of points

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// GLOBAL VARIABLES
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
int maxPoints = 200; // number of total points to draw
int numCandidates = 500; // number of candidate points to try
PVector[] verts = new PVector[3];
PVector[] points = new PVector[0];
int sizeMarker = 3;


// - - - - - - - - - - - - - - - - - - - - - - - 
// SETUP
// - - - - - - - - - - - - - - - - - - - - - - - 
void setup() {
  smooth();
  size(800, 800);
  for (int i=0; i<verts.length; i++) {
    verts[i] = new PVector(random(0, width), random(0, height));
  }
  points = (PVector[]) append(points, new PVector(verts[0].x, verts[0].y));
}


// - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW
// - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
  background(0);
  if (points.length <= maxPoints) {
    addPoint();
  }
  fill(255, 0, 0);
  noStroke();
  for (int i=1; i<points.length; i++) {
    ellipse(points[i].x, points[i].y, sizeMarker, sizeMarker);
  }
  stroke(100);
  strokeWeight(2);
  noFill();
  triangle(verts[0].x, verts[0].y, verts[1].x, verts[1].y, verts[2].x, verts[2].y);
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// FUNCTIONS
// - - - - - - - - - - - - - - - - - - - - - - - 
void addPoint() {
  float bestDistance = 0;
  PVector bestCandidate = new PVector(0, 0);
  for (int i=0; i<numCandidates; i++) {
    float closestDistance = width*height;
    float randomX = random(0, width);
    float randomY = random(0, height);
    if (containsPoint(verts, randomX, randomY)) {
      PVector candidate = new PVector(randomX, randomY);
      fill(100);
      noStroke();
      ellipse(candidate.x, candidate.y, sizeMarker, sizeMarker);
      for (int n=0; n<points.length; n++) {
        if (PVector.dist(candidate, points[n]) < closestDistance) {
          closestDistance = PVector.dist(candidate, points[n]);
        }
      }
      if (closestDistance > bestDistance) {
        bestDistance = closestDistance;
        bestCandidate.set(candidate.x, candidate.y);
      }
    }
  }
  points = (PVector[]) append(points, new PVector(bestCandidate.x, bestCandidate.y));
  println(frameCount + " - - - - - - - - - - - - ");
}

// From Toxiclibs Polygon2D class
// http://forum.processing.org/one/topic/mouse-within-a-certain-area.html
boolean containsPoint(PVector[] verts, float px, float py) {
  int num = verts.length;
  int i, j = num - 1;
  boolean oddNodes = false;
  for (i = 0; i < num; i++) {
    PVector vi = verts[i];
    PVector vj = verts[j];
    if (vi.y < py && vj.y >= py || vj.y < py && vi.y >= py) {
      if (vi.x + (py - vi.y) / (vj.y - vi.y) * (vj.x - vi.x) < px) {
        oddNodes = !oddNodes;
      }
    }
    j = i;
  }
  return oddNodes;
}

