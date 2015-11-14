//
//  CasesinsideSearchViewController.m
//  GuangXiOA
//
//  Created by sz apple on 12-1-5.
//  Copyright (c) 2012年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CasesinsideSearchViewController.h"
#import "DepartmentInfoItem.h"
#import "PDJsonkit.h"
#import "QsbgDetailViewController.h"
#import "YzsqDetailViewController.h"
#import "JfsqDetailViewController.h"
#import "YcwxDetailViewController.h"
#import "QjsqDetailsViewController.h"
#import "LfjdDetailViewController.h"
#import "QtsqDetailViewController.h"
#import "ServiceUrlString.h"
#import "UsersHelper.h"
#import "SharedInformations.h"
#import "ServiceUrlString.h"

#define kFieldTag_KSSJ 1 //开始时间
#define kFieldTag_JSSJ 2 //结束时间
#define kFieldTag_SQLX 3 //申请类别
#define kFieldTag_CBBM 4 //承办部门

@interface CasesinsideSearchViewController ()

@property (nonatomic, strong) NSString *sqlbCode;
@property (nonatomic, strong) NSString *cbbmCode;
@property (nonatomic, strong) UsersHelper *userHelper;

@end

@implementation CasesinsideSearchViewController
@synthesize pageCount,currentPage,isLoading,currentTag,typeDM;
@synthesize resultAry,departmentDM,refreshUrl,wordsSelectViewController,wordsPopoverController;
@synthesize webHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查询内部事项";
    
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchBar:)];
    self.navigationItem.rightBarButtonItem = aItem;
    
    self.bHaveShowed = YES;
    [self showSearchBar:aItem];
    
    self.userHelper = [[UsersHelper alloc] init];
    self.resultAry = [[NSMutableArray alloc] init];
    
    self.cbbmField.tag = kFieldTag_CBBM;//承办部门
    self.sqlbField.tag = kFieldTag_SQLX;//申请类型
    self.kssjField.tag = kFieldTag_KSSJ;//开始时间
    self.jssjField.tag = kFieldTag_JSSJ;//结束时间
    
    UIColor *color = [UIColor colorWithRed:67.0/255 green:160.0/255 blue:179.0/255 alpha:1];
    self.jjcdSegment.tintColor = color;
    
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Event Handler Methods

- (IBAction)searchButtonPressed:(id)sender
{
    if(self.isLoading)
    {
        return;
    }
    if(self.resultAry)
    {
        [self.resultAry removeAllObjects];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:@"QUERY_NBSXLIST" forKey:@"service"];
    if(self.cbbmField.text != nil && self.cbbmField.text.length > 0)
    {
        //承办部门
        [params setObject:self.cbbmCode forKey:@"q_CBBM"];
    }
    if(self.sqlbField.text != nil && self.sqlbField.text.length > 0)
    {
        //事项类别
        [params setObject:self.sqlbCode forKey:@"sxlb"];
    }
    if(self.kssjField.text.length > 0 && self.jssjField.text.length > 0)
    {
        [params setObject:@"1" forKey:@"q_RQNAME"];
    }
    if(self.kssjField.text != nil && self.kssjField.text.length > 0)
    {
        //开始时间
        [params setObject:self.kssjField.text forKey:@"q_RQ1"];
    }
    if(self.jssjField.text != nil && self.jssjField.text.length > 0)
    {
        //结束时间
        [params setObject:self.jssjField.text forKey:@"q_RQ2"];
    }
    if(self.jjcdSegment.selectedSegmentIndex > 0)
    {
        //紧急程度
        [params setObject:[NSString stringWithFormat:@"%d", self.jjcdSegment.selectedSegmentIndex] forKey:@"q_JJCD"];
    }
    if(self.btField.text != nil && self.btField.text.length > 0)
    {
        //标题
        [params setObject:self.btField.text forKey:@"q_BT"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.refreshUrl = strUrl;
    self.isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.refreshUrl andParentView:self.view delegate:self];
}

- (IBAction)touchForDept:(id)sender
{
    UIControl *ctrl = (UIControl*)sender;
    currentTag = ctrl.tag;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, 320);
	tmpController.delegate = self;
    
    NSArray *deptAry = [self.userHelper queryAllSubDept:@"050001"];
    NSMutableArray *deptNameAry = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *tmpDict in deptAry) {
        [deptNameAry addObject:[tmpDict objectForKey:@"ZZQC"]];
    }
    tmpController.wordsAry = deptNameAry;
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)touchForDate:(id)sender
{
    UIControl *btn =(UIControl*)sender;
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	self.dateController.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.wordsPopoverController = popover;
	[self.wordsPopoverController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
}

- (IBAction)touchForType:(id)sender
{
    UIControl *ctrl = (UIControl*)sender;
    currentTag = ctrl.tag;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, 320);
	tmpController.delegate = self;
    
    tmpController.wordsAry = [NSArray arrayWithObjects:@"请示报告", @"用章申请", @"经费申请", @"用车维修", @"请假", @"来访与接待",@"其他", nil];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)onSegmentClicked:(id)sender
{
    
}

