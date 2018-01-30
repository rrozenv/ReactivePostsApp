
import Foundation

struct User: Identifiable {
    let id: Int
    let username: String
    let name: String
    let email: String
    let address: Address
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case email
        case address
    }
}

extension User: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)

    }
}

extension User: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        username = try values.decode(String.self, forKey: .username)
        name = try values.decode(String.self, forKey: .name)
        email = try values.decode(String.self, forKey: .email)
        address = try values.decode(Address.self, forKey: .address)
    }
}
