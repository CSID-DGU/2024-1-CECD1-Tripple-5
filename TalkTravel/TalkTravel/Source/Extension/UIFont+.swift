import UIKit

extension UIFont {
    enum FontType: String {
        case pretendardBlack = "Pretendard-Black"
        case pretendardBold = "Pretendard-Bold"
        case pretendardExtraBold = "Pretendard-ExtraBold"
        case pretendardExtraLight = "Pretendard-ExtraLight"
        case pretendardLight = "Pretendard-Light"
        case pretendardMedium = "Pretendard-Medium"
        case pretendardRegular = "Pretendard-Regular"
        case pretendardSemibold = "Pretendard-SemiBold"
        case pretendardThin = "Pretendard-Thin"
        
        var name: String {
            return self.rawValue
        }
        
        static func font(_ type: FontType, ofsize size: CGFloat) -> UIFont {
            let font = UIFont(name: type.rawValue, size: size)!
            return font
        }
    }
}
