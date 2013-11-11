//
//  RefreshControl.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "RefreshControl.h"

@interface RefreshControl ()

@end

// 1. Click on table view controller in Storyboard and enable refreshing
// 2. Put the code snippet - @tableViewRefreshControl in viewDidLoad to get a hold of refresh control in the table view
// 3. Put the code snippet - @tableViewRefresh to reload the data asynchronously in the table

@implementation RefreshControl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Code snippet - @tableViewRefreshControl
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

// Code snippet - @tableViewRefresh
- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create(<#Side Thread Name in Const#>, nil);
    dispatch_async(fetchQ, ^{
        // Get data from the web such as
        <#NSArray *photos = [FlickrFetcher stanfordPhotos];#>
        [self.managedObjectContext performBlock:^{
            for (<#item#> in <#array#>) {
                // Do something about the downloaded data. Example is..
                <#[Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];#>
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}


@end
