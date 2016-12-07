//
//  Data.m
//  SideMEnuDemo
//
//  Created by Narendra on 29/11/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "Data.h"

@implementation Data

// Init the object with information from a dictionary
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        _iD = [jsonDictionary objectForKey:@"id"];
        _ticket_number = [jsonDictionary objectForKey:@"ticket_number"];
        _title= [jsonDictionary objectForKey:@"title"];
        _first_name = [jsonDictionary objectForKey:@"first_name"];
        _last_name = [jsonDictionary objectForKey:@"last_name"];
        _email = [jsonDictionary objectForKey:@"email"];
        _profile_pic = [jsonDictionary objectForKey:@"profile_pic"];
        _created_at = [jsonDictionary objectForKey:@"created_at"];
    }
    
    return self;
}

@end
