//
//  LaiWenChaXunController.m
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LaiWenChaXunController.h"
#import "PDJsonkit.h"
#import "LaiWenSearchController.h"

@implementation LaiWenChaXunController
@synthesize itemAry,typeAry;

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"来文查询";
    
    self.itemAry = [NSArray arrayWithObjects:@"厅来文", @"厅发文", @"厅通知公告", @"其他单位来文", @"会议", @"电话记录", @"其他", nil];
    self.typeAry = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	//self.navigationItem.hidesBackButton = YES;
	[self.navigationController setNavigationBarHidden:NO animated:YES];	
    
    
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
	return [itemAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 55;
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
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;

        
	}

	cell.textLabel.text = [itemAry objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;

}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LaiWenSearchController *controller = [[LaiWenSearchController alloc] initWithNibName:@"LaiWenSearchController" andType:[typeAry objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end