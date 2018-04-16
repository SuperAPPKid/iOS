//
//  ViewController.m
//  talkView
//
//  Created by user37 on 2018/1/22.
//  Copyright © 2018年 user37. All rights reserved.
//

#import "ViewController.h"
#import "MytextTableViewCell.h"
@interface ViewController () <UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic) NSMutableArray <NSString*> *messages;
@end

@implementation ViewController
CGSize keyboardSize;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [NSMutableArray array];
    [self.messages addObjectsFromArray:@[@"aaaa",@"bbbb",@"cccc",@"dddd",@"eeee",@"ffff",@"gggg",@"hhhh",@"IIII",@"JJJJ",@"KKKK",@"???????????????????????????????????????????????????????????????????????????"]];
    //table
    self.tableView.dataSource = self;
    self.tableView.layer.borderWidth = 10;
    //textField
    self.textField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self     selector:@selector(keyboardWiillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self      selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self     selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(tapScreen:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction)tapScreen:(UITapGestureRecognizer *)sender {
    if([self.textField isFirstResponder]) {
        [self.textField  resignFirstResponder];
    }
}

- (IBAction)sendBtn:(id)sender {
    if (![self.textField.text isEqualToString:@""]) {
        [self.messages addObject:self.textField.text];
        self.textField.text = @"";
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)keyboardWiillShow:(NSNotification*)aNotification{
    NSLog(@"keyboardWillShow");
    NSDictionary* info = [aNotification userInfo];
    keyboardSize =[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size ;
    CGRect frame = self.view.frame;
    frame.origin.y -= keyboardSize.height;
    self.topConstraint.constant = keyboardSize.height + 30;
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self.view setFrame:frame];
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}
-(void)keyboardWillHide:(NSNotification*)aNotification{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.topConstraint.constant = 30;//我是看原本storyboard中設30，所以我這裏設30
    [self.view setFrame:frame];
}
-(void)keyboardDidHide:(NSNotification*)aNotification{
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MytextTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"textViewCellMe" forIndexPath:indexPath];
    cell.myMessage.text = self.messages[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
