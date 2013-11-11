//
//  PhotoViewController.h
//  FlickrCD
//
//  Created by Ahryun Moon on 11/8/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface ImageVC : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) Photo *photo;

@end
