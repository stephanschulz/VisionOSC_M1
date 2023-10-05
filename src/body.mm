//
//  hand.m
//  CoreMLBody
//
//  Created by lingdong on 10/19/21.
//  based on https://github.com/pierdr/ofxiosfacetracking
//       and https://github.com/pambudi02/objc_handgesture

#include "body.h"

#pragma clang diagnostic ignored "-Wunguarded-availability"


@implementation Body

-(NSArray*)detect:(CGImageRef)image{
    
    //  VNDetectHumanBodyPoseRequest *req = [[VNDetectHumanBodyPoseRequest new] autorelease];
    //  NSDictionary *d = [[[NSDictionary alloc] init] autorelease];
    //  VNImageRequestHandler *handler = [[[VNImageRequestHandler alloc] initWithCGImage:image options:d] autorelease];
    
    VNDetectHumanBodyPoseRequest *req = [VNDetectHumanBodyPoseRequest new];
    NSDictionary *d = [[NSDictionary alloc] init];
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image options:d];
    
    [handler performRequests:@[req] error:nil];
    
    return req.results;
}
@end

BODY::BODY(){
    tracker = [[Body alloc] init];
}

void BODY::detect(ofPixels pix)
{
    CGImageRef image = CGImageRefFromOfPixels(pix,(int)pix.getWidth(),(int)pix.getHeight(),(int)pix.getNumChannels());
    NSArray* arr = [tracker detect:image];
    NSError *err;
    
    boundingRects.clear();
    //    VNHumanBodyPoseObservation *observation =(VNHumanBodyPoseObservation*) arr.firstObject;
    n_det = 0;
    for(VNHumanBodyPoseObservation *observation in arr){
        NSDictionary <VNHumanBodyPoseObservationJointName, VNRecognizedPoint *> *allPts = [observation recognizedPointsForJointsGroupName:VNHumanBodyPoseObservationJointsGroupNameAll error:&err];
        
        VNRecognizedPoint *Nose         = [allPts objectForKey:VNHumanBodyPoseObservationJointNameNose];
        VNRecognizedPoint *LeftEye      = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftEye];
        VNRecognizedPoint *RightEye     = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightEye];
        VNRecognizedPoint *LeftEar      = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftEar];
        VNRecognizedPoint *RightEar     = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightEar];
        VNRecognizedPoint *LeftWrist    = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftWrist];
        VNRecognizedPoint *RightWrist   = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightWrist];
        VNRecognizedPoint *LeftElbow    = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftElbow];
        VNRecognizedPoint *RightElbow   = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightElbow];
        VNRecognizedPoint *LeftShoulder = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftShoulder];
        VNRecognizedPoint *RightShoulder= [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightShoulder];
        VNRecognizedPoint *LeftHip      = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftHip];
        VNRecognizedPoint *RightHip     = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightHip];
        VNRecognizedPoint *LeftKnee     = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftKnee];
        VNRecognizedPoint *RightKnee    = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightKnee];
        VNRecognizedPoint *LeftAnkle    = [allPts objectForKey:VNHumanBodyPoseObservationJointNameLeftAnkle];
        VNRecognizedPoint *RightAnkle   = [allPts objectForKey:VNHumanBodyPoseObservationJointNameRightAnkle];
        
        detections[n_det][BODY_NOSE          ].x = Nose         .location.x * pix.getWidth();
        detections[n_det][BODY_LEFTEYE       ].x = LeftEye      .location.x * pix.getWidth();
        detections[n_det][BODY_RIGHTEYE      ].x = RightEye     .location.x * pix.getWidth();
        detections[n_det][BODY_LEFTEAR       ].x = LeftEar      .location.x * pix.getWidth();
        detections[n_det][BODY_RIGHTEAR      ].x = RightEar     .location.x * pix.getWidth();
        detections[n_det][BODY_LEFTWRIST     ].x = LeftWrist    .location.x * pix.getWidth();
        detections[n_det][BODY_RIGHTWRIST    ].x = RightWrist   .location.x * pix.getWidth();
        detections[n_det][BODY_LEFTELBOW     ].x = LeftElbow    .location.x * pix.getWidth();
        detections[n_det][BODY_RIGHTELBOW    ].x = RightElbow   .location.x * pix.getWidth();
        detections[n_det][BODY_LEFTSHOULDER  ].x = LeftShoulder .location.x * pix.getWidth();
        detections[n_det][BODY_RIGHTSHOULDER ].x = RightShoulder.location.x * pix.getWidth();
        detections[n_det][BODY_LEFTHIP       ].x = LeftHip      .location.x * pix.getWidth();
        detections[n_det][BODY_RIGHTHIP      ].x = RightHip     .location.x * pix.getWidth();
        detections[n_det][BODY_LEFTKNEE      ].x = LeftKnee     .location.x * pix.getWidth();
        detections[n_det][BODY_RIGHTKNEE     ].x = RightKnee    .location.x * pix.getWidth();
        detections[n_det][BODY_LEFTANKLE     ].x = LeftAnkle    .location.x * pix.getWidth();
        detections[n_det][BODY_RIGHTANKLE    ].x = RightAnkle   .location.x * pix.getWidth();
        
        detections[n_det][BODY_NOSE          ].y = (1-Nose         .location.y) * pix.getHeight();
        detections[n_det][BODY_LEFTEYE       ].y = (1-LeftEye      .location.y) * pix.getHeight();
        detections[n_det][BODY_RIGHTEYE      ].y = (1-RightEye     .location.y) * pix.getHeight();
        detections[n_det][BODY_LEFTEAR       ].y = (1-LeftEar      .location.y) * pix.getHeight();
        detections[n_det][BODY_RIGHTEAR      ].y = (1-RightEar     .location.y) * pix.getHeight();
        detections[n_det][BODY_LEFTWRIST     ].y = (1-LeftWrist    .location.y) * pix.getHeight();
        detections[n_det][BODY_RIGHTWRIST    ].y = (1-RightWrist   .location.y) * pix.getHeight();
        detections[n_det][BODY_LEFTELBOW     ].y = (1-LeftElbow    .location.y) * pix.getHeight();
        detections[n_det][BODY_RIGHTELBOW    ].y = (1-RightElbow   .location.y) * pix.getHeight();
        detections[n_det][BODY_LEFTSHOULDER  ].y = (1-LeftShoulder .location.y) * pix.getHeight();
        detections[n_det][BODY_RIGHTSHOULDER ].y = (1-RightShoulder.location.y) * pix.getHeight();
        detections[n_det][BODY_LEFTHIP       ].y = (1-LeftHip      .location.y) * pix.getHeight();
        detections[n_det][BODY_RIGHTHIP      ].y = (1-RightHip     .location.y) * pix.getHeight();
        detections[n_det][BODY_LEFTKNEE      ].y = (1-LeftKnee     .location.y) * pix.getHeight();
        detections[n_det][BODY_RIGHTKNEE     ].y = (1-RightKnee    .location.y) * pix.getHeight();
        detections[n_det][BODY_LEFTANKLE     ].y = (1-LeftAnkle    .location.y) * pix.getHeight();
        detections[n_det][BODY_RIGHTANKLE    ].y = (1-RightAnkle   .location.y) * pix.getHeight();
        
        
        detections[n_det][BODY_NOSE          ].z = Nose         .confidence;
        detections[n_det][BODY_LEFTEYE       ].z = LeftEye      .confidence;
        detections[n_det][BODY_RIGHTEYE      ].z = RightEye     .confidence;
        detections[n_det][BODY_LEFTEAR       ].z = LeftEar      .confidence;
        detections[n_det][BODY_RIGHTEAR      ].z = RightEar     .confidence;
        detections[n_det][BODY_LEFTWRIST     ].z = LeftWrist    .confidence;
        detections[n_det][BODY_RIGHTWRIST    ].z = RightWrist   .confidence;
        detections[n_det][BODY_LEFTELBOW     ].z = LeftElbow    .confidence;
        detections[n_det][BODY_RIGHTELBOW    ].z = RightElbow   .confidence;
        detections[n_det][BODY_LEFTSHOULDER  ].z = LeftShoulder .confidence;
        detections[n_det][BODY_RIGHTSHOULDER ].z = RightShoulder.confidence;
        detections[n_det][BODY_LEFTHIP       ].z = LeftHip      .confidence;
        detections[n_det][BODY_RIGHTHIP      ].z = RightHip     .confidence;
        detections[n_det][BODY_LEFTKNEE      ].z = LeftKnee     .confidence;
        detections[n_det][BODY_RIGHTKNEE     ].z = RightKnee    .confidence;
        detections[n_det][BODY_LEFTANKLE     ].z = LeftAnkle    .confidence;
        detections[n_det][BODY_RIGHTANKLE    ].z = RightAnkle   .confidence;
        
        scores[n_det] = observation.confidence;
        
        
        //get bounding box of skeleton
        float ymin = INT_MAX;
        float xmin = INT_MAX;
        float ymax = 0;
        float xmax = 0;
        
        for(int i = 0; i < BODY_N_PART; i++) {
            if(detections[n_det][i].z < 0.1) continue;
            ymin = min(ymin,detections[n_det][i].y);
            xmin = min(xmin,detections[n_det][i].x);
            ymax = max(ymax,detections[n_det][i].y);
            xmax = max(xmax,detections[n_det][i].x);
        }
        boundingRects.push_back(ofRectangle(glm::vec3(xmin,ymin,0), glm::vec3(xmax,ymax,0)));
        
        //      boundingRects.push_back(cv::Rect(xmin,ymin, xmax-xmin,ymax-ymin,0));
        
        n_det = (n_det + 1) % MAX_DET;
        
        
        
    }
    CGImageRelease(image);

}

