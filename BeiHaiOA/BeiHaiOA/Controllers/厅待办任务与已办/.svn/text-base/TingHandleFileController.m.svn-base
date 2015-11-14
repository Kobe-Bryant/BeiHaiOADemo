//
//  HandleFileController.m
//  GuangXiOA
//
//  Created by 张 仁松 on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TingHandleFileController.h"
#import "NSURLConnHelper.h"
#import "PDJsonkit.h"
#import "BECheckBox.h"
#import "NSStringUtil.h"
#import "StepUserItem.h"
#import "ServiceUrlString.h"

@implementation TingHandleFileController

@synthesize aryUsualOpinion,aItem;
@synthesize arySteps,canSign,arySelectedUsers;
@synthesize stepTableView,txtView;
@synthesize wordsPopoverController,wordsSelectViewController,delegate,webServiceType;
@synthesize radioScrollView,aryRadioViews,lastSelMainPersonIndex,canSingleFinish,canFinish;
@synthesize finishButton,transferButton,aryFilteredSteps;
@synthesize webHelper,arySectionIsOpen,searchBar;

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


-(void)processWebData:(NSData*)webData{

    if([webData length] <=0 )
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    /*{"result":"success","canSplit":true,"canFinish":false,"canSendback":false,"canRevoke":false,"canSingleFinish":false,"canTransition":true,"canSign":false,"signDesc":"是否同意","agreeDesc":"同意","noAgreeDesc":"不同意","steps":[{"stepId":"6910179e-1318-4623-83a1-223d986a71eb","processType":"SINGLE_MASTER","stepDesc":"办公室负责人审核","users":[{"userId":"tanliang","userName":"谭良"},{"userId":"system","userName":"系统管理员"}]}]}*/
    if (webServiceType == kWebService_Transfer) {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        
        if (dicTmp){
            if ([[dicTmp objectForKey:@"result"] isEqualToString:@"true"]) {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"提示" 
                                      message:@"办理成功"
                                      delegate:self 
                                      cancelButtonTitle:@"确定" 
                                      otherButtonTitles:nil];
                [alert show];
                              
            }
            else{
                NSString *message = [dicTmp objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"错误" 
                                      message:message
                                       delegate:nil 
                                      cancelButtonTitle:@"确定" 
                                      otherButtonTitles:nil];
                [alert show];

                
            }
            return;
        }
        else{
            bParseError = YES;
        }
    }
    else{
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        canSingleFinish = NO;
        if (dicTmp && [[dicTmp objectForKey:@"result"] isEqualToString:@"success"]) {
            //步骤
            self.arySteps = [dicTmp objectForKey:@"steps"];
            self.aryUsualOpinion = [dicTmp objectForKey:@"kjyj"];//常用意见
            NSInteger count = [arySteps count];
            if(count > 0){
                self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:count];
                for (NSInteger i = 0; i < count; i++) {
                    [arySectionIsOpen addObject:[NSNumber numberWithBool:YES]];
                }
            }
            
            self.canSign = [[dicTmp objectForKey:@"canSign"] boolValue];
            self.canSingleFinish = [[dicTmp objectForKey:@"canSingleFinish"] boolValue];
            self.canFinish = [[dicTmp objectForKey:@"canFinish"] boolValue];
            if(canFinish || canSingleFinish)
                finishButton.hidden = NO;
            else
                finishButton.hidden = YES;
            NSString * cllx =[dicTmp objectForKey:@"cllx"];
             
            if([arySteps count] == 0 || [cllx isEqualToString:@"READER"]) //READER 表示抄送 只能结束
                transferButton.hidden = YES;
            else
                transferButton.hidden = NO;
            
            BOOL sftyjStep = [[dicTmp objectForKey:@"sftyjStep"] boolValue];
            if(sftyjStep){
                finishButton.hidden = YES;
                transferButton.hidden = YES;
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"存在相关处室正在提意见，不能进行流转操作，详情请查看流程列表信息！"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
                [alert show];

                return;
            }
        }
        else
            bParseError = YES;
        if (bParseError == NO) {

            self.aryFilteredSteps = [NSMutableArray arrayWithArray:arySteps];
            [stepTableView reloadData]; 
            
        }
    }
    
    
    if (bParseError) {
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"获取数据出错。" 
                              delegate:nil 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
}

-(void)processError:(NSError *)error{
}

#pragma mark - View lifecycle

-(void)requestWorkFlow{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"WORKFLOW_BEFORE_TRANSITION" forKey:@"service"];
    [params setObject:aItem.strLCSLBH forKey:@"LCSLBH"];
    [params setObject:aItem.strBZDYBH forKey:@"BZDYBH"];
    [params setObject:aItem.strBZBH forKey:@"BZBH"];
    [params setObject:aItem.strprocesser forKey:@"processer"];
    [params setObject:aItem.strprocessType forKey:@"processType"];
    
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];

    webServiceType =  kWebService_WorkFlow;
   self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"办理成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [delegate HandleGWResult:TRUE];
    } 
}

