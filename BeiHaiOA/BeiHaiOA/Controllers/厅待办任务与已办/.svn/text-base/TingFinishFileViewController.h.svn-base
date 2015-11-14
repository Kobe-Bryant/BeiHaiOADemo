//
//  FinishFileViewController.h
//  GuangXiOA
//
//  Created by zhang on 12-12-7.
//
//

#import <UIKit/UIKit.h>
#import "BanLiItem.h"
#import "NSURLConnHelper.h"
#import "HandleGWProtocol.h"
#import "BaseViewController.h"

@interface TingFinishFileViewController : BaseViewController<NSURLConnHelperDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) IBOutlet UITextView *txtView;

@property (nonatomic,strong) BanLiItem *aItem;
@property (nonatomic,strong) IBOutlet UILabel *resultLabel;
@property (nonatomic,assign) id<HandleGWDelegate> delegate;
@property(nonatomic,strong)   NSURLConnHelper *webHelper;


-(IBAction)btnSendOpinion:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil andBanliItem:(BanLiItem*)item;
@end

