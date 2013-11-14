//
//  KitchenViewController.m
//  KitchenSink
//
//  Created by Ahryun Moon on 11/13/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "KitchenViewController.h"
#import "AskerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface KitchenViewController ()

@property (weak, nonatomic) IBOutlet UIView *kitchenSink;
@property (weak, nonatomic) NSTimer *timer;
@property (weak, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPopoverController *imagePickerPopOver;

@end

@implementation KitchenViewController

- (IBAction)takeFoodPhoto:(UIBarButtonItem *)sender
{
    [self presenImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
}

- (void)presenImagePicker:(UIImagePickerControllerSourceType)sourceType sender:(UIBarButtonItem *)sender
{
    if (!self.imagePickerPopOver && [UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = sourceType;
            picker.mediaTypes = @[(NSString *)kUTTypeImage];
            picker.allowsEditing = YES;
            picker.delegate = self;
            if ((sourceType != UIImagePickerControllerSourceTypeCamera) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
                // Pop Over
                self.imagePickerPopOver = [[UIPopoverController alloc] initWithContentViewController:picker];
                [self.imagePickerPopOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                self.imagePickerPopOver.delegate = self;
            } else {
                // Modal
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }
}

// If it was a popover
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePickerPopOver = nil;
}

// If it was a modal
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#define MAX_IMAGE_WIDTH 200

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect frame = imageView.frame;
        if (frame.size.width > MAX_IMAGE_WIDTH) {
            frame.size.height = frame.size.height * MAX_IMAGE_WIDTH / frame.size.width;
            frame.size.width = MAX_IMAGE_WIDTH;
        }
        imageView.frame = frame;
        [self setRandomLocationForView:imageView];
        [self.kitchenSink addSubview:imageView];
    }
    if (self.imagePickerPopOver) {
        [self.imagePickerPopOver dismissPopoverAnimated:YES];
        self.imagePickerPopOver = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)addFoodPhoto:(UIBarButtonItem *)sender
{
    [self presenImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:sender];
}

#define SINK_CONTROL @"Sink Controls"
#define STOP_SINK @"Stop Sink"
#define UNSTOP_SINK @"Unstop Sink"
#define CANCEL_SINK @"Cancel Sink"
#define EMPTY_SINK @"Empty Sink"

- (IBAction)controlSink:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheetDefault;
    NSString *drainButton = self.timer ? STOP_SINK : UNSTOP_SINK;
    if (!self.actionSheet) {
        actionSheetDefault = [[UIActionSheet alloc] initWithTitle:SINK_CONTROL
                                                         delegate:self
                                                cancelButtonTitle:CANCEL_SINK
                                           destructiveButtonTitle:EMPTY_SINK
                                                otherButtonTitles:drainButton, nil];
    }
    self.actionSheet = actionSheetDefault;
    [self.actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self.kitchenSink.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } else {
        NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([choice isEqualToString:STOP_SINK]) {
            [self stopDrainTimer];
        } else if ([choice isEqualToString:UNSTOP_SINK]) {
            [self startDrainTimer];
        }
    }
}

#define MOVE_DURATION 3.0
#define MOVE_DELAY 1.0
#define DEGREE_TO_RADIANCE(x) M_PI * x / 180.0
#define DRAIN_DURATION 3.0

- (void)startDrainTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:DRAIN_DURATION/3
                                         target:self
                                       selector:@selector(rotateAndDisappear:)
                                       userInfo:nil
                                        repeats:YES];
}

- (void)stopDrainTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startDrainTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopDrainTimer];
}

#define DISHCLEAN_INTERVAL 2.0

- (void)cleanDish
{
    if (self.kitchenSink.window) {
        [self addFood:nil];
        [self performSelector:@selector(cleanDish) withObject:nil afterDelay:DISHCLEAN_INTERVAL];
    }
}

- (void)rotateAndDisappear:(NSTimer *)timer
{
    [self rotateAndDisappear];
}

- (void)rotateAndDisappear
{
    for (UIView *view in self.kitchenSink.subviews) {
        CGAffineTransform transform = view.transform;
        if (CGAffineTransformIsIdentity(transform)) {
            [UIView animateWithDuration:MOVE_DURATION/3 delay:MOVE_DELAY options:UIViewAnimationOptionCurveLinear animations:^{view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7, 0.7), DEGREE_TO_RADIANCE(120.0));} completion:^(BOOL finished){
                if (finished) [UIView animateWithDuration:MOVE_DURATION/3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4, 0.4), DEGREE_TO_RADIANCE(240.0));} completion:^(BOOL finished){
                    if (finished) [UIView animateWithDuration:MOVE_DURATION/3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.1, 0.1), DEGREE_TO_RADIANCE(360.0));} completion:^(BOOL finished){
                        if (finished) [view removeFromSuperview];
                    }];
                }];
            }];
        }
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    CGPoint tabLocation = [sender locationInView:self.kitchenSink];
    for (UIView *view in self.kitchenSink.subviews) {
        if (CGRectContainsPoint(view.frame, tabLocation)) {
            [UIView animateWithDuration:MOVE_DURATION delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self setRandomLocationForView:view];
                view.transform = CGAffineTransformMakeScale(0.99, 0.99);
            } completion:^(BOOL finished){
                view.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

- (void)addFood:(NSString *)food
{
    UILabel *foodLabel = [[UILabel alloc] init];
    foodLabel.font = [UIFont systemFontOfSize:42];
    foodLabel.backgroundColor = [UIColor clearColor];
    foodLabel.text = food;
    [foodLabel sizeToFit];
    [self setRandomLocationForView:foodLabel];
    [self.kitchenSink addSubview:foodLabel];
}

- (void)setRandomLocationForView:(UIView *)view
{
    // Only UILabel and UIButton can do size to fit
    CGRect sinkBounds = CGRectInset(self.kitchenSink.bounds, view.frame.size.width/2, view.frame.size.height/2);
    CGFloat x = arc4random() % (int)sinkBounds.size.width + view.frame.size.width/2;
    CGFloat y = arc4random() % (int)sinkBounds.size.height + view.frame.size.height/2;
    view.center = CGPointMake(x, y);
}

- (IBAction)cancelAsking:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)doneAsking:(UIStoryboardSegue *)segue
{
    AskerViewController *askerView = segue.sourceViewController;
    [self addFood:[askerView answer]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Ask Question"]) {
        AskerViewController *askerView = segue.destinationViewController;
        askerView.question = @"What food do you like?";
    }
}


@end
