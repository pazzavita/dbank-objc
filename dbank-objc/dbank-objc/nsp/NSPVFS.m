//
//  NSPVFS.m
//  dbank-objc
//
//  Created by 江宇英 on 13-3-27.
//
//

#import "NSPVFS.h"

@implementation NSPVFS

/**
 * 列举子目录
 *
 * 参数      可选    类型                      说明
 * path      可选    string                   文件夹路径
 * fields    可选    string[]                 需要查询的文件属性数组
 * options   可选     map<string, object>     附加选项
 */
- (id)listDirectory:(NSString *)aPath
{
    return [self listDirectory:aPath
                    withFields:[NSArray arrayWithObjects:@"name", @"url", @"size", @"type", nil]];
}

- (id)listDirectory:(NSString *)aPath
         withFields:(NSArray *)fields
{
	NSDictionary *send = [[NSDictionary alloc]
                            initWithObjectsAndKeys:
                            aPath, @"path",
                            fields,@"fields",
                            @{@"type":@(3)}, @"options",
                            nil];
	id res = [super callService:NSPVFSLsDir withParameters:send];
	
	[send autorelease];
	
	return res;
}

/**
 * 复制文件
 *
 * 参数       可选    类型                   说明
 * files     必选    String[]               文件路径数组。该接口支持拷贝文件以及文件夹，文件夹会递归拷贝内容。
 * path      必选    String                 拷贝目标文件夹（文件）路径
 * attribute 可选    map<string, string>    默认为空，复制文件时的可选参数配置，这个以后可不断扩展。
 */
- (id)copyFile:(NSString *)aFilepath
        toPath:(NSString *)aPath
{
    return [self copyFiles:[NSArray arrayWithObject:aFilepath]
                    toPath:aPath
            withAttributes:[[[NSDictionary alloc] init] autorelease]];
}

- (id)copyFile:(NSString *)aFilepath
        toPath:(NSString *)aPath
withAttributes:(NSDictionary *)attributes
{
    return [self copyFiles:[NSArray arrayWithObject:aFilepath]
                    toPath:aPath
            withAttributes:attributes];
}

- (id)copyFiles:(NSArray *)files
         toPath:(NSString *)aPath
{
    return [self copyFiles:files
                    toPath:aPath
            withAttributes:[[[NSDictionary alloc] init] autorelease]];
}

- (id)copyFiles:(NSArray *)files
         toPath:(NSString *)aPath
 withAttributes:(NSDictionary *)attributes
{
	NSDictionary *send = [[NSDictionary alloc]
                            initWithObjectsAndKeys:
                            aPath, @"path",
                            files, @"files",
                            attributes, @"attribute",
                            nil];
	id res = [self callService:NSPVFSCopyFile withParameters:send];
	
	[send autorelease];
	
	return res;
}

/**
 * 移动文件
 *
 * 参数        可选    类型                   说明
 * files      必选    String[]               文件路径数组。该接口支持移动文件以及文件夹，文件夹会递归移动文件夹内容。
 * path       必选    string                 拷贝目标文件夹（文件）路径。
 * attribute  可选    map<string, string>    默认为空。移动文件(夹)时的可选参数配置，这个以后可不断扩展
 */
- (id)moveFileFrom:(NSString *)aFilepath
            toPath:(NSString *)aPath
{
    return [self moveFilesFrom:[NSArray arrayWithObject:aFilepath]
                        toPath:aPath
                withAttributes:[[[NSDictionary alloc] init] autorelease]];
}

- (id)moveFileFrom:(NSString *)aFilepath
            toPath:(NSString *)aPath
    withAttributes:(NSDictionary *)attributes
{
    return [self moveFilesFrom:[NSArray arrayWithObject:aFilepath]
                        toPath:aPath
                withAttributes:attributes];
}

- (id)moveFilesFrom:(NSArray *)files
             toPath:(NSString *)aPath
{
    return [self moveFilesFrom:files
                        toPath:aPath
                withAttributes:[[[NSDictionary alloc] init] autorelease]];
}

