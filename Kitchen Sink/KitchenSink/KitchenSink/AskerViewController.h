//
//  AskerViewController.h
//  KitchenSink
//
//  Created by Ahryun Moon on 11/13/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskerViewController : UIViewController

@property (strong, nonatomic) NSString *question;
@property (strong, readonly) NSString *answer;

@end
