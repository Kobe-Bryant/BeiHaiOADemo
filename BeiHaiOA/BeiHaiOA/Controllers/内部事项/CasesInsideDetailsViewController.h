//
//  CasesInsideDetailsViewController.h
//  BeiHaiOA
//
//  Created by 曾静 on 11-12-28.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "BaseViewController.h"
#import "UITableViewCell+Custom.h"
#import "SharedInformations.h"
#import "FileUtil.h"
#import "ServiceUrlString.h"
#import "DisplayAttachFileController.h"
#import "TaskActionBaseViewController.h"
#import "ToDoActionsDataModel.h"
#import "UsersHelper.h"

@interface CasesInsideDetailsViewController : TaskActionBaseViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnHelperDelegate>

@property (nonatomic, strong) NSDictionary *itemParams;
@property (nonatomic, assign) BOOL isHandle;
@property (nonatomic, strong) NSString *caseID;
@property (nonatomic, strong) NSString *caseType;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray *baseKeyAry;

@property (nonatomic, strong) NSURLConnHelper *webHelper;
@property (nonatomic, strong) NSArray *infoTitleAry;
@property (nonatomic, strong) NSDictionary *baseInfoDic;
@property (nonatomic, strong) NSArray *attachmentInfoAry;
@property (nonatomic, strong) NSMutableArray *toDisplayHeightAry;
@property (nonatomic, strong) NSArray *stepAry;
@property (nonatomic, strong) NSArray *stepHeightAry;      //步骤的高度
@property (nonatomic, strong) NSArray *hqfjAry;

@property (nonatomic, strong) ToDoActionsDataModel *actionsModel;

- (NSString *)getShortDateStr:(NSString *)str;

- (id)initWithNibName:(NSString *)nibNameOrNil
            andParams:(NSDictionary*)item
              isBanli:(BOOL)isToBanLi;

@end
