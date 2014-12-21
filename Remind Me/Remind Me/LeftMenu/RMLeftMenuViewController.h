//
//  CBLeftMenuViewController
//  Chase
//
//  Created by Shashidhar Shenoy on 11/11/14.
//  Copyright (c) 2014 NeurLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface RMLeftMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mMenuTableView;
@end
