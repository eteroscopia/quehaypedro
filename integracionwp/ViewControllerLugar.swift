//
//  ViewController.swift
//  integracionwp
//
//  Created by Maestro on 03/11/16.
//  Copyright © 2016 Maestro. All rights reserved.
//

import UIKit
import Alamofire

/* https://quehayobson.azurewebsites.net/api/get_posts/?post_type=lugar 111 */

class ViewControllerLugar: UIViewController, UITableViewDelegate, UITableViewDataSource { // view Controller de lugar
    
    var lugares : [Lugar] = []

    @IBOutlet weak var tvLugares: UITableView!
    
    //@IBOutlet weak var lblDireccion: UILabel! esta cura ya esta desvinculada
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "https://quehayobson.azurewebsites.net/api/get_posts/", parameters: ["post_type": "lugar"]) // le decimos que a ese sitio web le haga un GET... El parametro es un diccionario cuya llave es foo
            .responseJSON { response in // el in indica que lo que esta antes del mismo es un parametro para el siguiente bloque de codigo que se va a ejecutar
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization Ya en jSON
                
                    if let diccionarioRespuesta = response.result.value as? NSDictionary{ // en result esta lo que te trajo esa llamada, y en este caso lo guardamos en una variables llamada json.
                        // lo anterior dice: si puedes convertir la respuesta en un nsdictionary.. entonces ponselo a diccionarioRespuesta y rifatela
                      /*  self.lblDireccion.text = String(diccionarioRespuesta.valueForKey("count_total") as! Int) // alamo fire esta consciente que la mayoria de las llamadas de HTTP son para mostrar informacion en pantalla... por lo tanto, a diferencia del otro metodo, no tenemos que agregar la funcion "dispatch".
                            // count total es un parametro en la respuesta del sitio al hacerle un get con el codigo 111*/
                        
                        if let posts = diccionarioRespuesta.valueForKey("posts") as? NSArray { // posts es un arreglo de posts, cada un es un objeto (que en swift llamamos NSDictionary)
        
                            for post in posts {
                                if let diccionarioPost = post as? NSDictionary {
                                    // aqui estas haciendo un casting de post a diccionario y se lo estas mandando al constructor Lugar
                                    
                                    self.lugares.append(Lugar(diccionario: diccionarioPost, callback: self.actualizarTableViewLugares)) // esta funcion no tiene parentesis porque no se esta ejecutando, sino que, la estamos mandando como parametro cuando se crea el Lugar
                                }
                            }
                            
                            self.tvLugares.reloadData() // vuelve a ejecutar todas las funciones del table view
                
                        }
                    }
        }
    }
    
    
    func actualizarTableViewLugares(){
        tvLugares.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { // que tantas columnas
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // que tantas filas
        return lugares.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { // crea la celda
        
        let celda = tableView.dequeueReusableCellWithIdentifier("celdaLugar") as! lugarCelda
        celda.lblNombre.text = lugares[indexPath.row].titulo
        
        if let imagen = lugares[indexPath.row].imgFoto {
        celda.imgFondo.image = imagen
            
        }
        
        return celda
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDetalles" {
            let detallesController = segue.destinationViewController as! DetallesController
            detallesController.lugar = lugares[(tvLugares.indexPathForSelectedRow?.row)!]
        }
    }
    
}



/*
 
 Antes de poner el arreglo de posts estaba esto
 
 if let primerPost = posts[0] as? NSDictionary {
 if let customFields = primerPost.valueForKey("custom_fields") as? NSDictionary {
 if let direccion = customFields.valueForKey("direccion") as? NSArray {
 if let valorDireccion = direccion [0] as? String {
 self.lblDireccion.text = valorDireccion
 }
 }
 }
 }
*/

