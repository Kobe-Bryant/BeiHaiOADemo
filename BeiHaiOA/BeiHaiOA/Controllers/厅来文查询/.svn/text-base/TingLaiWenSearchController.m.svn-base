//
//  LaiWenSearchController.m
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TingLaiWenSearchController.h"
#import "AppDelegate.h"
#import "PDJsonKit.h"
#import "NSStringUtil.h"
#import "ServiceUrlString.h"
#import "TingLaiwenDetailController.h"

@implementation TingLaiWenSearchController

@synthesize resultAry,resultTableView,bHaveShowed,lxtype;
@synthesize titleField,titleLabel,danweiLabel,danweiField,searchBtn;
@synthesize wenHaoLabel,wenHaoField;
@synthesize pageCount,currentPage;
@synthesize isLoading,resultHeightAry;
@synthesize webHelper,currentTag;
@synthesize fromDateField,fromDateLabel,endDateField,endDateLabel,popController,dateController;
@synthesize xuhaoLabel,xuhaoField,urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil andType:(NSString*)typeStr
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.lxtype = typeStr;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    titleField.hidden = NO;
    titleLabel.hidden = NO;
    danweiLabel.hidden = NO;
    danweiField.hidden = NO;
    searchBtn.hidden = NO;
    wenHaoLabel.hidden = NO;
    wenHaoField.hidden = NO;
    xuhaoLabel.hidden = NO;
    xuhaoField.hidden = NO;
    fromDateField.hidden = NO;
    fromDateLabel.hidden = NO;
    endDateField.hidden = NO;
    endDateLabel.hidden = NO;
}

-(void)processWebData:(NSData*)webData{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        if (pageInfoDic ) {
            pageCount = [[pageInfoDic objectForKey:@"pages"] intValue];
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
        }
        else
            bParseError = YES;
        
        NSArray *parsedItemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        
        if (parsedItemAry == nil) {
            bParseError = YES;
        }
        else{
           // [resultAry removeAllObjects];
            [resultAry addObjectsFromArray:parsedItemAry];
        }
            
    }
    else
        bParseError = YES;
    if (bParseError) {
        [self showAlertMessage:@"获取数据出错."];
    }
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [resultAry count];i++) {
        NSDictionary *dicTmp = [resultAry objectAtIndex:i];
        NSString *text = [dicTmp objectForKey:@"LWBT"];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:text byFont:font andWidth:520.0]+20;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.resultHeightAry = aryTmp;
    
    [self.resultTableView reloadData];
    
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    [self.resultTableView reloadData];
    [self showAlertMessage:@"请求数据失败."];
}


