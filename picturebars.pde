
void keyPressed() {
  // Learnt this trick from @blprnt, save a screen shot when 's' key is pressed.
	String output_file = "screen_shots/" + 
				year() + "_" +
				month() + "_" +
				day() + "_" +
				hour() + "_" +
				minute() + "_" +
				second() + ".png";

	if (key == 's') save(output_file); 

	// To save the image with the black background marked as tansparent
	// Does not work well with anti-aliasing turned on
	if (key == 'S') {
		PGraphics frameToSave = createGraphics(width, height, P2D);
		colorMode(HSB);
		frameToSave.beginDraw();
		loadPixels();
		frameToSave.loadPixels();
		float h,s,b;
		for (int i=0; i<pixels.length; i++){
			h=hue(pixels[i]);
			s=saturation(pixels[i]);
			b=brightness(pixels[i]);
			if (b>0) frameToSave.pixels[i]=color(h,s,b,255);
			else frameToSave.pixels[i]=color(h,s,b,0);
			// re-use the brightness value as the alpha --
			// (since the pixel array, strictly speaking,
			// does not contain alpha values (whoops.)
			// in this example, if the brightness is 0,
			// use 0 alpha, otherwise use full alpha.
		}
		frameToSave.updatePixels();
		frameToSave.endDraw();
		frameToSave.save(output_file);
	}
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
	size(2000, 800, P2D);
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

	PictureBar p = new PictureBar(
				width / 3,
				height / 2 - 100,
				logos, 
				user_percent);

	int icons_per_level = 3;

	stroke(255);
	line(0, height / 2, width, height / 2);

	for(int x = 0; x < width; x += width / 3) {
		p.set_columns(icons_per_level);
		icons_per_level += 2;

		p.set_init_x(x);
		p.set_init_y(50);
		p.set_bottom_to_top();
		p.draw();

		p.set_init_x(x);
		p.set_init_y(height / 2 + 50);
		p.set_top_to_bottom();
		p.draw();

		line(x, 0, x, height);
	}
}

void draw() {
}


