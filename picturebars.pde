
void keyPressed() {
  // Learnt this trick from @blprnt, save a screen shot when 's' key is pressed.
   if (key == 's') 
    save( "screen_shots/" + 
      year() + "_" +
      month() + "_" +
      day() + "_" +
      hour() + "_" +
      minute() + "_" +
      second() + ".png"); 
}

PImage[] logos;

// This data is form the Firefox 4 beta  Test Pilot survey, from:
// 	https://testpilot.mozillalabs.com/testcases/beta/aggregated-data.html
// 
// 280 users did not answer the question, the breakup:
//	243 chrome_users
//	3361 firefox_users
//	114 ie_users
//	326 non_firefox_users
//	37 opera_users
//	47 safari_users

int users[] = { 
	37, 	// Opera Users
	243, 	// Google-Chrome users
	114, 	// IE users
	47	// Safari Users	
	};

float total_users = 37 + 243 + 114 + 47;

void setup() {
	size(1233, 800, P2D);
	smooth();

	logos = new PImage[4];
	logos[0] = loadImage("Apple_Safari.png");
	logos[1] = loadImage("Google_Chrome.png");
	logos[2] = loadImage("Internet_Explorer.png");
	logos[3] = loadImage("Opera.png");

	PImage background_img = loadImage("Firefox.png");

	// Start with a black canvas
	background(0);
	noLoop();

	float user_percent[] = new float[users.length];
	for(int ii = 0; ii < user_percent.length; ii++) {
		user_percent[ii] = users[ii] / total_users;
	}

	PictureBar p = new PictureBar(width, height, logos, user_percent);
	p.draw();
}

void draw() {
}


