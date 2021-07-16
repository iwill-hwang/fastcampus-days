//
//  EventEditorViewController.swift
//  Days
//
//  Created by donghyun on 2021/07/14.
//

import Foundation
import UIKit

enum EventEditMode {
    case add
    case edit
}

protocol EventEditorViewControllerDelegate: AnyObject {
    func eventEditorViewController(_ controller: EventEditorViewController, finishEditing event: Event, mode: EventEditMode, widget: Bool)
    func eventEditorViewControllerDidCancel(_ controller: EventEditorViewController)
}

class EventEditorViewController: UITableViewController {
    weak var delegate: EventEditorViewControllerDelegate?
    
    var mode: EventEditMode!
    var event: Event!
    
    @IBOutlet weak private var iconButton: UIButton!
    @IBOutlet weak private var titleField: UITextField!
    @IBOutlet weak private var datePicker: UIDatePicker!
    @IBOutlet weak private var widgetSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconButton.setImage(UIImage(named: "icon_\(event.icon)"), for: .normal)
        self.titleField.text = event.title
        self.widgetSwitch.isOn = GroupDefaults.shared.widgetId == event.id
        self.datePicker.date = event.date
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "IconPicker" {
            let navigationController = segue.destination as? UINavigationController
            let iconPickerViewController = navigationController?.topViewController as? IconPickerViewController
            
            iconPickerViewController?.delegate = self
        }
    }
    
    @IBAction func dateChanged() {
        self.event.date = datePicker.date
    }
    
    @IBAction func presentIconPicker() {
        performSegue(withIdentifier: "IconPicker", sender: nil)
    }
    
    @IBAction func cancel() {
        delegate?.eventEditorViewControllerDidCancel(self)
    }
    
    @IBAction func save() {
        guard let title = titleField.text else {
            let controller = UIAlertController(title: "제목을 입력해주세요", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            
            return
        }
        
        event.title = title
        delegate?.eventEditorViewController(self, finishEditing: event, mode: mode, widget: widgetSwitch.isOn)
    }
    
    deinit {
        print("EventEditorViewController deinit")
    }
}

extension EventEditorViewController: IconPickerViewControllerDelegate {
    func iconPickerViewController(_ controller: IconPickerViewController, didSelectIcon icon: Icon) {
        controller.dismiss(animated: true, completion: nil)
        self.event.icon = icon.id
        self.iconButton.setImage(UIImage(named: "icon_\(icon.id)"), for: .normal)
    }
}
