//
//  LandscapeBaseViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-3.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSURLConnHelper.h"
#import "NSURLConnHelperDelegate.h"
@interface LandscapeBaseViewController : UIViewController<NSURLConnHelperDelegate>
@property(nonatomic,strong)NSURLConnHelper *webHelper;
-(void)showAlertMessage:(NSString*)msg;
@end
