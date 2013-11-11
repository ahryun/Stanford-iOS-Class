//
//  ImageDisplay.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/8/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "ImageDisplay.h"

@interface ImageDisplay ()

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;

@end

@implementation ImageDisplay

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

// if use core data
- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    [self resetImage];
    
}

#define APPLICATION_NAME @"<#Folder Name#>"
#define IMAGE_FOLDER @"<#Image Folder NAme#>"

- (void)resetImage
{
    if (self.imageScrollView) {
        self.imageScrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        NSString *uniqueID = self.photo.uniqueID;
        [self.loadingSpinner startAnimating];
        dispatch_queue_t imageFetch = dispatch_queue_create("Flickr Photo", NULL);
        dispatch_async(imageFetch, ^{
            UIApplication *application = [UIApplication sharedApplication];
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath =[documentPaths objectAtIndex:0];
            NSString *subDir = [documentPath stringByAppendingPathComponent:APPLICATION_NAME];
            NSString *imgDir = [subDir stringByAppendingPathComponent:IMAGE_FOLDER];
            NSString *imagePath = [imgDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg", self.photo.uniqueID]];
            
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            UIImage *image;
            if ([fileManager isReadableFileAtPath:imagePath]) {
                image = [[UIImage alloc] initWithContentsOfFile:imagePath];
            } else {
                application.networkActivityIndicatorVisible = YES;
                NSURL *photoURL = [NSURL URLWithString:self.photo.photoURL];
                NSData *data = [[NSData alloc] initWithContentsOfURL:photoURL];
                image = [[UIImage alloc] initWithData:data];
            }
            
            application.networkActivityIndicatorVisible = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.photo.uniqueID isEqualToString:uniqueID]) {
                    if (image) {
                        self.imageScrollView.zoomScale = 1.0;
                        self.imageScrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                        BOOL portrait = self.imageScrollView.bounds.size.height > self.imageScrollView.bounds.size.width ? YES : NO;
                        if (portrait) {
                            [self.imageScrollView zoomToRect:CGRectMake(0, 0, 1.0, image.size.height) animated:YES];
                        } else {
                            [self.imageScrollView zoomToRect:CGRectMake(0, 0, image.size.width, 1.0) animated:YES];
                        }
                        [self.loadingSpinner stopAnimating];
                    }
                }
            });
        });
    }
}

@end
