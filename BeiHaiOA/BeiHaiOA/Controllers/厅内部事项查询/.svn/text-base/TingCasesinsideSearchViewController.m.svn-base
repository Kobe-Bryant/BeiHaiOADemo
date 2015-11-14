//
//  CasesinsideSearchViewController.m
//  GuangXiOA
//
//  Created by sz apple on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TingCasesinsideSearchViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "TingCasesInsideDetailsViewController.h"
#import "TingDataHelper.h"
#import "TingDepartmentInfoItem.h"

@implementation TingCasesinsideSearchViewController

@synthesize resultTableView,titleField,niwenField,nianfenField,jjcdSeg,searchBtn,typeField;
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Private methods and delegates
-(void)processWebData:(NSData*)webData{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        if (pageInfoDic) {
            pageCount = [[pageInfoDic objectForKey:@"pages"] intValue];
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
        }
        else
            bParseError = YES;
        
        NSArray *parsedItemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        
        if ([parsedItemAry count] != 0){
           // [resultAry removeAllObjects];
            [self.resultAry addObjectsFromArray:parsedItemAry];
        }
            
            
    }
    else
        bParseError = YES;
    if (bParseError) {
        [self showAlertMessage:@"查询的事项不存在."];
    } else
        [self.resultTableView reloadData];
}

-(void)processError:(NSError *)error{
    isLoading = NO;
    [self.resultTableView reloadData];
    [self showAlertMessage:@"请求数据失败."];
}


- (IBAction)searchButtonPressed:(id)sender {
    [self.titleField resignFirstResponder];
    
    [resultAry removeAllObjects];
    currentPage = 0;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_NBSXLIST" forKey:@"service"];
    if ([titleField.text length]>0)
    {
        [params setObject:titleField.text forKey:@"q_BT"];
    }
    if ([niwenField.text length]>0)
    {
        [params setObject:self.departmentDM forKey:@"q_CBDW"];
    }
    if ([nianfenField.text length]>0)
    {
        [params setObject:nianfenField.text forKey:@"q_SQNF"];
    }
    if ([typeField.text length]>0 && ![typeField.text isEqualToString:@"所有"])
    {
        [params setObject:[NSString stringWithFormat:@"%d", self.typeDM] forKey:@"lx"];
    }
    if (jjcdSeg.selectedSegmentIndex == 1)
    {
        [params setObject:@"2" forKey:@"q_JJCD"];
    }
    else if (jjcdSeg.selectedSegmentIndex == 2)
    {
        [params setObject:@"1" forKey:@"q_BT"];
    }
    else if (jjcdSeg.selectedSegmentIndex == 3)
    {
        [params setObject:@"0" forKey:@"q_BT"];
    }
    NSString *strUrl =  [ServiceUrlString generateTingUrlByParameters:params];
    self.refreshUrl = strUrl;
    
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:refreshUrl andParentView:self.view delegate:self];
}

- (void)touchDownForYear:(id)sender {
    UIControl *ctrl = (UIControl*)sender;
    currentTag = ctrl.tag;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(120, 400);
	tmpController.delegate = self;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    int currentYear = [[dateString substringToIndex:4] intValue];
    
	tmpController.wordsAry = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",currentYear],[NSString stringWithFormat:@"%d",currentYear-1],[NSString stringWithFormat:@"%d",currentYear-2],[NSString stringWithFormat:@"%d",currentYear-3],[NSString stringWithFormat:@"%d",currentYear-4],[NSString stringWithFormat:@"%d",currentYear-5],[NSString stringWithFormat:@"%d",currentYear-6],[NSString stringWithFormat:@"%d",currentYear-7],[NSString stringWithFormat:@"%d",currentYear-8],[NSString stringWithFormat:@"%d",currentYear-9],[NSString stringWithFormat:@"%d",currentYear-10],nil];
    
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

- (IBAction)touchDownForDepartment:(id)sender {
    UIControl *ctrl = (UIControl*)sender;
    currentTag = ctrl.tag;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(320, 400);
	tmpController.delegate = self;
    
    NSMutableArray *bmNameAry = [[NSMutableArray alloc] init];
    NSArray *departmentAry = [[TingDataHelper shareInstace] getTingDeptList];
    for (TingDepartmentInfoItem *aItem in departmentAry)
        [bmNameAry addObject:aItem.name];
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

- (IBAction)touchDownForType:(id)sender {
    UIControl *ctrl = (UIControl*)sender;
    currentTag = ctrl.tag;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(180, 250);
	tmpController.delegate = self;
    
	tmpController.wordsAry = [[NSArray alloc] initWithObjects:@"所有",@"请示报告",@"用章申请",@"经费申请",@"其它",nil];
    
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

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    if (currentTag == 1)
    {
        self.niwenField.text = words;
        NSArray *depAry = [[TingDataHelper shareInstace] getTingDeptList];
        TingDepartmentInfoItem *aItem = [depAry objectAtIndex:row];
        self.departmentDM = aItem.number;
    } else if (currentTag == 2)
        self.nianfenField.text = words;
    else {
        self.typeField.text = words;
        self.typeDM = row;
    }
    
    if (self.wordsPopoverController != nil) {
		[self.wordsPopoverController dismissPopoverAnimated:YES];
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查询内部事项";
    
    
    // Do any additional setup after loading the view from its nib.
    self.resultAry = [[NSMutableArray alloc] init];
    
    self.niwenField.tag = 1;
    self.nianfenField.tag = 2;
    self.typeField.tag = 3;
    [self.typeField addTarget:self action:@selector(touchDownForType:) forControlEvents:UIControlEventTouchDown];
    [self.niwenField addTarget:self action:@selector(touchDownForDepartment:) forControlEvents:UIControlEventTouchDown];
    [self.nianfenField addTarget:self action:@selector(touchDownForYear:) forControlEvents:UIControlEventTouchDown];
    
    self.jjcdSeg.selectedSegmentIndex = 0;
    UIColor *color = [UIColor colorWithRed:67.0/255 green:160.0/255 blue:179.0/255 alpha:1];
    jjcdSeg.tintColor = color;
    [self searchButtonPressed:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];	
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if(section == 0){
        headerView.text =@"  搜索结果列表";
        
    }
    
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [resultAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 90;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    
	NSString *itemTitle = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"BT"];
    if (itemTitle == nil) {
        itemTitle = @"";
    }
    
    NSString *people = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"CBR"];
    if (people == nil)
        people = @"";
    
    NSString *department = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"BMMC"];
    if (department == nil)
        department = @"";
    
    NSString *caseType = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"SQLBMC"];
    if (caseType == nil)
        caseType = @"";
    
	cell.textLabel.text = itemTitle;
    cell.textLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"事项类别：%@    拟稿人：%@    拟文处室：%@",caseType,people,department];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
	return cell;
  
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * flag = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"SFZXXJBRFW"];
    if([flag integerValue] != 1){
        [self showAlertMessage:@"您没有权限查看此公文。"];
        return;
    }
    TingCasesInsideDetailsViewController *childView = [[TingCasesInsideDetailsViewController alloc] initWithNibName:@"TingCasesInsideDetailsViewController" bundle:nil];
    childView.caseID = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"XH"];
    NSString *caseType = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"SQLBMC"];
    childView.title = [NSString stringWithFormat:@"%@详细信息",caseType];
    [self.navigationController pushViewController:childView animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
    
    if (currentPage == pageCount)
        return;

    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        currentPage++;
        
		isLoading = YES;
        
        NSString *newStrUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",self.refreshUrl,currentPage];

        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:newStrUrl andParentView:self.view delegate:self];

        
    }
}

@end
