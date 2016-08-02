//
//  BaseViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "BaseViewController.h"
#import "SoftwareCell.h"
#import "ShortcutKeyViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView dequeueReusableCellWithIdentifier:@"kSoftwareCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.softwares.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareItem *item = self.softwares[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSoftwareCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.text = item.softwareName;
    cell.textLabel.textColor = kAppTextColor;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareItem *item = self.softwares[indexPath.row];
    ShortcutKeyViewController *vc = [[ShortcutKeyViewController alloc] initWithSoftwareItem:item];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
