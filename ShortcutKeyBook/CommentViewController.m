//
//  CommentViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/24.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "SoftwareManager.h"
#import "AddCommentViewController.h"
#import "LoginViewController.h"

@interface CommentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SoftwareItem *softwareItem;
@property (copy, nonatomic) NSArray *commentList;
@property (assign, nonatomic) BOOL isLoadingData;

@end

@implementation CommentViewController

- (instancetype)initWithSoftwareItem:(SoftwareItem *)item;
{
    self = [super init];
    if (self) {
        self.softwareItem = item;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"评论";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
    
    [self queryComments];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryComments];
}

- (void)queryComments
{
    if (self.isLoadingData) {
        return;
    }
    
    self.isLoadingData = YES;
    [[SoftwareManager sharedInstance] queryallCommentsOfSoftware:self.softwareItem.softwareId
                                               completionHandler:^(NSError *error, NSArray *comments) {
                                                   self.isLoadingData = NO;
                                                   if (!error) {
                                                       self.commentList = comments;
                                                       [self.tableView reloadData];
                                                   }
                                               }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    CommentItem *item = self.commentList[indexPath.row];
    [cell fillData:item];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentItem *item = self.commentList[indexPath.row];
    return [CommentTableViewCell cellHeightWithContent:item.content];
}

#pragma mark - Button actions

- (IBAction)onAddCommentBtnClicked:(id)sender
{
    if (![LoginManager sharedInstance].logged) {
        LoginViewController *loginViewController = [LoginViewController new];
        [self presentViewControllerWithNavi:loginViewController animated:YES completion:nil];
        return;
    }
    
    AddCommentViewController *vc = [AddCommentViewController initWithSoftwareItem:self.softwareItem];
    [self presentViewControllerWithNavi:vc animated:YES completion:nil];
}

@end
