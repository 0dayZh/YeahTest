//
//  ViewController.h
//  YeahTest
//
//  Created by Yeah on 15/7/21.
//  Copyright © 2015年 Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIScrollView+EmptyDataSet.h>
#import <SVProgressHUD.h>

@interface ViewController : UIViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

