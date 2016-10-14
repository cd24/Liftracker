//
//  FileUtil.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
/**
 The FileUtil serves as an abstraction to file operations by streamlining common operations for the file system.
 */
class FileUtil : BaseUtil {
    
    /**
     Retrieves the documents directory from NSSearchPaths 
     
     - Warning: Assumes the document directory exists, if this is not the case or NSSearchPathForDirectory in the documents domain reutrns an array smaller than 0, this will throw an index exception.
     
     - Returns: URL to the applications documents directory
    */
    static func getDocumentDirectory() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        return URL(fileURLWithPath: documentsPath)
    }
}
