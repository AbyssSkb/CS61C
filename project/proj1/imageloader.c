/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Opens a .ppm P3 image file, and constructs an Image object.
// You may find the function fscanf useful.
// Make sure that you close the file with fclose before returning.
Image* readData(char* filename)
{
    // YOUR CODE HERE
    FILE* fp = fopen(filename, "r");
    char buf[20];
    int height, width, max_value;
    fscanf(fp, "%s %d %d %d", buf, &width, &height, &max_value);
    Image* ans = malloc(sizeof(Image));
    ans->image = malloc(sizeof(Color*) * width * height);
    ans->cols = width;
    ans->rows = height;
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            int index = i * width + j;
            ans->image[index] = malloc(sizeof(Color));
            int r, g, b;
            fscanf(fp, "%d %d %d", &r, &g, &b);
            ans->image[index]->R = r;
            ans->image[index]->G = g;
            ans->image[index]->B = b;
        }
    }
    fclose(fp);
    return ans;
}

// Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image* image)
{
    printf("P3\n");
    printf("%d %d\n", image->cols, image->rows);
    printf("255\n");
    int width = image->cols;
    int height = image->rows;
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            int index = i * width + j;
            printf("%3d %3d %3d", image->image[index]->R, image->image[index]->G, image->image[index]->B);
            if (j + 1 < width) {
                printf("   ");
            } else {
                printf("\n");
            }
        }
    }
}

// Frees an image
void freeImage(Image* image)
{
    for (int i = 0; i < image->cols * image->rows; i++) {
        free(image->image[i]);
    }
    free(image->image);
    free(image);
}
