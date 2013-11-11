//
//  Tag+Create.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/4/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+ (Tag *)tagWithName:(NSString *)name withManagedObjectContext:(NSManagedObjectContext *)context
{
    Tag *tag = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // Handle error
    } else if (![matches count]) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        tag.name = name;
    } else {
        tag = [matches lastObject];
    }
    return tag;
}

@end