-(IBAction)inputCustomClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;
    NSArray *ary  = nil;
	if (![txtView isFirstResponder]) {
		[txtView becomeFirstResponder];		
	}
    if (index == 0) {
        ary = [NSArray arrayWithObjects:@"请", @"让", @"至", nil];	
    }
    else if(index == 1) {
        NSMutableArray *aryTmp  = [NSMutableArray arrayWithCapacity:4];
        if(aryUsualOpinion){
            for(NSDictionary *tmpDic in aryUsualOpinion){
                NSString* strtmp = [tmpDic objectForKey:@"DMNR"];
                if(strtmp)
                    [aryTmp addObject:strtmp];
            }
            ary = aryTmp;
        }else{
            ary = [NSArray arrayWithObjects:@"阅处", @"阅办",@"阅示",@"跟进", @"办理", @"先提出意见", @"研究",  @"会签",
               nil];
        }
        
    }
    else{
        ary = [NSArray arrayWithObjects:@"，", @"、",@"。", @"！",@"：",@"？",@"⋯⋯", nil];
    }
    

	wordsSelectViewController.wordsAry = ary;
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}


- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
	
    //定位光标
    NSRange range = [txtView selectedRange];
    NSMutableString *top = [[NSMutableString alloc] initWithString:[txtView text]];
    NSString *addName = [NSString stringWithFormat:@"%@",words];
    [top insertString:addName atIndex:range.location];

	txtView.text = top;

    int opLoaction = [addName length] + range.location ;
    txtView.selectedRange = NSMakeRange(opLoaction, 0);
	
	if (wordsPopoverController != nil) {
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
	
}

//整个流程结束接口
-(void)wholeFinishWork{
    
    NSString *opinion = [NSString stringWithFormat:@"%@",txtView.text];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"WORKFLOW_FINISH_ACTION" forKey:@"service"];
    [params setObject:aItem.strLCSLBH forKey:@"workflowId"];
    [params setObject:aItem.strLCBH forKey:@"workflowDefineId"];
    [params setObject:aItem.strBZDYBH forKey:@"stepDefineId"];
    [params setObject:aItem.strBZBH forKey:@"stepId"];
    [params setObject:aItem.strprocesser forKey:@"processer"];
    [params setObject:aItem.strprocessType forKey:@"processType"];
    [params setObject:opinion forKey:@"opinion"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    
    
    webServiceType = kWebService_Transfer;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

//当前步骤结束接口
-(void)singleFinishWork{
    NSString *opinion = [NSString stringWithFormat:@"%@",txtView.text];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"WORKFLOW_SINGLEFINISH_ACTION" forKey:@"service"];
    [params setObject:aItem.strLCSLBH forKey:@"workflowId"];
    [params setObject:aItem.strLCBH forKey:@"workflowDefineId"];
    [params setObject:aItem.strBZDYBH forKey:@"stepDefineId"];
    [params setObject:aItem.strBZBH forKey:@"stepId"];
    [params setObject:aItem.strprocesser forKey:@"processer"];
    [params setObject:aItem.strprocessType forKey:@"processType"];
    [params setObject:opinion forKey:@"opinion"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
  
    
    webServiceType = kWebService_Transfer;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

//流转
-(void)transferToNextStep{
    if([arySelectedUsers count] <=0)
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"请选择处理人." 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];

        return;
        
    }
    NSMutableString *selectSteps = [NSMutableString stringWithCapacity:100];
    NSMutableString *selectUsers = [NSMutableString stringWithCapacity:100];
    NSMutableString *selectType = [NSMutableString stringWithCapacity:100];
    BOOL first = YES;
    for (StepUserItem *usrItem in arySelectedUsers) {

        if (first) {
            [selectSteps appendFormat:@"%@",usrItem.stepID];
            [selectUsers appendFormat:@"%@",usrItem.userId];
            [selectType appendFormat:@"%@",usrItem.processType];
            first = NO;
        }else{
            [selectSteps appendFormat:@"@%@",usrItem.stepID];//之前用#隔开
            [selectUsers appendFormat:@"@%@",usrItem.userId];
            [selectType appendFormat:@"@%@",usrItem.processType];//之前用#隔开
        }
        
    }
    NSString *opinion = [NSString stringWithFormat:@"%@",txtView.text];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"WORKFLOW_DO_TRANSITION" forKey:@"service"];
    [params setObject:aItem.strLCSLBH forKey:@"LCSLBH"];
    [params setObject:aItem.strLCBH forKey:@"LCBH"];
    [params setObject:aItem.strBZDYBH forKey:@"BZDYBH"];
    [params setObject:aItem.strBZBH forKey:@"BZBH"];
    [params setObject:aItem.strprocesser forKey:@"processer"];
    [params setObject:aItem.strprocessType forKey:@"processType"];
    [params setObject:selectSteps forKey:@"selectSteps"];
    [params setObject:selectUsers forKey:@"selectUsers"];
    [params setObject:selectType forKey:@"selectType"];
    [params setObject:opinion forKey:@"opinion"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    
    
    if (lastSelMainPersonIndex != NOT_SELECTED) {
        StepUserItem *usrItem = [arySelectedUsers objectAtIndex:lastSelMainPersonIndex];
        
        strUrl = [NSString stringWithFormat:@"%@&attributes=[{name:'zbr',value:'%@'}]",strUrl,usrItem.userId];
    }
    
    webServiceType = kWebService_Transfer;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(IBAction)btnTransferPressed:(id)sender{
    [self transferToNextStep];
}

-(IBAction)btnFinishPressed:(id)sender{
    if (canSingleFinish) {
        [self singleFinishWork];
    }else if(canFinish){
        [self wholeFinishWork];
    }
}

-(IBAction)btnClearPressed:(id)sender{
    txtView.text = @"";
}

-(void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"流转";
    self.arySelectedUsers = [NSMutableArray arrayWithCapacity:5];
    lastSelMainPersonIndex = NOT_SELECTED;
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  initWithStyle:UITableViewStylePlain];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, 300);
	tmpController.delegate = self;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    [radioScrollView setContentSize:CGSizeMake(415, 500)];
    [self requestWorkFlow];
 
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	return [aryFilteredSteps count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 35.0;
    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:section];
    NSString *aSubTitle =[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"stepActionDesc"]];
    headerHeight = headerHeight +[NSStringUtil calculateTextHeight:aSubTitle byFont:[UIFont boldSystemFontOfSize:17.0] andWidth:self.stepTableView.bounds.size.width];
	return headerHeight;
}



