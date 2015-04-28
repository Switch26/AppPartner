//
//  TableSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatSectionViewController.h"
#import "MainMenuViewController.h"
#import "ChatCell.h"

@interface ChatSectionViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *loadedChatData;
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
@end

@implementation ChatSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loadedChatData = [[NSMutableArray alloc] init];
    self.offscreenCells = [NSMutableDictionary dictionary];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) { // Use automatic cell resize class for iOS 8
        self.tableView.estimatedRowHeight = 63.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    } else self.tableView.estimatedRowHeight = UITableViewAutomaticDimension; // for iOS 7
    
    // Prevent cells from being selected
    self.tableView.allowsSelection = NO;
    
}

- (void)loadJSONData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chatData" ofType:@"json"];

    NSError *error = nil;

    NSData *rawData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];

    id JSONData = [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingAllowFragments error:&error];

    [self.loadedChatData removeAllObjects];
    if ([JSONData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonDict = (NSDictionary *)JSONData;

        NSArray *loadedArray = [jsonDict objectForKey:@"data"];
        if ([loadedArray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *chatDict in loadedArray)
            {
                ChatData *chatData = [[ChatData alloc] init];
                [chatData loadWithDictionary:chatDict];
                [self.loadedChatData addObject:chatData];
            }
        }
    }

    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadJSONData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatCell";
    ChatCell *cell = nil;

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (ChatCell *)[nib objectAtIndex:0];
    }

    ChatData *chatData = [self.loadedChatData objectAtIndex:[indexPath row]];

    [cell loadWithData:chatData];
    
    return cell;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.loadedChatData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)  //iOS8 part
        {
            return UITableViewAutomaticDimension;
        }
    else // iOS7 part in order to calculate cell row height
        {
            NSString *reuseIdentifier = @"ChatCell";
            
            // Use a dictionary of offscreen cells to get a cell for the reuse identifier, creating a cell and storing
            // it in the dictionary if one hasn't already been added for the reuse identifier.
            ChatCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
            if (!cell) {
                cell = [[ChatCell alloc] init];
                [self.offscreenCells setObject:cell forKey:reuseIdentifier];
            }
            
            // Configure the cell with content for the given indexPath:
            cell = nil;
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil];
                cell = (ChatCell *)[nib objectAtIndex:0];
            }

            ChatData *chatData = [self.loadedChatData objectAtIndex:[indexPath row]];
            [cell loadWithData:chatData];
            
            
            // Set the width of the cell to match the width of the table view. This is important so that we'll get the
            // correct cell height for different table view widths if the cell's height depends on its width
            cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
            
            // Get the actual height required for the cell's contentView
            CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            
            // Add an extra point to the height to account for the cell separator, which is added between the bottom
            // of the cell's contentView and the bottom of the table view cell.
            height += 1.0f;
            
            return height;
        }
}

// Changing status bar color to white
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
