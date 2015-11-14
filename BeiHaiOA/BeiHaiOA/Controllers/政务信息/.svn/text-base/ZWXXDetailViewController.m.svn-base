//
//  ZWXXDetailViewController.m
//  GuangXiOA
//
//  Created by zhang on 12-9-18.
//
//

#import "ZWXXDetailViewController.h"
#import "PDJSONKit.h"
#import "DisplayAttachFileController.h"
#import "UITableViewCell+Custom.h"
#import "NSStringUtil.h"
#import "FileUtil.h"
#import "ServiceUrlString.h"

@interface ZWXXDetailViewController ()
@property(nonatomic,strong) NSArray *aryAttachFiles;
@property(nonatomic,strong) NSDictionary *dataInfo;
@end

@implementation ZWXXDetailViewController
@synthesize myWebView,myTableView,q_XH;
@synthesize dataInfo,aryAttachFiles;

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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_ZWXX_CONTENT" forKey:@"service"];
    [params setObject:q_XH forKey:@"q_XH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Network Handler Method

-(void)processWebData:(NSData*)webData
{
    NSString *resultJSON =[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSArray *valueAry = [resultJSON objectFromJSONString] ;
    NSDictionary *resultDic = [valueAry objectAtIndex:0];
    if (resultDic)
    {
        NSArray *aryTmp = [resultDic objectForKey:@"dataInfos"];
        if(aryTmp && [aryTmp count] > 0)
        {
            self.dataInfo = [aryTmp objectAtIndex:0];
        }
        if (self.dataInfo)
        {
            NSString *content = [self.dataInfo objectForKey:@"NR"];
            if(content == nil || content.length == 0)
                content = @"暂无信息内容";
            NSMutableString *strNR = [NSMutableString stringWithString:content];
            [strNR replaceOccurrencesOfString:@"\r\n" withString:@"</br></p><p>" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length]) ];
            NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"zwxx" ofType:@"html"];
            NSMutableString *html = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            [html appendFormat:@"<span style=\"float:right;\">%@</span> </div><div style=\"border-top:4px solid #FF0000;border-bottom:1px solid #FF0000; height:10px; overflow:hidden;width: 100%%; margin:0px 0px; margin-bottom:16px;\"></div>",[self.dataInfo objectForKey:@"CJSJ"]];
            [html appendFormat:@"</br><h2>%@</h2>",[self.dataInfo objectForKey:@"BT"]];
            [html appendFormat:@"<div class=\"content\"><p>%@</p></div>",strNR];
            [html appendFormat:@"<div class=\"redline\"></div><div class=\"titbottom\">来源：%@   作者：%@</div></div></body></html>",[self.dataInfo objectForKey:@"BSDW"],[dataInfo objectForKey:@"BSR"]];
            [self.myWebView loadHTMLString:html baseURL:nil];
        }
        self.aryAttachFiles = [resultDic objectForKey:@"wjxx"];
        [self.myTableView reloadData];
    }
    if(resultDic ==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请求数据失败,请检查网络连接并重试。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

-(void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败,请检查网络连接并重试。"
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//没有附件
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        if(self.aryAttachFiles == nil)
        {
            return 0;
        }
        else if ([self.aryAttachFiles count] > 0)
        {
            return [self.aryAttachFiles count];
        }
        else
        {
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0f;
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
    if (section == 0)
        headerView.text = @"相关信息";
    else 
        headerView.text = @"相关附件";
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(indexPath.section == 0)
    {
        NSString *title1 = @"";
        NSString *title2 = @"";
        NSString *value1 = @"";
        NSString *value2 = @"";
        if (indexPath.row == 0)
        {
            title1 = @"报送单位：";
            title2 = @"报送人：";
            value1 = [self.dataInfo objectForKey:@"BSDW"];
            value2 = [self.dataInfo objectForKey:@"BSR"];
        }
        else
        {
            title1 = @"报送时间：";
            title2 = @"信息类别：";
            value1 = [self.dataInfo objectForKey:@"CJSJ"];
            value2 = [self.dataInfo objectForKey:@"XXLB"];
        }
        cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        static NSString *identifier = @"cellLaiwenDetail";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (self.aryAttachFiles ==nil||[self.aryAttachFiles count] == 0)
        {
            cell.textLabel.text = @"暂无附件信息";
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
            bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
            cell.selectedBackgroundView = bgview;
        }
        else
        {
            NSDictionary *dicTmp = [self.aryAttachFiles objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [dicTmp objectForKey:@"WDDX"];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if ([self.aryAttachFiles count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [self.aryAttachFiles objectAtIndex:indexPath.row];
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil)
        {
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:idStr forKey:@"id"];
        [params setObject:appidStr forKey:@"appid"];
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UIWebView Delegate Method

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'"];
}


@end
