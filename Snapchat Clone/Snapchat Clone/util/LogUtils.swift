//
//  LogUtils.swift
//  Snapchat Clone
//
//  Created by Gilberto Silva on 02/12/21.
//

import Foundation

class LogUtils {
    
    static var shared: LogUtils = {
        LogUtils()
      }()
    
    private init(){}
    
    static func printMessage(tag: String, message: String){
        print("\(tag): \(message)")
    }
    
}
