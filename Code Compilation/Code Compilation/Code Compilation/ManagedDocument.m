//
//  ManagedDocument.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "ManagedDocument.h"

@interface ManagedDocument ()

@end

@implementation ManagedDocument

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useDemoDocument];
}

- (void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"<#Folder Name#>"];
    UIManagedDocument *managedDocument = [[UIManagedDocument alloc] initWithFileURL:url];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        // create it
        [managedDocument saveToURL:url
                  forSaveOperation:UIDocumentSaveForCreating
                 completionHandler:^(BOOL success) {
                     if (success) {
                         self.managedObjectContext = managedDocument.managedObjectContext;
                         [self refresh];
                     }
                 }];
    } else if (managedDocument.documentState == UIDocumentStateClosed) {
        // Open it
        [managedDocument openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = managedDocument.managedObjectContext;
            }
        }];
        
    } else {
        // use it
        self.managedObjectContext = managedDocument.managedObjectContext;
    }
}

@end