-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section 
{
    CGFloat headerHeight = 35.0;
    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:section];
    NSString *title = [tmpDic objectForKey:@"stepDesc"];
    //NSString *aSubTitle = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"stepActionDesc"]];
    NSString *aSubTitle = [NSString stringWithFormat:@"%@",@" "];
    BOOL opened = YES;
    if(section < [arySectionIsOpen count]){
        opened = [[arySectionIsOpen objectAtIndex:section] boolValue];
    } 
    headerHeight = headerHeight +[NSStringUtil calculateTextHeight:aSubTitle byFont:[UIFont boldSystemFontOfSize:17.0] andWidth:self.stepTableView.bounds.size.width];
    
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc] 
                                            initWithFrame:CGRectMake(0.0, 0.0, self.stepTableView.bounds.size.width, headerHeight) 
                                            title:title
                                            subTitle:aSubTitle                                        
                                            section:section 
                                            opened:opened
                                            delegate:self];
	return sectionHeadView;
}

#pragma mark - QQ section header view delegate

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    NSNumber *opened = [arySectionIsOpen objectAtIndex:section];
    [arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [stepTableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0) 
    {
		[self.stepTableView reloadData];
      //  [self.stepTableView deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}


-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	NSNumber *opened = [arySectionIsOpen objectAtIndex:section];
    [arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
	[self.stepTableView reloadData];
	// 展开+动画 (如果不需要动画直接reloaddata)
    ///////////////////////////////////////////////////////////////fix
	//if(persons.indexPaths){
    //if ([persons.m_arrayPersons count] > 0)
    {
        
		//[self.processTable insertRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
	//persons.indexPaths = nil;
    ///////////////////////////////////////////////////////////////fix
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section < [arySectionIsOpen count]){
        BOOL opened = [[arySectionIsOpen objectAtIndex:section] boolValue];
        if(opened == NO) return 0;
    }
    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:section];
	return [[tmpDic objectForKey:@"users"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 40;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // if(indexPath.row%2 == 0)
    //    cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;

        
	}
    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:indexPath.section];
	NSArray *tmpAry = [tmpDic objectForKey:@"users"];
    
	cell.textLabel.text = [[tmpAry objectAtIndex:indexPath.row] objectForKey:@"userName"];
    cell.detailTextLabel.text = [[tmpAry objectAtIndex:indexPath.row] objectForKey:@"userDeptName"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *userId = [[tmpAry objectAtIndex:indexPath.row] objectForKey:@"userId"];
    NSString *stepId = [tmpDic objectForKey:@"stepId"];
    for (StepUserItem *aUsrItem in arySelectedUsers) {
        if ([aUsrItem.userId isEqualToString:userId] && [aUsrItem.stepID isEqualToString:stepId]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
            
        }
    }

	
	return cell;
    
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

-(void)checkBoxClicked:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"checkBoxClicked %d",btn.tag);
    if (lastSelMainPersonIndex != NOT_SELECTED) {
        BECheckBox *radioBox = [self.aryRadioViews objectAtIndex:lastSelMainPersonIndex];
        if (lastSelMainPersonIndex == btn.tag) {
            if ([radioBox isChecked]) {
                lastSelMainPersonIndex = btn.tag;
            }else{
                lastSelMainPersonIndex = NOT_SELECTED;
            }
            
        }else{
            [radioBox setIsChecked:NO];
            lastSelMainPersonIndex = btn.tag;
        }
        
    }
    else
        lastSelMainPersonIndex = btn.tag;
    
}

-(void)showRadioBoxes{
    
    
   // NSMutableString *strHtml = [NSMutableString stringWithCapacity:30];
    if (aryRadioViews) {
        for (int i = 0; i < [aryRadioViews count]; i++) {
            [[aryRadioViews objectAtIndex:i] removeFromSuperview];
        }
        [aryRadioViews removeAllObjects];
    }
    int i = 0;
    CGRect rect = CGRectMake(10, -40, 110, 40);
    for (StepUserItem *aUsrItem in arySelectedUsers) {

        if (i%3 == 0) {
            rect.origin.x = 10;
            rect.origin.y += 45;
        }
        else if (i%3 == 1) {
            rect.origin.x += 120;
        }
        else{
            rect.origin.x += 120;
            
        }
        
        BECheckBox *radioBox=[[BECheckBox alloc]initWithFrame:rect];
        radioBox.tag = i;
        [radioBox setTitle:aUsrItem.userHanzi forState:UIControlStateNormal];
        radioBox.titleLabel.font=[UIFont systemFontOfSize:18];
        [radioBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [radioBox setTarget:self fun:@selector(checkBoxClicked:)];	

        [self.radioScrollView addSubview:radioBox];
        if (aryRadioViews == nil) {
            self.aryRadioViews = [NSMutableArray arrayWithCapacity:5];
        }
        [aryRadioViews addObject:radioBox];

        i++;
        
    }
    
    lastSelMainPersonIndex = NOT_SELECTED;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL alreadyChecked = NO;
    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:indexPath.section];
	NSArray *tmpAry = [tmpDic objectForKey:@"users"];
    NSString *userId = [[tmpAry objectAtIndex:indexPath.row] objectForKey:@"userId"];
    NSString *stepId = [tmpDic objectForKey:@"stepId"];
    NSString *processType = [tmpDic objectForKey:@"processType"];
    
    for (StepUserItem *aUsrItem in arySelectedUsers) {
        if ([aUsrItem.userId isEqualToString:userId] && [aUsrItem.stepID isEqualToString:stepId])  {
            [arySelectedUsers removeObject:aUsrItem];
            alreadyChecked = YES;
            break;
            
        }
    }
    if (alreadyChecked == NO) {
        StepUserItem *aUsrItem = [[StepUserItem alloc] init];
        aUsrItem.userHanzi = [[tmpAry objectAtIndex:indexPath.row] objectForKey:@"userName"];
        aUsrItem.userId = userId;
        aUsrItem.stepID = stepId;
        aUsrItem.processType = processType;
        [arySelectedUsers addObject:aUsrItem];

    }
   // [self showSelectedStepInWebView];
    [self showRadioBoxes];
    [tableView reloadData];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    int len = [searchText length];
    if(len == 0){
        self.aryFilteredSteps = [NSMutableArray arrayWithArray: arySteps];
         [stepTableView reloadData];
        return;
    }
    self.aryFilteredSteps = [[NSMutableArray alloc] initWithCapacity:10];
    for (int section = 0; section < [arySteps count]; section++) {
        NSDictionary *tmpDic = [arySteps objectAtIndex:section];
        NSMutableDictionary *filteredDic = [NSMutableDictionary dictionaryWithDictionary:tmpDic];
        NSArray *tmpAry = [tmpDic objectForKey:@"users"];
        NSMutableArray *filterdAry = [NSMutableArray arrayWithCapacity:10];
        for (int row = 0; row < [tmpAry count]; row++) {
            NSDictionary *userDic = [tmpAry objectAtIndex:row];
            NSString *userId = [userDic objectForKey:@"userId"];
            NSString *userName = [userDic objectForKey:@"userName"];
            if([userId length] >= len){
                if([[userId substringToIndex:len] isEqualToString:searchText]){
                    [filterdAry addObject:userDic];
                    continue;
                }
                
            }
            if([userName length] >= len){
                if([[userName substringToIndex:len] isEqualToString:searchText]){
                    [filterdAry addObject:userDic];
                    continue;
                }
            }
            
        }
        [filteredDic setValue:filterdAry forKey:@"users"];
        [aryFilteredSteps   addObject:filteredDic];  
        
    }
   
    [stepTableView reloadData];
    
}

@end
