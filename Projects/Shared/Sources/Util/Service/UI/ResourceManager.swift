//
//  FontManager.swift
//  폰트 매니저는 타입으로 정의 하고 tuist resource mapping 클래스로 사용한다
//
//  Created by inforex_imac on 2022/12/19.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.

import UIKit

public enum ResourceManager {
    
    
    public enum Font {
        
//        static let medium = UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
        
//        static let bold = GlobalHoneysFontFamily.NotoSansCJKKRBold.regular
        
//        static let regular = GlobalHoneysFontFamily.NotoSansCJKKRRegular.regular

        case b(_ size : CGFloat)
        case m(_ size : CGFloat)
        case r(_ size : CGFloat)
        
        
        var get : UIFont {
            switch self {
            case .b(let size):
//                return ResourceManager.Font.bold.font(size: size)
                return UIFont.boldSystemFont(ofSize: size)
            case .m(let size):
//                return ResourceManager.Font.medium.font(size: size)
                return UIFont.systemFont(ofSize: size, weight: .medium)
            case .r(let size):
//                return ResourceManager.Font.regular.font(size: size)
                return UIFont.systemFont(ofSize: size, weight: .regular)
            }
        }
    }
    
    
    public enum Color {
        case rgb(_ r :CGFloat, _ g : CGFloat, _ b : CGFloat)
        
        public var toUIColor : UIColor {
            switch self {
            case .rgb(let r, let g, let b) :
                return UIColor(redF: r, greenF: g, blueF: b, alphaF: 1)
            }
        }
    }
    
    
//    static let image = GlobalHoneysAsset.self
}


struct Dummy {
    static let name : [String] = [
        "Pellentesque congue",
        "Donec id",
        "Ut nec",
        "Aenean tristique",
        "Cras molestie",
        "Quisque placerat",
        "Vestibulum eu",
        "Quisque mollis",
        "Morbi faucibus",
        "Nam consequat",
        "Sed a",
        "Duis nec",
        "Sed ac",
        "Morbi sed",
        "Ut finibus",
        "Nam suscipit",
        "Vestibulum pellentesque",
        "Mauris mollis",
        "Curabitur varius",
        "Fusce a"
    ]
    
    static func getName() -> String {
        guard let name = name.randomElement() else {
            return "noname"
        }
        return name
    }
    
    static func getContent() -> String {
        guard let content = content.randomElement() else {
            return "noname"
        }
        return content
    }
    
