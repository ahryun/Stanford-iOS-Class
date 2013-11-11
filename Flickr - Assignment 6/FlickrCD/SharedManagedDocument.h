//
//  SharedManagedDocument.h
//  FlickrCD
//
//  Created by Ahryun Moon on 11/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface SharedManagedDocument : NSObject

@property (nonatomic, strong, readonly) UIManagedDocument *sharedDocument;

+ (SharedManagedDocument *)sharedInstance;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

@end
