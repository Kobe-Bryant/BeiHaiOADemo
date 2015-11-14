//
//  BanLiController.m
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TingBanLiController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "TingBanLiDetailController.h"
#import "BanLiItem.h"
#import "TingFaWenBanliController.h"
#import "TingUndealCaseDetailsViewController.h"
#import "SystemConfigContext.h"


@implementation TingBanLiController
@synthesize itemAry,currentPage,pageSum;
@synthesize myTableView;
@synthesize isLoading,segmentControlTitles;
@synthesize webHelper;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];

    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        if (pageInfoDic ) {
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
            pageSum = [[pageInfoDic objectForKey:@"pages"] intValue];
        }
        else
            bParseError = YES;
        
        NSArray *tmpAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfo"];
        if([tmpAry count] > 0)
            [itemAry addObjectsFromArray:tmpAry];
        
    }
    else
        bParseError = YES;
    if (bParseError) {
        
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
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_BLLIST" forKey:@"service"];
    [params setObject:@"ALL" forKey:@"bwlx"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"待办任务";
    self.itemAry = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
	//self.navigationItem.hidesBackButton = YES;
	[self.navigationController setNavigationBarHidden:NO animated:YES];	
    if(itemAry)[itemAry removeAllObjects];
    [self getFirstListData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

#pragma mark UITableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isLoading)return 0;
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   // if(isLoading)return nil;
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  待办任务(%d条)",[itemAry count]];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [itemAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *WryXmspListCellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WryXmspListCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WryXmspListCellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;

        
	}

    if([itemAry count] <=0)return cell;
	NSString *itemTitle = [[itemAry objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
    if (itemTitle== nil)
    {
        itemTitle = @"";
    }
    int num = [[[itemAry objectAtIndex:indexPath.row] objectForKey:@"JJCD"] intValue];
    if(num == 2)
    {
        //特急
        cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    else if(num == 1)
    {
        //8b0000
        UIColor *rgb = [UIColor colorWithRed:0x8B*1.0f/255 green:0.0f blue:0.0f alpha:1.0];
        cell.textLabel.textColor = rgb;
        cell.detailTextLabel.textColor = rgb;
        //cell.textLabel.textColor = [UIColor blueColor];
        // cell.detailTextLabel.textColor = [UIColor blueColor];
    }else
    {
        //一般
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"交办人：%@    时间：%@    步骤名称：%@",[[itemAry objectAtIndex:indexPath.row] objectForKey:@"YHMC"],[[itemAry objectAtIndex:indexPath.row] objectForKey:@"LCKSSJ"],[[itemAry objectAtIndex:indexPath.row] objectForKey:@"BZMC"]];
    NSString *strLCBH = [[itemAry objectAtIndex:indexPath.row] objectForKey:@"LCLXBH"];

    cell.textLabel.text = itemTitle;
    if ([strLCBH isEqualToString:@"32028100002"]) {//发文
        cell.imageView.image = [UIImage imageNamed:@"fw.png"];
    }
    else if ([strLCBH isEqualToString:@"14a8ff58-d896-45cf-b18a-35a6ff68eb4d"]) {//内部事项
        cell.imageView.image = [UIImage imageNamed:@"nbsx.png"];
        
    }
    else if ([strLCBH isEqualToString:@"e4514fdc-ced9-44c8-bcb4-b5279bf0d584"]) {//来文
        cell.imageView.image = [UIImage imageNamed:@"lw.png"];
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (itemAry==nil || [itemAry count] <= indexPath.row)
    {
        NSLog(@"parsedItemAry error in BanliCOntroller");
    }
    
    NSDictionary *tmpDic = [itemAry objectAtIndex:indexPath.row];
    BanLiItem *aItem = [[BanLiItem alloc] init];
    aItem.strLCBH = [tmpDic objectForKey:@"LCLXBH"];
    aItem.strLCSLBH =[tmpDic objectForKey:@"LCBH"];
    aItem.strBZDYBH=[tmpDic objectForKey:@"BZDYBH"];
    aItem.strBZBH=[tmpDic objectForKey:@"BZBH"];
    NSString *userid = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
    aItem.strprocesser = userid;
    aItem.strprocessType=[tmpDic objectForKey:@"SFZB"];
    aItem.strBH = [tmpDic objectForKey:@"LCSLBH"];
    
    
    if ([aItem.strLCBH isEqualToString:@"32028100002"]) 
    {
        //发文
        TingFaWenBanliController *controller = [[TingFaWenBanliController alloc] initWithNibName:@"TingFaWenBanliController" andBanliItem:aItem isBanli:YES];
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if ([aItem.strLCBH isEqualToString:@"14a8ff58-d896-45cf-b18a-35a6ff68eb4d"]) {//内部事项
        //内部事项
        TingUndealCaseDetailsViewController *childView = [[TingUndealCaseDetailsViewController alloc] initWithNibName:@"TingUndealCaseDetailsViewController" bundle:nil];
        childView.myItem = aItem;
        childView.isHandle = YES;
        childView.title = @"内部事项详细信息";
        [self.navigationController pushViewController:childView animated:YES];
    }
     else if ([aItem.strLCBH isEqualToString:@"e4514fdc-ced9-44c8-bcb4-b5279bf0d584"]) 
    {
        //来文
        TingBanLiDetailController *controller = [[TingBanLiDetailController alloc] initWithNibName:@"TingBanLiDetailController" andBanliItem:aItem isBanli:YES];
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
        // Released above the header
        currentPage++;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"QUERY_BLLIST" forKey:@"service"];
        [params setObject:@"ALL" forKey:@"bwlx"];
        [params setObject:[NSString stringWithFormat:@"%d",currentPage]  forKey:@"P_CURRENT"];
        NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

@end
