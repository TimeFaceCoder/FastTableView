//
//  FastDemoTableViewItemCell.m
//  FastTableView
//
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "FastDemoTableViewItemCell.h"
#import <CoreText/CoreText.h>
#import <SDWebImage/SDWebImageManager.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "UIImageEffects.h"
#import "FastTableView-Bridging-Header.h"
#import "FastTableView-Swift.h"
#import <pop/POP.h>

const static CGFloat  kLineSpace        = 6.0f;
const static CGFloat  kViewPadding      = 12.0f;
const static CGFloat  kTopViewPadding   = 12.0f;
const static CGFloat  kAvatarSize       = 42.0f;
const static CGFloat  kTopAreaHeight    = 96.0f;
const static CGFloat  kTitleHeight      = 18.0f;
const static CGFloat  kBottomAreaHeight = 36.0f;

@interface FastDemoTableViewItemCell() {
    
}
@property (nonatomic ,assign) CGSize        imageSize;
@property (nonatomic ,strong) CALayer       *placeholderLayer;
@property (nonatomic ,strong) ASDisplayNode *containerNode;
@property (nonatomic ,strong) ASImageNode   *backgroundImageNode;
@property (nonatomic ,strong) ASImageNode   *contentImageNode;

@property (nonatomic ,strong) ASImageNode   *avatarImageNode;
@property (nonatomic ,strong) ASTextNode    *nickNameTextNode;
@property (nonatomic ,strong) ASTextNode    *titleTextNode;
@property (nonatomic ,strong) ASTextNode    *contentTextNode;

@end

@implementation FastDemoTableViewItemCell {
    BOOL drawed;
}
@dynamic item;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self.layer addSublayer:self.placeholderLayer];
//        [self addSubnode:self.containerNode];
        [self addSubnode:self.backgroundImageNode];
        [self addSubnode:self.contentImageNode];
        [self addSubnode:self.avatarImageNode];
        [self addSubnode:self.nickNameTextNode];
        [self addSubnode:self.titleTextNode];
        [self addSubnode:self.contentTextNode];
    }
    return self;
}

+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager {
    //高度计算
    CGFloat height = kTopAreaHeight + kBottomAreaHeight;
    if ([item isKindOfClass:[FastDemoTableViewItem class]]) {
        FastDemoTableViewItem *lineItem = (FastDemoTableViewItem *)item;
        if ([[lineItem.data objectForKey:@"content"] length]) {
            //时光内容
            CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]) - kViewPadding * 2;
            CGSize contentSize = [FastDemoTableViewItemCell findHeightForText:[lineItem.data objectForKey:@"content"]
                                                                     havingWidth:width
                                                                         andFont:[UIFont systemFontOfSize:16]];
            height += contentSize.height;
            lineItem.contentHeight = contentSize.height;
        }
        //时光图片
        if ([lineItem.data objectForKey:@"imageObjList"] && [[lineItem.data objectForKey:@"imageObjList"] count] > 0) {
            NSDictionary *imageModel = [[lineItem.data objectForKey:@"imageObjList"] objectAtIndex:0];
            CGFloat scale = [UIScreen mainScreen].bounds.size.width / [[imageModel objectForKey:@"imgWidth"] floatValue];
            CGFloat imageHeight = [[imageModel objectForKey:@"imgHeight"] floatValue];
            height += kTopViewPadding + imageHeight * scale;
            lineItem.contentImageHeight = imageHeight;
        }
    }
    return height;
}

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineSpacing:kLineSpace];
        [paragraphStyle setParagraphSpacing:kLineSpace];
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, 100)
                                          options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                       attributes:@{ NSFontAttributeName:font,
                                                     NSParagraphStyleAttributeName:paragraphStyle}
                                          context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

- (void)cellDidLoad {
    [super cellDidLoad];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    [self drawViews];
}


- (void)cellDidDisappear {
    [super cellDidDisappear];
    //重用准备
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _backgroundImageNode.image = nil;
    _contentImageNode.image = nil;
    _avatarImageNode.image = nil;
    _titleTextNode.attributedString = nil;
    _contentTextNode.attributedString = nil;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(__bridge id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    _placeholderLayer.frame = self.bounds;
    _containerNode.frame = self.bounds;
    _backgroundImageNode.frame = self.bounds;
    _contentImageNode.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - kBottomAreaHeight - _imageSize.height,
                                         _imageSize.width, _imageSize.height);
    _contentTextNode.frame = CGRectMake(kViewPadding, kTopAreaHeight,
                                        CGRectGetWidth(self.bounds) - kViewPadding * 2,
                                        self.item.contentHeight);
    [CATransaction commit];

}


