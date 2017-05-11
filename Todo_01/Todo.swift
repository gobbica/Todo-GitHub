//
//  Todo.swift
//  Todo_01
//
//  Created by Candido Gobbi on 21.04.17.
//  Copyright © 2017 Candido Gobbi. All rights reserved.
//

import UIKit

class Todo: NSObject, NSCoding {
    
    //imposto i valori di default
    static var lunghezzaMax = 30
    static var nomeTodoDefault = "Todo senza nome"
    static var descrizioneDefault = "Todo senza descrizioone"
    static var dataScadenzaDefault = NSDate()
    static var immagineDefault = UIImage(named: "TodoSenzaImmagine")!
    
    // proprietà della classe Todo
    var nomeTodo: String
    var descrizioneTodo: String
    var dataCreazione: NSDate
    var dataScadenza: NSDate
    var tema: String = ""
    var immagine : UIImage
    var onOff : Bool!
    
    override init() {
        self.dataCreazione = NSDate()
        self.dataScadenza = NSDate()
        self.nomeTodo = Todo.nomeTodoDefault
        self.descrizioneTodo = Todo.descrizioneDefault
        self.immagine = Todo.immagineDefault
        self.onOff = true
    }
    
    init(nomeTodo: String, descrizioneTodo: String, dataCreazione: NSDate, dataScadenza: NSDate, immagine: UIImage, onOff: Bool){
        self.nomeTodo = nomeTodo
        self.descrizioneTodo = descrizioneTodo
        self.dataCreazione = dataCreazione
        self.dataScadenza = dataScadenza
        self.immagine = immagine
        self.onOff = onOff
    }
    
    //trasforma la data in una stringa "dd.MM.yyyy"
    static func dateToString(data: NSDate) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: (data) as Date)
    }
    
    //trasforma la stringa in una data "dd.MM.yyyy"
    static func stringToDate(data: String) -> NSDate{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: data)! as NSDate
    }
    
    //MARK: Archiving Paths
    
    //Leggo la directory dell'App (07-08)
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //La directory dove andrò ad inserire i files
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos_10")
    
    
    //definizione delle chiavi per NSCoding (07-04)
    struct PropertyKey {
        static let nomeTodo = "nomeTodo"
        static let descrizioneTodo = "descrizioneTodo"
        static let dataCreazione = "dataCreazione"
        static let dataScadenza = "dataScadenza"
        static let immagine = "immagine"
        static let onOff = "onOff"
    }
    
    //MARK: NSCoding
    
    //encode dei dati. Per archiviare i dati (07-06)
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nomeTodo, forKey: PropertyKey.nomeTodo)
        aCoder.encode(descrizioneTodo, forKey: PropertyKey.descrizioneTodo)
        aCoder.encode(dataCreazione, forKey: PropertyKey.dataCreazione)
        aCoder.encode(dataScadenza, forKey: PropertyKey.dataScadenza)
        aCoder.encode(immagine, forKey: PropertyKey.immagine)
        aCoder.encode(onOff, forKey: PropertyKey.onOff)
    }
    
    //decode dei dati. Per caricare i dati (07-07)
    required convenience init(coder aDecoder: NSCoder) {
        let nomeTodo = aDecoder.decodeObject(forKey: PropertyKey.nomeTodo) as! String
        let descrizioneTodo = aDecoder.decodeObject(forKey: PropertyKey.descrizioneTodo) as! String
        let dataCreazione = aDecoder.decodeObject(forKey: PropertyKey.dataCreazione) as! NSDate
        let dataScadenza = aDecoder.decodeObject(forKey: PropertyKey.dataScadenza) as! NSDate
        let immagine = aDecoder.decodeObject(forKey: PropertyKey.immagine) as! UIImage
        let onOff = aDecoder.decodeObject(forKey: PropertyKey.onOff) as! Bool
        
        // Must call designated initializer.
        self.init(nomeTodo: nomeTodo, descrizioneTodo: descrizioneTodo, dataCreazione: dataCreazione, dataScadenza: dataScadenza, immagine: immagine, onOff: onOff)
    }
}

//funzione Bool; vera se la stringa non contiene caratteri o solo (spazi e/o tab)
extension String {
    func containsNonWhitespace() -> Bool {
        return(!self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)
    }
}
