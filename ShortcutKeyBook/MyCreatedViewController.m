//
//  MyCreatedViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MyCreatedViewController.h"
#import "SoftwareCell.h"
#import "SoftwareItem.h"
#import "SoftwareManager.h"
#import "LoginManager.h"
#import "ShortcutKeyViewController.h"
#import "EmptyView.h"

@implementation MyCreatedViewController

+ (instancetype)myCreatedViewController
{
    return [[self alloc] initWithNibName:@"BaseViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我创建的快捷键";
    
    NSString *account = [LoginManager sharedInstance].currentUserInfo.username;
    [[SoftwareManager sharedInstance] queryAllMyCreatedSoftwaresWithAccount:account completionHandler:^(NSError *error, NSArray *softwares) {
        if (softwares.count > 0) {
            self.softwares = softwares;
            [self.tableView reloadData];
        } else {
            [EmptyView showOnView:self.view withText:@"您还没有创建过快捷键哦~"];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
