//
//  UpTimerDelegateDataSource.swift
//  Geronimo
//
//  Created by Serg Liamthev on 3/27/18.
//  Copyright © 2018 Serg Liamthev. All rights reserved.
//

import UIKit

class UpTimerDelegateDataSource: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
