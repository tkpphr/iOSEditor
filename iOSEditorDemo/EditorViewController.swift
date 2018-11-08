//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit
import iOSEditor

public class EditorViewController : UIViewController,UINavigationBarDelegate,UITextViewDelegate {
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var redoButton: UIBarButtonItem!
    @IBOutlet private weak var undoButton: UIBarButtonItem!
    @IBOutlet private weak var exitButton: UIBarButtonItem!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var navigationTitle: UINavigationItem!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    public var filePath:String?
    private var editor:TextDataEditor!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.delegate = self
        self.textView.delegate = self
        self.editor = TextDataEditor()
        self.refresh()
        
        if let filePath = self.filePath {
            self.navigationTitle.title = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let filePath = self.filePath {
            let vc = LoadProgressViewController(
            task: {
                [weak self] in
                sleep(3)
                return self?.editor.loadFile(filePath: filePath) ?? false
            },
            finished:{
                [weak self] isSucceed in
                if(isSucceed){
                    self?.refresh()
                }else{
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if self.editor.fileData.text != textView.text {
            let textData = self.editor.fileData
            let oldText = textData.text
            let newText = textView.text!
            let editorCommand = EditorCommand(doCommand: {
                textData.text = newText
            },
                                              undo: {
                                                textData.text = oldText
            },
                                              redo:{
                                                textData.text = newText
            })
            self.editor.doCommand(editorCommand: editorCommand)
            self.refresh()
        }
    }
    
    @IBAction private func undoButtonTapped(_ sender:Any){
        self.editor.undo()
        self.refresh()
    }
    
    @IBAction private func redoButtonTapped(_ sender:Any){
        self.editor.redo()
        self.refresh()
    }
    
    @IBAction private func saveButtonTapped(_ sender:Any){
        self.showSaveFileAlert(saveAfterExit: false)
    }
    
    @IBAction private func exitButtonTapped(_ sender:Any){
        let alert = UIAlertController.createExitEditorAlert(isDataChanged: self.editor.isDataChanged,
                                                            saveSelected: {[weak self] in
                                                                DispatchQueue.main.async {
                                                                    self?.showSaveFileAlert(saveAfterExit: true) }
                                                            },
                                                            exitSelected: { [weak self] in self?.performSegue(withIdentifier: "unwindToMain", sender: self)})
        self.present(alert, animated: false, completion: nil)
    }
    
    private func showSaveFileAlert(saveAfterExit:Bool){
        let vc = SaveFileNameInputViewController(fileName: self.editor.fileData.fileName, saveDirectory: self.editor.saveDirectory, fileExtension: self.editor.fileExtension, inputCompleted: {
            [weak self] fileName in
            let vc = SaveProgressViewController(
                task:{
                    [weak self] in
                    sleep(3)
                    return self?.editor.saveFile(fileName: fileName) ?? false
                },
                finished:{
                    [weak self]  isSucceed in
                    if isSucceed {
                        if saveAfterExit {
                            self?.performSegue(withIdentifier: "unwindToMain", sender: self)
                        }else{
                            self?.refresh()
                        }
                    }
            })
            self?.present(vc, animated: true, completion: nil)
        })
        self.present(vc, animated: true, completion: nil)
    }
    
    private func refresh(){
        self.navigationTitle.title = self.editor.title
        self.undoButton.isEnabled = self.editor.canUndo
        self.redoButton.isEnabled = self.editor.canRedo
        if self.textView.text != self.editor.fileData.text {
            self.textView.text = self.editor.fileData.text
        }
    }
}
