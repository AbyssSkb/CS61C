/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
// Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
// and the left column as adjacent to the right column.
Color* evaluateOneCell(Image* image, int row, int col, uint32_t rule)
{
    // YOUR CODE HERE
    int num[24];
    for (int i = 0; i < 24; i++) {
        num[i] = 0;
    }
    int width = image->cols;
    int height = image->rows;
    for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
            if (dx == 0 && dy == 0) {
                continue;
            }
            int x = (col + dx + width) % width;
            int y = (row + dy + height) % height;
            int index = y * width + x;
            int raw_color = (image->image[index]->R << 16) + (image->image[index]->G << 8) + image->image[index]->B;

            for (int pos = 0; pos < 24; pos++) {
                num[pos] += raw_color & 1;
                raw_color >>= 1;
            }
        }
    }

    int new_color = 0;
    int index = row * width + col;
    int raw_color = (image->image[index]->R << 16) + (image->image[index]->G << 8) + image->image[index]->B;
    for (int pos = 0; pos < 24; pos++) {
        int self_bit = (raw_color >> pos) & 1;
        int new_rule = rule;
        if (self_bit) {
            new_rule >>= 9;
        }
        if ((new_rule >> num[pos]) & 1) {
            new_color |= (1 << pos);
        }
    }
    Color* ans = malloc(sizeof(Color));
    ans->B = new_color & 0xff;
    ans->G = (new_color >> 8) & 0xff;
    ans->R = (new_color >> 16) & 0xff;
    return ans;
}

// The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
// You should be able to copy most of this from steganography.c
Image* life(Image* image, uint32_t rule)
{
    // YOUR CODE HERE
    int width = image->cols;
    int height = image->rows;
    Image* ans = malloc(sizeof(Image));
    ans->rows = height;
    ans->cols = width;
    ans->image = malloc(sizeof(Color*) * width * height);
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            int index = i * width + j;
            ans->image[index] = evaluateOneCell(image, i, j, rule);
        }
    }
    return ans;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char** argv)
{
    // YOUR CODE HERE
    Image* image = readData(argv[1]);
    int rule = strtol(argv[2], NULL, 0);
    Image* new_image = life(image, rule);
    writeData(new_image);
    freeImage(new_image);
    freeImage(image);
    return 0;
}
