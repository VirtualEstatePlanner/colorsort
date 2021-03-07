
# ColorSort

## Usage

First select a sorting style (as defined by the image tag), then run:

`docker run --rm -e OUTPUTFILE=`*OUTPUT_FILENAME_WITH_NO_EXTENSION*` \`
`-v `*YOUR_PNG_IMAGE_WITH_EXTENSION*`:/source.png -v `*OUTPUT_DIRECTORY*`:/output \`
`georgegeorgulasiv/colorsort:`*SORT_CRITERIA_TAG*

but, replace the parts in *italics* with the appropriate values.

Then just wait until the image appears in your output directory.