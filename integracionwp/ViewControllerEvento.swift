//
//  ViewControllerEvento.swift
//  integracionwp
//
//  Created by Maestro on 15/11/16.
//  Copyright © 2016 Maestro. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ViewControllerEvento : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var eventos : [Evento] = []

    
    @IBOutlet weak var tvEventos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "https://quehayobson.azurewebsites.net/api/get_posts/", parameters: ["post_type": "evento"]) // le decimos que a ese sitio web le haga un GET... El parametro es un diccionario cuya llave es foo
            .responseJSON { response in // el in indica que lo que esta antes del mismo es un parametro para el siguiente bloque de codigo que se va a ejecutar
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization Ya en jSON
                
                if let diccionarioRespuesta = response.result.value as? NSDictionary{
                    
                    if let posts = diccionarioRespuesta.valueForKey("posts") as? NSArray { //
            
                        for post in posts {
                            if let diccionarioPost = post as? NSDictionary {
                                // aqui estas haciendo un casting de post a diccionario y se lo estas mandando al constructor Lugar
                                
                                self.eventos.append(Evento(diccionario: diccionarioPost, callback: self.actualizarTableViewEventos)) // esta funcion no tiene parentesis porque no se esta ejecutando, sino que, la estamos mandando como parametro cuando se crea el Lugar
                            }
                        }
                        
                        self.tvEventos.reloadData() // vuelve a ejecutar todas las funciones del table view
                        
                    }
                }
        }
    }
    
    func actualizarTableViewEventos(){
        tvEventos.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { // que tantas columnas
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // que tantas filas
        return eventos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { // crea la celda
        
        let celda = tableView.dequeueReusableCellWithIdentifier("celdaEvento") as! EventoCelda
        celda.lblNombreEvento.text = eventos[indexPath.row].titulo
       
        if let imagen = eventos[indexPath.row].imgFoto {
            celda.imgFondoEvento.image = imagen
            
        }
        
        return celda
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
        if segue.identifier == "goToDetallesEvento" {
            let detallesControllerEvento = segue.destinationViewController as! DetallesControllerEvento
            detallesControllerEvento.evento = eventos[(tvEventos.indexPathForSelectedRow?.row)!]
        }
    }
}

