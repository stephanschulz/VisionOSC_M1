//
//  hand.h
//  CoreMLHand
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture


#ifndef body_h
#define body_h

#include "ofMain.h"
#import <Foundation/Foundation.h>
#import <Vision/Vision.h>
#import <AVKit/AVKit.h>

#include "constants.h"

#include "ofxCv.h"
using namespace ofxCv;
using namespace cv;

class BODY;

@interface Body:NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>{
  AVCaptureSession*           session;
  AVCaptureVideoDataOutput*   videoDataOutput;
  AVCaptureDevice*            captureDevice;
}
-(NSArray*)detect:(CGImageRef)image;
@end

class BODY{
public:
  BODY();
   
  void detect(ofPixels image);
  CGImageRef CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents );

  ofVec3f detections[MAX_DET][BODY_N_PART];
  float scores      [MAX_DET];
  int n_det = 0;
  
   void drawBodyPart(int _index, int part, int det, ofColor color);
    
    bool bShowGUI;
    void drawInfo(int _x, int _y);
    
    vector<ofRectangle> boundingRects;
    
    void draw();
    
protected:
  
 Body* tracker;

};

#endif /* body_h */
