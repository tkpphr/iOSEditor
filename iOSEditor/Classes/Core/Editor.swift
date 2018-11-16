/*
 MIT License
 
 Copyright (c) 2018 tkpphr
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

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
