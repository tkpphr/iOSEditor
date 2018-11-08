//Copyright (c) 2018-present tkpphr. All rights reserved.

import UIKit
import iOSEditor

public class MainViewController: UIViewController,UINavigationBarDelegate,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    private var selectedFilePath:String?
    private var fileNames:[String]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var saveDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/"
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? EditorViewController)?.filePath = self.selectedFilePath
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 44
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TextDataCell")
        self.refreshList()
    }
    
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fileNames = self.fileNames {
            return fileNames.count
        }else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextDataCell", for: indexPath)
        cell.textLabel?.text = self.fileNames?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFilePath = self.saveDirectory + self.fileNames![indexPath.row]
        self.performSegue(withIdentifier: "prepareForEditor", sender: self)
    }
    
    @IBAction private func addButtonTapped(_ sender:Any){
        self.selectedFilePath = nil
        self.performSegue(withIdentifier: "prepareForEditor", sender: self)
    }
    
    @IBAction private func unwindToMain(_ segue:UIStoryboardSegue){
        self.refreshList()
    }
    
    private func refreshList(){
        do {
            self.fileNames = try FileManager.default.contentsOfDirectory(atPath: self.saveDirectory).filter{ $0.lowercased().hasSuffix(".txt") }
        }catch{
            print(error.localizedDescription)
        }
    }


}

