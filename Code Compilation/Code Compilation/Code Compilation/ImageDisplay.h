//
//  ImageDisplay.h
//  Code Compilation
//
//  Created by Ahryun Moon on 11/8/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface ImageDisplay : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) Photo *photo; // if use Core Data
// @property (strong, nonatomic) NSURL *photoURL; // if load photo from external storage each time

@end