CGImageRef BODY::CGImageRefFromOfPixels( ofPixels & img, int width, int height, int numberOfComponents ){
    
    int bitsPerColorComponent = 8;
    int rawImageDataLength = width * height * numberOfComponents;
    BOOL interpolateAndSmoothPixels = NO;
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGDataProviderRef dataProviderRef;
    CGColorSpaceRef colorSpaceRef;
    CGImageRef imageRef;
    
    GLubyte *rawImageDataBuffer =  (unsigned char*)(img.getData());
    dataProviderRef = CGDataProviderCreateWithData(NULL,  rawImageDataBuffer, rawImageDataLength, nil);
    if(numberOfComponents>1)
    {
        colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    }
    else
    {
        colorSpaceRef = CGColorSpaceCreateDeviceGray();
    }
    imageRef = CGImageCreate(width, height, bitsPerColorComponent, bitsPerColorComponent * numberOfComponents, width * numberOfComponents, colorSpaceRef, bitmapInfo, dataProviderRef, NULL, interpolateAndSmoothPixels, renderingIntent);
    
    CGDataProviderRelease(dataProviderRef);
    CGColorSpaceRelease(colorSpaceRef);
    return imageRef;
}

void BODY::draw(){
    ofPushStyle();
    //    ofSetColor(255,255,0);
    for (int i = 0; i < n_det; i++){
        
        ofColor bodyColor = ofColor((i*23+311)%200, (i*41+431)%200, (i*33+197)%200);
        ofSetColor(bodyColor);
        
        ofNoFill();
        ofDrawRectangle(boundingRects[i]);
        
        ofFill();
        for (int j = 0; j < BODY_N_PART; j++){
            ofDrawCircle(detections[i][j].x, detections[i][j].y, 10);
        }
        ofColor varianceColor = bodyColor - ofColor(10,10,10);
        drawBodyPart(i,BODY_LEFTSHOULDER,BODY_LEFTHIP, varianceColor);
        drawBodyPart(i,BODY_RIGHTSHOULDER,BODY_RIGHTHIP, varianceColor);
        drawBodyPart(i,BODY_LEFTHIP,BODY_LEFTANKLE, varianceColor);
        drawBodyPart(i,BODY_RIGHTHIP,BODY_RIGHTANKLE, varianceColor);
        drawBodyPart(i,BODY_LEFTSHOULDER,BODY_LEFTWRIST, varianceColor);
        drawBodyPart(i,BODY_RIGHTSHOULDER,BODY_RIGHTWRIST, varianceColor);
        
        stringstream ss;
        ss<<"id "<<i<<" : score "<<scores[i]<<endl;
//        ss<<boundingRects[i].getWidth()<<"x"<<boundingRects[i].getHeight();
        ofBitmapFont bitFont;
        ofRectangle bbox = bitFont.getBoundingBox(ss.str(), detections[i][BODY_NOSE].x,detections[i][BODY_NOSE].y);
        float eyeDist = detections[i][BODY_LEFTEYE].distance(detections[i][BODY_RIGHTEYE]);
        ofDrawBitmapStringHighlight(ss.str(),bbox.getPosition() - ofVec3f(bbox.getWidth()/2,bbox.getHeight(),0) - ofVec3f(0,eyeDist*2,0) ,ofColor::black,ofColor::yellow);
        
    }
    ofPopStyle();
}
void BODY::drawInfo(int _x, int _y){
    stringstream ss;
    ss<<"bodies "<<n_det; //<<endl;
    ofDrawBitmapString(ss.str(),0,0);
}


void BODY::drawBodyPart(int _index, int _startPart, int _endPart, ofColor _color){
    ofSetColor(_color);
    ofSetLineWidth(2);
    ofFill();
    if(detections[_index][_startPart] != ofVec3f(0,0,0)  && detections[_index][_endPart] != ofVec3f(0,0,0)){
        ofBeginShape();
        ofVertex(detections[_index][_startPart] - ofVec3f(5,0,0));
        ofVertex(detections[_index][_startPart] + ofVec3f(5,0,0));
        ofVertex(detections[_index][_endPart]);
        ofVertex(detections[_index][_startPart] - ofVec3f(5,0,0));
        ofEndShape();
    }
    
}
