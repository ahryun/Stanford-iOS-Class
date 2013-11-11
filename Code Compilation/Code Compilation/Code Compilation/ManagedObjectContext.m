//
//  ManagedObjectContext.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "ManagedObjectContext.h"

@interface ManagedObjectContext ()

@end

@implementation ManagedObjectContext

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"<#Entity Name#>"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"<#property#>" ascending:<#BOOL#> selector:@selector(<#Sort Rule#>)]];
        request.predicate = nil; // all tags
        self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultController = nil;
    }
}

@end
