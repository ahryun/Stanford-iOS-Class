//
//  PhotoCDTVC.h
//  FlickrCD
//
//  Created by Ahryun Moon on 11/6/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Tag.h"

@interface PhotoCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Tag *tag;

@end
