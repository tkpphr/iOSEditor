//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation

open class Editor<T:FileData> {
    private let isSavePointEnabled:Bool
    private let editorCommandStack:EditorCommandStack
    public let saveDirectory:String
    public let fileExtension:String
    private var dataChangedPoint:Int
    public var fileData : T {
        didSet {
            self.editorCommandStack.clear()
            self.dataChangedPoint = 0
        }
    }
    public var isDataChanged:Bool {
        return self.editorCommandStack.undoCount != self.dataChangedPoint
    }
    public var title : String {
        return self.isDataChanged ? "*" + self.fileData.fileName : self.fileData.fileName
    }
    public var isExistsFile : Bool {
        if self.fileData.fileName.isEmpty {
            return false
        }
        return FileManager.default.fileExists(atPath: self.saveDirectory + self.fileData.fileName + self.fileExtension)
    }
    public var undoCount :Int {
        return self.editorCommandStack.undoCount
    }
    public var redoCount : Int {
        return self.editorCommandStack.redoCount
    }
    public var canUndo: Bool {
        return self.editorCommandStack.canUndo
    }
    public var canRedo: Bool {
        return self.editorCommandStack.canRedo
    }
    
    public init(fileData:T,saveDirectory:String,fileExtension:String,isSavePointEnabled:Bool) {
        self.fileData = fileData
        self.saveDirectory = saveDirectory.isEmpty || String(saveDirectory.suffix(1)) == "/" ? saveDirectory : saveDirectory + "/"
        self.fileExtension =  fileExtension.isEmpty || String(fileExtension.prefix(1)) == "."
            ? fileExtension : "." + fileExtension
        self.isSavePointEnabled = isSavePointEnabled
        self.editorCommandStack = EditorCommandStack()
        self.dataChangedPoint = 0
    }
    
    public convenience init?(filePath:String,saveDirectory:String,fileExtension:String,isSavePointEnabled:Bool){
        guard let fileData = T.init(contentsOfFile:filePath) else { return nil }
        self.init(fileData: fileData, saveDirectory: saveDirectory, fileExtension: fileExtension, isSavePointEnabled: isSavePointEnabled)
    }
    
    public func doCommand(editorCommand:EditorCommand) {
        self.editorCommandStack.doCommand(editorCommand: editorCommand)
    }
    
    public func undo(){
        self.editorCommandStack.undo()
    }
    
    public func redo(){
        self.editorCommandStack.redo()
    }
    
    public func saveFile(fileName:String) -> Bool {
        var isSucceed = false
        let filePath = self.saveDirectory + fileName + self.fileExtension
        if FileManager.default.fileExists(atPath: filePath) {
            isSucceed = self.fileData.save(savePath: filePath)
        }else{
            if !FileManager.default.fileExists(atPath: saveDirectory) {
                do {
                    try FileManager.default.createDirectory(atPath: saveDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                    return false
                }
            }
            isSucceed = self.fileData.saveAs(savePath: filePath)
        }
        if isSucceed {
            self.fileData.filePath = filePath
            if !self.isSavePointEnabled {
                self.editorCommandStack.clear()
            }else{
                self.dataChangedPoint = editorCommandStack.undoCount
            }
        }
        return isSucceed
    }
    
    public func loadFile(filePath:String) -> Bool {
        if let fileData = T.init(contentsOfFile:filePath) {
            self.fileData = fileData
            return true
        }else{
            return false
        }
    }
    
}
