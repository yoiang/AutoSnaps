import processing.video.*;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

Capture camera;
PImage snap;
int snapTime;

void setup()
{
  size( 420, 200 );
  String[] cameras = Capture.list();
  if ( cameras.length > 0 )
  {
    camera = new Capture( this, cameras[ 0 ] );
    camera.start();
  }
  
  snap = createImage( 1280, 800, RGB );
  snap.loadPixels();
  
  snapTime = 0;
  
  background( 51 );
}

void draw()
{
  if ( snapTime == 0 && camera.available() )
  {    
    camera.read();
    camera.updatePixels();
    camera.stop();
    
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
               
    image( snap, 0, 0, 420, 200 );

    DateFormat dateFormat = new SimpleDateFormat( "yyyy-MM-dd'T'HH-mm-ss'Z'Z" );
    Date date = new Date();    
    snap.save( "AutoSnap " + dateFormat.format( date ) + ".jpeg" );
    snapTime = millis();
  }
  
  if ( snapTime > 0 && millis() - snapTime > 500 )
  {
    exit();
  }
}
  



