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
        let formate = Date().getFormattedDate(format: "yyyy-MM-dd HH:mm:ss.SSS")
        print("\(formate) \(tag): \(message)")
    }
    
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
