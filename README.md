Dbank SDK Objective-C
=====================
封装了基本的dbank api,第三方开发者可基于它开发网盘应用
* * *

Description
-----------

> 1. basic dbank api(lsdir/movefile/copyfile/rmfile ...)
> 2. It's easy to upload a file to netdisk.
> 3. It's easier to download a file from netdisk.

How to use
----------

*	包含头文件和引用链接库**nspclient.dylib**
<pre><code>
#import "NSPClient.h"
#import "NSPVFS.h"
#import "NSPUser.h"
</code></pre>

*   创建nspclient对象（使用鉴权sid与secret）
<pre><code>
NSPClient *client = [[[NSPClient alloc]
                      initWithSessionID:@"yuusgcYuCJwqkuuHa0NuTiEN5YaFKu6-MNqTllntlEgGYQY3"
                      andSessionSecret:@"132fbd785d6dc2fd1ffd66b8bb5c5eb3"]
                     autorelease];
</code></pre>

*   调用网盘Vfs/User服务
<pre><code>
NSPVFS *vfs = [client  vfsService];
id res;
        
NSArray *fields = [NSArray arrayWithObjects:@"name",@"url",@"size",@"type",nil];
        
res = [vfs listDirectory:NSPNetDiskRoot withFields:fields];
NSLog(@"listDirectory = %@",res);
</code></pre>

*   上传一个文件到dbank
<pre><code>
res = [client uploadFile:@"/Users/DF/a.txt" toPath:NSPNetDiskRoot];
NSLog(@"upload = %@",res);
</code></pre>

*	从网盘下载文件
<pre><code>
BOOL dl = [client downloadFile:[NSPNetDiskRoot stringByAppendingPathComponent:@"a.txt"]
                      intoPath:@"/Users/DF/a.dl.txt"];
NSLog(@"download = %d",dl);
</code></pre>

See Also
--------

具体使用方法参照 [dbank开放平台](http://open.dbank.com)

Weibo Account
-------------

Have a question? [@littley](http://weibo.com/littley)

