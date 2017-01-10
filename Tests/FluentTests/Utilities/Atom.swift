import Fluent

struct Atom: Entity {
    var id: Node?
    var name: String
    var groupId: Node?
    var exists: Bool = false
    var shouldDeleteObject = true
    var shouldCreateObject = true
    var shouldUpdateObject = true
    
    init(name: String, id: Node? = nil) {
        self.id = id
        self.name = name
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        groupId = try node.extract("group_id")
    }

    func makeNode(context: Context = EmptyNode) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "group_id": groupId
        ])
    }

    func compounds() throws -> Siblings<Compound> {
        return try siblings()
    }

    func group() throws -> Parent<Group> {
        return try parent(groupId, "parrrrent_id")
    }

    func protons() throws -> Children<Proton> {
        return children()
    }

    func nucleus() throws -> Nucleus? {
        return try children("nookleus_id").first()
    }

    static func prepare(_ database: Fluent.Database) throws {
        try database.create(entity) { builder in
            builder.id()
            builder.string("name")
            builder.int("group_id")
        }
    }
    static func revert(_ database: Fluent.Database) throws {
        try database.delete(entity)
    }

    // MARK: Callbacks
    func shouldCreate() -> Bool {
        return shouldCreateObject
    }
    
    func willCreate() {
        print("Atom will create.")
    }

    func didCreate() {
        print("Atom did create.")
    }

    func shouldUpdate() -> Bool {
        return shouldUpdateObject
    }
    
    func willUpdate() {
        print("Atom will update.")
    }

    func didUpdate() {
        print("Atom did update.")
    }

    func shouldDelete() -> Bool {
        return shouldDeleteObject
    }
    
    func willDelete() {
        print("Atom will delete.")
    }

    func didDelete() {
        print("Atom did delete.")
    }
}
