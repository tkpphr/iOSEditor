//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

public class SaveFileNameInputView : UIView,UITextFieldDelegate {
    @IBOutlet private weak var fileNameField : UITextField!
    @IBOutlet private weak var messageLabel : UILabel!
    @IBOutlet private weak var errorLabel : UILabel!
    public var inputErrorChanged:((_ isErrorEnabled:Bool) -> Void)?
    private var saveDirectory:String?
    private var fileExtension:String?
    private(set) var isInputErrorEnabled : Bool = false
    public var fileName:String {
        return self.fileNameField.text!
    }
    public var isShowKeyboard:Bool {
        return self.fileNameField.isFirstResponder
    }
    private var savePath:String {
        guard let saveDirectory = self.saveDirectory,
            let fileExtension = self.fileExtension,
            let fileName = self.fileNameField.text else {
                return ""
        }
        return saveDirectory + fileName + fileExtension
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNib()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.fileNameField.delegate = self
        self.fileNameField.returnKeyType = .done
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 30
    }
 
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.checkFileName()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
    public func reset(fileName:String,saveDirectory:String,fileExtension:String){
        self.saveDirectory = saveDirectory
        self.fileExtension = fileExtension
        self.isInputErrorEnabled = !fileName.isEmpty
        if self.fileNameField.text == fileName {
            self.checkFileName()
        }else{
            self.fileNameField.text = fileName
            self.checkFileName()
        }
    }
    
    public func checkFileName(){
        guard let fileName = self.fileNameField.text else {
            return
        }
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSEditor", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        var isInputErrorEnabled:Bool
        if fileName.isEmpty {
            self.errorLabel.isHidden = false
            self.messageLabel.text = bundle.localizedString(forKey: "hint_enter_file_name", value: nil, table: nil)
            isInputErrorEnabled = true
        }else{
            self.errorLabel.isHidden = true
            if FileManager.default.fileExists(atPath: self.savePath) {
                self.messageLabel.text = bundle.localizedString(forKey: "hint_save", value: nil, table: nil)
            }else{
                self.messageLabel.text = bundle.localizedString(forKey: "hint_save_as", value: nil, table: nil)
            }
            isInputErrorEnabled = false
        }
        
        if self.isInputErrorEnabled != isInputErrorEnabled {
            self.inputErrorChanged?(isInputErrorEnabled)
            self.isInputErrorEnabled = isInputErrorEnabled
        }
        
    }
    
    public func hideKeyboard(){
        self.fileNameField.resignFirstResponder()
    }
    
    private func loadNib() {
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSEditor", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        let nib = UINib(nibName: "SaveFileNameInputView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
