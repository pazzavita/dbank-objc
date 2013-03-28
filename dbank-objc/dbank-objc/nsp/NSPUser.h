//
//  NSPUser.h
//  dbank-objc
//
//  Created by 江宇英 on 13-3-27.
//
//

#import "NSPClient.h"

@interface NSPUser : NSPClient

/**
 * 获取网盘用户信息
 */
- (NSDictionary *)infoWithAttributes:(NSArray *)attrs;

/**
 * 更新网盘用户信息
 */
- (NSNumber *)update:(NSDictionary *)attrs;

@end
