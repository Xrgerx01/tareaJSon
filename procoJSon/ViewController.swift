//
//  ViewController.swift
//  procoJSon
//
//  Created by XrgerX on 3/09/16.
//  Copyright © 2016 XrgerX. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autors: UITextView!
    @IBOutlet weak var etiquetaPortada: UILabel!
    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var isbn: UITextField!
    var textoresultado: String = ""
    var urlstable: String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbn.delegate = self
        isbn.keyboardType = UIKeyboardType.WebSearch
        self.isbn.returnKeyType = .Search
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func clear() {
        isbn.text = ""
        titulo.text = ""
        autors.text = ""
    }
        
    @IBAction func textFieldDoneEditing(sender: UITextField){
            sender.resignFirstResponder()
    }
        
    func procesoJson() {
            let urls = String(urlstable) + isbn.text!
            let url = NSURL(string: urls)
            let datos:NSData? = NSData(contentsOfURL: url!)
            if datos == nil {
                let alerta = UIAlertController(title: "Sin Conexion", message: "No se pudo conectar con el Servidor", preferredStyle: .Alert)
                let accionError = UIAlertAction(title: "Error", style: .Default, handler: {
                    accion in //..
                })
                alerta.addAction(accionError)
                self.presentViewController(alerta, animated: true, completion: nil)
            }
            else{
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let dico1 = json as! NSDictionary
                    if (dico1.count > 0) {
                    let dico2 = dico1["ISBN:" + isbn.text!] as! NSDictionary
                    // Titulo
                    self.titulo.text = dico2["title"] as! NSString as String
                    
                    // Authors
                    var dico3 = dico2.valueForKey("authors") as! [NSDictionary]
                    self.autors.text = dico3.removeAtIndex(0).valueForKey("name")! as! String
                    // Portada
                        if (dico2["cover"]) != nil {
                            let dico4 = dico2.valueForKey("cover") as! NSDictionary
                            let deco5 = NSURL(string : dico4.valueForKey("small") as! NSString as String)
                            let datax = NSData(contentsOfURL: deco5!)
                            self.portada.image = UIImage(data: datax!)!
                            self.etiquetaPortada.hidden = true
                            self.portada.hidden = true
                        }
                        
                    }
                    else {
                        let alerta = UIAlertController(title: "Libro no Encontrado", message: "No existe Libro", preferredStyle: .Alert)
                        let accionError = UIAlertAction(title: "Error", style: .Default, handler: {
                            accion in //..
                        })
                        alerta.addAction(accionError)
                        self.presentViewController(alerta, animated: true, completion: nil)                    }
                }
                catch _ {
                    
                }
              
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                self.textoresultado = String(texto!)
                if self.textoresultado == "{}" {
                    self.textoresultado = "EL ISBN NO HA SIDO ENCONTRADO"
                }
            }
        }
        
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            isbn.text = textField.text!
            procesoJson()
            return true
        }


}