//
//  FaWenSearchController.m
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TingHaveDoneSearchController.h"
#import "PDJsonkit.h"
#import "TingBanLiDetailController.h"
#import "BanLiItem.h"
#import "ServiceUrlString.h"
#import "TingFaWenBanliController.h"
#import "TingUndealCaseDetailsViewController.h"
#import "SystemConfigContext.h"


@implementation TingHaveDoneSearchController

@synthesize myTableView,bHaveShowed;
@synthesize popController,dateController;
@synthesize titleField,titleLabel,searchBtn;
@synthesize pageSum,currentPage;
@synthesize fromDateField,fromDateLabel,endDateField,endDateLabel;
@synthesize isLoading,currentTag,urlString;
@synthesize webHelper,gwType,rightButtonBar,segmentControlTitles;
@synthesize laiWenItemAry,faWenItemAry,neiBuShiXiangItemAry;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    titleField.hidden = NO;
    titleLabel.hidden = NO;
    fromDateField.hidden = NO;
    fromDateLabel.hidden = NO;
    searchBtn.hidden = NO;
    endDateField.hidden = NO;
    endDateLabel.hidden = NO;
}

-(void)showSearchBar:(id)sender
{
    if(bHaveShowed)
    {
        bHaveShowed = NO;
        CGRect origFrame = myTableView.frame;
        UIBarButtonItem* rightButton = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
        [rightButton setTitle:@"开启查询"];
        titleField.hidden = YES;
        titleLabel.hidden = YES;
        fromDateField.hidden = YES;
        fromDateLabel.hidden = YES;
        searchBtn.hidden = YES;
        endDateField.hidden = YES;
        endDateLabel.hidden = YES;
    
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(myTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        myTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y-100, origFrame.size.width, origFrame.size.height+100);        
        [UIView commitAnimations];
    }
    else
    {
        UIBarButtonItem* rightButton = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
        [rightButton setTitle:@"关闭查询"];
        bHaveShowed = YES;
        CGRect origFrame = myTableView.frame;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(myTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        myTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+100, origFrame.size.width, origFrame.size.height-100);
        [UIView commitAnimations];
    }
}

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
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
        if (pageInfoDic )
        {
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
            pageSum = [[pageInfoDic objectForKey:@"pages"] intValue];
        }
        else
        {
            bParseError = YES;
        }
        NSArray *itemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        NSMutableArray *tmpAry = [[NSArray arrayWithObjects:faWenItemAry,laiWenItemAry,neiBuShiXiangItemAry, nil] objectAtIndex:gwType -1];
        [tmpAry addObjectsFromArray:itemAry];
    }
    else
    {
        bParseError = YES;
    }
    if (bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"获取数据出错。" 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [myTableView reloadData];
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    [myTableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败." 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [myTableView reloadData];
    return;
}

-(void)getFirstListData
{
    if(gwType == 1)
    {
        if ([faWenItemAry count] > 0)
        {
            [self.myTableView reloadData];
            return;
        }
    }
    else if(gwType == 2)
    {
        if ([laiWenItemAry count] > 0)
        {
            [self.myTableView reloadData];
            return;
        }
    }
    else
    {
        if ([neiBuShiXiangItemAry count] > 0)
        {
            [self.myTableView reloadData];
            return;
        }
    }
    
    isLoading = YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_YBRWTASK" forKey:@"service"];
    [params setObject:[NSString stringWithFormat:@"%d", self.gwType] forKey:@"gwType"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


-(IBAction)btnSearchPressed:(id)sender
{
    if(gwType == 1)
    {
        [faWenItemAry removeAllObjects];        
    }
    else if(gwType == 2)
    {
        [laiWenItemAry removeAllObjects];
    }
    else
    {
        [neiBuShiXiangItemAry removeAllObjects];
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_YBRWTASK" forKey:@"service"];
    [params setObject:[NSString stringWithFormat:@"%d", self.gwType] forKey:@"gwType"];
    if ([titleField.text length] > 0)
    {
        [params setObject:titleField.text forKey:@"q_DWMC"];
    }
    if ([fromDateField.text length] > 0)
    {
        [params setObject:fromDateField.text forKey:@"q_BEGIN"];
    }
    if ([endDateField.text length] > 0)
    {
        [params setObject:endDateField.text forKey:@"q_END"];
    }
    
    isLoading = YES;
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


-(IBAction)touchFromDate:(id)sender
{
	UIControl *btn =(UIControl*)sender;
	[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
	[popController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		switch (currentTag)
        {
			case 1:				
				fromDateField.text = dateString;
				break;
			case 2:
				endDateField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (currentTag)
        {
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


-(void)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"已办任务";

    self.gwType = 2;
    
    segmentControlTitles = [NSArray arrayWithObjects:@"来文",@"发文",@"内部事项", nil];
    UISegmentedControl *segmentCtrl = [[UISegmentedControl alloc] initWithItems:segmentControlTitles];
    segmentCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentCtrl.selectedSegmentIndex = 0;
    [segmentCtrl addTarget:self action:@selector(onTitleChangeClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentCtrl;
    
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
   
    self.laiWenItemAry = [[NSMutableArray alloc] init];
    self.faWenItemAry = [[NSMutableArray alloc] init];
    self.neiBuShiXiangItemAry = [[NSMutableArray alloc] init];
    
    [self getFirstListData];
}

#pragma mark -

- (void)onTitleChangeClick:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
    {
        gwType =  2;
    }
    else if(sender.selectedSegmentIndex == 1)
    {
        gwType =  1;
    }
    else
    {
        gwType = 3;
    }
    
    if(bHaveShowed)
    {
        [self showSearchBar:rightButtonBar];
    }
    [self getFirstListData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated {
	//self.navigationItem.hidesBackButton = YES;
	[self.navigationController setNavigationBarHidden:NO animated:YES];	
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   // if(isLoading)return nil;
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if(gwType == 1)
    {
        headerView.text = [NSString stringWithFormat:@"  查询到的发文任务(%d条)",[faWenItemAry count]];
    }
    else if(gwType == 2)
    {
        headerView.text = [NSString stringWithFormat:@"  查询到的来文任务(%d条)",[laiWenItemAry count]];
    }
    else
    {
        headerView.text = [NSString stringWithFormat:@"  查询到的内部事项(%d条)",[neiBuShiXiangItemAry count]];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(gwType == 1)
    {
        return [faWenItemAry count];
    }
    else if(gwType == 2)
    {
        return [laiWenItemAry count];
    }
    else
    {
        return [neiBuShiXiangItemAry count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *WryXmspListCellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WryXmspListCellIdentifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WryXmspListCellIdentifier];
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    
    NSMutableArray *tmpAry = [[NSArray arrayWithObjects:faWenItemAry,laiWenItemAry,neiBuShiXiangItemAry, nil] objectAtIndex:gwType -1];
    if([tmpAry count] <=0)return cell;
	NSString *itemTitle = [[tmpAry objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
    if (itemTitle== nil) {
        itemTitle = @"";
    }
    cell.textLabel.text = itemTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"时间：%@    步骤名称：%@",[[tmpAry objectAtIndex:indexPath.row] objectForKey:@"YKSSJ"],[[tmpAry objectAtIndex:indexPath.row] objectForKey:@"BZMC"]];
    
    
    NSString *strLCBH = [[tmpAry objectAtIndex:indexPath.row] objectForKey:@"LCLXBH"];
    if ([strLCBH isEqualToString:@"32028100002"]) {//发文
        cell.imageView.image = [UIImage imageNamed:@"fw.png"];
    }
    else if ([strLCBH isEqualToString:@"14a8ff58-d896-45cf-b18a-35a6ff68eb4d"]) {//内部事项
        cell.imageView.image = [UIImage imageNamed:@"nbsx.png"];
        
    }
    else if ([strLCBH isEqualToString:@"e4514fdc-ced9-44c8-bcb4-b5279bf0d584"]) {//来文
        cell.imageView.image = [UIImage imageNamed:@"lw.png"];
    }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
   	cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tmpAry = [[NSArray arrayWithObjects:faWenItemAry,laiWenItemAry,neiBuShiXiangItemAry, nil] objectAtIndex:gwType -1];
    if (tmpAry==nil || [tmpAry count] <= indexPath.row)
    {
        NSLog(@"parsedItemAry error in BanliCOntroller");
    }
    NSDictionary *tmpDic = [tmpAry objectAtIndex:indexPath.row];
    BanLiItem *aItem = [[BanLiItem alloc] init];
    aItem.strLCBH = [tmpDic objectForKey:@"LCLXBH"];
    aItem.strLCSLBH =[tmpDic objectForKey:@"LCBH"];
    aItem.strBZDYBH=[tmpDic objectForKey:@"BZDYBH"];
    aItem.strBZBH=[tmpDic objectForKey:@"BZBH"];
    NSString *userid = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
    aItem.strprocesser = userid;
    aItem.strprocessType=[tmpDic objectForKey:@"SFZB"];
    aItem.strBH = [tmpDic objectForKey:@"LCSLBH"];
    if ([aItem.strLCBH isEqualToString:@"32028100002"]) {//发文
        TingFaWenBanliController *controller = [[TingFaWenBanliController alloc] initWithNibName:@"TingFaWenBanliController" andBanliItem:aItem isBanli:NO];
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if ([aItem.strLCBH isEqualToString:@"14a8ff58-d896-45cf-b18a-35a6ff68eb4d"]) {//内部事项 

        TingUndealCaseDetailsViewController *childView = [[TingUndealCaseDetailsViewController alloc] initWithNibName:@"TingUndealCaseDetailsViewController" bundle:nil];
        childView.isHandle = NO;
        childView.myItem = aItem;
        childView.title = @"内部事项详细信息";
        [self.navigationController pushViewController:childView animated:YES];
    }
   else if ([aItem.strLCBH isEqualToString:@"e4514fdc-ced9-44c8-bcb4-b5279bf0d584"]) {//来文
        TingBanLiDetailController *controller = [[TingBanLiDetailController alloc] initWithNibName:@"TingBanLiDetailController" andBanliItem:aItem isBanli:NO];
        [self.navigationController pushViewController:controller animated:YES ];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (currentPage == pageSum)
    {
        return;
    }
    if (isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",urlString, currentPage];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

@end
