//
//  ViewController.m
//  YeahTest
//
//  Created by Yeah on 15/7/21.
//  Copyright © 2015年 Yeah. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (copy,nonatomic) NSDictionary *avatar;
@property (copy,nonatomic) NSDictionary *name;
@property (copy,nonatomic) NSDictionary *email;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DZNEmptyDataSetSource Methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Octocat"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor blueColor]};
    
    return [[NSAttributedString alloc] initWithString:@"GO" attributes:attributes];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:10.0]};
    
    return [[NSAttributedString alloc] initWithString:@"Press the GO button to get my information." attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        
        NSError *error;
        
        NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/Hs-Yeah"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        _avatar = [resultDic objectForKey:@"avatar_url"];
        _name   = [resultDic objectForKey:@"name"];
        _email  = [resultDic objectForKey:@"email"];
//        NSLog(@"avatar_url = %@\n", _avatar);
//        NSLog(@"name = %@\n", _name);
//        NSLog(@"email = %@\n", _email);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.emptyDataSetSource = nil;
            self.tableView.emptyDataSetDelegate = nil;
            
            self.tableView.dataSource = self;
            self.tableView.delegate   = self;
            
            [SVProgressHUD dismiss];
        });
    });
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *avatarID = @"Avatar";
    static NSString *nameID  = @"Name";
    static NSString *emailID = @"Email";
    
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:avatarID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:avatarID];
            }
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width - 200) / 2, 0, 200, 200)];
            imageView.image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _avatar]]]];
            [cell.contentView addSubview:imageView];
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:nameID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nameID];
            }
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _name];
            break;
        }
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:emailID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:emailID];
            }
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _email];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 210;
    }
    return tableView.rowHeight;
}

@end
