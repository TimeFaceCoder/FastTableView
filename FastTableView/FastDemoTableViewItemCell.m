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
@property (nonatomic ,strong) ASImageNode   *backgroundImageNode;
@property (nonatomic ,strong) ASImageNode   *contentImageNode;

@property (nonatomic ,strong) ASImageNode   *avatarImageNode;
@property (nonatomic ,strong) ASTextNode    *nickNameTextNode;
@property (nonatomic ,strong) ASTextNode    *titleTextNode;
@property (nonatomic ,strong) ASTextNode    *contentTextNode;

@end

@implementation FastDemoTableViewItemCell {
    
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
            height += kTopViewPadding + [FastDemoTableViewItemCell heightWithText:[lineItem.data objectForKey:@"content"]
                                                                             font:[UIFont systemFontOfSize:16]
                                                                            width:(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 2*kViewPadding)
                                                                            lines:3];
        }
        //时光图片
        if ([lineItem.data objectForKey:@"imageObjList"] && [[lineItem.data objectForKey:@"imageObjList"] count] > 0) {
            NSDictionary *imageModel = [[lineItem.data objectForKey:@"imageObjList"] objectAtIndex:0];
            CGFloat scale = [UIScreen mainScreen].bounds.size.width / [[imageModel objectForKey:@"imgWidth"] floatValue];
            height += kTopViewPadding + [[imageModel objectForKey:@"imgHeight"] floatValue] * scale;
        }
    }
    return height;
}

+ (CGFloat)heightWithText:(NSString *)text font:(UIFont*)font width:(CGFloat)width lines:(NSInteger)lines {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.font = font;
    lbl.numberOfLines = lines;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kLineSpace];//调整行间距
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [content addAttribute:NSParagraphStyleAttributeName
                    value:paragraphStyle
                    range:NSMakeRange(0, text.length)];
    
    lbl.attributedText = content;
    CGRect frame = lbl.frame;
    frame.size.width = width;
    frame.size.height = [FastDemoTableViewItemCell getHeightOfLabel:text
                                                      font:font
                                                labelWidth:width
                                                 lineSpace:kLineSpace
                                                     lines:lines];
    lbl.frame = frame;
    [lbl sizeToFit];
    
    return lbl.frame.size.height;
}

+ (CGFloat)getHeightOfLabel:(NSString*)text
                       font:(UIFont*)font
                 labelWidth:(CGFloat)width
                  lineSpace:(CGFloat)lineSpace
                      lines:(NSInteger)lines {
    if (text.length == 1) {
        text = [NSString stringWithFormat:@"%@ ",text];
    }
    if (!lines) {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]
                                              initWithString:text];
        
        
        //创建字体以及字体大小
        CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"), font.pointSize, NULL);
        [content addAttribute:(id)kCTFontAttributeName
                        value:(__bridge id)helvetica
                        range:NSMakeRange(0, [content length])];
        //设置字体区域行间距
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
        lineSpaceStyle.valueSize = sizeof(lineSpace);
        lineSpaceStyle.value=&lineSpace;
        
        //创建样式数组
        CTParagraphStyleSetting settings[]={
            lineSpaceStyle
        };
        //设置样式
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);
        
        [content addAttribute:(id)kCTParagraphStyleAttributeName
                        value:(__bridge id)paragraphStyle
                        range:NSMakeRange(0, [content length])];
        
        // layout master
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
        
        //计算文本绘制size
        CGSize tmpSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(width, MAXFLOAT), NULL);
        
        CFRelease(helvetica);
        CFRelease(paragraphStyle);
        CFRelease(framesetter);
        return tmpSize.height;
    } else {
        CGFloat lineHeight = font.lineHeight + lineSpace;
        CGSize size = CGSizeMake(width, lineHeight * lines);
        
        /// Make a copy of the default paragraph style
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        /// Set line break mode
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        /// Set text alignment
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName: paragraphStyle};
        CGSize labelHeight = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        //        CGSize labelHeight = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        
        return labelHeight.height + 3;
    }
}

- (void)cellDidLoad {
    [super cellDidLoad];
}

- (void)cellWillAppear {
    [super cellWillAppear];
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
        
        _contentTextNode.attributedString = [NSAttributedString attributedStringForDescriptionText:[self.item.data objectForKey:@"content"]];
    }

}


- (void)cellDidDisappear {
    [super cellDidDisappear];
    //重用准备
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _backgroundImageNode.image = nil;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(__bridge id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _backgroundImageNode.frame = self.bounds;
    _contentImageNode.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - kBottomAreaHeight - _imageSize.height, _imageSize.width, _imageSize.height);
    
    [CATransaction commit];
    
}


- (void)drawViews {
    [super drawViews];
}
- (void)clearViews {
    [super clearViews];
}
- (void)releaseMemory {
    [super releaseMemory];
}

#pragma mark - Privates

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
        CGFloat x = kViewPadding*2 + kAvatarSize;
        _nickNameTextNode.frame = CGRectMake(x, kViewPadding, CGRectGetWidth(self.bounds) - x - kViewPadding, kTitleHeight);
    }
    return _nickNameTextNode;
}

- (ASTextNode *)titleTextNode {
    if (!_titleTextNode) {
        _titleTextNode = [ASTextNode new];
        _titleTextNode.layerBacked = true;
        _titleTextNode.frame = CGRectMake(kViewPadding, kTopAreaHeight - kViewPadding - kTitleHeight, CGRectGetWidth(self.bounds) - kViewPadding * 2, kTitleHeight);
    }
    return _titleTextNode;
}

- (ASTextNode *)contentTextNode {
    if (!_contentTextNode) {
        _contentTextNode = [ASTextNode new];
        _contentTextNode.layerBacked = true;
        _contentTextNode.frame = CGRectMake(kViewPadding, kTopAreaHeight, CGRectGetWidth(self.bounds) - kViewPadding * 2, 0);
    }
    return _contentTextNode;
}

@end
