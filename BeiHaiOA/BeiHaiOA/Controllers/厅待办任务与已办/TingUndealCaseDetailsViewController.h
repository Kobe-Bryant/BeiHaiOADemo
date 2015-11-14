//
//  UndealCaseDetailsViewController.h
//  GuangXiOA
//
//  Created by sz apple on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanLiItem.h"
#import "NSURLConnHelper.h"
#import "HandleGWProtocol.h"
#import "BaseViewController.h"

@interface TingUndealCaseDetailsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnHelperDelegate,HandleGWDelegate>
@property (nonatomic,strong) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) BanLiItem *myItem;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,strong) NSArray *stepAry;
@property (nonatomic,strong) NSArray *stepHeightAry;      //步骤的高度
@property (nonatomic,strong) NSArray *attachmentAry;
@property (nonatomic,strong) NSArray *selInfoAry;
@property (nonatomic,strong)  NSURLConnHelper *webHelper;
@property (nonatomic,strong) NSArray *baseKeyArray;
@property (nonatomic,strong) NSArray *baseTitleArray;
@property (nonatomic,strong) NSArray *opinionKeyArray;
@property (nonatomic,strong) NSArray *opinionTitleArray;
@property (nonatomic,strong) NSArray *opinionCellHeightArray;//根据opinionTitleArray返回的值动态计算cell高度

@property (nonatomic,assign)NSInteger SQLBType;//SQLB 等于 ‘3’ 经费申请,要显示规财处意见
@property (nonatomic,assign) BOOL isHandle;
@property (nonatomic,assign) CGFloat cellNRHeight;
@property (nonatomic,assign)BOOL bOKFromTransfer;//办理返回ok
@end
