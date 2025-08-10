/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

// Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color* evaluateOnePixel(Image* image, int row, int col)
{
    Color* ans = malloc(sizeof(Color));
    int index = row * image->cols + col;
    int color = image->image[index]->B & 1;
    if (color == 1) {
        color = 255;
    }
    ans->R = color;
    ans->G = color;
    ans->B = color;
    return ans;
}

// Given an image, creates a new image extracting the LSB of the B channel.
Image* steganography(Image* image)
{
    // YOUR CODE HERE
    int width = image->cols;
    int height = image->rows;
    Image* new_image = malloc(sizeof(Image));
    new_image->image = malloc(sizeof(Color*) * width * height);
    new_image->cols = width;
    new_image->rows = height;
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            int index = i * width + j;
            new_image->image[index] = evaluateOnePixel(image, i, j);
        }
    }
    return new_image;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image,
where each pixel is black if the LSB of the B channel is 0,
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char** argv)
{
    // YOUR CODE HERE
    Image* image = readData(argv[1]);
    Image* new_image = steganography(image);
    writeData(new_image);
    freeImage(image);
    freeImage(new_image);
    return 0;
}
