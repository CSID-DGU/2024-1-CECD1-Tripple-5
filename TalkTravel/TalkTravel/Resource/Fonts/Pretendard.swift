import UIKit

public struct FontProperty {
    let font: UIFont.FontType
    let size: CGFloat
}

public enum Pretendard {
    case pretendardBlack(size: CGFloat)
    case pretendardBold(size: CGFloat)
    case pretendardExtraBold(size: CGFloat)
    case pretendardExtraLight(size: CGFloat)
    case pretendardLight(size: CGFloat)
    case pretendardMedium(size: CGFloat)
    case pretendardRegular(size: CGFloat)
    case pretendardSemibold(size: CGFloat)
    case pretendardThin(size: CGFloat)
    
    public var fontProperty: FontProperty {
        switch self {
        case .pretendardBlack(let size):
            return FontProperty(font: .pretendardBlack, size: size)
        case .pretendardBold(let size):
            return FontProperty(font: .pretendardBold, size: size)
        case .pretendardExtraBold(let size):
            return FontProperty(font: .pretendardExtraBold, size: size)
        case .pretendardExtraLight(let size):
            return FontProperty(font: .pretendardExtraLight, size: size)
        case .pretendardLight(let size):
            return FontProperty(font: .pretendardLight, size: size)
        case .pretendardMedium(let size):
            return FontProperty(font: .pretendardMedium, size: size)
        case .pretendardRegular(let size):
            return FontProperty(font: .pretendardRegular, size: size)
        case .pretendardSemibold(let size):
            return FontProperty(font: .pretendardSemibold, size: size)
        case .pretendardThin(let size):
            return FontProperty(font: .pretendardThin, size: size)
        }
    }
}

public extension Pretendard {
    var font: UIFont {
        guard let font = UIFont(name: fontProperty.font.name, size: fontProperty.size) else {
            return UIFont()
        }
        return font
    }
}