-(void)showSearchBar:(id)sender
{
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if(self.bHaveShowed)
    {
        self.bHaveShowed = NO;
        CGRect origFrame = self.listTableView.frame;
        
        [aItem setTitle:@"开启查询"];
        self.cbbmLabel.hidden = YES;
        self.cbbmField.hidden = YES;
        self.sqlbLabel.hidden = YES;
        self.sqlbField.hidden = YES;
        self.kssjLabel.hidden = YES;
        self.kssjField.hidden = YES;
        self.jssjLabel.hidden = YES;
        self.jssjField.hidden = YES;
        self.jjcdLabel.hidden = YES;
        self.jjcdSegment.hidden = YES;
        self.btLabel.hidden = YES;
        self.btField.hidden = YES;
        self.searchButton.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.listTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.01f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.listTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y-140, origFrame.size.width, origFrame.size.height+140);
        [UIView commitAnimations];
    }
    else
    {
        aItem.title = @"关闭查询";
        
        self.bHaveShowed = YES;
        CGRect origFrame = self.listTableView.frame;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.listTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.01f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        self.listTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+140, origFrame.size.width, origFrame.size.height-140);
        
        [UIView commitAnimations];
    }
    
    //隐藏键盘
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - Network Handler Methods

- (void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_NBSXLIST" forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)processWebData:(NSData*)webData
{
    self.isLoading = NO;
    if([webData length] <=0)
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        if (pageInfoDic)
        {
            pageCount = [[pageInfoDic objectForKey:@"pages"] intValue];
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
        }
        else
        {
            bParseError = YES;
        }
        
        NSArray *parsedItemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        
        if ([parsedItemAry count] != 0)
        {
            [self.resultAry addObjectsFromArray:parsedItemAry];
        }
            
            
    }
    else
        bParseError = YES;
    if (bParseError) {
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"查询的事项不存在。" 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];

        return;
        
    } else
        [self.listTableView reloadData];
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    [self.listTableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"提示"  message:@"请求数据失败." 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];

    return;
}

