//
//  ViewController.swift
//  Reminder App
//
//  Created by GGS-BKS on 24/08/22.
//
import UserNotifications
import UIKit

class ViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let datePicker1 = UIDatePicker()
    @IBOutlet var table: UITableView!
    private var models = [Entity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        table?.delegate = self
        table?.dataSource = self
    }
    @IBAction func didTapAdd(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else{
            return
    }
    vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
    vc.completion = {title, body, date in
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
            self.createItem(title: title, body: body, date: date)
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.sound = .default
            content.body = body
            let targetDate = date
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],from: targetDate), repeats: false)
            
            
            
            let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if error != nil {
                    print("Something went wrong")
                }
            })
        }
    }
    navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func didTapTest(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success{
                //schedule test
                self.scheduleTest()
            }else if error != nil{
                print("error occured")
            }
        })
    }
    func scheduleTest(){
        let content = UNMutableNotificationContent()
        content.title = "Hello world"
        content.sound = .default
        content.body = " hi this is test notification"
        let targetDate = Date().addingTimeInterval(5)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil {
                print("Something went wrong")
            }
        })
        
    }

}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        print("you selected the row")
                let itemD = models[indexPath.row]
                let delete = UIAlertController(title: "Options", message: "Few options available" , preferredStyle: .actionSheet)
        
                delete.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // View option
        delete.addAction(UIAlertAction(title: "View", style: .default, handler: {_ in
        let alert = UIAlertController(title: "View Reminders", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?[0].text = itemD.title
            alert.addTextField(configurationHandler: nil)
            alert.textFields?[1].text = itemD.body
            

        alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        
    }))
        
        
        // Edit option
        
            delete.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?[0].text = itemD.title
                alert.addTextField(configurationHandler: nil)
                alert.textFields?[1].text = itemD.body
                
                

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let field = alert.textFields?[0], let newTitle = field.text, !newTitle.isEmpty else{
                    return
                }
                guard let field2 = alert.textFields?[1], let newBody = field2.text, !newBody.isEmpty else{
                    return
                }
                
              
                self?.updateItem(item: itemD, newTitle: newTitle, newBody: newBody)
            }))
                self.present(alert, animated: true)
            
        }))
                delete.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                    self?.deleteItems(item: itemD)
                }))
        
        
                present(delete,animated: true)
        
    }
}

extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = models[indexPath.row].title
        
        
        if let date = models[indexPath.row].date {
              
              let formatter = DateFormatter()
              formatter.dateFormat = "MMM, dd, YYYY"
              
              cell.detailTextLabel?.text = formatter.string(from:date)
        
            
        }
        return cell
    }
    

    
    // core data
    func getAllItems(){
        do{
                models = try context.fetch(Entity.fetchRequest())
            DispatchQueue.main.async {
                self.table?.reloadData()
            }
        }catch{
            //error
        }
    }
    
    func createItem(title: String,body: String ,date: Date){
        let newItem = Entity(context: context)
        newItem.title = title
        newItem.body = body
        newItem.date = date
        do{
            try context.save()
            print("Item created")
            getAllItems()
        }
        catch{
            
        }
    }
    
    func updateItem(item: Entity, newTitle: String,newBody: String){
        item.title = newTitle
        item.body = newBody
        do{
            try context.save()
            getAllItems()
        }catch{
            print(error)
        }
    }
    func deleteItems(item : Entity){
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
}

