//
//  ViewController.swift
//  Todo_01
//
//  Created by Candido Gobbi on 21.04.17.
//  Copyright © 2017 Candido Gobbi. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //definizione degli oggetti contenuti nella View del todo
    @IBOutlet weak var dataCreazione_Label: UILabel!
    @IBOutlet weak var nomeTodo_TextField: UITextField!
    @IBOutlet weak var descrizione_TextView: UITextView!
    @IBOutlet weak var immgine_ImageView: UIImageView!
    @IBOutlet weak var salva_Button: UIBarButtonItem!
    @IBOutlet weak var dataScadenza_TextField: UITextField!
    @IBOutlet weak var onOff_Switch: UISwitch!

    //TapGestureRecognizer per cancellare la tastiera
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
    
    //TapGestureRecognizer per caricare le immagini
    @IBOutlet var viewTabGestureRecognizer: UITapGestureRecognizer!
    
    var todo : Todo? = nil
    var todos : [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //definisco i delegati
        nomeTodo_TextField.delegate = self
        descrizione_TextView.delegate = self
        dataScadenza_TextField.delegate = self
        
        //adatto i parametri di descrizione_TextView
        descrizione_TextView.isEditable = true
        descrizione_TextView.isScrollEnabled = true
        descrizione_TextView.allowsEditingTextAttributes = true
        
        //è vera se provengo dal segue "ShowDetail" (05-22)
        if let todo = todo {
            //popolo la view con i dati del todo associato alla Cell selezionata
            navigationItem.title = todo.nomeTodo
            nomeTodo_TextField.text = todo.nomeTodo
            dataCreazione_Label.text = Todo.dateToString(data: todo.dataCreazione)
            dataScadenza_TextField.text = Todo.dateToString(data: todo.dataScadenza)
            descrizione_TextView.text = todo.descrizioneTodo
            immgine_ImageView.image = todo.immagine
            
            //passo il valore di onOff a onOff_Switch
            onOff_Switch.setOn(todo.onOff,animated: true)
            
        } else {
            //inizializzo i valori della View
            navigationItem.title = Todo.nomeTodoDefault
            nomeTodo_TextField.text = "Inserisci il nome del Todo"
            descrizione_TextView.text = "Inserisci la descrizione"
            dataCreazione_Label.text = Todo.dateToString(data: Date() as NSDate)
            dataScadenza_TextField.text = Todo.dateToString(data: Date() as NSDate)
            onOff_Switch.setOn(true, animated: true)
            
            //inizializzo l'immagine
            immgine_ImageView.image=Todo.immagineDefault
        }
    }
    
    //uscendo dal TextField nomeTodo aggiorna il nome del todo sulla navigation bar
    @IBAction func cambiaNome(_ sender: Any) {
        aggiornaNome()
    }
    
    func aggiornaNome(){
        if (!(nomeTodo_TextField.text?.containsNonWhitespace())!) || (nomeTodo_TextField.text == "Inserisci il nome del Todo"){
            nomeTodo_TextField.text=Todo.nomeTodoDefault
        }
        navigationItem.title = nomeTodo_TextField.text
    }
    
    // cliccando sul resto della View scompare la tastiera
    @IBAction func togliTastiera(_ sender: UITapGestureRecognizer) {
        nomeTodo_TextField.resignFirstResponder()
        dataScadenza_TextField.resignFirstResponder()
        descrizione_TextView.resignFirstResponder()
    }
    
    //la scelta della data avviene mediante un DatePicker
    @IBAction func inserisciDataScadenza(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        dataScadenza_TextField.text = Todo.dateToString(data: sender.date as NSDate)
    }
    
    //l'immagine viene scelta caricata dal file system
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // mi assicuro che se l'utente clicca la foto mentre è in editing, la tastiera viene nascosta
        nomeTodo_TextField.resignFirstResponder()
        descrizione_TextView.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Carico l'immagine originale anche se l'info dictionary pootrebbe contenerne altre rappresentazioni.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // mostro l'immagine
        immgine_ImageView.image = selectedImage
        
        // faccio il dismiss del picker
        dismiss(animated: true, completion: nil)
    }
    
    

    //impostazione del bottone "annulla" (05-13)(05-24)
    @IBAction func annulla(_ sender: Any) {
        let isInAddMode = presentingViewController is UINavigationController
        
        // verifico se faccio il cancel da un todo nuovo (isInAddMode)
        if isInAddMode {
            //"annulla" da una view modale (05-13)
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            //"annulla" da un segue push (
            owningNavigationController.popViewController(animated: true)
        }
    }
    
    
    // operazioni necessarie per "salvare" un oggetto (05-15)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        // esegue il codice seguente solo se è stato cliccato Salva
        guard let button = sender as? UIBarButtonItem, button === salva_Button else{
            return
        }
        
        aggiornaNome()
        
        if (!(descrizione_TextView.text?.containsNonWhitespace())!) || (descrizione_TextView.text == "Inserisci la descrizione"){
            descrizione_TextView.text=Todo.descrizioneDefault
        }
        
        //coalescing: se navigationItem.title = nil allora assegna "" a nomeTodo
        let nomeTodo = navigationItem.title ?? Todo.nomeTodoDefault
        let descrizioneTodo = descrizione_TextView.text ?? Todo.descrizioneDefault
        let dataCreazione = Todo.stringToDate(data: dataCreazione_Label.text ?? Todo.dateToString(data: NSDate()))
        let dataScadenza = Todo.stringToDate(data: dataScadenza_TextField.text ?? Todo.dateToString(data: NSDate()))
        let immagine = immgine_ImageView.image ?? Todo.immagineDefault
        let onOff = onOff_Switch.isOn 
        
        // creo il todo che dovrà essere passato al TodoTableViewController
        todo = Todo()
        todo?.nomeTodo = nomeTodo
        todo?.descrizioneTodo = descrizioneTodo
        todo?.dataCreazione = dataCreazione
        todo?.dataScadenza = dataScadenza
        todo?.immagine = immagine
        todo?.onOff = onOff
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        Dispose of any resources that can be recreated.
    }
    
    // Viene chiamato quando l'utente smette di editare all'interno di un TextField (i.e. quando preme Enter oppure Done)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // nascondi la tastiera
        textField.resignFirstResponder()
        return true
    }
    
    func togliereTastiera(textField: UITextField){
        // nascondi la tastiera
        textField.resignFirstResponder()
    }
    
    // Viene chiamato se textFieldShouldReturn ritorna true, qui posso eseguire operazioni dopo che l'utente ha messo di scrivere.
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("L'utente ha smesso di scrivere")
    }
    
    //permette di imporre un limite alla lunghezza del textfield. Il limite è una proprietà atatic dalla classe Todo
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= Todo.lunghezzaMax
    }


}

