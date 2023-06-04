//
//  FileUtils+Query.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/3.
//

import Foundation

extension FileUtils {
    public static func getAllFilePathURL(_ dirPath:String,justFile:Bool = false) -> (files:[URL],dirs:[URL]) {
        let results = self.getAllFilePath(dirPath,justFile:justFile)
        return (results.files.flatMap({URL.init(string: $0)}),results.dirs.flatMap({URL.init(string: $0)}))
    }
    public static func getAllFilePath(_ dirPath:String,justFile:Bool = false) -> (files:[String],dirs:[String]) {
        var filePaths = [String]()
        var dirs = [String]()
            
            do {
                let array = try FileManager.default.contentsOfDirectory(atPath: dirPath)
                
                for fileName in array {
                    var isDir: ObjCBool = true
                    
                    let fullPath = "\(dirPath)/\(fileName)"
                    
                    if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                        if !isDir.boolValue {
                            filePaths.append(fullPath)
                        }else if justFile == false {
                            dirs.append(fullPath)
                        }
                    }
                }
                
            } catch let error as NSError {
                print("get file path error: \(error)")
            }
            
            return (filePaths,dirs);
    }
}
