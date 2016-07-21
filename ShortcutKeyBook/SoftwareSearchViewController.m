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

@interface SoftwareSearchViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
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
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = [UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
    self.navigationItem.titleView = self.searchBar;
    
    self.cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.cancelButtonItem;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SoftwareCell" bundle:nil] forCellWithReuseIdentifier:@"SoftwareCell"];
    self.collectionView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.searchBar becomeFirstResponder];
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
    self.collectionView.hidden = NO;
}

@end
