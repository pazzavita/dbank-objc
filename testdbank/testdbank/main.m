//
//  main.m
//  test
//
//  Created by Ciaos on 12-7-30.
//  Copyright (c) 2012年 Ciaos House. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSPClient.h"
#import "NSPVFS.h"
#import "NSPUser.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        /* 初始化nspclient对象 */
        NSPClient *client = [[[NSPClient alloc]
                              initWithSessionID:@"yuusgcYuCJwqkuuHa0NuTiEN5YaFKu6-MNqTllntlEgGYQY3"
                              andSessionSecret:@"132fbd785d6dc2fd1ffd66b8bb5c5eb3"]
                             autorelease];
        
        /* 调用Vfs服务显示文件目录 */
        NSPVFS *vfs = [client  vfsService];
        id res;
        
        NSArray *fields = [NSArray arrayWithObjects:@"name",@"url",@"size",@"type",nil];
        
        res = [vfs listDirectory:NSPNetDiskRoot withFields:fields];
        NSLog(@"listDirectory = %@",res);
        
        /* 上传文件到Dbank */
        res = [client uploadFile:@"/Users/DF/a.txt" toPath:NSPNetDiskRoot];
        NSLog(@"upload = %@",res);
        
        /* 从Dbank下载文件到本地磁盘 */
        BOOL dl = [client downloadFile:[NSPNetDiskRoot stringByAppendingPathComponent:@"a.txt"]
                              intoPath:@"/Users/DF/a.dl.txt"];
        NSLog(@"download = %d",dl);
    }
    return 0;
}

