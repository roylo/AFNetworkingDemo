//
//  I2WViewController.m
//  NetworkDemo
//
//  Created by 羅建凱 on 2014/9/22.
//  Copyright (c) 2014年 intowow. All rights reserved.
//

#import "I2WViewController.h"
#import "NetworkLib.h"

@interface I2WViewController () 

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSMutableDictionary *opDict;
@property (strong, nonatomic) NSMutableArray *taskArr;
@end

@implementation I2WViewController
{
    NetworkLib *nl;
}

- (IBAction)downloadOpt:(UIButton *)sender
{
    NSString *text = sender.currentTitle;
    NSLog(@"%@", text);
    
    AFDownloadRequestOperation *currentOp = [_opDict objectForKey:[_urlTextField text]];
    
    if ([text isEqualToString:@"Pause"] == YES) {
        [nl pauseDownload:currentOp];
    } else if ([text isEqualToString:@"Resume"] == YES) {
        [nl resumeDownload:currentOp];
    } else if ([text isEqualToString:@"Stop"] == YES) {
        [nl cancelDownload:currentOp];
    }
}
- (IBAction)textFieldResign:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)startDownload:(UIButton *)sender
{
    AFDownloadRequestOperation *op = [nl startDownloadWithURL:[_urlTextField text] ToFile:[_fileNameTextField text] withSuccess:^(id responseObject) {
        NSLog(@"Download Successfully!");
    } failure:^(NSError *error) {
        NSLog(@"Download failed with error: %@", error);
    } progress:^(AFDownloadRequestOperation *currentOp, float percent) {
        NSDictionary *opInfo = [currentOp userInfo];
        [_textView setText:[NSString stringWithFormat:@"%@ : %f", [opInfo objectForKey:@"name"], percent]];
    }];
    
    [_opDict setObject:op forKey:[_urlTextField text]];
    [_taskArr addObject:[_urlTextField text]];
    NSLog(@"%@", _opDict);
    [_urlTextField resignFirstResponder];
}

- (IBAction)downloadTest:(id)sender
{
    NSLog(@"%@", [NSString stringWithFormat:@"Download test start"]);
    [nl testDownloadStart];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (!nl) {
        nl = [[NetworkLib alloc]init];
    }
    if (!_opDict) {
        _opDict = [[NSMutableDictionary alloc] init];
    }
    if (!_taskArr) {
        _taskArr = [[NSMutableArray alloc] init];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_taskArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [_taskArr objectAtIndex:indexPath.row];
    return cell;
}

@end
