//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation

public class EditorCommandStack  {
    private var undoStack:[EditorCommand]
    private var redoStack:[EditorCommand]
    public var undoCount : Int {
        return self.undoStack.count
    }
    public var redoCount : Int {
        return self.redoStack.count
    }
    public var canUndo:Bool {
        return self.undoCount > 0
    }
    public var canRedo:Bool {
        return self.redoCount > 0
    }
    
    public init(){
        self.undoStack = []
        self.redoStack = []
    }
    
    public func doCommand(editorCommand:EditorCommand) {
        editorCommand.doCommand()
        self.undoStack.append(editorCommand)
        self.redoStack.removeAll()
    }
    
    public func undo() {
        if !self.canUndo {
            return
        }
        if let editorCommand = self.undoStack.popLast() {
            editorCommand.undo()
            self.redoStack.append(editorCommand)
        }
    }
    
    public func redo() {
        if !self.canRedo {
            return
        }
        if let editorCommand = self.redoStack.popLast() {
            editorCommand.redo()
            self.undoStack.append(editorCommand)
        }
    }
    
    public func clear() {
        self.undoStack.removeAll()
        self.redoStack.removeAll()
    }
    
}
