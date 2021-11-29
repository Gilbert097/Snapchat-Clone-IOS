//
//  DynamicData.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 25/04/21.
//

import Foundation

public struct EventData<EnumDataType> {
    public typealias EnumDataType = Hashable & Equatable
    
    public let type: EnumDataType
    public let info: Any?
    
    public init(type: EnumDataType, info: Any? = nil) {
        self.type = type
        self.info = info
    }
    
    public func getInfo<Info>() -> Info? {
        assert(info is Info, "Invalid Enum Data Type")
        return info as? Info
    }
}
