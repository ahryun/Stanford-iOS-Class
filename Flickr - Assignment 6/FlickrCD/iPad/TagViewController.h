//
//  TagViewController.h
//  FlickrCD
//
//  Created by Ahryun Moon on 11/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "MapViewController.h"

@interface TagViewController : MapViewController

@property (nonatomic, strong) NSManagedObjectContext *context;

- (void)reload;

@end
