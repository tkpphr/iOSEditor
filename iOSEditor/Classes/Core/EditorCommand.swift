//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation

open class EditorCommand {
    private(set) var doCommand: (() -> Void)
    private(set) var undo: (() -> Void)
    private(set) var redo: (() -> Void)
    
    public init(doCommand: @escaping (()->Void),undo: @escaping (()->Void),redo: @escaping (()->Void)){
        self.doCommand = doCommand
        self.undo = undo
        self.redo = redo
    }
    
    public convenience init(doCommand: @escaping (()->Void),undo: @escaping (()->Void)){
        self.init(doCommand: doCommand, undo: undo, redo: doCommand)
    }
    
}
