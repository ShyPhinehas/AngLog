//
//  Log.swift
//  FoxPlayer
//
//  Created by littlefox on 2017. 7. 20..
//  Copyright © 2017년 LittleFox. All rights reserved.
//

import Foundation

public class Log : NSObject{
    
    static public func d(_ str : String,fileName: String = #file , lineNumber: Int = #line,functionName: String = #function){
        
        let log : String = {
            let justFileName = (fileName.components(separatedBy: "/").last)?.components(separatedBy: ".").first
            return "\(e.now) \(justFileName ?? "")(\(functionName)) \(lineNumber): \(str)\n"
        }()
        
        if e.isDebugModeOn{
            print(log)
        }
        
        e.toFile(log: log)
    }
    
    var isDebugModeOn : Bool = true
    
    //MARK:-- manager
    static public let e = Log()
    let folderName : String = "Log"
    let fileName : String = "log.txt"
    let limitedFileSize : UInt64 = 5 * 1024 * 1024 // 5mb
    
    public var dataToAttachToEmail : Data? {
        get {
            if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
                let path = cacheDir.appendingPathComponent(folderName)
                let fileUrl : URL? = path.appendingPathComponent(fileName)
                return try? Data(contentsOf: fileUrl!)
            }
            return nil
        }
    }
    
    private var now : String {
        get{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS"
            dateFormat.locale = Locale.current
            return dateFormat.string(from: Date())
        }
    }
    
    private func toFile(log : String) {
      
        if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            
            let path = cacheDir.appendingPathComponent(folderName)
            let textPath = path.appendingPathComponent(fileName)
            
            let fileSize = sizeForLocalFilePath(filePath: textPath.relativePath)
            if fileSize > limitedFileSize{
                try? FileManager.default.removeItem(at: textPath)
            }
            
            try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
            let t = (toText() ?? "") + "\n" + log
            try? t.write(to: textPath, atomically: false, encoding: String.Encoding.utf8)

        }
    }
    
    private func toText() -> String?{
        if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let path = cacheDir.appendingPathComponent(folderName).appendingPathComponent(fileName)
            let t = try? String(contentsOf: path, encoding: String.Encoding.utf8)
            return t
        }
        
        return nil
    }
    
    private func sizeForLocalFilePath(filePath: String) -> UInt64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
}
