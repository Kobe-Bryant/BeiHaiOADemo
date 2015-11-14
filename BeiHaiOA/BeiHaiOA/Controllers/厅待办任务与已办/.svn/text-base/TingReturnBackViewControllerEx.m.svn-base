//
//  ReturnBackViewController.m
//  GuangXiOA
//
//  Created by zhang on 12-9-12.
//
//

#import "TingReturnBackViewControllerEx.h"
#import "PDJsonkit.h"
#import "NSURLConnHelper.h"
#import "ServiceUrlString.h"
#import "BECheckBox.h"
#import "NSStringUtil.h"

@implementation TingReturnBackViewControllerEx

@synthesize aItem,selUsrItem;
@synthesize arySteps;
@synthesize stepTableView,txtView;
@synthesize delegate,webServiceType;
@synthesize transferButton,aryFilteredSteps;
@synthesize webHelper,arySectionIsOpen;

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
    if (webServiceType == kWebService_ReturnBack) {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        
        if (dicTmp){
            if ([[dicTmp objectForKey:@"flag"] isEqualToString:@"true"]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"退回成功"
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

        if (dicTmp) {
            //步骤
            self.arySteps = [dicTmp objectForKey:@"returnBackStep"];

            NSInteger count = [arySteps count];
            if(count > 0){
                self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:count];
                for (NSInteger i = 0; i < count; i++) {
                    [arySectionIsOpen addObject:[NSNumber numberWithBool:YES]];
                }
            }
            

            if([arySteps count] == 0)
                transferButton.hidden = YES;
            else
                transferButton.hidden = NO;
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
    [params setObject:@"WORKFLOW_RETURNBACK" forKey:@"service"];
    
    [params setObject:aItem.strLCSLBH forKey:@"workflowId"];
    [params setObject:aItem.strLCBH forKey:@"workflowDefineId"];
    [params setObject:aItem.strBZBH forKey:@"stepId"];

    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
  
    webServiceType =  kWebService_WorkFlow;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"办理成功"] ||[alertView.message isEqualToString:@"退回成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [delegate HandleGWResult:TRUE];
    }
}




//回退
-(void)returnBackAction{
    
    if (selUsrItem == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请选择退回步骤中的人员。"
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *opinion = [NSString stringWithFormat:@"%@",txtView.text];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"WORKFLOW_RETURNBACK" forKey:@"service"];
    
    [params setObject:aItem.strLCBH forKey:@"workflowDefineId"];
    [params setObject:aItem.strBZBH forKey:@"stepId"];
    [params setObject:selUsrItem.workflowId forKey:@"workflowId"];
    [params setObject:selUsrItem.stepDefineId forKey:@"stepDefineId"];
    [params setObject:selUsrItem.stepID forKey:@"backStepIds"];    
    [params setObject:selUsrItem.processer forKey:@"processer"];
    [params setObject:selUsrItem.processType forKey:@"processType"];
    [params setObject:opinion forKey:@"thyj"];
    [params setObject:@"1" forKey:@"isSubmit"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    
    webServiceType = kWebService_ReturnBack;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(IBAction)btnTransferPressed:(id)sender{
    [self returnBackAction];
}



- (void)viewDidLoad
{
    [super viewDidLoad];    

    
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
    CGFloat headerHeight = 60.0;
   
	return headerHeight;
}



-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 60.0;
    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:section];
    NSString *title = [tmpDic objectForKey:@"stepDefineName"];
    BOOL opened = YES;
    if(section < [arySectionIsOpen count]){
        opened = [[arySectionIsOpen objectAtIndex:section] boolValue];
    }
    
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc]
                                            initWithFrame:CGRectMake(0.0, 0.0, self.stepTableView.bounds.size.width, headerHeight)
                                            title:title
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

	return 1;
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
    
	cell.textLabel.text = [tmpDic objectForKey:@"processerName"];

    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *userId = [tmpDic objectForKey:@"processer"];
    NSString *stepId = [tmpDic objectForKey:@"stepId"];
    if ([selUsrItem.processer isEqualToString:userId] && [selUsrItem.stepID isEqualToString:stepId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
	
	return cell;
    
}

#pragma mark -
#pragma mark UITableViewDelegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:indexPath.section];


    BackStepItemEx *aUsrItem = [[BackStepItemEx alloc] init];
    aUsrItem.processerName = [tmpDic objectForKey:@"processerName"];;
    aUsrItem.processer = [tmpDic objectForKey:@"processer"];
    aUsrItem.stepID = [tmpDic objectForKey:@"stepId"];
    aUsrItem.processType = [tmpDic objectForKey:@"processType"];
    aUsrItem.workflowId = [tmpDic objectForKey:@"workflowId"];
    aUsrItem.stepDefineId = [tmpDic objectForKey:@"stepDefineId"];
    aUsrItem.stepDefineName = [tmpDic objectForKey:@"stepDefineName"];
    
    self.selUsrItem = aUsrItem;

    [tableView reloadData];
    
}


@end
