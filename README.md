
# ColorSort

## Usage

First select a sorting style (as defined by the image tag) then run:


`docker run --rm -e OUTPUTFILE=`*OUTPUT_FILENAME_WITH_NO_EXTENSION*` -v `*PATH_TO_YOUR_PNG_IMAGE*`:/source.png -v `*PATH_TO_YOUR_OUTPUT_DIRECTORY*`:/output georgegeorgulasiv/colorsort:`*TAG_FOR_YOUR_SORT_CRITERIA*
```

Then wait until the image appears in your output directory