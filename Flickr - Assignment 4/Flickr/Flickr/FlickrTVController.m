//
//  FlickrTVController.m
//  Flickr
//
//  Created by Ahryun Moon on 10/24/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "FlickrTVController.h"
#import "FlickrFetcher.h"

@interface FlickrTVController ()

@property (nonatomic, strong) NSArray *photos; // of NSDictionary's

@end

@implementation FlickrTVController

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    //[self.tableView reloadData];
}

@end
