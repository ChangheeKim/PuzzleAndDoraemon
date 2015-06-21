//
//  PDGameDrop.h
//  PuzzleAndDoraemon
//
//  Created by 金昌熙 on 2015/06/19.
//  Copyright (c) 2015年 Level8. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DROP_ATTRIBUTE_COUNT 6
#define DROP_ATTRIBUTE_FIRE 0
#define DROP_ATTRIBUTE_WATER 1
#define DROP_ATTRIBUTE_WIND 2
#define DROP_ATTRIBUTE_LIGHT 3
#define DROP_ATTRIBUTE_DARK 4
#define DROP_ATTRIBUTE_HEART 5

@interface PDGameDrop : UIImageView

@property (nonatomic) int attributeType;
@property CGPoint targetLocation;
-(void)setLocation:(CGPoint)location;


-(void)moveWithSpeed:(float)speed;

+(PDGameDrop*)dropWithSize:(CGSize)size;
-(int)getRandomAttribute;

@end
