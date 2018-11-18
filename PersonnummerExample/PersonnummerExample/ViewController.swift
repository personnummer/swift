//
//  ViewController.swift
//  PersonnummerExample
//
//  Created by Philip Fryklund on 17/Nov/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import UIKit
import Personnummer

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		if let p = Personnummer(personnummer: "510818-9167") {
			print(p.century, p.year, p.month, p.day, p.separator.rawValue, p.fourLast)
			print(p.format(longFormat: true))
			print(p.format(longFormat: false))
		}
		else {
			print("Not valid")
		}
	}


}

