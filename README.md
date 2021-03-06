
# PixelSorting

A python library for pixel-sorting images.
This includes a script for easy pixel sorting from the command line, as well as
library code that is abstracted and easily extensible for custom features.

## Features
 - A variety of sorting paths
 - Many different sort functions
 - Edge detection for sorting boundaries
 - Sorting individual tiles within an image
 - Support for sorting GIFs and creating animated sorts.

## Installation
PixelSorting requires the Pillow module for image manipulation.

One can run ` pip install -r requirements.txt` to download any necessary modules.

## Usage

To run the script, use the command `python pixelsort.py <image> -o <result>` to sort a given image
and store it in `<result>`. Use the `--log` flag to view progress for sorting particularly large images.
Various sorting options are described in detail in below.
One can also run the script with the `-h|--help` flag to see the full list of options.

Given the following original image:

![Original Image][original]

The default sorting settings will produce:

![Default sorting][default]

One can also sort certain intervals using the `-i` flag.
The flags `-i 50 -r` will sort random intervals of length up to 50 pixels:

![Sorting random intervals][sort50random]

There are a variety of possible sorting paths, specified using the `-p` flag.
For example, `-i 100 -r -p diagonal` will produce:

![Sorting diagonally][sort100-diagonal]

Paths can also accept arguments.
For instance, the flag `-p "angled-line angle=60"` passes the argument `angle=60` to the `angled-line` path,
and sorts pixels in lines tilted at 60 degrees:

![Sorting with angled lines][sort-angled-line-60]

Sorting paths are explained in more detail in [the paths documentation](PATHS.md).

### Animation

The pixelsorting script supports animation using the `--animate` flag.
The syntax is `--animate "<param> initial_value end_value num_frames"`,
where the given parameter is interpolated between the start and end values for the given number of frames.

For instance, the flags `--animate "max_interval 2 30 15` will produce the following animation:
![Animated sort][sort-animated]

One can also animate path arguments using the syntax `path.arg`.
For instance, `-p angled-line --animate "path.angle 0 90 20"` will produce a 20-frame animation
in which the angle of sorting goes from horizontal to vertical.

One can also run the script using animated GIFs as input.

