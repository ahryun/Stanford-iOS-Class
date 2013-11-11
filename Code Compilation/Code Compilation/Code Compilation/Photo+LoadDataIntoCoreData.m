//
//  Photo+LoadDataIntoCoreData.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Photo+LoadDataIntoCoreData.h"

@implementation Photo (LoadDataIntoCoreData)

+ (Photo *)photoWithDictionaryObject:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"<#Entity Name#>"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"<#Property Name#>" ascending:<#BOOL#>]];
    request.predicate = [NSPredicate predicateWithFormat:@"<#Property Name#> = %@", <#Property of Your Interest#>];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1) {
        // Handle error
    } else if (![matches count]) {
        photo =[NSEntityDescription insertNewObjectForEntityForName:@"<#Entity#>" inManagedObjectContext:context];
        [photo setPhotoURL:<#Photo URL Data from Dictionary#>];
        // If you have other related entity that needs to be set up, make a custom method in a category file for that entity and call that method here.
    } else {
        photo = [matches lastObject];
    }
    return photo;
}

@end
