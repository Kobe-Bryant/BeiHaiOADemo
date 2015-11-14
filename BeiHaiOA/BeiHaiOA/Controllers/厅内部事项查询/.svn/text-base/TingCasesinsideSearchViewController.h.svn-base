//
//  CasesinsideSearchViewController.h
//  GuangXiOA
//
//  Created by sz apple on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "BaseViewController.h"

@interface TingCasesinsideSearchViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,WordsDelegate,UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UITableView *resultTableView;
@property (nonatomic,strong) IBOutlet UITextField *titleField;
@property (nonatomic,strong) IBOutlet UITextField *niwenField;
@property (nonatomic,strong) IBOutlet UITextField *nianfenField;
@property (nonatomic,strong) IBOutlet UISegmentedControl *jjcdSeg;
@property (nonatomic,strong) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong) IBOutlet UITextField *typeField;
@property (nonatomic,strong) NSURLConnHelper *webHelper;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isLoading;

@property (nonatomic,assign) NSInteger currentTag;

@property (nonatomic,strong) NSMutableArray *resultAry;
@property (nonatomic,strong) NSString *departmentDM;
@property (nonatomic,assign) NSInteger typeDM;
@property (nonatomic,strong) NSString *refreshUrl;

@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;

- (IBAction)searchButtonPressed:(id)sender;
@end
