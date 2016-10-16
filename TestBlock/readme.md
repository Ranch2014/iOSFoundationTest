# iOS代码块Block

## 概述

代码块 Block 是苹果在 iOS4 开始引入的对C语言的扩展，用来实现匿名函数的特性。

Block 是一种特殊的数据类型，它可以定义变量、作为参数、作为返回值。特殊地，Block 还可以保存一段代码，在需要的时候调用。目前Block已经广泛应用于iOS开发中，常用于GCD、动画、排序及各类回调。

Block 的特点：

- 在类中，定义一个 Block 变量，就像定义一个函数；
- Block 可以定义在方法内部，也可以定义在方法外部；
- 只有在调用 Block 的时候，才会执行其内部的代码。

## 声明和赋值

- 声明

Block 声明的格式为：

```objective-c
返回值类型 (^Block名字)(参数列表)
```

例如：

```objective-c
//声明一个无返回值、含两个NSString类型的参数，名为 aBlock 的 Block
void (^aBlock)(NSString *a, NSString *b);

//还可以不写参数名，只写参数类型。即：
void (^aBlock)(NSString *, NSString *);
```

- 赋值及调用

Block 赋值的格式为：

```
Block 变量 = ^(参数列表){函数体};
```

例如：

```objective-c
//赋值
aBlock = ^(NSString *a1, NSString *a2){
	NSLog(@"%@ loves %@", a1, a2);
};

//调用
aBlock(@"Li Lei", @"Han Meimei"); //调用后输出 "Li Lei loves Han Meimei"
```

> 注：Block 变量的赋值格式可以是： `Block 变量 = ^返回值类型(参数列表){函数体};`。
>
> 通常将返回值类型省略，因为编译器可以从存储代码块的变量中确定返回值的类型。

- 声明的同时进行赋值

例如：

```objective-c
//返回值类型为int，参数类型为int，名为myBlock
int (^myBlock)(int) = ^(int num) {
	return num * 10;
};

//调用代码
NSLog(@"result = %d", myBlock(5)); //输出：result = 50

//若没有参数列表，赋值时可以省略
void (^aVoidBlock)() = ^{
	NSLog(@"This is a void block");
};
```

- 使用 typedef 定义 Block

若要经常用到某种类型的 Block，则可以使用 typedef 来定义。例如：

```objective-c
//定义
typedef void (^sayHello)();
    
//可以像OC中声明变量一样使用Block类型sayHello来声明变量
sayHello hello = ^{
	NSLog(@"Hello!");
};

//调用
hello();
```

## Block 内访问局部变量

- Block 中可以访问局部变量

```objective-c
//声明局部变量 local
int local = 100;

//在 Block 中访问 local
void (^myBlock)() = ^{
	NSLog(@"global = %d", local);
};

//调用后输出：local = 100
myBlock(); 
```

- 在声明Block之后、调用Block之前对局部变量进行修改，在调用Block时局部变量的值是修改之前的旧值。

示例代码：

```objective-c
- (void)testModify
{
    int local = 100;
    void (^myBlock)() = ^{
        NSLog(@"local = %d", local);
    };
    local = 101;
  
    myBlock(); //输出"local = 100"
}
```

若添加 `__block` 关键字，则访问到的是修改后的新值，示例代码：

```objective-c
- (void)testModify
{
    __block int local = 100; //用 __block 修饰
    void (^myBlock)() = ^{
        NSLog(@"local = %d", local);
    };
    local = 200;
  
    myBlock(); //输出"global = 200"
}
```

- 修改局部变量

在 Block 的代码段中，不能修改外面的变量。例如：

```objective-c
- (void)viewDidLoad
{
	int x = 100;
  	void (^aBlock)() = ^{
		x = 20; //这样写是错误的
  	};
}
```

这样写 Xcode 会提示错误信息：`Variable is not assigning (missing __block type specifier)`。

此时给 `int x = 100` 语句前面加 `__block` 关键字即可。如下：

```objective-c
__block int x = 100;
```

这样在 Block 内部的代码段中就可以修改外部变量了。

## Block 内访问全局变量

- Block 中可以访问局部变量
- 在声明Block之后、调用Block之前对全局变量进行修改，在调用Block时全局变量的值是修改之前的新值。

示例代码：

```objective-c
int global = 100;
- (void)testModify
{
    void (^myBlock)() = ^{
        NSLog(@"global = %d", global);
    };
    global = 200;
  
    myBlock(); //输出"global = 200"
}
```

- 修改全局变量

Block 中可以直接修改全局变量。示例代码：

```objective-c
int x = 100; //全局变量
- (void)viewDidLoad
{
  	void (^aBlock)() = ^{
		x = 20; //这样写是OK的
  	};
}
```

## Block 作为函数的参数

- 作为 OC 函数的参数

例如：

```objective-c
//定义一个形参为Block的OC函数
- (void)useBlock:(int (^)(int, int))aBlock
{
    NSLog(@"result = %d", aBlock(20, 10));
}

//声明并赋值定义一个Block变量
int (^myBlock)(int, int) = ^(int x, int y) {
	return x * y;
};
[self useBlock:myBlock]; //把myBlock作为参数，传递给useBlock方法

//也可以这样简写(类似普通函数直接使用一个变量)
[self useBlock:^(int x, int y){
	return x + y;
}];
```





主要参考：

http://www.jianshu.com/p/14efa33b3562

https://my.oschina.net/leejan97/blog/268536