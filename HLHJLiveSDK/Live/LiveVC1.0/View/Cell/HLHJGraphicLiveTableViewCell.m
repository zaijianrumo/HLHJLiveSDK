//
//  HLHJGraphicLiveTableViewCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJGraphicLiveTableViewCell.h"


@implementation HLHJGraphicLiveTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self setUI];
    }
    return self;
}

-(void)setUI {
  
    _timeLab = [UILabel new];
    _timeLab.textColor = [UIColor redColor];
    _timeLab.font = [UIFont systemFontOfSize:13];
    _timeLab.text = @"2018-5-22 14：30:50";
    [self.contentView addSubview:_timeLab];
    
    _contetnLab = [UILabel new];
    _contetnLab.text = @"房间爱咖啡就来得及发卡机范德萨发生纠纷考虑是否就流口水斐林试剂分开连锁店经费落实到经费落实到法律思考jf";
    _contetnLab.textAlignment = NSTextAlignmentLeft;
    _contetnLab.numberOfLines = 0;
    _contetnLab.font = [UIFont systemFontOfSize:14];
    _contetnLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:_contetnLab];
    
    _iconImg = [HLHJMagicImageView new];
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    _iconImg.clipsToBounds = YES;
    [self.contentView addSubview:_iconImg];
    
    UIView *contentView = self.contentView;
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(10);
        make.top.equalTo(contentView.mas_top).offset(10);
    }];
    
    [_contetnLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLab.mas_left);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.top.equalTo(_timeLab.mas_bottom).offset(10);

    }];

    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contetnLab);
        make.top.equalTo(_contetnLab.mas_bottom).offset(10);
        make.bottom.equalTo(contentView.mas_bottom).offset(-10);
    }];
}

- (void)setModel:(ContetnModel *)model {
    
    _model = model;
    
    _timeLab.text  = [self cStringFromTimestamp:model.update_at];
    
    _contetnLab.text = model.online_content;

    WS(weakSelf);
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.online_thumb]] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

        CGSize imgSize  = image.size;
        if (imgSize.width > 200) {
            UIImage *image11 = [weakSelf imageCompressForWidth:image targetWidth:200];
            _iconImg.image = image11;
            [weakSelf.contentView setNeedsLayout];
        }
    }];
    
//
//    if (model.online_thumb.length == 0) {
//        [self.contentView setNeedsLayout];
//        return;
//    }
//    ///根据图片网址获取缓存
//    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@%@",BASE_URL,model.online_thumb]];
//    if (cachedImage) {
//        CGSize imgSize  =cachedImage.size;
//        if (imgSize.width > 200) {
//            UIImage *image = [self imageCompressForWidth:cachedImage targetWidth:200];
//            _iconImg.image = image;
//        }
//    } else {///不存在缓存 使用SDWebImageDownloader下载
//
//        _iconImg.image = [UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhanweitu"];
//        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.online_thumb]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//            if (finished) {
//                CGSize imgSize  =cachedImage.size;
//                if (imgSize.width > 200) {
//                    UIImage *image = [self imageCompressForWidth:cachedImage targetWidth:200];
//                    _iconImg.image = image;
//                }
//                ///对现在图片进行缓存
//                [[SDImageCache sharedImageCache]storeImage:image forKey:[NSString stringWithFormat:@"%@%@",BASE_URL,model.online_thumb] toDisk:YES completion:^{
//                    [self.contentView setNeedsLayout];
//                }];
//            }
//        }];
//    }
//
}
//、时间戳——字符串时间
- (NSString *)cStringFromTimestamp:(NSString *)timestamp{
    //时间戳转时间的方法
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}
//指定宽度按比例缩放
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) ==NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
