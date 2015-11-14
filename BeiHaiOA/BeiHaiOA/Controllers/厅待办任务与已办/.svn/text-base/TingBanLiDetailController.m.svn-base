//
//  BanLiDetaiController.m
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TingBanLiDetailController.h"
#import "ServiceUrlString.h"
#import "NSStringUtil.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"
#import "DisplayAttachFileController.h"

#import "TingHandleFileController.h"

#import "TingReturnBackViewControllerEx.h"
#import "TingFinishFileViewController.h"
#import "SharedInformations.h"

@implementation TingBanLiDetailController
@synthesize infoDic,stepAry,attachmentAry,toDisplayKeyTitle;
@synthesize resTableView,chushiOpinionAry,aItem,selInfoAry,toDisplayKey,isHandle;
@synthesize toDisplayHeightAry,bOKFromTransfer,stepHeightAry;
@synthesize webHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil andBanliItem:(BanLiItem*)item isBanli:(BOOL)isToBanLi
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.aItem = item;
        isHandle = isToBanLi;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - Private method and delegate
-(void)returnBackAction:(id)sender{
    TingReturnBackViewControllerEx *controller = [[TingReturnBackViewControllerEx alloc] initWithNibName:@"TingReturnBackViewControllerEx" bundle:nil];
    // controller.selInfoAry = selInfoAry;
    controller.aItem = aItem;
    controller.delegate = self;
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

-(void)banliAction:(id)sender{
    
    if ([aItem.strprocessType isEqualToString:@"READER"] ) {
        TingFinishFileViewController *controller = [[TingFinishFileViewController alloc] initWithNibName:@"TingFinishFileViewController" bundle:nil];
        // controller.selInfoAry = selInfoAry;
        controller.aItem = aItem;
        controller.delegate = self;
        [self.navigationController pushViewController:controller
                                             animated:YES];

    }else{
        {
            
            TingHandleFileController *controller = [[TingHandleFileController alloc] initWithNibName:@"TingHandleFileController" bundle:nil];
            // controller.selInfoAry = selInfoAry;
            controller.aItem = aItem;
            controller.delegate = self;
            [self.navigationController pushViewController:controller
                                                 animated:YES];
        }

    }

}

-(void)HandleGWResult:(BOOL)eOK{
    bOKFromTransfer = eOK;
}



#pragma mark - View lifecycle
-(void)processWebData:(NSData*)webData{
    if([webData length] <=0 )
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        
        self.infoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"lwInfo"] lastObject];
        NSString *djsj = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"DJSJ"]];
        if([djsj length] >=16){
            NSString *subSj = [djsj substringWithRange:NSMakeRange(11, 5)];
            if([subSj isEqualToString:@"00:00"]){
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
                [dic setObject:[djsj substringToIndex:11] forKey:@"DJSJ"];
                self.infoDic = dic;
            }
                
        }
        
        self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"lwbz"];
        
        self.attachmentAry = [[tmpParsedJsonAry lastObject] objectForKey:@"lwfj"];
        
        self.chushiOpinionAry = [[tmpParsedJsonAry lastObject] objectForKey:@"csyjInfo"];
        self.selInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"lwtldqp"];
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
    
    UIFont *font1 = [UIFont fontWithName:@"Helvetica" size:19.0];
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [toDisplayKey count];i++) {
        NSString *itemTitle =[NSString stringWithFormat:@"%@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i]]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font1 andWidth:520.0]+20;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.toDisplayHeightAry = aryTmp;


    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];

    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [stepAry count];i++) {
        NSDictionary *dicTmp = [stepAry   objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"批示记录：%@",
                           [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700]+30;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp2 addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.stepHeightAry = aryTmp2;

    [resTableView reloadData];
}

-(void)processError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败." 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    return;
}

