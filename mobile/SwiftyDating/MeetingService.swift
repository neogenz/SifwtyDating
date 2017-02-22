//
//  MeetingService.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import Foundation
import SQLite

class MeetingService{
    let peopleMeetTable = Table("peopleMeet")
    let idColumn = Expression<Int>("id")
    let firstnameColumn = Expression<String>("firstname")
    let lastnameColumn = Expression<String>("lastname")
    let birthdateColumn = Expression<Date>("birthdate")
    let sexeColumn = Expression<String>("sexe")
    let noteColumn = Expression<Int>("note")
    
    static var sharedInstance:MeetingService = MeetingService()
    
    private init() {
        do {
            try DBProvider.sharedInstance.connection?.run(peopleMeetTable.drop());
        }
        catch{
            print(error);
        }
        do{
            try DBProvider.sharedInstance.connection?.run(peopleMeetTable.create(ifNotExists: true) { table in
                table.column(idColumn, primaryKey: .autoincrement)
                table.column(firstnameColumn)
                table.column(lastnameColumn)
                table.column(birthdateColumn)
                table.column(sexeColumn)
                table.column(noteColumn)
            })
        } catch {
        }
    }
    
    
    func findAll() -> [PeopleMeet] {
        var result = [PeopleMeet]()
        if let conn = DBProvider.sharedInstance.connection {
            do {
                for row in try conn.prepare(peopleMeetTable) {
                    result.append(PeopleMeet(id: row[self.idColumn],
                                             firstname: row[self.firstnameColumn],
                                             lastname: row[self.lastnameColumn],
                                             birthdate: row[self.birthdateColumn],
                                             sexe: row[self.sexeColumn],
                                             note: row[self.noteColumn]
                    ))
                }
            } catch {
                print(error)
            }
        }
        return result
    }
    
    func create(this: PeopleMeet) -> Int64? {
        do{
            guard let connection = DBProvider.sharedInstance.connection else {
                return nil
            }
            let insert = self.peopleMeetTable.insert(self.firstnameColumn <- this.firstname,
                                                     self.lastnameColumn <- this.lastname,
                                                     self.birthdateColumn <- this.birthdate,
                                                     self.sexeColumn <- this.sexe.rawValue,
                                                     self.noteColumn <- this.note
            )
            return try? connection.run(insert)
        }catch {
            print(error)
        }
    }
    
    func count() -> Int {
        guard let connection = DBProvider.sharedInstance.connection else{
            return 0;
        }
        do {
            return try connection.scalar(self.peopleMeetTable.count);
        } catch {
            return 0;
        }
    }
    
    func delete(this: PeopleMeet) {
        if let connection = DBProvider.sharedInstance.connection,
            let id = this.id {
            let query = self.peopleMeetTable.filter(self.idColumn == id)
            do {
                try connection.run(query.delete());
            } catch {
            }
        }
    }
    
    func findAt(pos: Int) -> PeopleMeet? {
        if let connection = DBProvider.sharedInstance.connection{
            let query = peopleMeetTable.limit(1, offset:pos)
            do {
                for row in try connection.prepare(query) {
                    return PeopleMeet(id: row[self.idColumn],
                                      firstname: row[self.firstnameColumn],
                                      lastname: row[self.lastnameColumn],
                                      birthdate: row[self.birthdateColumn],
                                      sexe: row[self.sexeColumn],
                                      note: row[self.noteColumn]
                    )
                };
                
            } catch {
            }
            return nil
        }
        return nil
    }
    
    func update(peopleMeet:PeopleMeet) -> Int? {
        do{
            guard let connection = DBProvider.sharedInstance.connection else {
                return nil
            }
            let peopleToUpdate = peopleMeetTable.filter(self.idColumn == peopleMeet.id!)
            let update = peopleToUpdate.update([self.firstnameColumn <- peopleMeet.firstname,
                                                self.lastnameColumn <- peopleMeet.lastname,
                                                self.birthdateColumn <- peopleMeet.birthdate,
                                                self.sexeColumn <- peopleMeet.sexe.rawValue,
                                                self.noteColumn <- peopleMeet.note]
            )
            return try? connection.run(update)
        }catch {
            print(error)
        }
    }
}
