//
//  SoftwareSearchViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/21.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SoftwareSearchViewController.h"
#import "SoftwareCell.h"
#import "ShortcutKeyViewController.h"
#import "SoftwareManager.h"
#import "EmptyView.h"

@interface SoftwareSearchViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) UIBarButtonItem *cancelButtonItem;

@end

@implementation SoftwareSearchViewController

+ (instancetype)softwareSearchViewController
{
    return [[self alloc] initWithNibName:@"BaseViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    self.cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.cancelButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *aView in self.searchBar.subviews) {
        for (UIView *subView in aView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [subView becomeFirstResponder];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (void)onCancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    NSString *keyword = self.searchBar.text;
    [[SoftwareManager sharedInstance] searchSoftwaresWithKeyword:keyword completionHandler:^(NSError *error, NSArray *softwares) {
        if (softwares.count > 0) {
            [self.emptyView dismiss];
            self.softwares = softwares;
            [self.tableView reloadData];
        } else {
            self.emptyView = [EmptyView showOnView:self.view withText:@"没有搜到符合条件的快捷键哦~"];
        }
    }];
}

@end
