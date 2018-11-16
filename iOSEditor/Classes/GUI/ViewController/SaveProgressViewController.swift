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

public class SaveProgressViewController : UIViewController {
    private var task:(() -> Bool)?
    private var finished:((_ isSucceed:Bool) -> Void)?
    private var isSucceed:Bool?
    
    public init(task:@escaping ()->Bool,finished:@escaping (_ isSucceed:Bool) -> Void) {
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSEditor", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        super.init(nibName: "SaveProgressViewController", bundle: bundle)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.task = task
        self.finished = finished
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
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            [weak self] in
            self?.isSucceed = self?.task?()
            DispatchQueue.main.async {
                self?.dismiss(animated: false, completion: {
                    self?.finished?(self?.isSucceed ?? false)
                })
            }
        }
    }
}