    static func getPhoto() -> String {
        guard let photo = photo.randomElement() else {
            return "nophoto"
        }
        return photo
    }
    static let content : [String] = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        "Etiam id nulla eget augue gravida placerat.Etiam id nulla eget augue gravida placerat.",
        "Aenean convallis nisl nec hendrerit tincidunt.Aenean convallis nisl nec hendrerit tincidunt.",
        "Suspendisse finibus mauris quis nibh fermentum, a congue velit porttitor.Suspendisse finibus mauris quis nibh fermentum, a congue velit",
        "Aenean varius nunc nec orci faucibus vehicula.Aenean varius nunc nec orci faucibus vehicula.",
        "Sed at justo ullamcorper, vestibulum odio et, blandit nulla.Sed at justo ullamcorper, vestibulum odio et, blandit nulla.",
        "Suspendisse nec lorem bibendum, mattis sem in, laoreet velit.Suspendisse nec lorem bibendum, mattis sem in, laoreet velit.",
        "Duis sodales risus non magna iaculis fermentum.Duis sodales risus non magna iaculis fermentum.",
        "Aenean ornare nulla quis est imperdiet dignissim.Aenean ornare nulla quis est imperdiet dignissim.",
        "Sed dapibus quam sit amet ultrices sollicitudin.Sed dapibus quam sit amet ultrices sollicitudin.",
        "Praesent iaculis eros eu porttitor lobortis.Praesent iaculis eros eu porttitor lobortis.",
        "Nullam vel mi et eros porta tincidunt ut ac urna.Nullam vel mi et eros porta tincidunt ut ac urna.",
        "Cras ut ligula vestibulum, scelerisque nulla ac, porta elit.Cras ut ligula vestibulum, scelerisque nulla ac, porta elit.",
        "Integer sit amet massa et tellus sodales egestas.Integer sit amet massa et tellus sodales egestas.",
        "Nullam porta nulla nec velit rutrum vulputate.Nullam porta nulla nec velit rutrum vulputate.",
        "Donec finibus erat vel enim mattis ultricies.Donec finibus erat vel enim mattis ultricies.",
        "Fusce eget eros egestas, egestas dui quis, facilisis arcu.Fusce eget eros egestas, egestas dui quis, facilisis arcu.",
        "Mauris dictum magna eu lectus rhoncus, et lacinia velit scelerisque.Mauris dictum magna eu lectus rhoncus, et lacinia velit scelerisque.",
        "Praesent id ligula sed elit aliquet vestibulum.Praesent id ligula sed elit aliquet vestibulum.",
    ]
    
    static let photo: [String] = ["https://photo.dallalive.com/profile_0/21753716400/20230111025537454786.png?700X700",
             "https://photo.dallalive.com/profile_0/21740284800/20221230113049637482.png?700X700",
             "https://photo.dallalive.com/profile_0/21744824400/20230103234157125626.png?700X700",
             "https://photo.dallalive.com/profile_0/21752640000/20230110154634333987.png?700X700",
             "https://photo.dallalive.com/profile_0/21704342400/20221128115903057239.png?292x292",
             "https://photo.dallalive.com/profile_0/21674062800/20221101235258356171.png?292x292",
             "https://photo.dallalive.com/profile_0/21443806800/20220410225149412284.png?292x292",
             "https://photo.dallalive.com/profile_0/20988864000/20210301154610280466.jpeg?292x292",
             "https://photo.dallalive.com/profile_0/21577374000/20220807013252126739.png?292x292",
             "https://photo.dallalive.com/profile_0/21519014400/20220616103206665115.png?292x292",
             "https://photo.dallalive.com/profile_0/20949552000/20210125125506630207.png?292x292",
             "https://photo.dallalive.com/profile_0/20943982800/20210120233605502663.jpeg?292x292",
             "https://photo.dallalive.com/profile_0/20897884800/20201210115111788450.jpeg?292x292",
             "https://photo.dallalive.com/profile_0/21720067200/20221212163222406302.png?292x292",
             "https://photo.dallalive.com/profile_0/21740284800/20221230113049637482.png?292x292",
             "https://photo.dallalive.com/profile_0/21751516800/20230109164742864995.png?292x292",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%91%E1%85%B5%E1%84%8F%E1%85%A1%E1%84%8E%E1%85%B2.png?alt=media&token=68c2ffff-81a5-4db9-a67e-b776242cea02",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%8C%E1%85%A1%E1%86%B7%E1%84%86%E1%85%A1%E1%86%AB%E1%84%87%E1%85%A9.png?alt=media&token=e040d3d4-dd5e-4d81-b5e8-55c44c4f1606",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A1%E1%86%BC%E1%84%92%E1%85%A2%E1%84%8A%E1%85%B5.png?alt=media&token=90aafed7-36d4-4da9-84f0-05285a8184d2",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%8C%E1%85%B2%E1%84%87%E1%85%A6%E1%86%BA.png?alt=media&token=c3ed67c4-fc4b-4122-9c4c-e75e3c18b6b6",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%82%E1%85%A1%E1%84%8B%E1%85%A9%E1%86%BC.png?alt=media&token=8c14389d-10ad-4c5a-9562-2088316afab5",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%8B%E1%85%B5%E1%84%87%E1%85%B3%E1%84%8B%E1%85%B5.png?alt=media&token=bfd54682-7519-4ed9-a800-ca213b858a7f",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%85%E1%85%B5.png?alt=media&token=9f5dba67-0857-4d21-8ffb-d92db0d54566",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%81%E1%85%A9%E1%84%87%E1%85%AE%E1%84%80%E1%85%B5.png?alt=media&token=4c72eb7f-ab20-4184-8019-fe3033ee6fbe",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%88%E1%85%AE%E1%86%AF%E1%84%8E%E1%85%AE%E1%86%BC%E1%84%8B%E1%85%B5.png?alt=media&token=e9f65eea-70c6-486a-a647-876105edbf51",
             "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%80%E1%85%A9%E1%84%85%E1%85%A1%E1%84%91%E1%85%A1%E1%84%83%E1%85%A5%E1%86%A8.png?alt=media&token=1bc8cf35-e38b-4726-b5ec-844b0851c035"
        ]
}
