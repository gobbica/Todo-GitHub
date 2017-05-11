//
//  TodoTableViewController.swift
//  Todo_01
//
//  Created by Candido Gobbi on 23.04.17.
//  Copyright © 2017 Candido Gobbi. All rights reserved.
//

import UIKit



class TodoTableViewController: UITableViewController {
    
    @IBOutlet weak var archivia_UIBarButton: UIBarButtonItem!
    
    
    // l'array dei Todo che verranno mostrati nella tabella
    var todos = [Todo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //aggiungo il bottone di edit sulla sinistra
        navigationItem.leftBarButtonItem = editButtonItem
        
        //carica i todo archiviati (07-12)
        caricaTodo_iniziale()
        
        //per caricare dei modelli nel caso in cui non ci siano dati da caricare
//        if todos.count == 0 {
//            editButtonItem.isEnabled = false
//        } else {
//            editButtonItem.isEnabled = true
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //carica dei Todo di esempio (04-16)
    private func caricaEsempi(){
        let todo1=Todo()
        let todo2=Todo()
        let todo3=Todo()
        
        todo1.nomeTodo="Todo 1"
        todo2.nomeTodo="Todo 2"
        todo3.nomeTodo="Todo 3"
        
        todos += [todo1, todo2, todo3]
    } 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //Definisce quante sezioni ha la TableView (nel nostro caso 1) (04-16)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Definisce quante righe ha la TableView (le righe corrispondono al numero di elementi dell'array todos) (04-16)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    // Definisce come "disegnare" una cella ad un determinato indice di riga (04-17)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // istanzio l'identifier della cella che ho definito in Interface Builder
        let cellIdentifier = "TodoTableViewCell"
        
        // istanzio una cella utilizzando l'identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TodoTableViewCell else {
            fatalError("oopps, Fatal Error")
        }

        // in base alla riga corrente, leggo il todo della lista
        let todo = todos[indexPath.row]
        
        // setto le informazioni nella riga corrente
        cell.nomeTodo_Label.text=todo.nomeTodo
        cell.dataScadenza_Label.text = Todo.dateToString(data: todo.dataScadenza)
        cell.immagine_ImageView.image=todo.immagine
        cell.descrizioneTodo_Label.text = todo.descrizioneTodo
        
        // verifico la differenza di secondi tra la dataScadenza e oggi
        let oggiDate = Todo.stringToDate(data: Todo.dateToString(data: NSDate()))
        let differenzaData = todo.dataScadenza.timeIntervalSince(oggiDate as Date)
        
        // coloro le celle in base alla differenza tra la dataScadenza e oggi
        if differenzaData < 0 {
            cell.contentView.backgroundColor = UIColor.red
        }
        if differenzaData > 0 {
            cell.contentView.backgroundColor = UIColor.green
        }
        if differenzaData == 0 {
            cell.contentView.backgroundColor = UIColor.yellow
        }
        
        if todo.onOff == false{
            cell.contentView.backgroundColor = UIColor.white
        }
        
