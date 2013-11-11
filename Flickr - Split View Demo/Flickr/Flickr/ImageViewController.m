//
//  ImageViewController.m
//  Flickr
//
//  Created by Ahryun Moon on 10/24/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "ImageViewController.h"
#import "AttributedStringVC.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic) BOOL isShowingLandscapeView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (strong,nonatomic) UIPopoverController *urlPopover;


@end

@implementation ImageViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Show URL"]) {
        return (self.imageURL && !self.urlPopover.popoverVisible) ? YES : NO;
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

-(void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (void)setTitle:(NSString *)title
{
    super.title = title;
    self.titleBarButtonItem.title = title;
}
     
- (void)resetImage
{
    if (self.imageScrollView) {
        self.imageScrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        NSData *data = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:data];
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
        }
        
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
    
    self.titleBarButtonItem.title = self.title;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show URL"]) {
        if ([segue.destinationViewController isKindOfClass:[AttributedStringVC class]]) {
            AttributedStringVC *asc = (AttributedStringVC *)segue.destinationViewController;
            asc.text = [[NSAttributedString alloc] initWithString:[self.imageURL description]];
            if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
                self.urlPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
            }
            
        }
    }
}

@end
