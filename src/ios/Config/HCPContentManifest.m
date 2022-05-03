//
//  HCPContentManifest.m
//
//  Created by Nikolay Demyankov on 10.08.15.
//

#import "HCPContentManifest.h"
#import "HCPManifestFile.h"

@interface HCPContentManifest()

@property (nonatomic, readwrite, strong) NSArray *files;

@end

@implementation HCPContentManifest

#pragma mark Public API

- (HCPManifestDiff *)calculateDifference:(HCPContentManifest *)comparedManifest {
    NSMutableArray *addedFiles = [[NSMutableArray alloc] init];
    NSMutableArray *changedFiles = [[NSMutableArray alloc] init];
    NSMutableArray *deletedFiles = [[NSMutableArray alloc] init];
    
    NSMutableDictionary * filesMap = [[NSMutableDictionary alloc ] init];
    
    for (HCPManifestFile *oldFile in self.files) {
        [filesMap setValue:oldFile forKey:oldFile.name];
    }
    
    for (HCPManifestFile *newFile in comparedManifest.files){
        
        HCPManifestFile * oldFile = [filesMap objectForKey:newFile.name];
        
        if(oldFile == NULL){
            [addedFiles addObject:newFile];
        }else {
            if(![oldFile.md5Hash isEqualToString:newFile.md5Hash]){
                [changedFiles addObject:newFile];
            }
            [filesMap removeObjectForKey:oldFile.name];
        }
    }
    [deletedFiles addObjectsFromArray:[filesMap allValues]];
    return [[HCPManifestDiff alloc] initWithAddedFiles:addedFiles changedFiles:changedFiles deletedFiles:deletedFiles];
}


#pragma mark HCPJsonConvertable implmenetation

- (id)toJson {
    NSMutableArray *jsonObject = [[NSMutableArray alloc] init];
    for (HCPManifestFile *manifestFile in self.files) {
        id manifestFileObj = [manifestFile toJson];
        if (manifestFileObj) {
            [jsonObject addObject:manifestFileObj];
        }
    }
    
    return jsonObject;
}

+ (instancetype)instanceFromJsonObject:(id)json {
    if (![json isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSArray *jsonObject = json;
    NSMutableArray *manifestFilesList = [[NSMutableArray alloc] initWithCapacity:jsonObject.count];
    for (NSDictionary *manifestFileObject in jsonObject) {
        HCPManifestFile* manifestFile = [HCPManifestFile instanceFromJsonObject:manifestFileObject];
        if (manifestFile) {
            [manifestFilesList addObject:manifestFile];
        }
    }
    
    HCPContentManifest *manifest = [[HCPContentManifest alloc] init];
    manifest.files = manifestFilesList;
    
    return manifest;
}

@end