- (id)moveFilesFrom:(NSArray *)files
             toPath:(NSString *)aPath
     withAttributes:(NSDictionary *)attributes
{
	NSDictionary *send = [[NSDictionary alloc]
                            initWithObjectsAndKeys:
                            aPath, @"path",
                            files, @"files",
                            attributes, @"attribute",
                            nil];
    id res = [self callService:NSPVFSMoveFile withParameters:send];
	
	[send autorelease];
	
	return res;
}

/**
 * 删除文件
 *
 * 参数       可选     类型                 说明
 * files     必选     string[]            文件路径数组
 * reserve   可选     boolean             删除文件或文件夹时是否保留，默认为false，直接删除文件或文件夹。如果为true的话，将文件或文件夹移动到系统回收站进行暂时保留。
 * attribute 可选     map<string,string>	  对文件删除操作附加一些属性控制。
 */
- (id)deleteFile:(NSString *)aFilepath
{
    return [self deleteFiles:[NSArray arrayWithObject:aFilepath]
                 withReverse:NO
              withAttributes:[[[NSDictionary alloc] init] autorelease]];
}

- (id)deleteFile:(NSString *)aFilepath
     withReverse:(BOOL)reverse
{
    return [self deleteFiles:[NSArray arrayWithObject:aFilepath]
                 withReverse:reverse
              withAttributes:[[[NSDictionary alloc] init] autorelease]];
}

- (id)deleteFile:(NSString *)aFilepath
     withReverse:(BOOL)reverse
  withAttributes:(NSDictionary *)attributes
{
    return [self deleteFiles:[NSArray arrayWithObject:aFilepath]
                 withReverse:reverse
              withAttributes:attributes];
}

- (id)deleteFiles:(NSArray *)files
{
    return [self deleteFiles:files
                 withReverse:NO
              withAttributes:[[[NSDictionary alloc] init] autorelease]];
}

- (id)deleteFiles:(NSArray *)files
      withReverse:(BOOL)reverse
{
    return [self deleteFiles:files
                 withReverse:reverse
              withAttributes:[[[NSDictionary alloc] init] autorelease]];
}

- (id)deleteFiles:(NSArray *)files
      withReverse:(BOOL)reverse
   withAttributes:(NSDictionary *)attributes
{
	NSDictionary *send = [[NSDictionary alloc]
                            initWithObjectsAndKeys:
                            files, @"files",
                            reverse, @"reverse",
                            attributes, @"attribute",
                            nil];
    id res = [self callService:NSPVFSRmFile withParameters:send];
	
	[send autorelease];
	
	return res;
}

/**
 * 创建文件或者目录
 *
 * 参数    可选    类型               说明
 * files  必选    nsp.VFS.File[]    文件对象数组。
 * path   可选    string            父文件夹路径。
 */
- (id)createFile:(NSString *)aFilepath
    atParentPath:(NSString *)aParentPath
{
    return [self createFiles:[NSArray arrayWithObject:aFilepath]
                atParentPath:aParentPath];
}

- (id)createFiles:(NSArray *)files
     atParentPath:(NSString *)aParentPath
{
    return nil;
}

/**
 * 获取用户文件基本属性信息
 *
 * 参数       可选    类型        说明
 * files     必选    string[]    文件路径数组。
 * fields    可选    string[]    要查询的文件属性数组。“type,name”，两个属性，系统会自动返回，可以不用加入到列表中。
 */
- (id)attributesForFile:(NSString *)aFilepath
             withFields:(NSArray *)fields
{
    return [self attributesForFiles:[NSArray arrayWithObject:aFilepath]
                            withFields:fields];
}

- (id)attributesForFiles:(NSArray *)files
              withFields:(NSArray *)fields
{
	NSDictionary *send = [[NSDictionary alloc]
                            initWithObjectsAndKeys:
                            files, @"files",
                            fields, @"fields",
                            nil];
	id res = [super callService:NSPVFSGetAttr withParameters:send];
	
	[send autorelease];
	
	return res;
}

@end