- (void)drawViews {
    [super drawViews];
    
    if (drawed) {
//        return;
    }
    drawed = YES;
    if ([self.item.data objectForKey:@"imageObjList"] && [[self.item.data objectForKey:@"imageObjList"] count] > 0) {
        NSDictionary *imageModel = [[self.item.data objectForKey:@"imageObjList"] objectAtIndex:0];
        
        CGFloat scale = CGRectGetWidth(self.bounds) / [[imageModel objectForKey:@"imgWidth"] floatValue];
        CGFloat imageHeight = [[imageModel objectForKey:@"imgHeight"] floatValue] * scale;
        _imageSize = CGSizeMake(CGRectGetWidth(self.bounds), imageHeight);
        NSString *imageUrl = [NSString stringWithFormat:@"%@!m%.0fx%.0f.jpg",
                              [imageModel objectForKey:@"imageUrl"],CGRectGetWidth(self.bounds) * 2,imageHeight * 2];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrl]
                                                        options:0
                                                       progress:NULL
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
         {
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                 _backgroundImageNode.image = [UIImageEffects imageByApplyingExtraLightEffectToImage:image];
                 _contentImageNode.image = image;
             });
         }];
    }
    
    NSDictionary *authorObj = [self.item.data objectForKey:@"author"];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[authorObj objectForKey:@"avatar"]]
                                                    options:0
                                                   progress:NULL
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         _avatarImageNode.image = image;
     }];
    _nickNameTextNode.attributedString = [NSAttributedString attributedStringForNickName:[authorObj objectForKey:@"nickName"]];
    _titleTextNode.attributedString = [NSAttributedString attributedStringForTitleText:[self.item.data objectForKey:@"timeTitle"]];
    _contentTextNode.attributedString = [NSAttributedString attributedStringForContentText:[self.item.data objectForKey:@"content"]];
    
}
- (void)clearViews {
    [super clearViews];
    
    if (!drawed) {
        return;
    }
    //CLEAR
    drawed = NO;
}
- (void)releaseMemory {
    [super releaseMemory];
}

#pragma mark - Privates

- (CALayer *)placeholderLayer {
    if (!_placeholderLayer) {
        _placeholderLayer = [CALayer new];
        _placeholderLayer.contentsGravity = kCAGravityResizeAspectFill;
        _placeholderLayer.contentsScale = [[UIScreen mainScreen] scale];
        _placeholderLayer.backgroundColor = [[UIColor colorWithHue:0 saturation:0 brightness:0.85 alpha:1] CGColor];
        _placeholderLayer.contents = (__bridge id)([[UIImage imageNamed:@"CellTimeDefault.png"] CGImage]);
    }
    return _placeholderLayer;
}

- (ASDisplayNode *)containerNode {
    if (!_containerNode) {
        _containerNode = [[ASDisplayNode alloc] init];
        _containerNode.layerBacked = YES;
        _containerNode.shouldRasterizeDescendants = YES;
        _containerNode.borderColor = [[UIColor colorWithHue:0 saturation:0 brightness:0.85 alpha:0.2] CGColor];
        _containerNode.borderWidth = 1;
        _containerNode.frame = self.bounds;
    }
    return _containerNode;
}

- (ASImageNode *)backgroundImageNode {
    if (!_backgroundImageNode) {
        _backgroundImageNode = [ASImageNode new];
        _backgroundImageNode.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageNode.layerBacked = true;
    }
    return _backgroundImageNode;
}

- (ASImageNode *)contentImageNode {
    if (!_contentImageNode) {
        _contentImageNode = [ASImageNode new];
        _contentImageNode.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageNode.layerBacked = true;
        _contentImageNode.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - kBottomAreaHeight - self.item.contentImageHeight,
                                             CGRectGetWidth([[UIScreen mainScreen] bounds]), self.item.contentImageHeight);
    }
    return _contentImageNode;
}

- (ASImageNode *)avatarImageNode {
    if (!_avatarImageNode) {
        _avatarImageNode = [ASImageNode new];
        _avatarImageNode.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageNode.layerBacked = true;
        _avatarImageNode.layer.masksToBounds = YES;
        _avatarImageNode.layer.cornerRadius = kAvatarSize / 2;
        _avatarImageNode.frame = CGRectMake(kViewPadding, kViewPadding, kAvatarSize, kAvatarSize);
    }
    return _avatarImageNode;
}

- (ASTextNode *)nickNameTextNode {
    if (!_nickNameTextNode) {
        _nickNameTextNode = [ASTextNode new];
        _nickNameTextNode.layerBacked = true;
        _nickNameTextNode.placeholderColor = [UIColor blueColor];
        CGFloat x = kViewPadding*2 + kAvatarSize;
        _nickNameTextNode.frame = CGRectMake(x, kViewPadding,
                                             CGRectGetWidth(self.bounds) - x - kViewPadding,
                                             kTitleHeight);
    }
    return _nickNameTextNode;
}

- (ASTextNode *)titleTextNode {
    if (!_titleTextNode) {
        _titleTextNode = [ASTextNode new];
        _titleTextNode.layerBacked = true;
        _titleTextNode.frame = CGRectMake(kViewPadding, kTopAreaHeight - kViewPadding - kTitleHeight,
                                          CGRectGetWidth(self.bounds) - kViewPadding * 2, kTitleHeight);
    }
    return _titleTextNode;
}

- (ASTextNode *)contentTextNode {
    if (!_contentTextNode) {
        _contentTextNode = [ASTextNode new];
        _contentTextNode.layerBacked = true;
        _contentTextNode.truncationMode = NSLineBreakByTruncatingTail;
        _contentTextNode.maximumLineCount = 3;
        _contentTextNode.frame = CGRectMake(kViewPadding, kTopAreaHeight,
                                            CGRectGetWidth(self.bounds) - kViewPadding * 2,
                                            self.item.contentHeight);
    }
    return _contentTextNode;
}

@end
