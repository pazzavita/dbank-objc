//
//  NSPUser.m
//  dbank-objc
//
//  Created by 江宇英 on 13-3-27.
//
//

#import "NSPUser.h"

NSString *NSPUserGetInfo = @"nsp.user.getInfo";
NSString *NSPUserUpdate = @"nsp.user.update";

@implementation NSPUser

/**
 * 获取网盘用户信息
 */
- (NSDictionary *)infoWithAttributes:(NSArray *)attrs
{
	NSDictionary *send = [[NSDictionary alloc] initWithObjectsAndKeys:
                          attrs, @"attrs", nil];
	
    id res = [self callService:NSPUserGetInfo withParameters:send];
	
	[send autorelease];
	
	return res;
}

/**
 * 更新网盘用户信息
 */
- (NSNumber *)update:(NSDictionary *)attrs
{
	NSDictionary *send = [[NSDictionary alloc] initWithObjectsAndKeys:
                          attrs, @"attrs", nil];
	
    id res = [self callService:NSPUserUpdate withParameters:send];
	
	[send autorelease];
	
	return res;
}

@end
