//
//  ViewController.m
//  TestBlock
//
//  Created by 焦相如 on 6/18/16.
//  Copyright © 2016 jaxer. All rights reserved.
//

#import "ViewController.h"
typedef int (^theBlock)(int, int); //使用 typedef 简化 block

@interface ViewController ()

@end

@implementation ViewController

int global = 20; //定义全局变量

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test1];
//    [self test2];
//    [self test3];
    [self testModify];
    
    __block int x = 2; //这样定义后才能在block内部修改该变量
    void (^printBlock)() = ^{
        x = 19; //OK
        NSLog(@"no number");
    };
    printBlock();
    
    NSLog(@"x = %d", x);
    
//    printNumBlock(33);
    
    //调用 block 作为参数的函数
    int (^myBlock)(int, int) = ^(int x, int y) {
        return x * y;
    };
    [self useBlock:myBlock];

    //简写
    [self useBlock:^(int x, int y){
        return x + y;
    }];
    
    //调用
    [self useBlockTypedef:^(int x, int y){
        return x - y;
    }];
}

void (^printNumBlock)(int) = ^(int num){
    NSLog(@"hello %d", num);
};

/** 声明，赋值，调用 */
- (void)test1
{
    // Block 变量的声明，格式为: 返回值类型(^Block名字)(参数列表); PS: ^被称作"脱字符"
    void (^aBlock)(NSString *a, NSString *b);
//    void (^bBlock)(NSString *, NSString *); //可以不写参数名，只写参数类型
    
    //Block 变量的赋值，格式为: Block变量 = ^(参数列表){函数体};
    aBlock = ^(NSString *a1, NSString *a2){
        NSLog(@"%@ loves %@", a1, a2);
    };
    
    //调用 Block
    aBlock(@"haha", @"hei");
}

/** 声明 block 的同时进行赋值 */
- (void)test2
{
    //eg1
    int (^myBlock)(int) = ^(int num) {
        return num * 10;
    };
    NSLog(@"myBlock-->%d", myBlock(9));
    
    //eg2
    void (^loveBlock)(NSString *, NSString *) = ^(NSString *a, NSString *b) {
        NSLog(@"%@ loves %@", a, b);
    };
    loveBlock(@"Li Lei", @"Han Meimei");
}

/** 使用 typedef 定义 block 类型 */
- (void)test3
{
    typedef void (^sayHello)();
    
    //定义
    sayHello hello = ^{
        NSLog(@"Hello!");
    };
    hello(); //调用
}

/** block 作为 OC 函数的参数(定义一个函数) */
- (void)useBlock:(int (^)(int, int))aBlock
{
    NSLog(@"result ==== %d", aBlock(20, 10));
}

/** 函数参数类型为定义的 block 类型 */
- (void)useBlockTypedef:(theBlock)block
{
    NSLog(@"block-->%d", block(1, 2));
}

/** 声明Block后，调用前修改局部变量，调用时仍是旧值 */
- (void)testModify
{
    __block int local = 100;
    void (^myBlock)() = ^{
//        NSLog(@"local = %d", local);
//        global = 3;
        NSLog(@"global == %d", global);
    };
    local = 200;
    global = 50;
    myBlock();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
