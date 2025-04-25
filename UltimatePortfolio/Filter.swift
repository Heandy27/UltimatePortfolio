//
//  Filter.swift
//  UltimatePortfolio
//
//  Created by Andy Heredia on 25/4/25.
//

import Foundation

/*La palabra Hashable es un protocolo en Swift. Significa que una estructura (como Filter en tu caso) puede ser usada en listas, conjuntos, diccionarios y también para comparaciones eficientes.*/

/*Muy útil para cosas como:
 
 Set<Filter> (conjuntos)

 Dictionary<Filter, Algo>

 ForEach en SwiftUI que necesita saber si un elemento ha cambiado o no.*/

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    // se usa como valor por defecto para minModificationDate, indicando "la fecha más antigua posible".
    var minModificationDate = Date.distantPast
    var tag: Tag?
    
    static var all = Filter(id: UUID(), name: "All Issues", icon: "tray")
    static var recent = Filter(id: UUID(), name: "Recent issues", icon: "clock", minModificationDate: .now.addingTimeInterval(86400 * -7)) // dame le mas recientes dentro de 7 días
    
    
    // Esto le dice a Swift cómo generar un "hash" único del filtro. Solo usa el id, lo cual es suficiente ya que UUID es único
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    //Esto define que dos filtros son iguales si tienen el mismo id. No importa si el name o el icon son distintos.
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
    
}
