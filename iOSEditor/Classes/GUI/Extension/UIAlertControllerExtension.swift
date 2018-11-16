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
import UIKit

public extension UIAlertController {
    
    public class func createExitEditorAlert(isDataChanged:Bool,saveSelected: @escaping () -> Void ,exitSelected:@escaping () -> Void) -> UIAlertController {
        class dummy {}
        var bundle = Bundle(for: type(of:dummy()))
        if let path = bundle.path(forResource: "iOSEditor", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        let messageKey = isDataChanged ? "message_exit_with_data_changed" : "message_exit"
        let alert = UIAlertController(title:bundle.localizedString(forKey: "exit", value: nil, table: nil),message: bundle.localizedString(forKey: messageKey, value: nil, table: nil), preferredStyle: .alert)
        if isDataChanged{
            alert.addAction(UIAlertAction(title: bundle.localizedString(forKey: "save", value: nil, table: nil), style: .default, handler: { _ in saveSelected() }))
            alert.addAction(UIAlertAction(title: bundle.localizedString(forKey: "dont_save", value: nil, table: nil), style: .destructive, handler: { _ in exitSelected() }))
            alert.addAction(UIAlertAction(title: bundle.localizedString(forKey: "cancel", value: nil, table: nil), style: .cancel, handler: nil))
        }else{
            alert.addAction(UIAlertAction(title: bundle.localizedString(forKey: "yes", value: nil, table: nil), style: .default,handler: { _ in exitSelected() }))
            alert.addAction(UIAlertAction(title: bundle.localizedString(forKey: "no", value: nil, table: nil), style: .cancel, handler: nil))
        }
        return alert
    }
    
    
}
