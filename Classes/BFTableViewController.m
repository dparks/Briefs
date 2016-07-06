//
//  BFTableViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/15/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFTableViewController.h"
#import "BFCellController.h"


//  Adapted from code seen on http://cocoawithlove.com/2008/12/heterogeneous-cells-in.html
//
//  Originally created by Matt Gallagher on 27/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

@implementation BFTableViewController

@synthesize tableGroups, tableView;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Data Management

- (void)constructTableGroups
{
    self.tableGroups = [NSArray arrayWithObject:[NSArray array]];
}

- (void)clearTableGroups
{
    self.tableGroups = nil;
}

- (void)updateAndReload
{
    [self clearTableGroups];
    [self constructTableGroups];
    [self.tableView reloadData];
}



///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    if (!self.tableGroups)
        [self constructTableGroups];

    return [self.tableGroups count];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    if (!self.tableGroups)
        [self constructTableGroups];
    return [[self.tableGroups objectAtIndex:section] count];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Selection and moving

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableGroups) {
        [self constructTableGroups];
    }
    return [[[self.tableGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] tableView:(UITableView *)tv cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableGroups)  {
        [self constructTableGroups];
    }

    NSObject<BFCellController> *cellData = [[self.tableGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([cellData respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
        [cellData tableView:tv didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableGroups)  {
        [self constructTableGroups];
    }

    NSObject<BFCellController> *cellData = [[self.tableGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([cellData respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
        return [cellData tableView:tv heightForRowAtIndexPath:indexPath];
    }
    else return 45.0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableGroups)  {
        [self constructTableGroups];
    }

    NSObject<BFCellController> *cellData = [[self.tableGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([cellData respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]){
        return [cellData tableView:tv editingStyleForRowAtIndexPath:indexPath];
    }
    else return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableGroups) {
        [self constructTableGroups];
    }

    NSObject<BFCellController> *cellData = [[self.tableGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([cellData respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]){
        [cellData tableView:tv commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];

        // Update the array and table view.
        [self constructTableGroups];
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableGroups) {
        [self constructTableGroups];
    }

    NSObject<BFCellController> *cellData = [[self.tableGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([cellData respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]){
        [cellData tableView:tv accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self clearTableGroups];
}

- (void)dealloc
{
    [self clearTableGroups];
    [self.tableView release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////

@end


