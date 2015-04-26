//
//  StoreCollection.swift
//  PropperShopper
//
//  Created by Bartlomiej Siemieniuk on 26/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

import UIKit

class StoreCollection: NSObject {
    
    var stores = [Store]()
    
    static let sharedInstance = StoreCollection()
    
    func addStore(store: Store) -> Int {
        self.stores.append(store)
        return self.size() - 1
    }
    
    func getStore(id: Int) -> Store {
        return self.stores[id]
    }
    
    func getAllStores() -> [Store] {
        return self.stores
    }
    
    func size() -> Int {
        return self.stores.count
    }
}
