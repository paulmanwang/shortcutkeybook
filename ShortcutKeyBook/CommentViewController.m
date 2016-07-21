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

@interface CommentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger softwareId;
@property (copy, nonatomic) NSArray *commentList;
@property (assign, nonatomic) BOOL isLoadingData;

@end

@implementation CommentViewController

- (instancetype)initWithSoftwareId:(NSInteger)softwareId
{
    self = [super init];
    if (self) {
        self.softwareId = softwareId;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"评论";
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
    [[SoftwareManager sharedInstance] queryallCommentsOfSoftware:self.softwareId
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
    AddCommentViewController *vc = [AddCommentViewController initWithSoftwareId:self.softwareId];
    [self presentViewControllerWithNavi:vc animated:YES completion:nil];
}

@end
