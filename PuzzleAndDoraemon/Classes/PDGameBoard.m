//
//  PDGameBoard.m
//  PuzzleAndDoraemon
//
//  Created by 金昌熙 on 2015/06/19.
//  Copyright (c) 2015年 Level8. All rights reserved.
//

#import "PDGameBoard.h"
#import "PDGameDrop.h"

@implementation PDGameBoard

-(void)initialization{
	
	[self setUserInteractionEnabled:YES];
	
	_bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	[_bgImageView setBackgroundColor:[UIColor blackColor]];
	[self addSubview:_bgImageView];
	
	//=============================
	//
	//	ドロップ・ラインを初期化：
	//
	
	//int numberOfDrops = NUMBER_OF_LINES * NUMBER_OF_DROPS_FOR_EACH_LINE;
	
	float width = self.bounds.size.width / NUMBER_OF_DROPS_FOR_EACH_LINE;
	float height = self.bounds.size.height / NUMBER_OF_LINES;
	
	_lines = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_LINES];
	
	for( int i = 0 ; i < NUMBER_OF_LINES ; i++ ){
		NSMutableArray *line = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_DROPS_FOR_EACH_LINE];
		[_lines addObject:line];
		
		for( int i = 0 ; i < NUMBER_OF_DROPS_FOR_EACH_LINE ; i++ ){
			PDGameDrop *drop = [PDGameDrop dropWithSize:CGSizeMake(width, height)];
			[drop getRandomAttribute];
			[self addSubview:drop];
			[line addObject:drop];
		}
	}
	
	[self refreshTargetLocationOfDrops];
	[self lineUpimmediately];
	
	//
	//	終わり
	//
	//==============================
	
	_pickedDropIndicator = [PDGameDrop dropWithSize:CGSizeMake(width*1.2, height*1.2)];
	[_pickedDropIndicator setAlpha:0.7];
	
	[NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(onTick) userInfo:nil repeats:YES];
}

// ドロップの移動目標地点を更新：
-(void)refreshTargetLocationOfDrops{
	
	float width = self.bounds.size.width / NUMBER_OF_DROPS_FOR_EACH_LINE;
	float height = self.bounds.size.height / NUMBER_OF_LINES;
	
	for(NSMutableArray *line in _lines){
		NSInteger lineNumber = [_lines indexOfObject:line];
		for(PDGameDrop *drop in line){
			NSInteger dropNumber = [line indexOfObject:drop];
			
			float x = width * dropNumber;
			float y = height * lineNumber;
			
			[drop setTargetLocation:CGPointMake(x, y)];
		}
	}
}

// 今すぐ整列：
-(void)lineUpimmediately{
	for(NSMutableArray *line in _lines){
		for(PDGameDrop *drop in line){
			[drop setLocation:drop.targetLocation];
		}
	}
}

// 指定した速度で目標地点へ移動：
-(void)moveDropsToTargetLocationWithSpeed:(float)speed{
	for(NSMutableArray *line in _lines){
		for(PDGameDrop *drop in line){
			if(drop.targetLocation.x != drop.frame.origin.x || drop.targetLocation.y != drop.frame.origin.y){
				[drop moveWithSpeed:speed];
			}
		}
	}
}

-(void)onTick{
	[self moveDropsToTargetLocationWithSpeed:16.0f];
}

