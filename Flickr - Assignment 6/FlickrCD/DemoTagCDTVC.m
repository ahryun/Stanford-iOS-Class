//
//  DemoTagCDTVC.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/5/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "DemoTagCDTVC.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "SharedManagedDocument.h"

@implementation DemoTagCDTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useDemoDocument];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)useDemoDocument
{
    [[SharedManagedDocument sharedInstance] performWithDocument:^(UIManagedDocument *document){
        self.managedObjectContext = document.managedObjectContext;
        [self refresh];
    }];
}

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Load Flickr", nil);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        [self.managedObjectContext performBlock:^{
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

@end
