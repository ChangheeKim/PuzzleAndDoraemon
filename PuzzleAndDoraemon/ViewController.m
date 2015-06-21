//
//  ViewController.m
//  PuzzleAndDoraemon
//
//  Created by 金昌熙 on 2015/06/19.
//  Copyright (c) 2015年 Level8. All rights reserved.
//

#import "ViewController.h"
#import "PDGameBoard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	PDGameBoard *gameBoard = [[PDGameBoard alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - ((self.view.bounds.size.width/6)*5) - 16, self.view.bounds.size.width, (self.view.bounds.size.width/6)*5)];
	[gameBoard initialization];
	
	[self.view addSubview:gameBoard];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
