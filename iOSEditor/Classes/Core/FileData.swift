//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation

public protocol FileData {
    var filePath:String { get set }
    var fullFileName:String { get }
    var fileName:String { get }
    var fileExtension:String { get }
    func save(savePath:String) -> Bool
    func saveAs(savePath:String) -> Bool
    
    init?(contentsOfFile:String)
}

public extension FileData{
    
    public var fullFileName:String{
        return URL(fileURLWithPath: self.filePath).lastPathComponent;
    }
    
    public var fileName:String{
        return URL(fileURLWithPath: self.filePath).deletingPathExtension().lastPathComponent;
    }
    
    public var fileExtension:String{
        return URL(fileURLWithPath: self.filePath).pathExtension;
    }
    
    
}
