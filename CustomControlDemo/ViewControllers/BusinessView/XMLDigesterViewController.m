//
//  XMLDigesterViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-26.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "XMLDigesterViewController.h"
#import "XMLDigester.h"
#import "XMLDigesterSetPropertyRule.h"
#import "Metadata.h"

@interface XMLDigesterViewController ()

@end

@implementation XMLDigesterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"sample.xml" ofType:nil];	  
    NSData* xml = [NSData dataWithContentsOfFile:path];
    
    XMLDigester* digester = [XMLDigester digesterWithData:xml];
    [digester addObjectCreateRuleWithClass:[Metadata class] forPattern:@"xml"];  // xpath 
    
    NSString* metedataRoot = @"xml/metadata/";
    NSArray* properties = [NSArray arrayWithObjects:@"title", @"language", @"publisher", @"creator", nil];
    
    for (NSString* str in properties) {
        [digester addRule: [XMLDigesterSetPropertyRule setPropertyRuleWithDigester:digester name:nil] 
               forPattern: [metedataRoot stringByAppendingString:str]];        
    } 
    
    Metadata*  data = [digester digest];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    lblTitle.text = [NSString stringWithFormat:@"Title:%@",data.title];
    [self.view addSubview:lblTitle];
    [lblTitle release];
    
    UILabel *lblLanguage = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
    lblLanguage.text = [NSString stringWithFormat:@"Language:%@",data.language];
    [self.view addSubview:lblLanguage];
    [lblLanguage release];
    
    UILabel *lblPublisher = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 300, 30)];
    lblPublisher.text = [NSString stringWithFormat:@"Publisher:%@",data.publisher];
    [self.view addSubview:lblPublisher];
    [lblPublisher release];
    
    UILabel *lblCreator = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 300, 30)];
    lblCreator.text = [NSString stringWithFormat:@"Creator:%@",data.creator];
    [self.view addSubview:lblCreator];
    [lblCreator release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
