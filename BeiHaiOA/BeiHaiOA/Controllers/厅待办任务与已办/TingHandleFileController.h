//
//  HandleFileController.h
//  GuangXiOA
//
//  Created by 张 仁松 on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  主任、处长的流转

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "BanLiItem.h"
#import "HandleGWProtocol.h"
#import "NSURLConnHelper.h"
#import "QQSectionHeaderView.h"
#define kWebService_WorkFlow 0
#define kWebService_Transfer 1
#define NOT_SELECTED -1
#import "BaseViewController.h"

@interface TingHandleFileController : BaseViewController<WordsDelegate,UIAlertViewDelegate,QQSectionHeaderViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) BanLiItem *aItem;
@property (nonatomic,strong) NSArray *aryUsualOpinion;
@property (nonatomic,strong) NSArray *arySteps;
@property (nonatomic,strong) NSMutableArray *aryFilteredSteps;
@property (nonatomic,strong) NSMutableArray *arySectionIsOpen;
//@property (nonatomic,strong) NSMutableArray *aryCheckedIndexPath;
@property (nonatomic,strong) NSMutableArray *arySelectedUsers;
@property (nonatomic,assign) BOOL canFinish;
@property (nonatomic,assign) BOOL canSingleFinish;
@property (nonatomic,assign) BOOL canSign;

//@property (nonatomic,strong) IBOutlet UIWebView *webView;//显示所选择的步骤
@property (nonatomic,strong) IBOutlet UITableView *stepTableView;
@property (nonatomic,strong) IBOutlet UITextView *txtView;

@property (nonatomic,strong) IBOutlet UIButton *transferButton;
@property (nonatomic,strong) IBOutlet UIButton *finishButton;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UIPopoverController* wordsPopoverController;
@property (nonatomic, retain) CommenWordsViewController* wordsSelectViewController;
@property (nonatomic,assign) id<HandleGWDelegate> delegate;
@property (nonatomic,assign) NSInteger webServiceType; // 0 请求流转步骤 1 流转命令

@property (nonatomic,retain) NSMutableArray *aryRadioViews;
@property (nonatomic,assign) NSInteger lastSelMainPersonIndex; //上次选择的主办人在aryRadioViews中的索引

@property (nonatomic,retain) IBOutlet UIScrollView *radioScrollView;
@property(nonatomic,strong)NSURLConnHelper *webHelper;
-(IBAction)inputCustomClick:(id)sender;//输入segctrl

-(IBAction)btnTransferPressed:(id)sender;
-(IBAction)btnFinishPressed:(id)sender;

-(IBAction)btnClearPressed:(id)sender;

@end