#pragma mark - UITableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if(section == 0)
    {
        headerView.text =  [NSString stringWithFormat:@"  查询到的内部事项(%d条)",[resultAry count]];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [resultAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
    }
    /*
     "ROWNUMBER": 6,
     "PXH": 20130001,
     "SQLBMC": "用章申请",
     "BMMC": "办公室",
     "XH": "74ed10e0-99a5-4f18-8486-2dbc8663a6cb",
     "NBSXSPBH": "2",
     "CBBM": "45162101",
     "CBR": "黄山松",
     "BT": "22222222222",
     "SQSJ": "2013-12-30 00:00",
     "CJSJ": "2013-12-30 10:27",
     "WJXH": 1,
     "BGSQSRQ": "",
     "JJCD": "1",
     "SFZXXJBRFW": "1"
     */
    NSDictionary *itemDict = [self.resultAry objectAtIndex:indexPath.row];
	NSString *itemTitle = [itemDict objectForKey:@"BT"];
    if (itemTitle == nil)
    {
        itemTitle = @"";
    }
    NSString *people = [itemDict objectForKey:@"CBR"];
    if (people == nil)
    {
        people = @"";
    }
    
    NSString *department = [itemDict objectForKey:@"BMMC"];
    if (department == nil)
        department = @"";
    
    NSString *caseType = [itemDict objectForKey:@"SQLBMC"];
    if (caseType == nil)
    {
        caseType = @"";
    }
    
    NSString *sqsj = [itemDict objectForKey:@"SQSJ"];
    if(sqsj == nil)
    {
        sqsj = @"";
    }
    else if (sqsj.length > 10)
    {
        sqsj = [sqsj substringToIndex:10];
    }
    
	cell.textLabel.text = [NSString stringWithFormat:@"%@[%@]", itemTitle, caseType];
    cell.textLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"申请时间：%@    承办人：%@    承办单位：%@",sqsj,people,department];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * flag = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"SFZXXJBRFW"];
    if([flag integerValue] != 1){
        [self showAlertMessage:@"您没有权限查看此公文。"];
        return;
    }
    
    CasesInsideDetailsViewController *childView = [[CasesInsideDetailsViewController alloc] initWithNibName:@"CasesInsideDetailsViewController" bundle:nil];
    
    if(childView)
    {
        childView.caseID = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"XH"];
        NSString *title = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"SQLBMC"];
        childView.title = [NSString stringWithFormat:@"%@详细信息",title];
        
        [self.navigationController pushViewController:childView animated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (isLoading)
    {
        return;
    }
    if (currentPage == pageCount)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
		isLoading = YES;
        NSString *newStrUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",self.refreshUrl,currentPage];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:newStrUrl andParentView:self.view delegate:self];
    }
}

#pragma mark - Animation

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.cbbmLabel.hidden = NO;
    self.cbbmField.hidden = NO;
    self.sqlbLabel.hidden = NO;
    self.sqlbField.hidden = NO;
    self.kssjLabel.hidden = NO;
    self.kssjField.hidden = NO;
    self.jssjLabel.hidden = NO;
    self.jssjField.hidden = NO;
    self.jjcdLabel.hidden = NO;
    self.jjcdSegment.hidden = NO;
    self.btLabel.hidden = NO;
    self.btField.hidden = NO;
    self.searchButton.hidden = NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - PopupDateViewController Delegate Method

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
	[self.wordsPopoverController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		switch (currentTag)
        {
			case kFieldTag_KSSJ:
				self.kssjField.text = dateString;
				break;
			case kFieldTag_JSSJ:
				self.jssjField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (currentTag)
        {
			case kFieldTag_KSSJ:
				self.kssjField.text = @"";
				break;
			case kFieldTag_JSSJ:
				self.jssjField.text = @"";
				break;
			default:
				break;
		}
    }
}

#pragma mark - CommenWordsViewController Delegate Method

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    if (currentTag == kFieldTag_CBBM)
    {
        self.cbbmField.text = words;
        NSArray *deptAry = [self.userHelper queryAllDept];
        for (NSDictionary *tmpDict in deptAry)
        {
            NSString *deptName = [tmpDict objectForKey:@"ZZQC"];
            if([words isEqualToString:deptName])
            {
                self.cbbmCode = [tmpDict objectForKey:@"ZZBH"];
                break;
            }
        }
        if(self.cbbmCode == nil || self.cbbmCode.length <= 0)
        {
            self.cbbmCode = @"";
        }
    }
    else if(currentTag == kFieldTag_SQLX)
    {
        self.sqlbField.text = words;
        self.sqlbCode = [NSString stringWithFormat:@"%d", row + 1];
    }
    if (self.wordsPopoverController != nil)
    {
		[self.wordsPopoverController dismissPopoverAnimated:YES];
	}
}

@end
