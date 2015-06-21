//
//  PDGameDrop.m
//  PuzzleAndDoraemon
//
//  Created by 金昌熙 on 2015/06/19.
//  Copyright (c) 2015年 Level8. All rights reserved.
//

#import "PDGameDrop.h"

@implementation PDGameDrop

+(PDGameDrop *)dropWithSize:(CGSize)size{
	
	return [[PDGameDrop alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

-(instancetype)initWithFrame:(CGRect)frame{
	
	self = [super initWithFrame:frame];
	
	if(self){
		
	}
	
	return self;
}

-(int)getRandomAttribute{
	
	int randomNumber = arc4random() % DROP_ATTRIBUTE_COUNT;
	
	[self setAttributeType:randomNumber];
	
	return _attributeType;
}

-(void)setAttributeType:(int)attributeType{
	_attributeType = attributeType;
	
	// Attributeの変換に必要な動作を行う：
	if(_attributeType == DROP_ATTRIBUTE_FIRE){
		[self setImage:[UIImage imageNamed:@"dropIconFire"]];
	}
	else if (_attributeType == DROP_ATTRIBUTE_WATER){
		[self setImage:[UIImage imageNamed:@"dropIconWater"]];
	}
	else if (_attributeType == DROP_ATTRIBUTE_WIND){
		[self setImage:[UIImage imageNamed:@"dropIconTree"]];
	}
	else if (_attributeType == DROP_ATTRIBUTE_LIGHT){
		[self setImage:[UIImage imageNamed:@"dropIconLight"]];
	}
	else if (_attributeType == DROP_ATTRIBUTE_DARK){
		[self setImage:[UIImage imageNamed:@"dropIconDark"]];
	}
	else if (_attributeType == DROP_ATTRIBUTE_HEART){
		[self setImage:[UIImage imageNamed:@"dropIconHeart"]];
	}
	
	return;
}

-(void)setLocation:(CGPoint)location{
	[self setFrame:CGRectMake(location.x, location.y, self.frame.size.width, self.frame.size.height)];
}

-(void)moveWithSpeed:(float)speed{
	
	// 現在座標と目標座標の間の距離を計算：
	CGPoint distance;
	distance.x = _targetLocation.x - self.frame.origin.x;
	distance.y = _targetLocation.y - self.frame.origin.y;
	
	// スピードによる縦横の移動距離を計算：
	float totalDistance = fabs(distance.x) + fabs(distance.y);
	float speedRate = speed/totalDistance;
	CGPoint dividedSpeed;
	dividedSpeed.x = speedRate * distance.x;
	dividedSpeed.y = speedRate * distance.y;
	
	// 実際の移動を行う：
	// 横移動：
	if(distance.x > 0){
		if(self.frame.origin.x + dividedSpeed.x > _targetLocation.x){
			[self setLocation:CGPointMake(_targetLocation.x, self.frame.origin.y)];
		}else{
			[self setLocation:CGPointMake(self.frame.origin.x + dividedSpeed.x, self.frame.origin.y)];
		}
	}else if(distance.x < 0){
		if(self.frame.origin.x + dividedSpeed.x < _targetLocation.x){
			[self setLocation:CGPointMake(_targetLocation.x, self.frame.origin.y)];
		}else{
			[self setLocation:CGPointMake(self.frame.origin.x + dividedSpeed.x, self.frame.origin.y)];
		}
	}
	
	// 縦移動：
	if(distance.y > 0){
		if(self.frame.origin.y + dividedSpeed.y > _targetLocation.y){
			[self setLocation:CGPointMake(self.frame.origin.x, _targetLocation.y)];
		}else{
			[self setLocation:CGPointMake(self.frame.origin.x, self.frame.origin.y + dividedSpeed.y)];
		}
	}else if(distance.y < 0){
		if(self.frame.origin.y + dividedSpeed.y < _targetLocation.y){
			[self setLocation:CGPointMake(self.frame.origin.x, _targetLocation.y)];
		}else{
			[self setLocation:CGPointMake(self.frame.origin.x, self.frame.origin.y + dividedSpeed.y)];
		}
	}
}

@end