-(void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title =@"来文详细信息";
    // Do any additional setup after loading the view from its nib.
    if (isHandle) {
        
        UIBarButtonItem *aBarItemBL = [[UIBarButtonItem alloc] initWithTitle:@"  办理  " style:UIBarButtonItemStyleBordered target:self action:@selector(banliAction:)];
        
        //抄送的不能退文
        if([aItem.strprocessType isEqualToString:@"READER"] ){
            self.navigationItem.rightBarButtonItem = aBarItemBL;
        }else{
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
           

            UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
           UIBarButtonItem *aBarItemTH = [[UIBarButtonItem alloc] initWithTitle:@"  退回  " style:UIBarButtonItemStyleBordered target:self action:@selector(returnBackAction:)];
            
            toolBar.items = [NSArray arrayWithObjects: aBarItemTH,flexItem,aBarItemBL,nil];
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
            self.navigationItem.rightBarButtonItem = rightItem;

        }
       
        
    }
    
    
    NSString *strUrl = nil;
    if (isHandle) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"QUERY_LWBL" forKey:@"service"];
         [params setObject:aItem.strLCBH forKey:@"LCBH"];
         [params setObject:aItem.strLCSLBH forKey:@"LCSLBH"];
         [params setObject:aItem.strBZDYBH forKey:@"BZDYBH"];
         [params setObject:aItem.strBZBH forKey:@"BZBH"];
         [params setObject:aItem.strprocesser forKey:@"processer"];
         [params setObject:aItem.strprocessType forKey:@"processType"];

        strUrl = [ServiceUrlString generateTingUrlByParameters:params];

    }
    else{
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"QUERY_LWBL" forKey:@"service"];
        [params setObject:aItem.strBH forKey:@"LCSLBH"];
        strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        
    }
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];

    self.toDisplayKey = [NSArray arrayWithObjects:@"LWRQ", @"XSBJRQ",@"LWDW",@"LWLX",@"LWWH",@"JJCD",@"LWBT",@"TNBYJ",@"CSYJ",@"TLDPS",
                        @"WJLX",@"BZ",@"DJR",@"DJSJ",@"XGR",@"XGSJ",nil];
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"来文日期：",@"限时办结日期：",@"来文单位：",@"文件类型：",@"来文文号：",@"紧急程度：",@"文件名称：",@"拟办意见：",@"处室意见：",@"厅领导批示：",@"文件流向：",@"备       注：",@"登  记  人：",@"登记时间：",@"修  改  人：",@"修改时间：",nil];  
    bOKFromTransfer = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    if (bOKFromTransfer) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)  headerView.text= @"  来文信息";
    else if (section == 1)  headerView.text= @"  来文附件";
    else if (section == 2)  headerView.text= @"  处理步骤";
    else   headerView.text= @"  处室意见信息";
    
    
    return headerView ;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0)
    {
        if (infoDic) {
            return 11;
        }
        return 0;
    }
    else if (section == 1){
        return [attachmentAry count];
    }
    else if (section == 2)  {
        return [stepAry count];
    }
    else {

        return [chushiOpinionAry count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
    if ( indexPath.section == 3) {
        return 100;
    }
    if(indexPath.section == 2)
        return [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
    else if (indexPath.section == 1 ) {
        return 80;
    }
    else if(indexPath.section == 0){
        if(indexPath.row == 0 ||  indexPath.row == 2 ||
           indexPath.row == 9  || indexPath.row == 10 )
            return 60.0;
        else if(indexPath.row == 1  )//来文有可能很长
            return 70.0;
        //前面3行是4列所以此处＋3
       return [[toDisplayHeightAry objectAtIndex:indexPath.row+3] floatValue];
        
    }
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	

	UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:0];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:1];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:0]];
            if([value1 length]>10)value1 = [value1 substringToIndex:10];
            NSString *value2 = [infoDic objectForKey:[toDisplayKey objectAtIndex:1]];
            if([value2 length]>10)value2 = [value1 substringToIndex:10];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else if( indexPath.row == 1){//LWLX
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:2];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:3];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:2]];
            NSString *lwType = [infoDic objectForKey:[toDisplayKey objectAtIndex:3]];
            NSString *value2 = [SharedInformations getLWLXFromStr:lwType];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:70];
            
        }
        else if( indexPath.row == 2){////JJCD
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:4];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:5];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:4]];
            int num = [[infoDic objectForKey:[toDisplayKey objectAtIndex:5]] intValue];
            NSString *value2 = [SharedInformations getJJCDFromInt:num];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
            
            
        }
        else if( indexPath.row == 9 || indexPath.row == 10){
            int div = 3;
            if(indexPath.row == 10)div = 4;
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:indexPath.row+div];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:indexPath.row+div+1];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+div]];
            NSString *value2 = [infoDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+div+1]];
            
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else{
            NSString *itemValue = nil;
            itemValue = [infoDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+3]];
            if (itemValue== nil) {
                itemValue = @"";
            }
            CGFloat nHeight = [[toDisplayHeightAry objectAtIndex:indexPath.row+3] floatValue];
            
            cell = [UITableViewCell makeSubCell:tableView
                                      withTitle:[toDisplayKeyTitle   objectAtIndex:indexPath.row+3]
                                          value:itemValue
                                      andHeight:nHeight];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

    }
    else if (indexPath.section == 1){
        static NSString *identifier = @"fujiancell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (attachmentAry ==nil||[attachmentAry count] == 0) {
            
            cell.textLabel.text = @"没有相关附件";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else{
            NSDictionary *dicTmp = [attachmentAry   objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ",
                                   [dicTmp objectForKey:@"WDMC"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            if([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame )
                cell.imageView.image = [UIImage imageNamed:@"pdf_file.png"];
            else if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"doc_file.png"];
            else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"xls_file.png"];
            else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"rar_file.png"];
            else
                cell.imageView.image = [UIImage imageNamed:@"default_file.png"];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                         [dicTmp objectForKey:@"WDDX"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else if (indexPath.section == 2)  {

        NSDictionary *dicTmp = [stepAry   objectAtIndex:indexPath.row];
        NSString *title =[NSString stringWithFormat:@"%d %@",
                          indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
        NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
        NSString *value1 =[NSString stringWithFormat:@"批示记录：%@",
                          [dicTmp objectForKey:@"CLRYJ"] ];
        NSString *value3 =[NSString stringWithFormat:@"处理时间：%@",
                           [dicTmp objectForKey:@"JSSJ"]];
        CGFloat height  = [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
        cell = [UITableViewCell makeSubCell:tableView
                                  withTitle:title
                                  SubValue1:value1 
                                  SubValue2:value2
                                  SubValue3:value3
                                  andHeight:height];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;   
    }
    else if (indexPath.section == 3){

        NSDictionary *dicTmp = [chushiOpinionAry   objectAtIndex:indexPath.row];
        NSString *value1 =[NSString stringWithFormat:@"%d. 意见：%@",
                          indexPath.row+1,[dicTmp objectForKey:@"YJ"]];
        NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"TCRMC"] ];
        NSString *title =[NSString stringWithFormat:@"单位／处室：%@",
                           [dicTmp objectForKey:@"ZZJC"] ];
        NSString *value3 =[NSString stringWithFormat:@"处理时间：%@",
                           [dicTmp objectForKey:@"CJSJ"]];
        cell = [UITableViewCell makeSubCell:tableView
                                  withTitle:title
                                  SubValue1:value1 
                                  SubValue2:value2
                                  SubValue3:value3
                                  andHeight:100];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            
    }
 
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;

	return cell;
  
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
        
        if ([attachmentAry count] <= 0) {
            return;
        }
        NSDictionary *dicTmp = [attachmentAry objectAtIndex:indexPath.row];
        
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil ) {
            return;
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:idStr forKey:@"id"];
        [params setObject:appidStr forKey:@"appid"];
        NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];

        
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        
        
        [self.navigationController pushViewController:controller animated:YES];

    }
    
}

@end
