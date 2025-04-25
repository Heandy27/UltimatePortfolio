import CoreData

class DataController: ObservableObject {
    //  Esta propiedad se encarga de cargar y gestionar datos locales mediante Core Data, así como de sincronizarlos con iCloud para que todos los dispositivos del usuario compartan los mismos datos para nuestra aplicación.
    let container: NSPersistentCloudKitContainer
    @Published var selectedFilter: Filter? = Filter.all
    
    
    /*Esta es una instancia estática que se usa para previsualización en SwiftUI.
     
     Se crea un DataController en memoria, sin guardar datos en disco.
     
     Luego se llaman a createSampleData() para poblarlo con datos de prueba.*/
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        // añadiremos un inMemoryvalor booleano al crear nuestro controlador de datos. Si se establece como verdadero, los datos se crearán completamente en memoria en lugar de en disco, lo que significa que desaparecerán al finalizar la aplicación.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        // Aquí se cargan los datos desde el disco o se crea la base de datos si no existe.
        //Si hay un error, se detiene la ejecución con fatalError.
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    func createSampleData() {
        //Se obtiene el viewContext, que es el contexto principal para trabajar con Core Data.
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(i)"
            
            for j in 1...10 {
                let issue = Issue(context: viewContext)
                issue.title = "Issue \(i)-\(j)"
                issue.content = "Description goes here"
                issue.creationDate = .now
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 0...2)
                tag.addToIssues(issue)
            }
        }
        
        try? viewContext.save()
    }
    
    // Guarda los cambios en Core Data si hubo modificaciones. Se usa try? para evitar que el programa se caiga si algo falla.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    // Elimina un objeto específico y luego guarda los cambios.
    //Se envía objectWillChange para notificar a la interfaz que habrá un cambio.
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    /* Crea una solicitud de eliminación masiva con NSBatchDeleteRequest.
     resultType permite obtener los IDs de los objetos eliminados.*/
    
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        // Si la eliminación fue exitosa, se sincroniza el contexto para que la interfaz de usuario se actualice correctamente.
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    /* Se crean dos solicitudes para eliminar todas las etiquetas y todos los problemas, usando el método delete.
     Finalmente se guarda el contexto.*/
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        delete(request2)
        
        save()
    }
}
