//Copyright (c) 2018-present tkpphr. All rights reserved.

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
