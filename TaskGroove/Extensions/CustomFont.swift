
import SwiftUI

extension Font {
    static func dmsans(weight: Font.Weight = .regular, size: CGFloat = 17) -> Font {
        Font.custom("DMSans-Regular", size: size)
    }
    
    static func dmsansBold(weight: Font.Weight = .bold,  size: CGFloat = 17) -> Font {
        Font.custom("DMSans-Bold", size: size)
    }
    
    static func dmsansThin(weight: Font.Weight = .thin, size: CGFloat = 17) -> Font {
        Font.custom("DMSans-Thin", size: size)
    }
    
    static func dmsansExtraBold(weight: Font.Weight = .heavy, size: CGFloat = 17) -> Font {
        Font.custom("DMSans-ExtraBold", size: size)
    }
}