        // ritorno la cella
        return cell
    }
    
    // fa l'unwind (05-16)(05-23)
    @IBAction func unwindAllaTabellaTodo(sender: UIStoryboardSegue) {
        //verifica se proviene da un TodoViewController
        if let sorgenteViewController = sender.source as? TodoViewController, let todo = sorgenteViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                // se torno da ShowDetail
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // se torno da AddItem
                // leggo il numero dell'ultima riga della tabella
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                    
                //aggiungo il nuovo todo alla Lista (sia nell'array che nella tabella)
                todos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    @IBAction func iBArchiviaTodos(_ sender: Any) {
        displayAlertConCancel(title: "Archiviazione TODO", message: "Archiviando questi todo sovvrascrivi quelli archiviati precedentemente. Sei sicuro di continuare?", funzione: archiviaTodo)
    }
    
    @IBAction func iBCaricaTodos(_ sender: Any) {
        displayAlertConCancel(title: "Caricamento TODO", message: "Caricando i todo sovvrascrivi quelli visibili a schermo. Sei sicuro di continuare?", funzione: caricaTodo)
    }
    

    //Stampa i todo presenti nell'array. È per un mio controllo
    private func stampaTodos() {
        for todo in todos {
            print(todo.dataCreazione)
        }
    }
    
    
    //Salva su filesystem i todo presenti nell'array (07-09)
    private func archiviaTodo() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(todos, toFile: Todo.ArchiveURL.path)
        
        if isSuccessfulSave {
            if todos.count == 0 {
                displayAlert(title: "Archiviazione TODO", message: "Non ci sono todo da archiviare")
            } else {
                displayAlert(title: "Archiviazione TODO", message: "Sono stati archiviati correttamente \(todos.count) todo")
            }
        } else {
            displayAlert(title: "Archiviazione TODO", message: "ATTENZIONE: i dati non sono stati salvati")
        }
    }
    
    
    //Carica da filesystem i todo e li inserisce nell'array (07-10)
    private func caricaTodo() {
        let todos =  NSKeyedUnarchiver.unarchiveObject(withFile: Todo.ArchiveURL.path) as? [Todo]
        
        if let todos = todos {
            self.todos = todos
            if todos.count == 0 {
                displayAlert(title: "Caricamento TODO", message: "Non ci sono todo da caricare")
            } else {
                displayAlert(title: "Caricamento TODO", message: "Sono stati caricati correttamente \(todos.count) todo")
            }
            
        } else {
            displayAlert(title: "Caricamento TODO", message: "ATTENZIONE: i todo non sono stati cariati")
        }
        
        //per forzare il refresh della textView
        tableView.reloadData()
        
    }
    
    private func caricaTodo_iniziale() {
        let todos =  NSKeyedUnarchiver.unarchiveObject(withFile: Todo.ArchiveURL.path) as? [Todo]
        
        if let todos = todos {
            self.todos = todos
        } else {
            displayAlert(title: "Caricamento TODO", message: "ATTENZIONE: i todo non sono stati cariati")
        }
    }
    
    //Mostra un messaggio di alert con cancel
    private func displayAlertConCancel(title: String, message: String, funzione: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default) {
            (action) -> Void in print("Hai clioccato su OK.")
            return funzione()
            })
        alert.addAction(UIAlertAction(title: "Annulla", style: UIAlertActionStyle.cancel) {
            (action) -> Void in print("Hai cliccato su annulla.")
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    //Mostra un messaggio di alert.
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // metodo regalato da Apple per la cancellazione dei una cella. Metodo commentato commentato di default (05 - 26)
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // se l'utente vuole cancellare
        if editingStyle == .delete {
            // cancello il todo dall'array e dalla tabella
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } //else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //}
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    //preparo l'oggetto da passare a dipendenza del Segue che utilizzo (AddItem oppure ShowDetail) (05-20 e 21)
    //devo precedentemente dare un nome alle Segue con l'Identifier (da Main.storyboard)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: segue)
        
        switch (segue.identifier ?? ""){
        case "AddItem":
            print("Aggiunta di un nuovo todo")
        case "ShowDetail":
            print("Display di un todo esistente")
            
            // se sono in ShowDetail significa che ho cliccato una Cell, quindi posso identificarla
            guard let selectedTodoCell = sender as? TodoTableViewCell else{
                fatalError("oopps unexpected sender: \(String(describing: sender))")
            }
            
            //dalla Cell risalgo al suo indice
            guard let indexPath = tableView.indexPath(for: selectedTodoCell) else{
                fatalError("oopps la cella selezionata non è visualizzata nella tabella")
            }
            
            //dall'indice della Cell risalgo al todo cliccato
            let selectedTodo = todos[indexPath.row]
            
            //setto il todo nel controller di destinazione
            guard let todoViewController = segue.destination as? TodoViewController else{
                fatalError("oopps unexpected destination: \(segue.destination)")
            }
            todoViewController.todo = selectedTodo
        default:
            break
        }
    }


}
