import processing.video.*;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import gifAnimation.*;
import com.dhchoi.*; // Countdown Timer

int displayWidth = 420;
int displayHeight = 200;

Capture camera;
PImage snap;

GifMaker animation;

CountdownTimer timer;
int animationFrameCount;
float animationFrameDelaySeconds;

int snappedFramesCount;

void setup()
{
  size( displayWidth, displayHeight );
  
  String[] cameras = Capture.list();
  if ( cameras.length == 0 )
  {
    javax.swing.JOptionPane.showMessageDialog(null, "No camera found!");
    exit();
  }
  camera = new Capture( this, cameras[ 0 ] );
  camera.start();
  
  snap = createImage( 1280, 800, RGB );
  snap.loadPixels();
  
  animationFrameCount = 5;
  animationFrameDelaySeconds = 0.010;
  
  animation = new GifMaker(this, fileName() );
  animation.setRepeat(0);
  
  snappedFramesCount = 0;
  
  background( 51 );
  
  timer = CountdownTimer.getNewCountdownTimer(this);
  timer.configure(animationFrameDelayMilliseconds(), animationFrameDelayMilliseconds() );
  timer.start();
}

int animationFrameDelayMilliseconds()
{
  return (int)(animationFrameDelaySeconds * 1000);
}

String fileName()
{
  DateFormat dateFormat = new SimpleDateFormat( "yyyy-MM-dd'T'HH-mm-ss'Z'Z" );
  Date date = new Date();
  return "AutoSnap " + dateFormat.format( date ) + ".gif";
}

void snapPicture()
{
  if (camera.available() )
  {
    camera.read();
    camera.updatePixels();
    
    snap.copy( 
               camera,
               0,
               0,
               camera.width,
               camera.height,
               0,
               0,
               snap.width,
               snap.height
               );
               
    image(snap, 0, 0, displayWidth, displayHeight);

    animation.addFrame(snap);
    animation.setDelay(animationFrameDelayMilliseconds());
    
    snappedFramesCount ++;
  }
}

void onTickEvent(CountdownTimer t, long timeLeftUntilFinish)
{
}

void onFinishEvent(CountdownTimer t)
{
  if (snappedFramesCount < animationFrameCount)
  {
    snapPicture();
    timer.reset();
    timer.start();
  } else
  {
    camera.stop();
    exit();
  }
}

void draw()
{
}