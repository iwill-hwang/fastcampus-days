//
//  ViewController.swift
//  Days
//
//  Created by donghyun on 2021/06/01.
//

import UIKit

class EventListCell: UITableViewCell {
    var event: Event! {
        didSet {
            let format = DateFormatter.dateFormat(fromTemplate: "dMMMMyyyy", options: 0, locale: Locale.current)!
            let formatter = DateFormatter()
            let dayCount = event.dayCount()
            
            formatter.dateFormat = format
            
            titleLabel.text = event.title
            dateLabel.text = formatter.string(from: event.date)
            iconView.image = UIImage(named: "icon_\(event.icon)")
            
            if dayCount == 0 {
                dayCountLabel.text = "Today"
            } else if dayCount < 0 {
                dayCountLabel.text = "D-\(abs(dayCount))"
            } else {
                dayCountLabel.text = "D+\(dayCount)"
            }
        }
    }
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var dayCountLabel: UILabel!
    @IBOutlet weak private var iconView: UIImageView!
}

struct EventAction {
    var event: Event
    var mode: EventEditMode
}

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
        self.widgetSwitch.isOn = UserDefaults.standard.double(forKey: "widget") == event.id
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
        event.title = titleField.text ?? ""
        delegate?.eventEditorViewController(self, finishEditing: event, mode: mode, widget: widgetSwitch.isOn)
    }
}

extension EventEditorViewController: IconPickerViewControllerDelegate {
    func iconPickerViewController(_ controller: IconPickerViewController, didSelectIcon icon: Icon) {
        controller.dismiss(animated: true, completion: nil)
        self.event.icon = icon.id
        self.iconButton.setImage(UIImage(named: "icon_\(icon.id)"), for: .normal)
    }
}

class EventListViewController: UIViewController {
    private let storage: EventStorage = LocalEventStorage()
    
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if identifier == "EventEditor" {
            let navigationController = segue.destination as? UINavigationController
            let eventEditorViewController = navigationController?.topViewController as? EventEditorViewController
            
            if let eventEditorViewController = eventEditorViewController, let action = sender as? EventAction {
                eventEditorViewController.mode = action.mode
                eventEditorViewController.event = action.event
                eventEditorViewController.delegate = self
            }
        }
    }
    
    @IBAction func add() {
        let action = EventAction(event: Event.create(), mode: .add)
        performSegue(withIdentifier: "EventEditor", sender: action)
    }
}

extension EventListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.list().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell") as! EventListCell
        let event = storage.list()[indexPath.row]
        
        cell.event = event
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = storage.list()[indexPath.row]
            storage.delete(event)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = storage.list()[indexPath.item]
        let action = EventAction(event: event, mode: .edit)
        
        performSegue(withIdentifier: "EventEditor", sender: action)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension EventListViewController: EventEditorViewControllerDelegate {
    func eventEditorViewController(_ controller: EventEditorViewController, finishEditing event: Event, mode: EventEditMode, widget: Bool) {
        if mode == .add {
            let count = self.storage.list().count
            self.storage.add(event)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.tableView.insertRows(at: [IndexPath(row: count, section: 0)], with: .automatic)
            }
            
        } else {
            self.storage.update(event)
            self.tableView.reloadData()
        }
        
        let currentWidgetId = UserDefaults.standard.double(forKey: "widget")
        
        if widget == false {
            if currentWidgetId == event.id {
                UserDefaults.standard.removeObject(forKey: "widget")
            }
        } else {
            UserDefaults.standard.setValue(event.id, forKey: "widget")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func eventEditorViewControllerDidCancel(_ controller: EventEditorViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
