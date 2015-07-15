//
//  ViewController.m
//  Eternal
//
//  Created by Gregg Mojica on 7/15/15.
//  Copyright (c) 2015 Gregg Mojica. All rights reserved.
//

#import "ViewController.h"
#import "GMTray.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMTray *tray = [[GMTray alloc]init];
    tray.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [tray setupStaticArray:@[@"Home",@"About",@"Information",@"Detail",@"Apps", @"Settings"]];
    
    [self addChildViewController:tray];
    [self.view addSubview:tray.view];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"didLaunch"] == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Howdy!" message:@"Swipe left to view the sidebar" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"didLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
