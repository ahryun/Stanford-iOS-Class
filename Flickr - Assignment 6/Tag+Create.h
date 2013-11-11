//
//  Tag+Create.h
//  FlickrCD
//
//  Created by Ahryun Moon on 11/4/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)

+ (Tag *)tagWithName:(NSString *)name withManagedObjectContext:(NSManagedObjectContext *)context;

@end
