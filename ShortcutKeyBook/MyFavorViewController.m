//
//  MyFavorViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MyFavorViewController.h"
#import "SoftwareManager.h"
#import "SoftwareCell.h"
#import "ShortcutKeyViewController.h"
#import "EmptyView.h"


@implementation MyFavorViewController

+ (instancetype)myFavorViewController
{
    return [[self alloc] initWithNibName:@"BaseViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我收藏的快捷键";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.softwares = [[SoftwareManager sharedInstance] loadMyFavorSoftwares];
    [self performSelector:@selector(showEmptyView) withObject:nil afterDelay:0];
}

- (void)showEmptyView
{
    if (self.softwares.count == 0) {
        [EmptyView showOnView:self.view withText:@"您还没有收藏快捷键哦~"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
