//
//  XMLDigesterSetNextPropertyRule.m
//  BookReader
//
//  Created by mythlink on 10-12-21.
//  Copyright 2010 mythlink. All rights reserved.
//

#import "XMLDigester.h"
#import "XMLDigesterSetNextPropertyRule.h"


@implementation XMLDigesterSetNextPropertyRule

+ (id) setNextPropertyRuleWithDigester: (XMLDigester*) digester 
{
    return [[[self alloc] initWithDigester: digester] autorelease];
}

- (void) didEndElement: (NSString*) element
{
    id child = [[self digester] peekObjectAtIndex: 0];
    id parent = [[self digester] peekObjectAtIndex: 1];
    if (child != nil && parent != nil) {
        [parent setValue:child forKey: element];
    }
}
@end
