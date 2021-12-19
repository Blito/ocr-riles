This is a little script to go through all images in a directory and change all file names based on the content of the images.

It does OCR in them using `tesseract` and uses plain bash to rename the files.

# Instructions

1. Install tesseract
    * https://tesseract-ocr.github.io/tessdoc/Installation.html

2. Run the script like:
```bash
$ rename.sh my_folder_with_images
```