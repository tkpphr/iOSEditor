//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import iOSEditor

public class TextDataEditor : Editor<TextData> {

    
    public init(textData:TextData) {
        let saveDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        super.init(fileData: textData, saveDirectory: saveDirectory, fileExtension: ".txt", isSavePointEnabled: true)
    }
    
    public convenience init(){
        self.init(textData: TextData(filePath: "Untitled.txt"))
    }
    
}
