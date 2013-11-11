//
//  ImageViewController.m
//  Flickr
//
//  Created by Ahryun Moon on 10/24/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic) BOOL isShowingLandscapeView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;


@end

@implementation ImageViewController

-(void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
}

-(void)setImageID:(NSString *)imageID
{
    _imageID = imageID;
    [self resetImage];
}

#define VIEWED_PHOTOS @"recentPhotos"

- (void)resetImage
{
    if (self.imageScrollView) {
        self.imageScrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        NSURL *imageURL = self.imageURL;
        [self.loadingSpinner startAnimating];
        dispatch_queue_t imageFetch = dispatch_queue_create("Flickr Photo", NULL);
        dispatch_async(imageFetch, ^{
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
            UIApplication *application = [UIApplication sharedApplication];
            
            // See if the image has been cached
            
            // Create the image path
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath =[documentPaths objectAtIndex:0];
            NSString *subDir = [documentPath stringByAppendingPathComponent:VIEWED_PHOTOS];
            NSString *imgDir = [subDir stringByAppendingPathComponent:@"image"];
            NSLog(@"Image ID here is %@", self.imageID);
            NSString *imagePath = [imgDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg", self.imageID]];
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSLog(@"%@", imagePath);
            UIImage *image;
            if ([fileManager isReadableFileAtPath:imagePath]) {
                NSLog(@"Pulling cached image");
                image = [[UIImage alloc] initWithContentsOfFile:imagePath];
            } else {
                application.networkActivityIndicatorVisible = YES;
                NSLog(@"Pulling image from URL");
                NSData *data = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                image = [[UIImage alloc] initWithData:data];
            }
            
            application.networkActivityIndicatorVisible = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.imageURL == imageURL) {
                    if (image) {
                        self.imageScrollView.zoomScale = 1.0;
                        self.imageScrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                        NSLog(@"Super view width: %f, height: %f", self.view.bounds.size.width, self.view.bounds.size.height);
                        NSLog(@"Scroll view width: %f, height: %f", self.imageScrollView.bounds.size.width, self.imageScrollView.bounds.size.height);
                        NSLog(@"Image view width: %f, height: %f", self.imageView.bounds.size.width, self.imageView.bounds.size.height);
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView // makes zooming possible
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageScrollView addSubview:self.imageView];
    self.imageScrollView.minimumZoomScale = 0.2;
    self.imageScrollView.maximumZoomScale = 5.0;
    self.imageScrollView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageScrollView.delegate = self;
    [self resetImage];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

- (void)orientationChanged:(NSNotification *)note
{
    UIDevice *device = note.object;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            NSLog(@"Device in portrait mode");
            [self resetImage];
            break;
        default:
            NSLog(@"Device in landscape mode");
            [self resetImage];
            break;
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

@end
