//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

public class SaveFileNameInputViewController : UIViewController {
    @IBOutlet private weak var saveFileNameInputView:SaveFileNameInputView!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    private var fileName:String?
    private var saveDirectory:String?
    private var fileExtension:String?
    private var inputCompleted:((_ fileName:String) -> Void)?
    
    public init(fileName:String,saveDirectory:String,fileExtension:String,inputCompleted:@escaping (_ fileName:String) -> Void) {
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSEditor", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        super.init(nibName: "SaveFileNameInputViewController", bundle: bundle)
        self.fileName = fileName
        self.saveDirectory = saveDirectory
        self.fileExtension = fileExtension
        self.inputCompleted = inputCompleted
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return  }
        context.setFillColor(UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0).cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.okButton.setBackgroundImage(image, for: .highlighted)
        self.cancelButton.setBackgroundImage(image, for: .highlighted)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.saveFileNameInputView.reset(fileName: self.fileName ?? "", saveDirectory: self.saveDirectory ?? "", fileExtension: self.fileExtension ?? "")
        self.saveFileNameInputView.inputErrorChanged = self.onInputErrorChanged
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction private func cancelButtonTapped(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func okButtonTapped(_ sender:Any) {
        if self.saveFileNameInputView.isShowKeyboard {
            self.saveFileNameInputView.endEditing(true)
            return
        }
        if !self.saveFileNameInputView.isInputErrorEnabled {
            self.dismiss(animated: true, completion: {[weak self] in self?.inputCompleted?(self?.saveFileNameInputView.fileName ?? "")})
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration: TimeInterval = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: duration, animations: {
            [weak self] in
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height/2))
            self?.view.transform = transform
        })
    }
    
    
    @objc private func keyboardWillHide(notification: Notification?) {
        if let duration: TimeInterval = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double {
            UIView.animate(withDuration: duration, animations: {
                [weak self] in
                self?.view.transform = .identity
            })
        } else {
            self.view.transform = .identity
        }
    }
    
    @objc private func willEnterForeground(){
        self.saveFileNameInputView.checkFileName()
    }
    
    private func onInputErrorChanged(_ isInputErrorEnabled:Bool){
        self.okButton.isEnabled = !isInputErrorEnabled
    }
}
