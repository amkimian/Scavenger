//
//  AnswerObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class QuestionObject;

@interface AnswerObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * correct;
@property (nonatomic, retain) NSString * answerCommentary;
@property (nonatomic, retain) NSString * answerTag;
@property (nonatomic, retain) QuestionObject * question;

@end