-(CGPoint)gridPoint:(CGPoint)point{

	CGPoint gridPoint;
	
	float width = self.bounds.size.width / NUMBER_OF_DROPS_FOR_EACH_LINE;
	float height = self.bounds.size.height / NUMBER_OF_LINES;
	
	for(int y = 0 ; y < NUMBER_OF_LINES ; y++){
		
		float startPointY = y * height;
		float endPointY = startPointY + height;
		
		if(point.y >= startPointY && point.y <= endPointY){
			gridPoint.y = y;
		}
		
		for(int x = 0; x < NUMBER_OF_DROPS_FOR_EACH_LINE ; x++){
			float startPointX = x * width;
			float endPointX = startPointX + width;
			
			if(point.x >= startPointX && point.x <= endPointX){
				gridPoint.x = x;
			}
		}
	}
	
	//NSLog(@"return gridPoint: x:%.f y:%.f", gridPoint.x, gridPoint.y);
	
	return gridPoint;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [touch locationInView:self];
	// ドロップが画面から離れないように：
	if(location.y > self.bounds.size.height) location.y = self.bounds.size.height;
	if(location.y < 0) location.y = 0;
	
	CGPoint gridPoint = [self gridPoint:location];
	
	_prevGridPoint = gridPoint;
	
	[self pickDropWithGridPoint:gridPoint];
	
	[_pickedDropIndicator setCenter:location];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	// ドロップが画面から離れないように：
	if(location.y > self.bounds.size.height) location.y = self.bounds.size.height;
	if(location.y < 0) location.y = 0;
	
	CGPoint gridPoint = [self gridPoint:location];
	
	[_pickedDropIndicator setCenter:location];
	
	if(_prevGridPoint.y != gridPoint.y || _prevGridPoint.x != gridPoint.x){
		[self moveDropOnGridPoint:_prevGridPoint toGridPoint:gridPoint];
		
		[_pickedDrop setCenter:location];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	// ドロップが画面から離れないように：
	if(location.y > self.bounds.size.height) location.y = self.bounds.size.height;
	if(location.y < 0) location.y = 0;
	
	CGPoint gridPoint = [self gridPoint:location];
	
	if(_prevGridPoint.y != gridPoint.y || _prevGridPoint.x != gridPoint.x){
		[self moveDropOnGridPoint:_prevGridPoint toGridPoint:gridPoint];
	}
	
	[_pickedDropIndicator removeFromSuperview];
	[_pickedDrop setAlpha:1.0f];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"Toucheds Cancelled");
}



-(void)moveDropOnGridPoint:(CGPoint)pickedDropPoint toGridPoint:(CGPoint)targetPoint{
	
	CGPoint currentDropPoint = pickedDropPoint;
	
	while(targetPoint.x - currentDropPoint.x > 0){
		currentDropPoint.x += 1;
		[self changeDropOnGridPoint:pickedDropPoint withDropOnGridPoint:currentDropPoint];
		pickedDropPoint = currentDropPoint;
	}
	
	while(targetPoint.x - currentDropPoint.x < 0){
		currentDropPoint.x -= 1;
		[self changeDropOnGridPoint:pickedDropPoint withDropOnGridPoint:currentDropPoint];
		pickedDropPoint = currentDropPoint;
	}
	
	while(targetPoint.y - currentDropPoint.y > 0){
		currentDropPoint.y += 1;
		[self changeDropOnGridPoint:pickedDropPoint withDropOnGridPoint:currentDropPoint];
		pickedDropPoint = currentDropPoint;
	}
	
	while(targetPoint.y - currentDropPoint.y < 0){
		currentDropPoint.y -= 1;
		[self changeDropOnGridPoint:pickedDropPoint withDropOnGridPoint:currentDropPoint];
		pickedDropPoint = currentDropPoint;
	}
	
	_prevGridPoint = targetPoint;
	[self refreshTargetLocationOfDrops];
}

-(void)pickDropWithGridPoint:(CGPoint)point{
	
	_pickedDrop = [self dropOnGridPoint:point];
	[_pickedDrop setAlpha:0.3];
	
	[self addSubview:_pickedDropIndicator];
	[_pickedDropIndicator setAttributeType:_pickedDrop.attributeType];
}

-(void)changeDropOnGridPoint:(CGPoint)pointA withDropOnGridPoint:(CGPoint)pointB{
	PDGameDrop *dropA = [self dropOnGridPoint:pointA];
	PDGameDrop *dropB = [self dropOnGridPoint:pointB];
	
	[[_lines objectAtIndex:pointA.y] replaceObjectAtIndex:pointA.x withObject:dropB];
	[[_lines objectAtIndex:pointB.y] replaceObjectAtIndex:pointB.x withObject:dropA];
	
	return;
}

-(PDGameDrop*)dropOnGridPoint:(CGPoint)point{
	return [[_lines objectAtIndex:point.y] objectAtIndex:point.x];
}

@end