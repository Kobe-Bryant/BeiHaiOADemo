//
//  LoginViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *usrField;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UIButton *btnLogin;
@property (nonatomic, strong) UISwitch *pwdSwitchCtrl;

@end


#define KUserName @"KUserName"

@implementation LoginViewController
@synthesize usrField,pwdField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

-(void)addUIViews
{
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg"]];
    bgImgView.frame =  CGRectMake(0, 0, 768, 1004);
    [self.view addSubview:bgImgView];
    
    self.usrField = [[UITextField alloc]  initWithFrame:CGRectMake(280, 354, 190, 40)];
    usrField.borderStyle = UITextBorderStyleNone;
    usrField.font = [UIFont systemFontOfSize:21];
    usrField.delegate = self;
    usrField.autocapitalizationType = UITextAutocapitalizationTypeNone;//设置首字母不自动大写
    usrField.autocorrectionType = UITextAutocorrectionTypeNo;//设置不自动更正
    [self.view addSubview:usrField];
    
    self.pwdField = [[UITextField alloc] initWithFrame:CGRectMake(280, 410, 190, 40)];
    pwdField.borderStyle = UITextBorderStyleNone;
    pwdField.font = [UIFont systemFontOfSize:21];
    pwdField.secureTextEntry = YES;
    [self.view addSubview:pwdField];
    
    self.btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnLogin.reversesTitleShadowWhenHighlighted = YES;
    self.btnLogin.showsTouchWhenHighlighted = YES;
    [self.btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    self.btnLogin.frame = CGRectMake(490, 354, 115, 105);
    [self.view addSubview:self.btnLogin];
    
    UILabel *savePwd = [[UILabel alloc] initWithFrame:CGRectMake(235, 460, 80, 30)];
    savePwd.backgroundColor = [UIColor clearColor];
    savePwd.textColor = [UIColor lightGrayColor];
    savePwd.text = @"记住密码";
    [self.view addSubview:savePwd];
    
    self.pwdSwitchCtrl = [[UISwitch alloc] initWithFrame:CGRectMake(320, 460, 120, 30)];
    self.pwdSwitchCtrl.on = NO;
    [self.view addSubview:self.pwdSwitchCtrl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addUIViews];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *usr = [defaults objectForKey:KUserName];
	if (usr == nil) usr= @"";
	usrField.text = usr;
    
    NSString* savePwd = [defaults objectForKey:KSavePwd];
    if([savePwd isEqualToString:@"1"]){
        NSString *pwd = [defaults objectForKey:KUserPassword];
        if([pwd length] > 0)
            pwdField.text = pwd;
        self.pwdSwitchCtrl.on = YES;
    }else
        self.pwdSwitchCtrl.on = NO;
    
}

-(void)login:(id)sender
{
    
    
    NSString *msg = @"";
    if ([usrField.text isEqualToString:@""] || usrField.text.length <= 0)
    {
        msg = @"用户名不能为空";
    }
    else if([pwdField.text isEqualToString:@""]  || pwdField.text.length <= 0)
    {
        msg = @"密码不能为空";
    }
    if([msg length] > 0)
    {
        [self showAlertMessage:msg];
		return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_INDEX" forKey:@"service"];
    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
    [dicUser setObject:pwdField.text forKey:@"password"];
    [dicUser setObject:usrField.text forKey:@"userId"];
    [[SystemConfigContext sharedInstance] setUser:dicUser];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在登录中..." tagID:0] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
    {
        NSString *msg = @"登录失败";
        [self showAlertMessage:msg];
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    BOOL bFailed = NO;
    id obj = [resultJSON objectFromJSONString];
    if([obj isKindOfClass:[NSDictionary class]])
    {
        [self showAlertMessage:[obj objectForKey:@"MSG"]];
        return;
    }
    else
    {
        NSArray *jsonAry = [resultJSON objectFromJSONString];
        if (jsonAry && [jsonAry count] > 0)
        {
            NSDictionary *dicInfo = [jsonAry objectAtIndex:0];
            int status = [[dicInfo objectForKey:@"status"] intValue];
            if (status == 1)
            {
                NSString *usr = usrField.text;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:usr forKey:KUserName];
                [defaults setObject:pwdField.text forKey:KUserPassword];
                if (self.pwdSwitchCtrl.on)
                    [defaults setObject:@"1" forKey:KSavePwd];
                else
                    [defaults setObject:@"0" forKey:KSavePwd];
                [defaults synchronize];
                if(dicInfo)
                {
                    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
                    [dicUser setObject:pwdField.text forKey:@"password"];
                    [dicUser setObject:usr forKey:@"userId"];
                    [dicUser setObject:[dicInfo objectForKey:@"uname"] forKey:@"uname"];
                    [dicUser setObject:[dicInfo objectForKey:@"depart"] forKey:@"depart"];
                    [dicUser setObject:[dicInfo objectForKey:@"orgid"] forKey:@"orgid"];
                    [[SystemConfigContext sharedInstance] setUser:dicUser];
                }
                //获取待办事项个数
                NSArray *aryDatas = [dicInfo objectForKey:@"datas"];
                NSMutableDictionary *dicBadgeInfo = [NSMutableDictionary dictionaryWithCapacity:5];
                [dicBadgeInfo setObject:@"0" forKey:@"待办任务(局)"];
                if([aryDatas count] > 0)
                {
                    for(NSDictionary *dicItem in aryDatas)
                    {
                        NSString *lx = [dicItem objectForKey:@"LX"];
                        NSString *num = [NSString stringWithFormat:@"%@",[dicItem objectForKey:@"NUM"]];
                        if([lx isEqualToString:@"ALL"])
                        {
                            [dicBadgeInfo setObject:num forKey:@"待办任务(局)"];
                        }
                        else if([lx isEqualToString:@"TZGG"])
                        {
                            [dicBadgeInfo setObject:num forKey:@"通知公告(局)"];
                        }
                    }
                }
                
                //跳转到主菜单界面
                MainMenuViewController *menuController= [[MainMenuViewController alloc] init];
                menuController.dicBadgeInfo = dicBadgeInfo;
                [self.navigationController pushViewController:menuController animated:YES];
            }
            else if(status == -1)
            {
                UILabel *udidLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 600, 468, 120)];
                udidLabel.backgroundColor = [UIColor clearColor];
                udidLabel.textColor = [UIColor redColor];
                udidLabel.font = [UIFont systemFontOfSize:22.0];
                udidLabel.numberOfLines = 0;
                udidLabel.text = [NSString stringWithFormat: @"此设备未与所登录的用户绑定。如需绑定，请联系维护人员并提供以下设备号：\n   %@", [[SystemConfigContext sharedInstance] getDeviceID]];
                [self.view addSubview:udidLabel];
                
                return;
            }
            else if(status == 0 )
            {
                
                NSString *msg = [dicInfo objectForKey:@"description"];
                [self showAlertMessage:msg];
                bFailed = YES;
            }
        }
        else
        {
            bFailed = YES;
        }
        if (bFailed)
        {
            [self showAlertMessage:@"登录失败"];
            return;
        }
    }
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:@"请求数据失败,请检查网络."];
   
    return;
}

-(void)gotoMainMenu{
    MainMenuViewController *menuController = [[MainMenuViewController alloc] init];
    [self.navigationController pushViewController:menuController animated:YES];
}

@end
