import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer dance;
BeatDetect beat;
FFT fftLin;

PFont font;

float height3;
float height23;
float spectrumScale = 20;
float avgnum = 60;
float g = 0;
float eRadius = 150;
float startl;
boolean color1 = false;
int one = 1;

ArrayList<PVector> characters = new ArrayList<PVector>();

void setup() {
  //fullScreen();
  size(800, 600);
  colorMode(RGB);
  
  for (int i = 0; i < width; i += 15) {
    for (int j = 0; j < height; j += 15) {
      characters.add(new PVector(i,j));
    
    }
  
  }
  
  height3 = 0;
  height23 = height;
  
  textAlign(CENTER, BOTTOM);
  
  minim = new Minim(this);
  
  //replace the 'dance.mp3' with any song file,
  //as long as it is in the data directory
  dance = minim.loadFile("dance.mp3", 1024);
  beat = new BeatDetect();
  
  fftLin = new FFT( dance.bufferSize(), dance.sampleRate() );
  
  
  dance.loop();
  rectMode(CORNERS);

  //importing the classic console font
  //you may have to install this yourself into the data folder
  font = createFont("clacon.ttf", 15);
  textFont(font);
  

}

void draw() {
  ArrayList<PVector> points = new ArrayList<PVector>();
  for(int i = 0; i < dance.bufferSize() - 1; i++) {
      stroke(0);
      strokeWeight(10);
      float x1 = map( i, 0, dance.bufferSize(), 0, width );
      points.add(new PVector(x1, height/2 + dance.left.get(i)*200));
  } 
  fftLin.linAverages(int(avgnum));
  background(15);
  //noStroke();
  fftLin.forward(dance.mix);
  beat.detect(dance.mix);
  int w = int( width/fftLin.avgSize() );
    for(int i = 0; i < fftLin.avgSize()/2; i++){ 
      for (float j = height; j > height - fftLin.getAvg(i)*spectrumScale; j -= 15) { 
        
        if (color1 == true) {
          fill(0);
        } else {
          fill(255, 0, 0);
        }
        
        textSize(15);
        text(int((noise(i*w+g, j)*10)), floor(i*w) + 10, j);
        text(int((noise(width-i*w+g, j)*10)), floor(width - i*w) - 10, j);
      
      }
      
      for (int n = 0; n < height - fftLin.getAvg(fftLin.avgSize()/2 - i - 1)*spectrumScale; n += 15 ) {
        textSize(15);
        if (dist(width/2 ,0, width/2 - i*w - 13, n) < eRadius && dist(width/2 ,0, width/2 - i*w - 13, n) > eRadius - map(sin(g*5), -1, 1, 20, 70)) {
          fill(255, 255, 255);
          text(int(noise(width/2 - i*w+g, n)*100), width/2 - i*w - 13, n);
          text(int(noise(width/2 + i*w+g, n)*100), width/2 + i*w + 13, n); 
        } else {
          if (n < fftLin.getAvg(i)*spectrumScale){
              fill(map((noise(width/2 - i*w+g*10, n)), 0, 1, 50, 255));
              text(int(noise(width/2 - i*w+g, n)*10), width/2 - i*w - 13, n);
              fill(map((noise(width/2 + i*w+g*10, n)), 0, 1, 0, 255));
              text(int(noise(width/2 + i*w+g, n)*10), width/2 + i*w + 13, n); 
          }
        }
          
        }
      }
      
      for (float l = startl; l <= height + 15; l += 15) {
        fill(255, 0, 0);
        textSize(15);
        text(int(random(9)), width/2, l);
      }

      startl -= 2;

      g += 0.001;
      if (eRadius > 400 && beat.isOnset()) {
        eRadius = 50;
      } else {
        eRadius += 10;
      }
      
}
  
  
