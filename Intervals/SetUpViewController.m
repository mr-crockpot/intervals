//
//  SetUpViewController.m
//  Intervals
//
//  Created by Adam Schor on 6/3/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "SetUpViewController.h"


@interface SetUpViewController ()

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    
    for(UIViewController *tab in  self.tabBarController.viewControllers)
        
    {
        [tab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIFont fontWithName:@"Helvetica" size:24.0], NSFontAttributeName, nil]
                                      forState:UIControlStateNormal];
    }
    
    _keyForTimes = @"keyForTimes";
    [self loadData];
    _indexPathTable =[NSIndexPath indexPathForRow:0 inSection:0];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    _btnAdd.enabled = YES;
    _btnAdjust.enabled = YES;
    _btnEdit.enabled = YES;
    
    _btnAdjust.title = @"Adjust";
    _btnEdit.title = @"Edit";
    
    _indexPathTable =[NSIndexPath indexPathForRow:0 inSection:0];
    _adjustable = NO;
    _editable = NO;
    
    [_tblViewTimes setEditing:_editable animated:YES];
    
    _btnAdjust.title = @"Adjust";
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [self saveData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData {
    
    _arrTimes = [[NSMutableArray alloc] initWithArray:[DataManager getDataForKey:_keyForTimes]];
    
}

-(void)saveData {
    [DataManager saveData:_arrTimes forKey:_keyForTimes];
    
}

-(void)toggleEdit{
    _editable = !_editable;
    if (_editable) {
        _btnEdit.title = @"Done";
        _btnAdd.enabled = NO;
        _btnAdjust.enabled = NO;
    }
    else {
        _btnEdit.title = @"Edit";
        _btnAdd.enabled = YES;
        _btnAdjust.enabled = YES;
    }
    
    [_tblViewTimes setEditing:_editable animated:YES];
}

-(void)addTime {
    
    NSInteger repeats = [_pickerViewTimes selectedRowInComponent:0]+1;
    NSInteger time = [_pickerViewTimes selectedRowInComponent:1] + 1;
    NSInteger interval = [_pickerViewTimes selectedRowInComponent:2] + 1;
    
    for (int x = 0; x<repeats; x++) {
        [_arrTimes addObject:@(time)];
        [_arrTimes addObject:@(interval)];
    }
    
    [self saveData];
    [_tblViewTimes reloadData];
    
    _indexPathTable =[NSIndexPath indexPathForRow:_arrTimes.count-1 inSection:0];
    
    [_tblViewTimes selectRowAtIndexPath:_indexPathTable animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}


#pragma mark Table Codes

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrTimes.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@", _arrTimes[indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blueColor];
    
    
    //cell.textLabel.highlightedTextColor = [UIColor yellowColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *backView = [[UIView alloc] init];
    if (_adjustable) {
        backView.backgroundColor = [UIColor yellowColor];
    }
    
    else {
        backView.backgroundColor = [UIColor clearColor];
    }
    [cell setSelectedBackgroundView:backView];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_adjustable) {
        _selectedRow = indexPath.row;
        
        [_pickerViewTimes selectRow:[_arrTimes[_selectedRow] integerValue] -1 inComponent:1 animated:NO];
        _indexPathTable =[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSInteger fromRow = sourceIndexPath.row;
    NSInteger toRow = destinationIndexPath.row;
    
    NSInteger moveValue = [_arrTimes[fromRow] integerValue];
    
    [_arrTimes removeObjectAtIndex:fromRow];
    [_arrTimes insertObject:@(moveValue) atIndex:toRow];
    
    [self saveData];
    
    [_tblViewTimes reloadData];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_arrTimes removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    
    [self saveData];
    [_tblViewTimes reloadData];
}





#pragma mark Picker Codes

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return 10;
            break;
        case 1:
            return 90;
            break;
        case 2:
            return 30;
            break;
        default:
            return 0;
            break;
    }
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    NSString *title;
    
    switch (component) {
        case 0:
            
            break;
            
        default:
            break;
    }
    title = [NSString stringWithFormat:@"%li",row+1];
    
    return title;
}

-(UIView * )pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    NSString *fontName = @"Helvetica";
    float fontSize = 24;
    UILabel *tview = (UILabel *) view;
    tview = [[UILabel alloc] init];
    
    switch (component) {
        case 0:
            tview.textColor = [UIColor blueColor];
            break;
        case 1:
            tview.textColor = [UIColor redColor];
            break;
        case 2:
            tview.textColor = [UIColor greenColor];
            break;
        default:
            break;
    }
    
    tview.font = [UIFont fontWithName:fontName size:fontSize];
    tview.textAlignment = NSTextAlignmentCenter;
    
    tview.text = [NSString stringWithFormat:@"%li",row+1];
    
    return tview;
    
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (_adjustable) {
        
        NSInteger seconds = [_pickerViewTimes selectedRowInComponent:1]+1;
        
        if (component == 1) {
            [_arrTimes replaceObjectAtIndex:_selectedRow withObject:@(seconds)];
            
        }
        [_tblViewTimes selectRowAtIndexPath:_indexPathTable animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        [_tblViewTimes reloadData];
        
        
        [self saveData];
    }
    
    
}



- (IBAction)btnAddPressed:(id)sender {
    
    [self addTime];
}

- (IBAction)btnEditPressed:(id)sender {
    
    [self toggleEdit];
}

- (IBAction)btnAdjustPressed:(id)sender {
    
    _adjustable = !_adjustable;
    if (_adjustable) {
        _btnAdd.enabled = NO;
        _btnEdit.enabled = NO;
        _btnAdjust.title = @"Done";
        _indexPathTable =[NSIndexPath indexPathForRow:0 inSection:0];
        [_tblViewTimes selectRowAtIndexPath:_indexPathTable animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [_tblViewTimes reloadData];
        
    }
    else {
        _btnAdjust.title = @"Adjust";
        _btnEdit.enabled = YES;
        _btnAdd.enabled = YES;
        
        
    }
    
    [_tblViewTimes reloadData];
}
@end

