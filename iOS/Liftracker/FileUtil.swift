//
//  FileUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
class FileUtil : BaseUtil {
    
    static func getDocumentDirectory() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        return URL(fileURLWithPath: documentsPath)
    }
}
