String _s="";
float padding= 30;

void status(String s) {
 textSize(16);
  fill(255);
  
  if (s=="speed1") {
    _s = s +"is "+ round(1.0/speed1*1000);
  }
  if (s=="speed2") {
    _s = s +"is "+ 1.0/speed2*1000;
  }
 
  text(_s, padding, height-padding);  // Text wraps within text box

  if (playMovie) {
  }
}