[//]: # "Figures"
[original]: README-images/original.jpg
[default]: README-images/sort-sum.jpg
[sort50random]: README-images/sort-50-random.jpg
[sort100-diagonal]: README-images/sort-100-diagonal.jpg
[sort-angled-line-60]: README-images/sort-angled-line-60.jpg
[sort-animated]: README-images/sort-animated.gif


### License

This software is licensed under the GNU GPL license, which can be found in [LICENSE.txt](LICENSE.txt).
In short, one is free to use, modify, and redistribute this code, under the GPL license.


# PixelSorting – Documentation

A detailed description of the possible sort parameters.

## Command Line Options

To run the script, use the command `python pixelsort.py <image> -o <result>` to sort a given image
and store it in `<result>`. Use the `--log` flag to view progress for sorting particularly large images.
The other settings and options are described below.
For the example README-images, the original image used is this:

![Original Image][original]

#### Sorting Interval:

The `-i` or `--max-interval` argument specified the length of individual intervals of pixels to sort.
By default, whole rows of the image are sorted at once. However, when `-i <INTEGER>` is used,
pixels are sorted in consecutive groups of the given length.

With `-i` omitted:

![Default sorting interval][default]

With `-i 50`:

![Sorting interval of 50px][sort50]

With `-i 100`:

![Sorting interval of 100px][sort100]

The `-r` or `--randomize` argument will cause pixel intervals to have random length between 1 and `INTERVAL` pixels,
where `INTERVAL` is the amount specified by the `-i` flag. If the `-i` flag is omitted, then `-r` has no effect.

With `-i 50`:

![Uniform sorting interval of 50px][sort50]

With `-i 50 -r`:

![Random sorting interval of 50px][sort50random]

The `--progressive-amount <AMOUNT>` flag takes a floating point amount,
and increases the sorting interval by the given amount each row, as a fraction of the total interval.
For instance, with `-i 100` and `--progressive-amount 0.01`,
the sorting interval would increase by 1 pixel each row.
Since there are hundreds of rows in an image, values less than `0.001` usually work best.

With `-i 100 -r` and no progressive sorting:

![Sorting with random interval of 100][sort100random]

With `-i 100 -r --progressive-amount 0.0001`:

![Sorting with random interval of 100 and progressive sorting][sort100-progressive]

(It is difficult to see, but the sorting intervals near the top rows are smaller than at the bottom.)

#### Sorting Keys:

One can apply a custom function to pixels before they are sorted,
allowing one to sort by brightness, saturation, or some other metric.
This is done using the `-s <KEY>` or `--sortkey <KEY>` flag, where `<KEY>`
is one of a set of predefined function names.
By default, pixels are sorted simply using their numerical value.
Note that sorting is stable, so if pixels are mapped to the same value,
their relative position will be unchanged.

Default sorting method:

![Default sorting method][sort-default]

Using `-s sum` will sort by the sum of the pixel's (R,G,B) values:

![Sorting by pixel sum][sort-sum]

Using `-s red|green|blue` will sort using only the given channel of each pixel.
Sorting with `-s blue` is shown below.

![Sorting by pixel sum][sort-blue]

Other sorting methods include:
 - `chroma`
 - `hue`
 - `intensity`
 - `lightness`
 - `luma`
 - `random`
 - `saturation`
 - `value`

Using the `-R` or `--reverse` flag will reverse the sorting order of the pixels:

With `-i 50`:

![Uniform sorting interval of 50px][sort50]

With `-i 50 -R`:

![Reversed sorting interval of 50px][sort50reverse]

The `-d` or `--discretize <INTEGER>` flag will take pixel values,
divide them by the given amount, and cast to an integer.
This means that pixels with small variations will be binned into the same categories,
and not sorted relative to each other.
This allows one, for instance, to only move the "brightest" pixels while the other pixels stay in place.

With `-s sum` and `-d` omitted:

![Sorting by sum][sort-sum]

With `-s sum -d 100`:

![Sorting by sum with -d 100][sort-sum-d100]

With `-s sum -d 200`:

![Sorting by sum with -d 200][sort-sum-d200]

#### Sorting Paths

By default, all sorting is done in horizontal intervals through the image.
However, several other sorting paths are available.

The `-v` flag will sort the image vertically instead of horizontally.
Otherwise, one can explicitly specify what type of path to use with the `-p` or `--path` flag:
 - `concentric` Instead of rows, sorts concentric rectangles around the image.

![Sorting with concentric path][sort100-concentric]

 - `diagonal` Sorts in diagonal lines that move from the top left to the bottom right.

![Sorting with diagonal path][sort100-diagonal]

 - `horizontal`: The default, sorts horizontally row by row

![Sorting with horizontal path][sort100random]

 - `vertical`: Sorts vertically, column by column

![Sorting with concentric path][sort100-vertical]

Sorting paths are explained in detail in [the paths documentation.](PATHS.md)

#### Path modifiers

Several modifiers can be applied to individual intervals of pixels.
 - `mirror` - The mirror modifier takes an interval of pixels,
and moves each successive pixel to either the beginning or end of the interval.
 This makes intervals look symmetric, and borders between intervals are more continuous.
 This is especially useful for intervals that form loops, such as the `concentric` path.

   With `-s luma -p concentric --mirror`:
   ![Sorting with concentric paths and --mirror][sort-concentric-mirror]

 - `splice` - The splice modifier splits an interval of pixels at a certain position,
 and places the front half after the second half.
 The split position is given as a number between `0` and `1`, with `0` reprsenting the start of the list
  and `1` representing the end.

   With `-s luma -p concentric --splice 0`:
   ![Sorting with concentric paths and splice=0][sort-concentric-splice-0]

   With `-s luma -p concentric --splice 0.3`:
   ![Sorting with concentric paths and splice=0.3][sort-concentric-splice-0.3]

  - `splice-random` - Randomly splices each interval at a different position.

   With `-s luma -p concentric --splice-random`:
   ![Sorting with concentric paths and --splice-random][sort-concentric-splice-random]


#### Edge Detection

Edge detection allows one to break up sorting intervals are points of high contrast
(i.e. where there are edges in the image). This creates the effect of only sorting within low-contrast regions.
The `-e <THRESHOLD>` or `--edge-threshold <THRESHOLD>` flag can be used to specify a numerical threshold above
pixels are considered "edges". Intuitively, this means that low thresholds will cause images with very short sorting
intervals, while very high threholds will cause the image to be almost completely sorted, as if `-e` had
not been specified at all. However, the exact effects depend on the image specified.

The original image:

![Original Image][original]

Sorting with `-e 50`:

![Sorting with -e 50][sort-edge-detect-50]

Sorting with `-e 100`:

![Sorting with -e 100][sort-edge-detect-100]

Sorting with `-e 200`:

![Sorting with -e 200][sort-edge-detect-200]

Sorting without the `-e` flag:

![Sorting without -e][default]

Note that with low `-e` values, nearly the whole image is undisturbed,
since almost everything is considered an 'edge',
but with high `-e` values everything is sorted except for the starkly-contrasted trees.

### Image Thresholds

Image colors can also be used to determine sorting intervals. When `--image-threshold <FLOAT>`
is specified, pixels that are too dark or too bright are not sorted,
and delimit sorting intervals. The value given determines the thresholds for pixel brightness.
This value ranges from 0 (meaning all pixels are within the brightness threshold, and everything gets sorted),
to 1 (meaning all pixels are out of the brightness threshold, and nothing is sorted).

The original image:

![Original Image][original]

Sorting with `--image-threshold 0`:

![Sorting with --image-threshold 0][sort-image-threshold-0]

Sorting with `--image-threshold 0.6`:

![Sorting with --image-threshold 0.6][sort-image-threshold-0.6]

Sorting with `--image-threshold 1`:

![Sorting with --image-threshold 1][sort-image-threshold-1]

### Image Masks

One can also specify a custom image that will be used as a sort mask.
In this case, pixels that with a brightness of more than half will be used to delimit sort intervals,
while darker pixels will be ignored. This can be done with the `--image-mask <FILENAME>` flag.
Note that the image mask must have *exactly* the same size

Sorting without `--image-mask` and with `-R`:

![Sorting without image mask][default]

An image mask that can be applied to an image:

![Image mask][image-mask]

Sorting with `--image-mask image-mask.jpg` and `-R`:

![Sorting with image mask][sort-image-mask]

The parts of the image corresponding to black pixels in the pixel mask are sorted,
while the parts corresponding to white pixels are not.

### Tiles

One can also sort individual tiles in the image. With the `--use-tiles` flag,
the image will be broken into a grid of recantgular tiles, and each tile will be sorted as if it were a separate image.
By default, tiles are 50 pixels on a size, but this can be changed with the `--tile-x <INT>` and `--tile-y <INT>` flags

Sorting with `--use-tiles` and `-p diagonal`

![Sorting with tiles with default arguments][sort-tiles-default]

Sorting with `--use-tiles --tile-x 20 --tile-y 30` and `-p diagonal`

![Sorting with custom sized tiles][sort-tiles-custom-size]

The `--tile-density <FLOAT>` flag will only sort the given fraction of tiles. For instance, with `--tile-density 0.5`,
only half of the tiles will be sorted, while the others are unmodified. By default, all tiles are sorted.
Also, if the density is less than 1, tiles are sorted uniformly across the image.
If the `--randomize-tiles` flag is specified, then tiles will be randomly sorted,
with the probability given by `--tile-density <FLOAT>`.

Sorting with `--use-tiles --tile-x 20 --tile-y 20 --tile-density 0.5` and `-p diagonal-single`

![Sorting with tiles and density 0.5][sort-tiles-half]

Sorting with `--use-tiles --tile-x 20 --tile-y 20 --tile-density 0.5 --randomize-tiles` and `-p diagonal-single`

![Sorting with custom sized tiles][sort-tiles-half-random]


### Channels

It is also possible to sort individual channels of an RGB image, using the `--channel {red,green,blue}` flag.

Sorting with `--channel red` and `-s sum -i 100 -r`

![Sorting red channel only][sort-channel-red]

### Animation

This pixelsorting library also includes tools for creating and modifying animated gifs.
To change a certain parameter over time, on can use the `--animate "PARAM START STOP N_STEPS"` flag.
For instance, to change the sorting interval from 10 to 100 over 15 frames, one could specify
`--animage "max_interval 10 100 15"`.
Note that currently, this is only possible for parameters that have numerical values.
Also, only one parameter can be animated at a time.

Animated sort, with  `--animate "max_interval 2 30 15"` and `-s sum -r`:

![Animated sort][sort-animated]

To save intermediate frames, use the `--save-frames` flag.

One can also input animated gifs, and each frame of the gif will be modified according to the command line arguments.
If `--animate "..."` is specified as well, the animated settings will be applied frame-by-frame to the gif.

[//]: # "Figures"
[original]: README-images/original.jpg
[default]: README-images/sort-sum.jpg
[sort50]: README-images/sort-50.jpg
[sort100]: README-images/sort-100.jpg
[sort50random]: README-images/sort-50-random.jpg
[sort100random]: README-images/sort-100-random.jpg
[sort-default]: README-images/sort-default.jpg
[sort-sum]: README-images/sort-sum.jpg
[sort-blue]: README-images/sort-blue.jpg
[sort50reverse]: README-images/sort-50-reverse.jpg
[sort-sum-d100]: README-images/sort-sum-d100.jpg
[sort-sum-d200]: README-images/sort-sum-d200.jpg
[sort100-progressive]: README-images/sort-100-progressive.jpg
[sort100-concentric]: README-images/sort-100-concentric.jpg
[sort100-diagonal]: README-images/sort-100-diagonal.jpg
[sort-diagonal-single]: README-images/sort-diagonal-single.jpg
[sort100-random-walk]: README-images/sort-100-random-walk.jpg
[sort100-random-walk-horizontal]: README-images/sort-100-random-walk-horizontal.jpg
[sort100-random-walk-vertical]: README-images/sort-100-random-walk-vertical.jpg
[sort100-vertical]: README-images/sort-100-vertical.jpg
[sort-concentric-mirror]: README-images/sort-concentric-mirror.jpg
[sort-concentric-splice-0]: README-images/sort-concentric-splice-0.jpg
[sort-concentric-splice-0.3]: README-images/sort-concentric-splice-0.3.jpg
[sort-concentric-splice-random]: README-images/sort-concentric-splice-random.jpg
[sort-edge-detect-50]: README-images/sort-edge-detect-50.jpg
[sort-edge-detect-100]: README-images/sort-edge-detect-100.jpg
[sort-edge-detect-200]: README-images/sort-edge-detect-200.jpg
[sort-image-threshold-0]: README-images/sort-image-threshold-0.jpg
[sort-image-threshold-0.6]: README-images/sort-image-threshold-0.6.jpg
[sort-image-threshold-1]: README-images/sort-image-threshold-1.jpg
[image-mask]: README-images/image-mask.jpg
[sort-image-mask]: README-images/sort-image-mask.jpg
[sort-tiles-default]: README-images/sort-tiles-default.jpg
[sort-tiles-custom-size]: README-images/sort-tiles-custom-size.jpg
[sort-tiles-half]: README-images/sort-tiles-half.jpg
[sort-tiles-half-random]: README-images/sort-tiles-half-random.jpg
[sort-channel-red]: README-images/sort-channel-red.jpg
[sort-animated]: README-images/sort-animated.gif
# PixelSorting – Sort Paths

Sorting paths specify the directions in which pixels are sorted on an image. For example,
by default the sort path is horizontal, so pixels are sorted row-by-row.
Consecutive rows move down vertically through the image.

Every path is defined in this way - as a series of "rows" (or intervals), in which each row is a set of pixels.
Ideally, each pixel in a "row" would be close to the previous pixel, and each row would be close to the previous one.
Thus, a sorting path can "sweep over" the area of the image and cover it completely.
In a way, a sort path corresponds to a two-dimensional *parametrization* of the image plane.

However, sort paths don't have to be constrained in this way, and can pretty much be arbitrary sets of sets of pixels.

One can specify the type of sort path using the command line argument `-p|--path <pathname>`.
Some paths accept arguments, which can be specified using the syntax:
`-p|--path "<pathname> <arg1>=<val1> <arg2>=<val2> ..."`.

## Built-in Paths
The pixelsorting script has the following built-in sorting path options:
- `angled-line`
- `circles`
- `concentric`
- `diagonal`
- `diagonal-single`
- `fill-circles`
- `horizontal`
- `random-walk`
- `random-walk-horizontal`
- `random-walk-vertical`
- `vertical`

#### angled-line

The angled-line path consists of a series of adjacent rows of pixels,
where each row is a series of pixels in a line, at a certain angle.

**Parameters**:
 - `angle` --- The angle of the lines in degrees. By default, this is `0`.

The following image shows this sort path with an angle of 60 degrees:

![sort with 60° angle][angled-line-60]

#### circles

The circles path consists of a series of concentric circles.
The circles expand until every part of the image, including the corners, is covered.

The following image shows this sort path:

![sort with concentric circles][circles]


#### concentric

The concentric path consists of a series of concentric rectangles, starting with the border of the image and moving inwards.

![sort with concentric rectangles][concentric]

#### diagonal

The diagonal path consists of a series of diagonal lines moving from the top left to the bottom right of the image.
Successive lines start at the bottom-left corner and move up until the top-right corner.

![sort with diagonal lines][diagonal]

#### diagonal-single

This is similar to the diagonal path, except that instead of a series of consecutive lines, all the paths are combined into a single line.
This creates a very smooth progression moving diagonally through the image.

![sort with diagonal-single path][diagonal-single]

#### fill-circles

This path covers an image with a series of overlapping circles. Each circle is like the `circles` path,
in that it contains concentric rings of pixels forming a circle.

**Parameters**
 - `radius` --- The radius of each individual circle. By default, this is `100`.

 The following image shows this sort path with a radius of 30:

![sort with fill-circles path][fill-circles-30]

#### horizontal

This is the default sort path. It sorts pixels in horizontal rows,
with each row one pixel below the previous one.

![sort with horizontal lines][horizontal]

#### random-walk

Sorts pixels in a series of random walks over the image.
The random walks terminate when they reach the edge of the image.
The number of random walks is such that, roughly,
the number of pixels covered in the walks is equal
to the total number of pixels in the image.
However, since walks often overlap, the whole image is rarely covered.

![sort with random walk][random-walk]

#### random-walk-horizontal

This sorts pixels in a series of horizontal random walks.
For each row of the image, a line starts on the left-most pixel, and then moves to the right,
randomly shifting up or down a pixel each step.

![sort with horizontal random walk][random-walk-horizontal]

#### random-walk-vertical

This sorts pixels in a series of vertical random walks.
For each column of the image, a line starts on the top pixel, and then moves down,
randomly shifting left or right a pixel each step.

![sort with vertical random walk][random-walk-vertical]

#### vertical

Similar to the horizontal path, this sorts an image in a series of vertical lines moving across the image.

![sort with vertical lines][vertical]

## Custom paths

While it is not possible to specify custom paths from the command line,
they can be created programmatically and passed to the sorting function in a Python script.
Each sort path is simply a generator of generators of pixels.
This means that each sort path is a function that, when called,
yields a series of "intervals", and each interval yields a series of `(x,y)` tuples representing pixel
coordinates.
The function should accept a tuple of (width, height) which represents the dimensions of the image.

For example, here is an implementation of the `horizontal` sort path:

```python
def horizontal_path(size):
    width, height = size
    return (((x, y) for x in range(width)) for y in range(height))
```

Then, sort paths are called in the following fashion:

```python
pixel_iterator = your_sort_path(img_size)
for row in pixel_iterator:
    for pixel in row:
        x, y = pixel
        # do stuff with pixel....
```

[//]: # "Figures"
[angled-line-60]: README-images/sort-angled-line-60.jpg
[circles]: README-images/sort-circles.jpg
[concentric]: README-images/sort-100-concentric.jpg
[diagonal]: README-images/sort-100-diagonal.jpg
[diagonal-single]: README-images/sort-diagonal-single.jpg
[fill-circles-30]: README-images/sort-fill-circles-30.jpg
[horizontal]: README-images/sort-100-random.jpg
[random-walk]: README-images/sort-100-random-walk.jpg
[random-walk-horizontal]: README-images/sort-100-random-walk-horizontal.jpg
[random-walk-vertical]: README-images/sort-100-random-walk-vertical.jpg
[vertical]: README-images/sort-100-vertical.jpg
