//
//  EditorTouchMask_VC.m
//  aventura
//
//  Created by DonKikochan on 03/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "EditorTouchMask_VC.h"

@interface EditorTouchMask_VC ()

@end

@implementation EditorTouchMask_VC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_Pressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
