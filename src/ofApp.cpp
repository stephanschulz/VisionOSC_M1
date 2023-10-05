#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
  ofSetDataPathRoot("../Resources/");
  
  gui.setup("", "settings.xml");
  
  gui.add(osc_group);
  gui.add(cam_group);
  gui.add(btn_reset.setup("Apply OSC/Cam Settings"));
  btn_reset.addListener(this, &ofApp::resetCamOsc);
  gui.add(do_group);
  
  gui.loadFromFile("settings.xml");
  
    cam.listDevices();
  cam.setDeviceID(cam_id);
  cam.initGrabber(cam_w,cam_h);
  
  sender.setup(osc_host.get(), osc_port.get());
}

//--------------------------------------------------------------
void ofApp::update(){
  cam.update();
  if (cam.isFrameNew()){
    ofPixels & pixels = cam.getPixels();

    if (do_body) body.detect(pixels);
    if (do_face) face.detect(pixels);
    
    
    if (do_body){
      ofxOscMessage m;
      m.setAddress("/poses/arr");
      m.addIntArg(cam.getWidth());
      m.addIntArg(cam.getHeight());
      m.addIntArg(body.n_det);
      for (int i = 0; i < body.n_det; i++){
        m.addFloatArg(body.scores[i]);
        for (int j = 0; j < BODY_N_PART; j++){
          m.addFloatArg(body.detections[i][j].x);
          m.addFloatArg(body.detections[i][j].y);
          m.addFloatArg(body.detections[i][j].z);
        }
      }
      sender.sendMessage(m, false);
    }
    

    
    if (do_face){
      ofxOscMessage m;
      m.setAddress("/faces/arr");
      m.addIntArg(cam.getWidth());
      m.addIntArg(cam.getHeight());
      m.addIntArg(face.n_det);
      for (int i = 0; i < face.n_det; i++){
        m.addFloatArg(face.scores[i]);
        for (int j = 0; j < FACE_N_PART; j++){
          m.addFloatArg(face.detections[i][j].x);
          m.addFloatArg(face.detections[i][j].y);
          m.addFloatArg(face.detections[i][j].z);
        }
      }
      sender.sendMessage(m, false);
    }
    
  
    
   
    
    
  }
  
  
  ofSetWindowTitle(ofToString(ofGetFrameRate()));
}

//--------------------------------------------------------------
void ofApp::draw(){
  cam.draw(0,0);
  
  if (do_body){
    ofPushStyle();
    ofSetColor(255,255,0);
    for (int i = 0; i < body.n_det; i++){
      for (int j = 0; j < BODY_N_PART; j++){
        ofDrawCircle(body.detections[i][j].x, body.detections[i][j].y, 10);
      }
    }
    ofPopStyle();
  }
  
  
  
  if (do_face){
    ofPushStyle();
    for (int i = 0; i < face.n_det; i++){
      ofFill();
      ofSetColor(255,0,255);
      for (int j = 0; j < FACE_N_PART; j++){
        ofDrawCircle(face.detections[i][j].x, face.detections[i][j].y, 5);
      }
      // face orientation: extremely choppy
      // seems to only support 45deg increments, X-axis not supported
  //    ofSetColor(0,0,255);
  //    ofPushMatrix();
  //    ofTranslate(face.detections[i][34]);
  //    ofRotateZRad(face.orientations[i].z);
  //    ofRotateYRad(face.orientations[i].y);
  //    ofRotateXRad(face.orientations[i].x);
  //    ofNoFill();
  //    ofDrawBox(-50,-50,-50,100,100,100);
  //    ofPopMatrix();
    }
    ofPopStyle();
  }
  
 
  
  gui.draw();
}

void ofApp::resetCamOsc(){
  cam.setDeviceID(cam_id);
  cam.initGrabber(cam_w,cam_h);
  sender.setup(osc_host.get(), osc_port.get());
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
