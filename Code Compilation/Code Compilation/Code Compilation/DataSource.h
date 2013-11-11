//
//  DataSource.h
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//
// Define Cell identifier in Storyboard

#import <UIKit/UIKit.h>

@interface DataSource : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;

@end
