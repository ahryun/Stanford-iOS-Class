//
//  PhotoViewController.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/8/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "ImageVC.h"
#import "MapViewController.h"
#import "Photo+MKAnnotation.h"

@interface ImageVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) MapViewController *mapViewController;

@end

@implementation ImageVC

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    [self resetImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageScrollView addSubview:self.imageView];
    self.imageScrollView.minimumZoomScale = 0.2;
    self.imageScrollView.maximumZoomScale = 2.0;
    self.imageScrollView.delegate = self;
    if (self.mapViewController) {
        NSLog(@"The Photo I'm seeing is %@", self.mapViewController);
        [self.mapViewController.mapView removeAnnotations:self.mapViewController.mapView.annotations];
        [self.mapViewController.mapView addAnnotation:self.photo];
    }
}

- (void)resetImage
{
    [self.spinner startAnimating];
    dispatch_queue_t fetchQ = dispatch_queue_create("", nil);
    dispatch_async(fetchQ, ^{
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath =[documentPaths objectAtIndex:0];
        NSString *subDir = [documentPath stringByAppendingPathComponent:@"FlickrPhotos"];
        NSString *imgDir = [subDir stringByAppendingPathComponent:@"Images"];
        NSString *imgPath = [imgDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", self.photo.uniqueID]];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        UIImage *photoImage;
        UIApplication *application = [UIApplication sharedApplication];
        if (![fileManager fileExistsAtPath:imgPath]) {
            NSURL *photoURL = [NSURL URLWithString:self.photo.photoURL];
            application.networkActivityIndicatorVisible = YES;
            NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
            photoImage = [UIImage imageWithData:photoData];
            NSLog(@"%@", imgPath);
            [fileManager createDirectoryAtPath:imgDir withIntermediateDirectories:YES attributes:nil error:nil];
            BOOL success = [fileManager createFileAtPath:imgPath contents:photoData attributes:nil];
            if (!success) NSLog(@"Photo did NOT get saved correctly");
            
        } else {
            NSLog(@"File exists");
            NSData *photoData = [NSData dataWithContentsOfFile:imgPath];
            photoImage = [UIImage imageWithData:photoData];
        }
        application.networkActivityIndicatorVisible = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            // image is a UIImage init alloced with NSData
            self.imageScrollView.zoomScale = 1.0;
            self.imageScrollView.contentSize = photoImage.size;
            self.imageView.image = photoImage;
            self.imageView.frame = CGRectMake(0, 0, photoImage.size.width, photoImage.size.height);
            // Below makes sure the photo takes up the most space of the screen
            BOOL portrait = self.imageScrollView.bounds.size.height > self.imageScrollView.bounds.size.width ? YES : NO;
            if (portrait) {
                [self.imageScrollView zoomToRect:CGRectMake(0, 0, 1.0, photoImage.size.height) animated:YES];
            } else {
                [self.imageScrollView zoomToRect:CGRectMake(0, 0, photoImage.size.width, 1.0) animated:YES];
            }
            [self.spinner stopAnimating];
        });
    });
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView // makes zooming possible
{
    // imageView is an UIImageView
    return self.imageView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embedded Map"]) {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            self.mapViewController = segue.destinationViewController;
        }
        
    }
    
}

@end
