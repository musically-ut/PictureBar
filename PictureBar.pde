/**This is the class for drawing charts based on images
 * instead of the boring colored bars. 
 */

class PictureBar {
	int width_, height_;
	PImage bar_images[];
	float bar_values[];

	int init_x, init_y, base_line, direction;
	int bar_dist, images_in_level;
	int max_bar;

	/** PictureBar object initializer
	 * @param w Width of the region to cover
	 * @param h Height of the region to cover
	 * @param logos An PImage array with all the logo images (should be
	 * square)
	 * @param percent An float array with percentages for each bar
	 */
	PictureBar(int w, int h, PImage[] logos, float[] user_percent) {
		width_ = w;
		height_ = h;
		bar_images = logos;
		bar_values = user_percent;

		init_x = 0;
		init_y = 0;
		
		images_in_level = 4;

		bar_dist = 100;

		base_line = height_;
		direction = -1;

		// Calculate which bar has the largest value
		// this will be the bar which will have 100% height
		// This will help in determining then number of icons
		// and the percentage represented by each
		max_bar = 0;
		for(int ii=1; ii < user_percent.length; ii++) {
			if (user_percent[ii] > user_percent[max_bar]) {
				max_bar = ii;
			}
		}
	}

	/** Sets the initial x value (default value is zero)
	 * @param x The initial x location
	 */
	void set_init_x(int x) {
		init_x = x;
	}

	/** Sets the initial y value (default value is zero)
	 * @param y The initial x location
	 */
	void set_init_y(int y) {
		init_y = y;
	}

	/** Sets the average distance between the bars (default is 100 pixels)
	 * @param dist The distance (in pixels) to put between bars
	 */
	void set_bar_dist(int dist) {
		bar_dist = dist;
	}

	/** Sets the number of icons to put in one level, images will be
	 * resized accordingly
	 * @param n Number of icons to put in one row
	 */
	void set_row_images(int n) {
		images_in_level = n;
	}

	/** Makes the bars inverted (from top to bottom)
	 */
	void set_top_to_bottom() {
		base_line = 0;
		direction = 1;
	}

	/** Makes the bars inverted (from top to bottom)
	 */
	void set_bottom_to_top() {
		base_line = height_;
		direction = -1;
	}

	/** Draws the bars on the canvas */
	void draw() {
		pushMatrix();
		translate(init_x, init_y);

		int num_bars = logos.length;

		float bar_width = (width * 1.0 / num_bars) - bar_dist;
		float icon_size = bar_width / images_in_level;
		float each_icon_percent = 0.0;

		// This is the maximum height to which icons can go
		int max_height_icons = int((height_ / bar_width) *
					images_in_level);
		int num_icons_min = (max_height_icons - 1) * 
					images_in_level;

		// Now to calculate how many icons to fill in the last
		// row to maximize the overall accuracy
		int icons_at_last_level = 1;
		float min_error = 100, error;
		int bar_icons;

		for(int ii = 1; ii <= images_in_level; ii++) {
			each_icon_percent = bar_values[max_bar] / 
				(num_icons_min + ii);

			error = 0;
			for(int jj = 0; jj < num_bars; jj++) {
				bar_icons = round(
					bar_values[jj] /
					each_icon_percent); 
				error += abs(
					bar_values[jj] - 
					bar_icons * 
					each_icon_percent);
			}
			println("Error = " + error);

			if(error < min_error) {
				min_error = error;
				icons_at_last_level = ii;
			}
		}
		each_icon_percent = bar_values[max_bar] / (num_icons_min +
					icons_at_last_level);

		println("Each icon unit = " + each_icon_percent);
		println("Direction = " + direction);

		for(int bar_index = 0; bar_index < num_bars; bar_index++) {
			pushMatrix();

			// Go to the first drawing location
			// The difference is that the images are drawn upright,
			// With reference to their top left corner
			// which is different in different cases
			if(direction < 0) {  // Drawing bottom to top
				translate(
					bar_dist / 2 + bar_index * 
						(bar_width + bar_dist),
					base_line - icon_size);
			} else { // Drawing top to bottom
				translate(
					bar_dist / 2 + bar_index *
						(bar_width + bar_dist),
					base_line);
			}

			_draw_icons(
				bar_index, 
				icon_size, 
				each_icon_percent);

			popMatrix();
		}
		popMatrix();
	}

	/** Internal private function to draw the icons.
	 *
	 * @param bar_index Index of the bar to draw
	 * @param icon_size Size of one icon to draw
	 * @param units Percent represented by one icon
	 */
	void _draw_icons(int bar_index, float icon_size, float units) {
		float value = bar_values[bar_index];
		PImage icon = bar_images[bar_index];

		int count = 0;
		int level = 0;
		int num_icons = round(value / units);
		println("Bar index " + bar_index + " has " + num_icons +
			" icons.");

		boolean finished = false;

		while(!finished) {
			for(int ii = 0; ii < images_in_level; ii++) {
				image(
					icon,
					icon_size * ii,
					icon_size * level,
					icon_size,
					icon_size);
				count++;
				if(count == num_icons) {
					finished = true;
					break;
				}
			}
			level += direction;
		}
	}
}
