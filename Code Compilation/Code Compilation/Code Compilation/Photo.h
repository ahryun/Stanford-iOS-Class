//
//  Photo.h
//  Code Compilation
//
//  Created by Ahryun Moon on 11/8/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * uniqueID;

@end
