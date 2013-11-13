//
//  DemoTagMapViewController.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "DemoTagMapViewController.h"
#import "SharedManagedDocument.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@interface DemoTagMapViewController ()

@end

@implementation DemoTagMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.context) [self useDemoDocument];
}

- (void)useDemoDocument
{
    [[SharedManagedDocument sharedInstance] performWithDocument:^(UIManagedDocument *document){
        self.context = document.managedObjectContext;
        [self refresh];
    }];
}

- (IBAction)refresh
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Load Flickr", nil);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        [self.context performBlock:^{
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.context];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reload];
            });
        }];
    });
}


@end
