//
//  SetUpViewController.h
//  Intervals
//
//  Created by Adam Schor on 6/3/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <uikit/NSIndexPath+UIKitAdditions.h>

#import "DataManager.h"

@interface SetUpViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate, UITableViewDataSource>

@property BOOL editable;
@property BOOL adjustable;


@property (strong, nonatomic) NSString *keyForTimes;
@property (strong,nonatomic) NSMutableArray *arrTimes;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewTimes;
@property (strong, nonatomic) IBOutlet UITableView *tblViewTimes;

@property NSIndexPath *indexPathTable;


@property  NSInteger selectedRow;

- (IBAction)btnAddPressed:(id)sender;
- (IBAction)btnEditPressed:(id)sender;
-(IBAction)btnAdjustPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnAdjust;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEdit;

@end
