//
//  ImagePicker.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/14/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "ImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ImagePicker ()

@property (strong, nonatomic) UIPopoverController *imagePickerPopOver;

@end

@implementation ImagePicker

// Hook up to a button
- (IBAction)takeFoodPhoto:(UIBarButtonItem *)sender
{
    [self presentImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
}

// Hook up to a button
- (IBAction)addFoodPhoto:(UIBarButtonItem *)sender
{
    [self presentImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:sender];
}

//////////////////////////
//  Show Image Picker   //
//////////////////////////

- (void)presentImagePicker:(UIImagePickerControllerSourceType)sourceType sender:(UIBarButtonItem *)sender
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

//////////////////////////
//       Cancel         //
//////////////////////////

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

//////////////////////////
//    Image Chosen      //
//////////////////////////

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
        // Set the imageView at the location you want
        [self.<#Surrounding View#> addSubview:imageView];
    }
    if (self.imagePickerPopOver) {
        [self.imagePickerPopOver dismissPopoverAnimated:YES];
        self.imagePickerPopOver = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
