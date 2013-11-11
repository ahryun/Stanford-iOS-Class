//
//  FlickrTVController.m
//  Flickr
//
//  Created by Ahryun Moon on 10/24/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "FlickrTVController.h"
#import "FlickrFetcher.h"

@interface FlickrTVController () <UISplitViewControllerDelegate>

@property (nonatomic, strong) NSArray *photos; // of NSDictionary's

@end

@implementation FlickrTVController

#pragma mark - UISplitViewControllerDelegate

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    //[self.tableView reloadData];
}

@end