-(IBAction)btnSearchPressed:(id)sender
{
    if (!resultAry) 
        resultAry = [[NSMutableArray alloc] initWithCapacity:30];
    else
        [resultAry removeAllObjects];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_LWLIST" forKey:@"service"];
    [params setObject:lxtype forKey:@"LWLX"];
    if ([titleField.text length] > 0)
    {
        [params setObject:titleField.text forKey:@"q_LWBT"];
    }
    if ([danweiField.text length] > 0)
    {
        [params setObject:danweiField.text forKey:@"q_LWDW"];
    }
    if ([wenHaoField.text length] > 0)
    {
        [params setObject:wenHaoField.text forKey:@"q_LWWH"];
    }
    if ([xuhaoField.text length] > 0) {
        [params setObject:xuhaoField.text forKey:@"q_WJXH"];
    }
    if([fromDateField.text length] > 0 || [endDateField.text length] >0)
    {
        [params setObject:@"1" forKey:@"inType"];
        if ([fromDateField.text length] > 0)
        {
            [params setObject:fromDateField.text forKey:@"sDate"];
        }
        if ([endDateField.text length] > 0)
        {
            [params setObject:endDateField.text forKey:@"eDate"];
        }
    }
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


-(IBAction)touchFromDate:(id)sender{
	UIControl *btn =(UIControl*)sender;
	[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
	
	
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date{
	[popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
		switch (currentTag) {
			case 1:
				fromDateField.text = dateString;
				break;
			case 2:
				endDateField.text = dateString;
				break;
			default:
				break;
		}
	}else {
        switch (currentTag) {
			case 1:
				fromDateField.text = @"";
				break;
			case 2:
				endDateField.text = @"";
				
				break;
			default:
				break;
		}
    }
    
}

//不让日起textfield可以编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}


-(void)showSearchBar:(id)sender{
   // UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if(bHaveShowed)
    {
        bHaveShowed = NO;
        CGRect origFrame = resultTableView.frame;
        UIBarButtonItem* rightButton = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
        [rightButton setTitle:@"开启查询"];
        titleField.hidden = YES;
        titleLabel.hidden = YES;
        danweiLabel.hidden = YES;
        danweiField.hidden = YES;
        searchBtn.hidden = YES;
        wenHaoLabel.hidden = YES;
        wenHaoField.hidden = YES;
        xuhaoLabel.hidden = YES;
        xuhaoField.hidden = YES;
        
  
        fromDateField.hidden = YES;
        fromDateLabel.hidden = YES;
        endDateField.hidden = YES;
        endDateLabel.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y-140, origFrame.size.width, origFrame.size.height+140);        
        [UIView commitAnimations];
        
        
        
    }
    else{
        
        UIBarButtonItem* rightButton = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
        [rightButton setTitle:@"关闭查询"];
        bHaveShowed = YES;
        CGRect origFrame = resultTableView.frame;        
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+140, origFrame.size.width, origFrame.size.height-140);
        
        [UIView commitAnimations];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"来文列表";
    
    
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStyleBordered target:self action:@selector(showSearchBar:)];
    self.navigationItem.rightBarButtonItem = aItem;
    bHaveShowed = YES;
    [self showSearchBar:aItem];
    
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	dateController.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
    
    resultAry = [[NSMutableArray alloc] initWithCapacity:30];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_LWLIST" forKey:@"service"];
    [params setObject:lxtype forKey:@"LWLX"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [resultAry count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = @"  搜索结果列表";
    return headerView;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
    //if([lxtype isEqualToString:@"51"])
   // {
        return [[resultHeightAry objectAtIndex:indexPath.row] floatValue];
    //}
	//return 90;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"CellId_laiwensearch";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.textLabel.numberOfLines =0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];

        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    
	NSString *itemTitle = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"LWBT"];
    if (itemTitle== nil) {
        itemTitle = @"";
    }
	cell.textLabel.text = itemTitle;
    NSString *lwdate = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"LWRQ"];
    if ([lwdate length] > 9) {
        lwdate = [lwdate substringToIndex:10];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"来文日期：%@    来文单位：%@",lwdate,[[resultAry objectAtIndex:indexPath.row] objectForKey:@"LWDW"]];
    cell.detailTextLabel.textAlignment = UITextAlignmentRight;
   // cell.detailTextLabel.textColor = [UIColor blueColor];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
	
    
}


#pragma mark -
#pragma mark UITableViewDelegate Methods
/*
 0  所有:
 1  办理过人员:  办理过人员、院领导。
 2  发起部门: 发起部门、办理过人员、办公室、院领导。
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *xh = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"XH"];
    NSString * flag = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"SFZXXJBRFW"];
    if([flag integerValue] != 1){
        [self showAlertMessage:@"您没有权限查看此公文。"];
        return;
    }
    TingLaiwenDetailController *controller = [[TingLaiwenDetailController alloc] initWithNibName:@"TingLaiwenDetailController" andLWID:xh];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	

    if (currentPage == pageCount)
        return;
	if (isLoading) {
        return;
    }
    
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        // Released above the header
		
        currentPage++;
        
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",urlString, currentPage];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

@end
