//
//  DataManager.h
//  Intervals
//
//  Created by Adam Schor on 6/3/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+(BOOL)saveData: (NSObject *) data forKey: (NSString *) key;
+(id)getDataForKey: (NSString *) key;
+(NSMutableArray *)getArrayForKey: (NSString *) key;


@end
