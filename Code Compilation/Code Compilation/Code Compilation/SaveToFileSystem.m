//
//  SaveToFileSystem.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/8/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "SaveToFileSystem.h"

@interface SaveToFileSystem ()

@end

@implementation SaveToFileSystem

// Must create directories (parent and sub directories)
// Then create a file

NSString *documentPath =[documentPaths objectAtIndex:0];
NSString *parentDir = [documentPath stringByAppendingPathComponent:@"<#Parent directory name#>"];
NSString *subDir = [parentDir stringByAppendingPathComponent:@"<#Sub directory name#>"];
NSString *filePath = [subDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", <#File Name#>];
NSFileManager *fileManager = [[NSFileManager alloc] init];
if (![fileManager fileExistsAtPath:imgDir]) {
    BOOL directorySaved = [fileManager createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
    BOOL success = [fileManager createFileAtPath:filePath contents:photoData attributes:nil];
    if (!directorySaved || !success) NSLog(@"File did NOT get saved correctly");
    
} else {
    NSData *photoData = [NSData dataWithContentsOfFile:filePath];
}

@end
