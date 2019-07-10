//
//  BSTestTests.m
//  BSTestTests
//
//  Created by Jerry on 19-07-10.
//  Copyright © 2019 Jungle Candy Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Document.h"

@interface BSTestTests : XCTestCase

@end

@implementation BSTestTests {
    BSManagedDocument *_document;
}


#pragma mark - Set up and tear down

- (void)setUp {
    _document = [[Document alloc] init];    // use subclass for automatic migration
}

- (void)tearDown {
#if ! __has_feature(objc_arc)
    [_document release];
#endif
    _document = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


#pragma mark -  Tests

- (void)testAutomaticDocumentMigrationFromVersion1 {
    NSURL *version1URL = [[NSBundle bundleForClass:[self class]] URLForResource:@"version1MRC" withExtension:@"bstest"];

    NSError *error;
    BOOL readingResult = [_document readFromURL:version1URL ofType:@"DocumentType" error:&error];
    /* After migrating from SenTest to XCTest, when testing in macOS 10.15
     Beta 3, the above returns NO and this test fails because a silent
     exception is raised in
     -[BSManagedDocument configurePersistentStoreCoordinatorForURL:ofType:modelConfiguration:storeOptions:error:]_block_invoke
     The name of this exception (p $arg1 at breakoint objc_exception_throw)
     is: "Error validating url for store".

     But I don't see what the problem is.  The storeURL which gets passed to
     -[NSPersistentStoreCoordinator addPersistentStoreWithType:configuration:URL:options:error:]
     is:
     file:///Users/jk/Library/Developer/Xcode/DerivedData/BSTest-dbedkldwcbknmafrpocucyfgqule/Build/Products/Debug/BSTest.app/Contents/PlugIns/BSTestTests.xctest/Contents/Resources/version1MRC.bstest/StoreContent/persistentStore
     Although its path I think is rather odd (…/Plugins/…), that file was
     copied to the product, and it exists, so it should be a "valid URL".  I am
     even able to read this store file with /usr/bin/sqlite3.

     I hope it is just another bug in macOS 10.15 Beta which will be fixed
     before the GM. */

    XCTAssertTrue(readingResult, @"Should be able to read version1 files, error is %@", error);
}

@end
