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
