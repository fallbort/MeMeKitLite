//
//  FileUtils.swift
//  MeMe
//
//  Created by LuanMa on 16/10/12.
//  Copyright © 2016年 sip. All rights reserved.
//

public class FileUtils {
    public static var _libraryDirectory: URL?
    public class var libraryDirectory: URL {
        if let dictURL = _libraryDirectory {
            return dictURL
        }else {
            let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
            _libraryDirectory = url
            return url
        }
    }
    
    public static var _cachesDirectory: URL?
    public class var cachesDirectory: URL {
        if let dictURL = _cachesDirectory {
            return dictURL
        }else {
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            _cachesDirectory = url
            return url
        }
    }
    
    public static var _documentDirectory: URL?
    public class var documentDirectory: URL {
        if let dictURL = _documentDirectory {
            return dictURL
        }else {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            _documentDirectory = url
            return url
        }
    }

    public static var _temporaryDirectory: URL?
    public class var temporaryDirectory: URL {
        if let dictURL = _temporaryDirectory {
            return dictURL
        }else {
            let url = URL(fileURLWithPath: NSTemporaryDirectory())
            _temporaryDirectory = url
            return url
        }
    }
    
    public class func isExist(_ filepath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filepath)
    }
    
    public class func removeFile(_ filepath: String) -> Bool {
        if FileManager.default.fileExists(atPath: filepath) {
            do {
                try FileManager.default.removeItem(atPath: filepath)
                return true
            } catch _ {

                return false
            }
        } else {
            return true
        }
    }
    
    // 删除文件夹及文件夹下所有的文件
    public class func removeDir(_ filepath: String) -> Bool {
        if FileManager.default.fileExists(atPath: filepath) {
            do {
                if let fileArray = FileManager.default.subpaths(atPath: filepath) {
                    for fn in fileArray {
                        let path = filepath.stringByAppendingPathComponent(path: fn)
                        try FileManager.default.removeItem(atPath: path)
                    }
                }
                return true
            } catch let error {

                return false
            }
        } else {
            return true
        }
    }
    
    // 删除文件夹及文件夹下所有的文件
    public class func forceRemoveDir(_ filepath: String) -> Bool {
        if FileManager.default.fileExists(atPath: filepath) {
            if let fileArray = FileManager.default.subpaths(atPath: filepath) {
                var allSuccess = true
                for fn in fileArray {
                    let path = filepath.stringByAppendingPathComponent(path: fn)
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch let error {
                        allSuccess = false
                    }
                }
                return allSuccess
            }else{
                return true
            }
            
        } else {
            return true
        }
    }

    public class func copyFile(_ srcPath: String, toPath: String) -> Bool {
        do {
            try FileManager.default.copyItem(atPath: srcPath, toPath: toPath)
            return true
        } catch _ {

            return false
        }
    }

    public class func moveFile(_ srcPath: String, toPath: String) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: srcPath, toPath: toPath)
            return true
        } catch _ {

            return false
        }
    }

    public class func createDir(_ path: String) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch _ {

            return false
        }
    }
	
	public class func createFile(_ filepath: String) -> Bool {
		return FileManager.default.createFile(atPath: filepath, contents: nil, attributes: nil)
	}

	public class func size(of filePath: String) -> UInt64 {
		do {
			//return [FileAttributeKey : Any]
			let attr = try FileManager.default.attributesOfItem(atPath: filePath)
			return attr[FileAttributeKey.size] as! UInt64
		} catch {

			return 0
		}
	}

    public class func unzip(_ filepath: String, toDestination destination: String,delegate:SSZipArchiveDelegate? = nil,progress:((_ progress:Double?,_ success:Bool?)->())? = nil) -> Bool {
        SSZipArchive.unzipFile(atPath: filepath, toDestination: destination, preserveAttributes: true, overwrite: true, nestedZipLevel: 0, password: nil, error: nil, delegate: delegate) { _, zipInfo, num, total,size in
            if total > 0 {
                let totalSize = zipInfo.uncompressed_size
                let oneFileProgress:Double = 1.0 / (Double)(total)
                var curProgress = Double(num) * oneFileProgress
                curProgress += ((Double)(size) / (Double)(totalSize) * oneFileProgress)
                curProgress = curProgress > 1.0 ? 1.0 : curProgress
                
                progress?(curProgress,nil)
            }else{
                progress?(nil,nil)
            }
            
        } completionHandler: { _, success, _ in
            if success == true {
                progress?(1.0,success)
            }else{
                progress?(nil,success)
            }
        }

    }

	public class func zip(src srcFilePath: String, to targetFilePath: String,progress:((_ progress:CGFloat?,_ done:Bool)->())? = nil) -> Bool {
		return SSZipArchive.createZipFile(atPath: targetFilePath, withFilesAtPaths: [srcFilePath])
	}
}
