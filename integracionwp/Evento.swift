//
//  Evento.swift
//  integracionwp
//
//  Created by Maestro on 15/11/16.
//  Copyright © 2016 Maestro. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Evento {
    
    var titulo : String
    var descripcion : String
    var direccion : String
    var telefono : String
    var horario : String
    var fecha : String
    var precio : String
    
    var urlFoto : String?
    var imgFoto : UIImage?
    
    var urlFoto2 : String?
    var imgFoto2 : UIImage?
    
    var urlThumbnail: String?
    var imgThumbnail: UIImage?
    
    var urlThumbnail2: String?
    var imgThumbnail2: UIImage?
    
    
    init(){
        
        titulo = ""
        descripcion = ""
        direccion = ""
        telefono = ""
        horario = ""
        fecha = ""
        precio = ""
        
    }
    
    init(diccionario : NSDictionary, callback: (() -> Void)?) {
        
        titulo = ""
        descripcion = ""
        direccion = ""
        telefono = ""
        horario = ""
        fecha = ""
        precio = ""
        
        if let titulo = diccionario.valueForKey("title_plain") as? String {
            self.titulo = titulo
        }
        
        if let customFields = diccionario.valueForKey("custom_fields") as? NSDictionary { // custom fields tinene direccion y telefono
            
            if let descripcion = customFields.valueForKey("descripcion") as? NSArray {
                if let valorDescripcion = descripcion [0] as? String {
                    self.descripcion = valorDescripcion
                }
            }
            
            if let direccion = customFields.valueForKey("direccion") as? NSArray {
                if let valorDireccion = direccion [0] as? String {
                    self.direccion = valorDireccion
                }
            }
            
            if let telefono = customFields.valueForKey("telefono") as? NSArray {
                if let valorTelefono = telefono[0] as? String {
                    self.telefono = valorTelefono
                }
            }
            
            if let horario = customFields.valueForKey("horario") as? NSArray {
                if let valorHorario = horario[0] as? String {
                    self.horario = valorHorario
                }
            }
            
            if let fecha = customFields.valueForKey("fecha") as? NSArray {
                if let valorFecha = fecha[0] as? String {
                    self.fecha = valorFecha
                }
            }
            
            
            if let precio = customFields.valueForKey("precio") as? NSArray {
                if let valorPrecio = precio[0] as? String {
                    self.precio = valorPrecio
                }
            }
        }
        
        if let attachments = diccionario.valueForKey("attachments") as? NSArray {
            
            if attachments.count > 0 {
                
                if let raiz =  attachments[0] as? NSDictionary {
                    if let urlImagen = raiz.valueForKey("url") as? String {
                        self.urlFoto = urlImagen
                        
                        
                    }
                    
                    if let images = raiz.valueForKey("images") as? NSDictionary {
                        if let thumbnail = images.valueForKey("thumbnail") as? NSDictionary {
                            
                            if let urlThumbnail = thumbnail.valueForKey("url") as? String {
                                self.urlThumbnail = urlThumbnail
                            }
                        }
                    }
                }
            }
        }
        
        if let urlFoto = self.urlFoto { // si tengo algo en self.urlFoto ejecuta:
            
            Alamofire.request(.GET, urlFoto, parameters: [:]).responseData(completionHandler: {
                response in
                if let data = response.data { // si tenemos data en response.data ejecuta:
                    self.imgFoto = UIImage(data:data)
                    
                    if let funcionCallback = callback {
                        funcionCallback()
                    }
                }
            })
            
        } else {
            // Asignarle imagen genérica
            
            self.imgFoto = UIImage(named: "mundo")
        }
        
        if let attachments2 = diccionario.valueForKey("attachments") as? NSArray {
            
            if attachments2.count > 0 {
                
                if let raiz2 =  attachments2[1] as? NSDictionary {
                    if let urlImagen2 = raiz2.valueForKey("url") as? String {
                        self.urlFoto2 = urlImagen2
                        
                        
                    }
                    
                    if let images2 = raiz2.valueForKey("images") as? NSDictionary {
                        if let thumbnail2 = images2.valueForKey("thumbnail") as? NSDictionary {
                            
                            if let urlThumbnail2 = thumbnail2.valueForKey("url") as? String {
                                self.urlThumbnail = urlThumbnail2
                            }
                        }
                    }
                }
            }
        }
        
        if let urlFoto2 = self.urlFoto2 { // si tengo algo en self.urlFoto ejecuta:
            
            Alamofire.request(.GET, urlFoto2, parameters: [:]).responseData(completionHandler: {
                response in
                if let data2 = response.data { // si tenemos data en response.data ejecuta:
                    self.imgFoto2 = UIImage(data:data2)
                    
                    if let funcionCallback = callback {
                        funcionCallback()
                    }
                }
            })
            
        } else {
            // Asignarle imagen genérica
            
            self.imgFoto2 = UIImage(named: "mundo")
        }
        
    }

}