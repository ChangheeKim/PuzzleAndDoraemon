//
//  PDGameBoard.h
//  PuzzleAndDoraemon
//
//  Created by 金昌熙 on 2015/06/19.
//  Copyright (c) 2015年 Level8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDGameDrop.h"

#define NUMBER_OF_LINES 5
#define NUMBER_OF_DROPS_FOR_EACH_LINE 6

@interface PDGameBoard : UIView

@property UIImageView *bgImageView;
@property NSMutableArray *lines;

@property PDGameDrop *pickedDropIndicator;
@property PDGameDrop *pickedDrop;
@property CGPoint prevGridPoint;


-(void)initialization;

@end
