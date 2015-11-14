//
//  SearchNoticeViewController.m
//  GuangXiOA
//
//  Created by sz apple on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TingSearchNoticeViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "TingDataHelper.h"
#import "TingDepartmentInfoItem.h"
#import "NoticeDetailsViewController.h"

@implementation TingSearchNoticeViewController

@synthesize bt,sfyd,lx,fbdw,yxj,searchButton,myTableView;
@synthesize pageCount,currentTag,pages,currentPage,isLoading;
@synthesize resultAry,refreshUrl,departmentDM,typeDM;
@synthesize wordsPopoverController,wordsSelectViewController;
@synthesize webHelper,showTingData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods and delegates

- (IBAction)searchButtonPressed:(id)sender
{
    [self.bt resignFirstResponder];
    self.pageCount = 0;
    self.currentPage = 0;
    if(resultAry)
    {
        [resultAry removeAllObjects];
    }
    [myTableView reloadData];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_TZGGLIST" forKey:@"service"];

    
    if ([bt.text length]>0)
    {
        [params setObject:bt.text forKey:@"q_TZBT"];
    }
    if ([lx.text length]>0)
    {
        [params setObject:typeDM forKey:@"lx"];
    }
    if ([fbdw.text length]>0)
    {
        [params setObject:departmentDM forKey:@"q_FBDW"];
    }
    if (sfyd.selectedSegmentIndex == 1)
    {
        [params setObject:@"0" forKey:@"q_YDZT"];
    }
    else if (sfyd.selectedSegmentIndex == 2)
    {
        [params setObject:@"1" forKey:@"q_YDZT"];
    }
    if (yxj.selectedSegmentIndex == 1)
    {
        [params setObject:@"1" forKey:@"q_YXJ"];
    }
    else if (yxj.selectedSegmentIndex == 2)
    {
        [params setObject:@"2" forKey:@"q_YXJ"];
    }

    self.refreshUrl = [ServiceUrlString generateTingUrlByParameters:params];
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:refreshUrl andParentView:self.view delegate:self];
}

- (IBAction)touchDownForDepartment:(id)sender
{
    UITextField *ctrl = (UITextField*)sender;
    ctrl.text = @"";
    currentTag = ctrl.tag;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(180, 400);
	tmpController.delegate = self;
    
    NSMutableArray *bmNameAry = [NSMutableArray arrayWithCapacity:20];
    NSArray *depAry = [[TingDataHelper shareInstace] getTingDeptList];
    if (depAry == nil) return;
    
    for (TingDepartmentInfoItem *aItem in depAry) {
        [bmNameAry addObject:aItem.name];
    }
    tmpController.wordsAry = [[NSArray alloc] initWithArray:bmNameAry];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

- (IBAction)touchDownForType:(id)sender
{
    UITextField *ctrl = (UITextField*)sender;
    ctrl.text = @"";
    currentTag = ctrl.tag;
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(150, 240);
	tmpController.delegate = self;
    
    tmpController.wordsAry = [[NSArray alloc] initWithObjects:@"审核通知公告",@"所有通知公告",@"本周通知公告", nil];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;	
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	//[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    if (currentTag == 2) {
        fbdw.text = words;
        NSArray *depAry = [[TingDataHelper shareInstace] getTingDeptList];
        if (depAry == nil) return;
        
        TingDepartmentInfoItem *aItem = [depAry objectAtIndex:row];
        self.departmentDM = aItem.number;
    } else {
        self.lx.text = words;
        
        switch (row) {
                
            case 0:
                self.typeDM = @"shtzgg";
                break;
                
            case 1:
                self.typeDM = @"sytzgg";
                break;
                
            case 2:
                self.typeDM = @"bztzgg";
                break;
                
            default:
                break;
        }
    }
    
    if (self.wordsPopoverController != nil) {
		[self.wordsPopoverController dismissPopoverAnimated:YES];
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.resultAry = [NSMutableArray arrayWithCapacity:5];
    
    self.lx.tag = 1;
    self.fbdw.tag = 2;
    [self.lx addTarget:self action:@selector(touchDownForType:) forControlEvents:UIControlEventTouchDown];
    [self.fbdw addTarget:self action:@selector(touchDownForDepartment:) forControlEvents:UIControlEventTouchDown];
    
    self.sfyd.selectedSegmentIndex = 0;
    self.yxj.selectedSegmentIndex = 0;
    
   /* UIColor *color = [UIColor colorWithRed:67.0/255 green:160.0/255 blue:179.0/255 alpha:1];
    sfyd.tintColor = color;
    yxj.tintColor = color;*/
    
    [self searchButtonPressed:nil]; 
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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
    headerView.text = [NSString stringWithFormat:@"  查询到的通知公告(%d条)",pageCount];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	return [resultAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        // cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    
    NSString *yxjStr = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"YXJMC"];
    if (!yxjStr)
        yxjStr = @"";
    
    NSString *fbdwStr = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"ZZJC"];
    if (!fbdwStr)
        fbdwStr = @"";
    
    NSString *fbsjStr = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"CJSJ"];
    if (!fbsjStr)
        fbsjStr = @"";
    
	cell.textLabel.text = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"TZBT"];
    cell.textLabel.numberOfLines = 3;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"优先级：%@    发布单位：%@    发布时间：%@",yxjStr,fbdwStr,fbsjStr];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeDetailsViewController *childView = [[NoticeDetailsViewController alloc] initWithNibName:@"NoticeDetailsViewController" bundle:nil];
    childView.tzbh = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"TZBH"];
    childView.title = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"TZBT"];
    childView.showTingData = YES;
    [self.navigationController pushViewController:childView animated:YES];
}

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        if (pageInfoDic)
        {
            pageCount = [[pageInfoDic objectForKey:@"count"] intValue];
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
            pages = [[pageInfoDic objectForKey:@"pages"] intValue];
        }
        else
            bParseError = YES;
        
        NSArray *parsedItemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        
        if ([parsedItemAry count] != 0)
        {
            //[resultAry removeAllObjects];
            [self.resultAry addObjectsFromArray:parsedItemAry];
        }
    }
    else
        bParseError = YES;
    [self.myTableView reloadData];
    if (bParseError)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"查询的通知公告不存在。" 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败." 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    return;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (isLoading) return;
    if (currentPage == pages)
         return;
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
		isLoading = YES;
        NSString *newStrUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",self.refreshUrl,currentPage];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:newStrUrl andParentView:self.view delegate:self];
    }
}

@end
