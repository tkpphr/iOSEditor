//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import iOSEditor

public class TextData : FileData {
    public var filePath: String
    public var text: String

    public init(filePath:String,text:String) {
        self.filePath = filePath
        self.text = text
    }
    
    public convenience init(filePath:String){
        self.init(filePath: filePath, text: "")
    }
    
    public required init?(contentsOfFile: String) {
        do {
            let text = try String.init(contentsOfFile: contentsOfFile, encoding: .utf8)
            self.text = text
        }catch{
            print(error.localizedDescription)
            return nil
        }
        self.filePath = contentsOfFile
    }
    
    public func save(savePath: String) -> Bool {
        return self.saveAs(savePath: savePath)
    }
    
    public func saveAs(savePath: String) -> Bool {
        do{
            try self.text.write(toFile: savePath, atomically: true, encoding: .utf8)
            return true
        }catch{
            print(error.localizedDescription)
            return false
        }
    }
    
}
